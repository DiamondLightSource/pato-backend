from string import Template

DATA_COLLECTION_TEXT = Template(
    "This dataset was named $dataset_name. The raw data for this collection is in $file_path .In this, a total of " +
    "$micrograph_count micrographs were collected across $grid_square_count grid squares." +
    "The following parameters were set during data collection:"
)

PRE_PROCESSING_TEXT = Template(
    "Processed results from this collection are in $file_path. Pre-processing of the micrographs was carried out, "+
    "consisting of motion correction, CTF estimation and particle picking. The median motion was $median_motion Å " +
    "and the median resolution from CTF correction was $median_resolution Å. During particle picking a mean of " +
    "$mean_particle_count particles were found per micrograph, and an estimated particle diameter of "
    "$estimated_particle_diameter Å was determined."
)

PARTICLE_CLASSIFICATION_TEXT = Template(
    "Before classification the particles are binned to a pixel size that gives a Nyquist frequency of around " +
    "$nyquist_freq Å. The binned pixel size for this collection was $binned_pixel_size. $batch_count batches of 2D " +
    "classification were run, with $particles_per_batch particles in each batch. Figure 3 shows some examples of " +
    "the classes which were generated."
)

CLASSIFICATION_3D_TEXT = Template(
    "3D classification was run up to $particle_count particles using a symmetry of $symmetry. The classes produced " +
    "are given in the table below:"
)

ANG_DIST_TEXT = Template(
    "The Fourier completeness of class $class_no suggests this sample has $sample_detail. The angular distribution " +
    "of the particles in this class is shown in figure 4, which should indicate how many orientations are present."
)

REFINEMENT_TEXT = Template(
    """3D structural refinement was run using $particle_count particles and a pixel size of $pixel_size Å.
A final resolution of $refined_resolution Å was obtained with completeness $refined_completeness."""
)

B_FACTOR_TEXT = Template(
    "The estimated B-factor is $b_factor, but we caution that masks are not optimised and the performance of earlier " +
    "automated processing steps will affect the results, so you should be able to improve upon this."
)

SYMMETRY_TEXT = Template(
    "Following refinement, we estimate that the symmetry of the sample is $symmetry. " +
    "Using this symmetry refinement gives a final resolution of $resolution Å and completeness $completeness."
)
