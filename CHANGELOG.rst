==========
Changelog
==========

+++++++++
v1.16.0 (17/03/2025)
+++++++++

**Added**

- Endpoint for generating SPA collection reports

+++++++++
v1.15.0 (10/03/2025)
+++++++++

**Added**

- Single data collection group endpoint

**Fixed**

- Fixed message queue connection parameters

+++++++++
v1.14.0 (06/03/2025)
+++++++++

**Added**

- Support picked tomogram retrieval @gmg29649

+++++++++
v1.13.0 (25/02/2025)
+++++++++

**Added**

- Include movie count in returned foil holes @gmg29649

**Changed**

- `hideUncollected` renamed to `hideSquares` in `/dataGroups/{dcgId}/grid-squares` @gmg29649
- Grid squares with empty image paths are not returned if `hideSquares` is true @gmg29649

+++++++++
v1.12.0 (17/02/2025)
+++++++++

**Added**

- Endpoint for registering email alerts (`dataGroups/{groupId}/alerts`)
- Send out emails when appropriate message queue messages are received

**Changed**

- Grid square and foil hole models now accept null values for location fields

+++++++++
v1.11.2 (07/02/2025)
+++++++++

**Changed**

- Include image in grid square model 

+++++++++
v1.11.1 (30/01/2025)
+++++++++

**Fixed**

- Movies with missing columns no longer throw internal server errors
- Data collections sorted on empty alignment quality columns now have predictable ordering

+++++++++
v1.11.0 (16/01/2025)
+++++++++

**Added**

- Added movie information endpoint (`/movie/{movieId}`) @gmg29649

+++++++++
v1.10.1 (14/01/2025)
+++++++++

**Changed**

- Coalesce null CTF values

+++++++++
v1.10.0 (10/12/2024)
+++++++++

**Added**

- Add GET /foil-holes/{foilHoleId}/movies endpoint
- Add GET /grid-squares/{gridSquareId}/foil-holes endpoint
- Add GET /grid-squares/{gridSquareId}/image endpoint
- Add GET /dataGroups/{groupId}/atlas/image endpoint
- Add GET /dataGroups/{groupId}/atlas endpoint
- Add GET /dataGroups/{groupId}/grid-squares endpoint

+++++++++
v1.9.0 (09/10/2024)
+++++++++

**Added**

- Include B-factor columns in particle classification data
- GZip support

+++++++++
v1.8.1 (23/09/2024)
+++++++++

**Changed**

- Semgented/denoised tomogram images are now sourced from the `ProcessedTomogram` table

+++++++++
v1.8.0 (28/08/2024)
+++++++++

**Added**

- Particle count per defocus value endpoint (:code:`/dataCollections/{collectionId}/ctf`)
- Particle count per resolution bin endpoint (:code:`/dataCollections/{collectionId}/particleCountPerResolution`)
- Custom model upload endpoint
- Sample handling redirect endpoint

+++++++++
v1.7.0 (20/06/2024)
+++++++++

**Added**

- Tomogram movie/thumbnail endpoints now support segmented movie/thumbnails

**Changed**

- Instead of setting :code:`denoised`, requests to tomogram movie/thumbnail endpoints must set :code:`movieType` to one of either "denoised" or "segmented"

+++++++++
v1.6.0 (14/05/2024)
+++++++++

**Added**

- B Factor fit plot (:code:`/{autoProcId}/bFactorFit`)

+++++++++
v1.5.0 (25/03/2024)
+++++++++

**Added**

- Endpoint for getting angle distribution plots (:code:`/autoProc/{autoProcId}/classification/{classificationId}/angleDistribution`)

**Fixed**

- Count of children in listing endpoints no longer return excess items for certain staff users

+++++++++
v1.4.1 (14/03/2024)
+++++++++

**Fixed**

- Session/proposal listings no longer show duplicate results

+++++++++
v1.4.0 (05/03/2024)
+++++++++

**Added**

