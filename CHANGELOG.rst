==========
Changelog
==========

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