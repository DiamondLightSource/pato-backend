from datetime import datetime
from pathlib import Path
from typing import List, Sequence

from fastapi import HTTPException, Response, status
from fpdf import FPDF
from lims_utils.tables import (
    CTF,
    AutoProcProgram,
    BLSession,
    DataCollection,
    DataCollectionGroup,
    MotionCorrection,
    ParticleClassification,
    ParticleClassificationGroup,
    ParticlePicker,
    ProcessingJob,
    Proposal,
)
from sqlalchemy import Row, func, select

from ..assets.paths import COMPANY_LOGO, DEJAVU_SERIF, DEJAVU_SERIF_BOLD
from ..models.templates import (
    ANG_DIST_TEXT,
    B_FACTOR_TEXT,
    CLASSIFICATION_3D_TEXT,
    DATA_COLLECTION_TEXT,
    PARTICLE_CLASSIFICATION_TEXT,
    PRE_PROCESSING_TEXT,
    REFINEMENT_TEXT,
    SYMMETRY_TEXT,
)
from ..utils.database import db


def _get_step(step_name: str, autoproc_programs: Sequence[Row]) -> AutoProcProgram:
    for proc in autoproc_programs:
        if proc.ProcessingJob.recipe == step_name:
            return proc.AutoProcProgram

    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"No {step_name} found for data collection",
    )


class ReportPDF(FPDF):
    def __init__(self):
        super().__init__()
        self.add_font(fname=DEJAVU_SERIF)
        self.add_font(fname=DEJAVU_SERIF_BOLD, family="DejaVuSerif", style="B")
        self.set_font("DejaVuSerif", size=12)
        self.oversized_images = "DOWNSCALE"
        self.set_image_filter("DCTDecode")
        self.page_count = 0

    def header(self):
        self.image(COMPANY_LOGO, x="R", y=7, h=12)
        self.line(y1=20, y2=20, x1=5, x2=self.w - 5)
        self.ln(21)

    def footer(self):
        self.page_count += 1
        self.set_y(-15)
        self.cell(w=0, align="C", text=str(self.page_count), new_y="TMARGIN")

    def add_h1(self, text: str, h: int = 22):
        self.set_font(size=20)
        self.cell(w=0, align="C", text=text, new_y="NEXT", new_x="LEFT", h=h)

    def add_h2(self, text: str):
        self.set_font(size=18, style="B")
        self.cell(w=0, align="L", text=text, new_y="NEXT", new_x="LEFT", h=18)
        self.set_font(size=8)

    def add_table(self, table_contents: Sequence[tuple[str, ...]]):
        with self.table(width=100) as table:
            for data_row in table_contents:
                row = table.row()
                for datum in data_row:
                    row.cell(datum)

    def caption(self, text: str):
        self.cell(text=text, w=0, align="C", new_y="NEXT", new_x="LMARGIN", h=12)

    def paragraph(self, text: str):
        self.multi_cell(
            w=0,
            text=text,
            new_x="LEFT",
        )