- CTF endpoint for SPA now returns particle count for all image numbers
- Standard deviation is returned for average ice thickness

+++++++++
v1.3.2 (19/02/2024)
+++++++++

**Changed**

- Improved performance for :code:`/sessions` endpoint, only returns eBIC sessions
- Fixed parameter generation for tomogram reprocessing
- CTF endpoint for autoprocessing programs now returns particle count

+++++++++
v1.3.1 (14/02/2024)
+++++++++

**Changed**

- "Reprocessing enabled" check moved to individual endpoint (:code:`/proposals/{proposalReference}/sessions/{visitNumber}/reprocessingEnabled`)
- :code:`allowReprocessing` removed from processing job parameters endpoint

+++++++++
v1.3.0 (07/02/2024)
+++++++++

**Added**

- Data collection creation endpoint (:code:`/proposals/{propId}/sessions/{sessionId}/dataCollections`)
- :code:`sortBy` argument to data collection listing endpoint

+++++++++
v1.2.3 (05/02/2024)
+++++++++

**Changed**

- :code:`Extract downscale is now true by default`

**Fixed**

- Processing parameters now generate correct gain reference path

+++++++++
v1.2.2 (24/01/2024)
+++++++++

**Fixed**

- Fixed input validation on SPA reprocessing

+++++++++
v1.2.1 (23/01/2024)
+++++++++

**Changed**

- If there is no message queue user set, :code:`reprocessingAvailable` is always false
- Updated database models

+++++++++
v1.2.0 (09/01/2024)
+++++++++

**Changed**

- Add single session endpoint (:code:`/proposals/{proposalReference}/sessions/{visitNumber}`)
- Fix data collections not showing up, due to table model mismatch

+++++++++
v1.1.11 (27/11/2023)
+++++++++

**Changed**

- Return pixel size on image in data collections in angstroms rather than nanometres

+++++++++
v1.1.10 (16/11/2023)
+++++++++

**Changed**

- Include image directory in :code:`dataCollectionGroups` endpoint

+++++++++
v1.1.9 (31/10/2023)
+++++++++

**Changed**

- Phase plate status now accounts for column possibly being a string

+++++++++
v1.1.8 (30/10/2023)
+++++++++

**Changed**

- :code:`phasePlate` field in data collection endpoints now returns a string rather than an integer value
- Drift plot X is read and passed down from file, rather than inferred from linear sequence generated from the range of the array's length

+++++++++
v1.1.7 (26/10/2023)
+++++++++

**Removed**

- User can no longer get motion correction drift data from table

+++++++++
v1.1.6 (05/10/2023)
+++++++++

**Added**

- Added option to disable CORS

+++++++++
v1.1.5 (27/09/2023)
+++++++++

**Changed**

- Consider recipe in processing job ordering

+++++++++
v1.1.4 (08/09/2023)
+++++++++

**Changed**

- Motion correction drift (:code:`/movies/{movieId}/drift`) endpoint falls back to gathering data from file if database entries do not exist


+++++++++
v1.1.4 (08/09/2023)
+++++++++

**Changed**

- Motion correction drift (:code:`/movies/{movieId}/drift`) endpoint falls back to gathering data from file if database entries do not exist

+++++++++
v1.1.3 (22/08/2023)
+++++++++

**Changed**

- Update internal dependencies due to vulnerabilities (certifi)

+++++++++
v1.1.2 (14/07/2023)
+++++++++

**Changed**

- Fix duplicate sessions for non-admin users
- Disable reprocessing on inactive visits

+++++++++
v1.1.1 (12/07/2023)
+++++++++

**Added**

- Virtual host can be set in message queue configs

+++++++++
v1.1.0 (11/07/2023)
+++++++++

**Added**

- GET endpoint for processing job parameters (:code:`dataCollections/{collectionId}/reprocessing`)
- POST endpoint for firing off SPA reprocessing pipeline (:code:`dataCollections/{collectionId}/reprocessing/spa`)

**Changed**

- Processing job list endpoint is now ordered by both processing job and autoprocessing job
- Tomogram reprocessing endpoint moved to :code:`dataCollections/{collectionId}/reprocessing/tomograms`

+++++++++
v1.0.0 (20/06/2023)
+++++++++

**Changed**

- First public production release

+++++++++
v0.13.0 (13/06/2023)
+++++++++

**Added**

- Adds `getMiddle` option to tomogram motion correction endpoint

+++++++++
v0.12.1 (08/06/2023)
+++++++++

**Changed**

- Permission lists take in strings rather than integers

+++++++++
v0.12.0 (06/06/2023)
+++++++++

**Added**

- Adds denoised central slices
- countCollections option for session query

++++++++++
v0.11.0 (30/05/2023)
++++++++++

**Added**

- Logs HTTP exceptions server-side

**Changed**

- Classes are sorted in ascending order when estimated resolution is selected as sorting criterion

++++++++++
v0.10.0 (16/05/2023)
++++++++++

**Added**

- User can now filter classes by selection status

++++++++++
v0.9.0 (24/04/2023)
++++++++++

**Added**

- Tomogram endpoint now includes processing data information

++++++++++
v0.8.1 (31/03/2023)
++++++++++

**Changed**

- Tomogram endpoint returns refined tilt axis

++++++++++
v0.8.0 (28/03/2023)
++++++++++

**Added**

- Enables cookie authentication support

++++++++++
v0.7.0 (14/03/2023)
++++++++++

**Changed**

- Removes unused support for OIDC auth
- Fixes CTF data endpoint

++++++++++
v0.6.0 (28/02/2023)
++++++++++

**Added**

- Support for 3D classification in single particle analysis

**Changed**

- Performance improvements for session, data collection group and data collection listing queries

++++++++++
v0.5.0 (21/02/2023)
++++++++++

**Added**

- User can now initiate tomogram reprocessing for a given data collection :code:`dataCollections/{collectionId}/tomograms/reprocessing`
- Collection/autoprocessing (:code:`/dataCollections/{collectionId}` and :code:`/autoProc/{autoProcId}`) program frequency data is available for total motion (:code:`/motion`), estimated resolution (:code:`/resolution`) and particle count (:code:`/particles`)

**Changed**

- Fixes bug with histograms that omitted bins with no items

++++++++++
v0.4.0 (07/02/2023)
++++++++++

**Added**

- User can now retrieve tomogram that belongs to autoprocessing program (:code:`/autoProc/{autoProcId}/tomogram`)
- Added max/min end date, max/min start date query parameters to sessions endpoint

**Changed**

- Collection can now return up to 3 tomograms, returns paged object for :code:`/tomograms` (renamed from :code:`/tomogram`)
- Proposal search also searches through title


++++++++++
v0.3.3 (03/02/2023)
++++++++++

**Changed**

- Adheres to new relations between data collections and tomograms, returns first tomogram instead of erroring out if there are more than 1


++++++++++
v0.3.2 (02/02/2023)
++++++++++

**Changed**

- Fixes error caused by lack of ProcessingJobId column
- Updates database model

++++++++++
v0.3.1 (01/02/2023)
++++++++++

**Changed**

- Fixed auth information mappings for user object causing 500s

++++++++++
v0.3.0 (01/02/2023)
++++++++++

**Added**

- Frequency data for ice thickness in data collections (:code:`/dataCollections/{id}/iceThickness`) and autoprocessing programs (:code:`/dataCollections/{id}/iceThickness`)


**Changed**

- Moves data collection listing from :code:`/dataCollections` to :code:`/dataGroups/{groupId}/dataCollections`
- Data collection also displays column with index relative to parent data collection group

++++++++++
v0.2.0 (24/01/2023)
++++++++++

**Added**

- New endpoint for getting ice thickness data (:code:`/movie/{id}/iceThickness`)
- New endpoints for tomogram projection images (:code:`/tomograms/{id}/projection?axis={axis}`) and movie (:code:`/tomograms/{id}/movie`)
- Endpoints for additional tomogram projections