def generate_report(collection_id: int):
    pdf = ReportPDF()
    pdf.add_page()

    data = db.session.execute(
        select(DataCollection, BLSession, Proposal)
        .select_from(DataCollection)
        .join(DataCollectionGroup)
        .join(BLSession)
        .join(Proposal)
        .filter(DataCollection.dataCollectionId == collection_id)
    ).one()

    autoproc_programs = db.session.execute(
        select(AutoProcProgram, ProcessingJob)
        .select_from(ProcessingJob)
        .join(AutoProcProgram)
        .filter(ProcessingJob.dataCollectionId == collection_id)
    ).all()

    preprocess_program = _get_step("em-spa-preprocess", autoproc_programs)
    class2d_program = _get_step("em-spa-class2d", autoproc_programs)
    class3d_program = _get_step("em-spa-class3d", autoproc_programs)
    refinement_program = _get_step("em-spa-refine", autoproc_programs)

    img_dir = Path(data.DataCollection.imageDirectory)

    metadata_dirs = list(img_dir.glob("metadata_*"))
    supervisor_name = (
        str(metadata_dirs[0]).split("metadata_")[1] if len(metadata_dirs) == 1 else ""
    )
    micrograph_count = db.session.scalar(
        select(func.count(MotionCorrection.motionCorrectionId)).filter(
            MotionCorrection.dataCollectionId == collection_id
        )
    )
    grid_squares = list(img_dir.glob("GridSquare*"))

    try:
        # Get the two particle picking/motion correction entries with the largest number of particles picked
        first_motion_correction, second_motion_correction = db.session.execute(
            select(MotionCorrection, ParticlePicker)
            .filter(ParticlePicker.programId == preprocess_program.autoProcProgramId)
            .join(
                MotionCorrection,
                ParticlePicker.firstMotionCorrectionId
                == MotionCorrection.motionCorrectionId,
            )
            .order_by(ParticlePicker.numberOfParticles.desc())
            .limit(2)
        )
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No motion correction found for data collection",
        )

    # We're not getting the instrument/year from the file path yet, but we might
    _, _, instrument, _, year, visit, raw_name = img_dir.parts

    # Summary title
    pdf.add_h1(f"Auto-processing report for {visit} {raw_name}", h=20)

    pdf.set_font(size=14)
    pdf.cell(
        w=0,
        align="C",
        text=datetime.now().strftime("%B %-d, %Y"),
        new_x="LEFT",
        new_y="NEXT",
    )

    pdf.add_h2("1 Data collection")
    pdf.paragraph(
        text=DATA_COLLECTION_TEXT.safe_substitute(
            dataset_name=supervisor_name,
            file_path=img_dir,
            micrograph_count=micrograph_count,
            grid_square_count=len(grid_squares),
        ),
    )

    if grid_squares and (foil_holes := list(grid_squares[0].glob("Data/FoilHole_*"))):
        file_type = foil_holes[0].suffix
    else:
        file_type = "Unknown"

    # Data collection parameter table
    parameter_table = (
        ("Parameter", "Value"),
        ("File format", file_type),
        ("Voltage", f"{data.DataCollection.voltage} keV"),
        ("Magnification", "105000.0"),
        ("Pixel size", f"{data.DataCollection.pixelSizeOnImage} Å"),
        (
            "Image size",
            f"{data.DataCollection.imageSizeX} x {data.DataCollection.imageSizeY}",
        ),
        ("Exposure time", f"{data.DataCollection.exposureTime} s"),
        ("Number of frames", str(first_motion_correction.MotionCorrection.lastFrame)),
        (
            "Dose per frame",
            f"{first_motion_correction.MotionCorrection.dosePerFrame} e− /Å2",
        ),
        ("C2 aperture size", f"{data.DataCollection.c2aperture} μm"),
        ("Slit width", f"{data.DataCollection.slitGapHorizontal} eV"),
    )

    pdf.set_y(80)
    pdf.caption(
        "Table 1: Parameters used for data collection",
    )

    pdf.add_table(parameter_table)

    # Motion correction, particle picking, CTF, general pre-processing
    median_motion = round(
        db.session.execute(
            select(
                func.percentile_disc(0.5)
                .within_group(MotionCorrection.totalMotion)
                .over(partition_by=MotionCorrection.autoProcProgramId)
            ).filter(
                MotionCorrection.autoProcProgramId
                == preprocess_program.autoProcProgramId
            )
        ).scalar_one(),
        1,
    )

    median_ctf_resolution = round(
        db.session.execute(
            select(
                func.percentile_disc(0.5)
                .within_group(CTF.estimatedResolution)
                .over(partition_by=CTF.autoProcProgramId)
            ).filter(CTF.autoProcProgramId == preprocess_program.autoProcProgramId)
        ).scalar_one(),
        1,
    )

    mean_particle_count = round(
        db.session.execute(
            select(func.avg(ParticlePicker.numberOfParticles)).filter(
                ParticlePicker.programId == preprocess_program.autoProcProgramId
            )
        ).scalar_one(),
        1,
    )

    particle_diameter = round(
        db.session.execute(
            select(ParticlePicker.particleDiameter).filter(
                ParticlePicker.programId == preprocess_program.autoProcProgramId,
                ParticlePicker.particleDiameter > 0,
            ).limit(1)
        ).scalar_one(),
        1,
    )

    pdf.add_h2("2 Pre-processing")
    pdf.paragraph(
        text=PRE_PROCESSING_TEXT.safe_substitute(
            median_motion=median_motion,
            file_path=f"{Path(data.DataCollection.imageDirectory).parent}/processed/{raw_name}",
            median_resolution=median_ctf_resolution,
            mean_particle_count=mean_particle_count,
            estimated_particle_diameter=particle_diameter,
        )
    )

    # Micrograph with most particles
    pdf.image(
        first_motion_correction.MotionCorrection.micrographSnapshotFullPath,
        h=60,
        y=200,
        x=20,
    )
    pdf.image(
        first_motion_correction.ParticlePicker.summaryImageFullPath, h=60, y=200, x=105
    )

    pdf.set_y(260)

    pdf.caption(
        "Figure 1: The motion corrected micrograph and pick locations for the micrograph with the most picked particles"
    )

    # Page 2
    pdf.add_page()

    # Micrograph with the second highest number of particles
    pdf.image(
        second_motion_correction.MotionCorrection.micrographSnapshotFullPath,
        h=60,
        y=30,
        x=20,
    )
    pdf.image(
        second_motion_correction.ParticlePicker.summaryImageFullPath, h=60, y=30, x=105
    )

    pdf.set_y(90)

    pdf.caption(
        "Figure 2: The motion corrected micrograph and pick locations for the micrograph with the second most "
        + "picked particles",
    )

    # Data regarding 2D and 3D classes, refinement and symmetry
    pdf.add_h2("3 Particle classification")

    class2d_groups = db.session.scalars(
        select(ParticleClassificationGroup).filter(
            ParticleClassificationGroup.programId == class2d_program.autoProcProgramId
        )
    ).all()

    if class2d_groups is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No 2D classification in data collection",
        )

    class2d_class_images: List[str] = []

    for class2d_group in class2d_groups:
        # Get two most populous 2D classes for each 2D classification group (batch)
        new_class_images = db.session.scalars(
            select(ParticleClassification.classImageFullPath)
            .filter(
                ParticleClassification.particleClassificationGroupId
                == class2d_group.particleClassificationGroupId,
                ParticleClassification.selected == 1,
            )
            .order_by(ParticleClassification.particlesPerClass.desc())
            .limit(2)
        ).all()

        if new_class_images:
            class2d_class_images += new_class_images

    if len(class2d_class_images) > 0:
        class2d_job = Path(class2d_class_images[0]).parent.parent
        batch_count = len(list(class2d_job.glob("job*")))

        # Binned pixel sizes are equal for any particle classification group, so it doesn't matter which one you pick
        pdf.paragraph(
            text=PARTICLE_CLASSIFICATION_TEXT.safe_substitute(
                batch_count=batch_count,
                binned_pixel_size=class2d_groups[0].binnedPixelSize or "N/A",
                particles_per_batch=50000,
                nyquist_freq=8.5,
            ),
        )

    # Display grid of most populous 2D classification images (2 per batch)
    for i, image in enumerate(class2d_class_images[:18]):
        size = (pdf.w - 20) / 9 - 1
        x = 10 + (size + 1) * (i % 9)
        y = 140 + (i // 9) * (size + 1)
        pdf.image(image, x=x, y=y, w=size)

    pdf.set_y(182)

    pdf.caption(
        "Figure 3: The most populous two classes from some 2D classification batches",
    )

    # 3D classification results, and prose detailing of symmetry/particle count for 3D class batches
    classes_3d = db.session.execute(
        select(ParticleClassification, ParticleClassificationGroup).filter(
            ParticleClassification.particleClassificationGroupId
            == ParticleClassificationGroup.particleClassificationGroupId,
            ParticleClassificationGroup.programId == class3d_program.autoProcProgramId,
        )
    ).all()

    pdf.paragraph(
        text=CLASSIFICATION_3D_TEXT.safe_substitute(
            particle_count=classes_3d[
                0
            ].ParticleClassificationGroup.numberOfParticlesPerBatch,
            symmetry=classes_3d[0].ParticleClassificationGroup.symmetry,
        )
    )

    class_3d_table = [
        ("Class number", "Number of particles", "Resolution", "Fourier completeness"),
    ]

    best_class: ParticleClassification = classes_3d[0].ParticleClassification
    best_class_index = 0

    # Skip the first one, since it's already selected as the best class by default
    for i, class_3d in enumerate(classes_3d[1:]):
        class_pc: ParticleClassification = class_3d.ParticleClassification
        if (
            best_class is None
            or class_pc.estimatedResolution > best_class.estimatedResolution
        ):
            best_class = class_pc
            best_class_index = i + 1
        class_3d_table.append(
            (
                str(i + 2),
                str(class_pc.particlesPerClass),
                str(class_pc.estimatedResolution),
                str(class_pc.overallFourierCompleteness),
            )
        )

    pdf.caption("Table 2: 3D classification results")
    pdf.add_table(class_3d_table)

    # Completeness refers to how "varied" and representative of the actual sample the collected data is.
    # Low completeness indicates that our particles are oriented mostly one way, and other orientations
    # are underrepresented in the dataset.
    pdf.set_y(252)
    pdf.paragraph(
        text=ANG_DIST_TEXT.safe_substitute(
            class_no=best_class_index + 1,
            sample_detail=(
                "multiple orientations visible"
                if best_class.overallFourierCompleteness > 0.9
                else "a strong preferred orientation"
            ),
        )
    )

    # Page 3
    pdf.add_page()
    # Angular distribution plot
    ang_dist_image = (
        f"{Path(best_class.classImageFullPath).parent}/"
        + f"{Path(best_class.classImageFullPath).stem}_angdist.jpeg"
    )
    pdf.image(ang_dist_image, x=65, y=25, w=80)
    pdf.set_y(75)
    pdf.caption(
        "Figure 4: The distribution of particle angles for the 3D class with the highest resolution",
    )

    classes_refinement = db.session.execute(
        select(ParticleClassification, ParticleClassificationGroup).filter(
            ParticleClassification.particleClassificationGroupId
            == ParticleClassificationGroup.particleClassificationGroupId,
            ParticleClassificationGroup.programId
            == refinement_program.autoProcProgramId,
        )
    ).all()

    # If the pipeline hasn't gone through a refinement step yet, there's no point in displaying this
    if classes_refinement is not None and len(classes_refinement) > 0:
        c1_refined = classes_refinement[0]
        c1_refined_index = 0
        # There are two refinement classes at most: one of which is C1, one of which is not C1.
        for i, c in enumerate(classes_refinement):
            if c.ParticleClassificationGroup.symmetry == "C1":
                c1_refined = c
                c1_refined_index = i

        pdf.paragraph(
            REFINEMENT_TEXT.safe_substitute(
                pixel_size=data.DataCollection.pixelSizeOnImage * 20,
                particle_count=classes_refinement[
                    0
                ].ParticleClassificationGroup.numberOfParticlesPerBatch,
                refined_resolution=c1_refined.ParticleClassification.estimatedResolution,
                refined_completeness=c1_refined.ParticleClassification.overallFourierCompleteness,
            )
        )

        # Penultimate paragraph, some older data collections don't have B-factor values
        if c1_refined.ParticleClassification.bFactorFitLinear:
            pdf.paragraph(
                B_FACTOR_TEXT.safe_substitute(
                    b_factor=round(
                        2 / c1_refined.ParticleClassification.bFactorFitLinear
                    )
                )
            )

        # Display refined symmetry text. That is, the class with symmetry >C1. If there is no
        # second refinement class, then there is no refined symmetry data to be displayed.
        if len(classes_refinement) == 2:
            sym_refined = classes_refinement[1 - c1_refined_index]
            pdf.paragraph(
                SYMMETRY_TEXT.safe_substitute(
                    symmetry=sym_refined.ParticleClassificationGroup.symmetry,
                    resolution=sym_refined.ParticleClassification.estimatedResolution,
                    completeness=sym_refined.ParticleClassification.overallFourierCompleteness,
                )
            )

    headers = {
        "Content-Disposition": f'inline; filename="report-{visit}-{raw_name}.pdf"'
    }
    return Response(
        bytes(pdf.output()),
        headers=headers,
        media_type="application/pdf",
    )