**Changed**

- Job status for autoprocessing is inferred from other columns and returned as :code:`status`
- Tomogram endpoints for central slice and XY shift plot obtain paths from new tomogram columns instead of autoprocessing attachments
- Sessions can be searched through their visit numbers as well
- Sessions also return their parent proposals
- Improvements to session query performance

++++++++++
v0.1.0 (12/01/2023)
++++++++++

**Added**

- New endpoint for getting processing jobs in data collections (:code:`/collections/{id}/processingJobs`)
- Autoprocessing program endpoints (:code:`/autoProc/{id}/ctf`, :code:`/autoproc/{id}/classification`, :code:`/autoProc/{id}/particlePicker` and :code:`/autoProc/{id}/motion`)
- Drift plot endpoint now support obtaining data directly from the DB instead of file (when :code:`fromDb` is set)
- New endpoints for getting 2d classification and particle picker images (:code:`image` suffix for both)
- Listing of data collections now supports filtering by data collections that contain valid tomograms (when :code:`onlyTomograms` is set)

**Changed**

- Data collection groups now also include experiment type information
- Session has been moved from being a child of :code:`proposals` to its own root endpoint (with :code:`proposal` being a query parameter)
- Data collection groups have been moved from being a child of :code:`sessions` to its own root endpoint (with :code:`proposal` and :code:`session` being query parameters)
- Data collections have been moved from being a child of :code:`dataGroups` to its own root endpoint (with :code:`groupId` being a query parameter)
- Overhaul of item count query; significant performance improvement
- Data collections now return all columns

++++++++++
v0.0.1 (06/12/2022)
++++++++++

**Changed**

- Search param :code:`s` renamed to :code:`search` for clarity
- Motion correction endpoints no longer return drift, and now support regular pagination. Drift is accessed through :code:`movies/{movieId}/drift`
- Moved :code:`image` endpoints to :code:`movies`
- Moved :code:`visits` to :code:`sessions`

++++++++++
v0.0.1-rc4 (06/12/2022)
++++++++++

**Changed**

- Authorisation and authentication is done through a separate microservice
- Data collection listing moved from :code:`/collection?group={id}` to :code:`dataGroups/{id}/collections`
- Visit listing moved from :code:`/visit?prop={id}` to :code:`proposals/{id}/visits`
- Data collection groups listing from :code:`/dataCollectionGroups?visit={id}` to :code:`visits/{id}/dataGroups`

++++++++++
v0.0.1-rc3 (30/11/2022)
++++++++++

**Added**

- Motion has been split into tomogram motion correction (with the prefix :code:`/tomograms`) and data collection motion correction (prefix :code:`/dataCollections`)

**Changed**

- Shift plot moved from :code:`/shiftPlot` to :code:`/tomograms/{tomogramId}/shiftPlot`
- Central slice moved from :code:`/image/slice/{tomogramId}`  to :code:`/tomograms/{tomogramId}/centralSlice`
- CTF moved from :code:`/ctf` to :code:`/tomograms/{tomogramId}/ctf`
- Listing of tomograms moved from :code:`/tomograms` to :code:`/dataCollections/{collectionId}/tomogram`
- Only a single tomogram is returned in the listing, as a one-to-one mapping between tomogram and collections is expected


++++++++++
v0.0.1-rc2 (25/11/2022)
++++++++++

**Added**

- Data collection group endpoint
- Support for configuration files
- Data collection groups and data collections are now searchable by comments
- Visits are now searchable by visit number
- Proposals are searchable by proposal code and proposal number
- User endpoint now also returns names, title and ID
- Model mapping for data collections and data collection groups

**Changed**

- Data collection moved from :code:`collection` to :code:`dataCollection`
- Data collections are now selected by group instead of visits

+++++++++
v0.0.1-rc1 (21/11/2022)
+++++++++

Initial version.
