/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.11-MariaDB, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: ispyb
-- ------------------------------------------------------
-- Server version	10.11.10-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AdminActivity`
--

DROP TABLE IF EXISTS `AdminActivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AdminActivity` (
  `adminActivityId` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL DEFAULT '',
  `action` varchar(45) DEFAULT NULL,
  `comments` varchar(100) DEFAULT NULL,
  `dateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`adminActivityId`),
  UNIQUE KEY `username` (`username`),
  KEY `AdminActivity_FKAction` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AdminActivity`
--

LOCK TABLES `AdminActivity` WRITE;
/*!40000 ALTER TABLE `AdminActivity` DISABLE KEYS */;
/*!40000 ALTER TABLE `AdminActivity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AdminVar`
--

DROP TABLE IF EXISTS `AdminVar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AdminVar` (
  `varId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `value` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`varId`),
  KEY `AdminVar_FKIndexName` (`name`),
  KEY `AdminVar_FKIndexValue` (`value`(767))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='ISPyB administration values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AdminVar`
--

LOCK TABLES `AdminVar` WRITE;
/*!40000 ALTER TABLE `AdminVar` DISABLE KEYS */;
INSERT INTO `AdminVar` VALUES
(4,'schemaVersion','4.7.0');
/*!40000 ALTER TABLE `AdminVar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Aperture`
--

DROP TABLE IF EXISTS `Aperture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Aperture` (
  `apertureId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sizeX` float DEFAULT NULL,
  PRIMARY KEY (`apertureId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Aperture`
--

LOCK TABLES `Aperture` WRITE;
/*!40000 ALTER TABLE `Aperture` DISABLE KEYS */;
/*!40000 ALTER TABLE `Aperture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Atlas`
--

DROP TABLE IF EXISTS `Atlas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Atlas` (
  `atlasId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionGroupId` int(11) NOT NULL,
  `atlasImage` varchar(255) NOT NULL COMMENT 'path to atlas image',
  `pixelSize` float NOT NULL COMMENT 'pixel size of atlas image',
  `cassetteSlot` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`atlasId`),
  KEY `Atlas_fk_dataCollectionGroupId` (`dataCollectionGroupId`),
  CONSTRAINT `Atlas_fk_dataCollectionGroupId` FOREIGN KEY (`dataCollectionGroupId`) REFERENCES `DataCollectionGroup` (`dataCollectionGroupId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Atlas of a Cryo-EM grid';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Atlas`
--

LOCK TABLES `Atlas` WRITE;
/*!40000 ALTER TABLE `Atlas` DISABLE KEYS */;
INSERT INTO `Atlas` VALUES
(1,5440742,'/dls/atlas.png',1,1);
/*!40000 ALTER TABLE `Atlas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProc`
--

DROP TABLE IF EXISTS `AutoProc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProc` (
  `autoProcId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `autoProcProgramId` int(10) unsigned DEFAULT NULL COMMENT 'Related program item',
  `spaceGroup` varchar(45) DEFAULT NULL COMMENT 'Space group',
  `refinedCell_a` float DEFAULT NULL COMMENT 'Refined cell',
  `refinedCell_b` float DEFAULT NULL COMMENT 'Refined cell',
  `refinedCell_c` float DEFAULT NULL COMMENT 'Refined cell',
  `refinedCell_alpha` float DEFAULT NULL COMMENT 'Refined cell',
  `refinedCell_beta` float DEFAULT NULL COMMENT 'Refined cell',
  `refinedCell_gamma` float DEFAULT NULL COMMENT 'Refined cell',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`autoProcId`),
  KEY `AutoProc_FKIndex1` (`autoProcProgramId`),
  KEY `AutoProc_refined_unit_cell` (`refinedCell_a`,`refinedCell_b`,`refinedCell_c`,`refinedCell_alpha`,`refinedCell_beta`,`refinedCell_gamma`)
) ENGINE=InnoDB AUTO_INCREMENT=603745 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProc`
--

LOCK TABLES `AutoProc` WRITE;
/*!40000 ALTER TABLE `AutoProc` DISABLE KEYS */;
INSERT INTO `AutoProc` VALUES
(596406,56425592,'P 6 2 2',92.5546,92.5546,129.784,90,90,120,'2016-01-14 12:46:22'),
(596411,56425944,'P 63 2 2',92.53,92.53,129.75,90,90,120,'2016-01-14 13:09:51'),
(596418,56425952,'P 61 2 2',92.6461,92.6461,129.879,90,90,120,'2016-01-14 13:24:22'),
(596419,56425963,'P 63 2 2',92.511,92.511,129.722,90,90,120,'2016-01-14 13:34:34'),
(596420,56426286,'P 61 2 2',92.693,92.693,129.839,90,90,120,'2016-01-14 14:01:57'),
(596421,56426287,'P 63 2 2',92.64,92.64,129.77,90,90,120,'2016-01-14 14:13:57'),
(603708,56983954,'I 2 3',78.1548,78.1548,78.1548,90,90,90,'2016-01-22 11:34:03'),
(603731,56985584,'I 2 3',78.15,78.15,78.15,90,90,90,'2016-01-22 11:52:36'),
(603732,56985589,'I 2 3',78.157,78.157,78.157,90,90,90,'2016-01-22 11:53:38'),
(603735,56985592,'I 2 3',78.15,78.15,78.15,90,90,90,'2016-01-22 11:54:01'),
(603744,56986673,'I 2 3',78.1381,78.1381,78.1381,90,90,90,'2016-01-22 12:01:59');
/*!40000 ALTER TABLE `AutoProc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcIntegration`
--

DROP TABLE IF EXISTS `AutoProcIntegration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcIntegration` (
  `autoProcIntegrationId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `dataCollectionId` int(11) unsigned NOT NULL COMMENT 'DataCollection item',
  `autoProcProgramId` int(10) unsigned DEFAULT NULL COMMENT 'Related program item',
  `startImageNumber` int(10) unsigned DEFAULT NULL COMMENT 'start image number',
  `endImageNumber` int(10) unsigned DEFAULT NULL COMMENT 'end image number',
  `refinedDetectorDistance` float DEFAULT NULL COMMENT 'Refined DataCollection.detectorDistance',
  `refinedXBeam` float DEFAULT NULL COMMENT 'Refined DataCollection.xBeam',
  `refinedYBeam` float DEFAULT NULL COMMENT 'Refined DataCollection.yBeam',
  `rotationAxisX` float DEFAULT NULL COMMENT 'Rotation axis',
  `rotationAxisY` float DEFAULT NULL COMMENT 'Rotation axis',
  `rotationAxisZ` float DEFAULT NULL COMMENT 'Rotation axis',
  `beamVectorX` float DEFAULT NULL COMMENT 'Beam vector',
  `beamVectorY` float DEFAULT NULL COMMENT 'Beam vector',
  `beamVectorZ` float DEFAULT NULL COMMENT 'Beam vector',
  `cell_a` float DEFAULT NULL COMMENT 'Unit cell',
  `cell_b` float DEFAULT NULL COMMENT 'Unit cell',
  `cell_c` float DEFAULT NULL COMMENT 'Unit cell',
  `cell_alpha` float DEFAULT NULL COMMENT 'Unit cell',
  `cell_beta` float DEFAULT NULL COMMENT 'Unit cell',
  `cell_gamma` float DEFAULT NULL COMMENT 'Unit cell',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  `anomalous` tinyint(1) DEFAULT 0 COMMENT 'boolean type:0 noanoum - 1 anoum',
  PRIMARY KEY (`autoProcIntegrationId`),
  KEY `AutoProcIntegrationIdx1` (`dataCollectionId`),
  KEY `AutoProcIntegration_FKIndex1` (`autoProcProgramId`),
  CONSTRAINT `AutoProcIntegration_ibfk_1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `AutoProcIntegration_ibfk_2` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=600377 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcIntegration`
--

LOCK TABLES `AutoProcIntegration` WRITE;
/*!40000 ALTER TABLE `AutoProcIntegration` DISABLE KEYS */;
INSERT INTO `AutoProcIntegration` VALUES
(592508,993677,56425592,NULL,NULL,NULL,209.131,215.722,NULL,NULL,NULL,NULL,NULL,NULL,92.5546,92.5546,129.784,90,90,120,'2016-01-14 12:46:22',0),
(592513,993677,56425944,1,3600,193.939,209.052,215.618,NULL,NULL,NULL,NULL,NULL,NULL,92.532,92.532,129.747,90,90,120,'2016-01-14 13:09:51',0),
(592520,993677,56425952,1,3600,194.077,209.062,215.62,NULL,NULL,NULL,NULL,NULL,NULL,92.6461,92.6461,129.879,90,90,120,'2016-01-14 13:24:22',0),
(592521,993677,56425963,1,3600,193.893,209.135,215.719,NULL,NULL,NULL,NULL,NULL,NULL,92.5114,92.5114,129.722,90,90,120,'2016-01-14 13:34:35',0),
(592522,993677,56426286,1,3600,194.077,209.062,215.62,NULL,NULL,NULL,NULL,NULL,NULL,92.6461,92.6461,129.879,90,90,120,'2016-01-14 14:01:57',0),
(592523,993677,56426286,1,1800,194.147,209.069,215.622,NULL,NULL,NULL,NULL,NULL,NULL,92.7867,92.7867,129.759,90,90,120,'2016-01-14 14:01:57',0),
(592524,993677,56426287,1,3600,193.939,209.052,215.618,NULL,NULL,NULL,NULL,NULL,NULL,92.531,92.531,129.745,90,90,120,'2016-01-14 14:13:57',0),
(592525,993677,56426287,1,1800,194.388,209.058,215.61,NULL,NULL,NULL,NULL,NULL,NULL,92.847,92.847,129.817,90,90,120,'2016-01-14 14:13:57',0),
(600339,1002287,56983954,NULL,NULL,NULL,209.264,215.741,NULL,NULL,NULL,NULL,NULL,NULL,78.1548,78.1548,78.1548,90,90,90,'2016-01-22 11:34:03',0),
(600362,1002287,56985584,1,7200,175.977,209.186,215.643,NULL,NULL,NULL,NULL,NULL,NULL,78.153,78.153,78.153,90,90,90,'2016-01-22 11:52:36',0),
(600363,1002287,56985589,1,7200,176.262,209.264,215.741,NULL,NULL,NULL,NULL,NULL,NULL,78.1569,78.1569,78.1569,90,90,90,'2016-01-22 11:53:38',0),
(600366,1002287,56985592,1,7200,176.239,209.177,215.651,NULL,NULL,NULL,NULL,NULL,NULL,78.153,78.153,78.153,90,90,90,'2016-01-22 11:54:01',0),
(600376,1002287,56986673,1,7200,176.219,209.178,215.653,NULL,NULL,NULL,NULL,NULL,NULL,78.1381,78.1381,78.1381,90,90,90,'2016-01-22 12:01:59',0);
/*!40000 ALTER TABLE `AutoProcIntegration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcProgram`
--

DROP TABLE IF EXISTS `AutoProcProgram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcProgram` (
  `autoProcProgramId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `processingCommandLine` varchar(255) DEFAULT NULL COMMENT 'Command line for running the automatic processing',
  `processingPrograms` varchar(255) DEFAULT NULL COMMENT 'Processing programs (comma separated)',
  `processingStatus` tinyint(1) DEFAULT NULL COMMENT 'success (1) / fail (0)',
  `processingMessage` varchar(255) DEFAULT NULL COMMENT 'warning, error,...',
  `processingStartTime` datetime DEFAULT NULL COMMENT 'Processing start time',
  `processingEndTime` datetime DEFAULT NULL COMMENT 'Processing end time',
  `processingEnvironment` varchar(255) DEFAULT NULL COMMENT 'Cpus, Nodes,...',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  `processingJobId` int(11) unsigned DEFAULT NULL,
  `processingPipelineId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`autoProcProgramId`),
  KEY `AutoProcProgram_FK2` (`processingJobId`),
  CONSTRAINT `AutoProcProgram_FK2` FOREIGN KEY (`processingJobId`) REFERENCES `ProcessingJob` (`processingJobId`)
) ENGINE=InnoDB AUTO_INCREMENT=56986807 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcProgram`
--

LOCK TABLES `AutoProcProgram` WRITE;
/*!40000 ALTER TABLE `AutoProcProgram` DISABLE KEYS */;
INSERT INTO `AutoProcProgram` VALUES
(56425592,'/dls_sw/apps/fast_dp/2395/src/fast_dp.py -a S -j 0 -J 18 /dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/tlys_jan_4_1_0001.cbf','fast_dp',1,NULL,NULL,NULL,NULL,'2016-01-14 12:46:22',NULL,NULL),
(56425944,'xia2 min_images=3 -3dii -xparallel -1 -atom s -blend -project cm14451v1 -crystal xtlysjan41 -ispyb_xml_out ispyb.xml image=/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/tlys_jan_4_1_0001.cbf','xia2 3dii',1,NULL,NULL,NULL,NULL,'2016-01-14 13:09:51',NULL,NULL),
(56425952,'xia2 min_images=3 -dials -xparallel -1 -atom s -blend -project cm14451v1 -crystal xtlysjan41 -ispyb_xml_out ispyb.xml image=/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/tlys_jan_4_1_0001.cbf','xia2 dials',1,NULL,NULL,NULL,NULL,'2016-01-14 13:24:22',NULL,NULL),
(56425963,'/dls_sw/apps/GPhL/autoPROC/20151214/autoPROC/bin/linux64/process -xml -Id xtlysjan41,/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/,tlys_jan_4_1_####.cbf,1,3600 autoPROC_XdsKeyword_MAXIMUM_NUMBER_OF_PROCESSORS=12 autoPROC_XdsKeyword_MAXIMUM_NUMBER_OF_J','autoPROC 1.0.4 (see: http://www.globalphasing.com/autoproc/)',1,NULL,NULL,NULL,NULL,'2016-01-14 13:34:34',NULL,NULL),
(56426286,'xia2 min_images=3 -dials -atom s -blend -ispyb_xml_out ispyb.xml image=/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/linediffraction_1_0001.cbf image=/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/tlys_jan_4_1_0001.cbf','xia2 dials',1,NULL,NULL,NULL,NULL,'2016-01-14 14:01:57',NULL,NULL),
(56426287,'xia2 min_images=3 -3dii -atom s -blend -ispyb_xml_out ispyb.xml image=/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/linediffraction_1_0001.cbf image=/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/tlys_jan_4_1_0001.cbf','xia2 3dii',1,NULL,NULL,NULL,NULL,'2016-01-14 14:13:57',NULL,NULL),
(56983954,'/dls_sw/apps/fast_dp/2395/src/fast_dp.py -a S -j 0 -J 18 /dls/i03/data/2016/cm14451-1/20160122/gw/ins2/001/ins2_2_0001.cbf','fast_dp',1,NULL,NULL,NULL,NULL,'2016-01-22 11:34:03',NULL,NULL),
(56985584,'xia2 min_images=3 -3d -xparallel -1 -atom s -blend -project cm14451v1 -crystal xins22 -ispyb_xml_out ispyb.xml image=/dls/i03/data/2016/cm14451-1/20160122/gw/ins2/001/ins2_2_0001.cbf','xia2 3d',1,NULL,NULL,NULL,NULL,'2016-01-22 11:52:36',NULL,NULL),
(56985589,'/dls_sw/apps/GPhL/autoPROC/20151214/autoPROC/bin/linux64/process -xml -Id xins22,/dls/i03/data/2016/cm14451-1/20160122/gw/ins2/001/,ins2_2_####.cbf,1,7200 autoPROC_XdsKeyword_MAXIMUM_NUMBER_OF_PROCESSORS=12 autoPROC_XdsKeyword_MAXIMUM_NUMBER_OF_JOBS=4 Sto','autoPROC 1.0.4 (see: http://www.globalphasing.com/autoproc/)',1,NULL,NULL,NULL,NULL,'2016-01-22 11:53:38',NULL,NULL),
(56985592,'xia2 min_images=3 -3dii -xparallel -1 -atom s -blend -project cm14451v1 -crystal xins22 -ispyb_xml_out ispyb.xml image=/dls/i03/data/2016/cm14451-1/20160122/gw/ins2/001/ins2_2_0001.cbf','xia2 3dii',1,NULL,NULL,NULL,NULL,'2016-01-22 11:54:01',NULL,NULL),
(56986673,'xia2 min_images=3 -dials -xparallel -1 -atom s -blend -project cm14451v1 -crystal xins22 -ispyb_xml_out ispyb.xml image=/dls/i03/data/2016/cm14451-1/20160122/gw/ins2/001/ins2_2_0001.cbf','xia2 dials',1,NULL,NULL,NULL,NULL,'2016-01-22 12:01:59',5,NULL),
(56986674,'/dls_sw/apps/dimple/git-master/main.py  --dls-naming --slow -fpng /dls/i24/data/2018/cm19649-3/processed/test180731/hewlmesh_1/line4/hewlmesh_1_1_/xia2/3d-run/DataFiles/cm19649v3_xhewlmesh11_free.mtz /dls/i24/data/2018/cm19649-3/tmp/hewlmesh_1.4308.pdb /d','dimple',1,'Blob scores: 78','2018-07-31 08:55:52','2018-07-31 08:57:10',NULL,'2018-07-31 08:57:10',NULL,NULL),
(56986675,NULL,'dimple',0,'Unknown error','2018-07-31 08:57:12',NULL,NULL,NULL,NULL,NULL),
(56986676,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,6,NULL),
(56986677,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,7,NULL),
(56986678,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,8,NULL),
(56986679,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,9,NULL),
(56986680,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,10,NULL),
(56986800,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,9,NULL),
(56986801,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,1265,NULL),
(56986802,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,1265,NULL),
(56986803,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,54,NULL),
(56986804,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,51,NULL),
(56986805,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,52,NULL),
(56986806,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,53,NULL);
/*!40000 ALTER TABLE `AutoProcProgram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcProgramAttachment`
--

DROP TABLE IF EXISTS `AutoProcProgramAttachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcProgramAttachment` (
  `autoProcProgramAttachmentId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `autoProcProgramId` int(10) unsigned NOT NULL COMMENT 'Related autoProcProgram item',
  `fileType` enum('Log','Result','Graph','Debug','Input') DEFAULT NULL COMMENT 'Type of file Attachment',
  `fileName` varchar(255) DEFAULT NULL COMMENT 'Attachment filename',
  `filePath` varchar(255) DEFAULT NULL COMMENT 'Attachment filepath to disk storage',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  `importanceRank` tinyint(3) unsigned DEFAULT NULL COMMENT 'For the particular autoProcProgramId and fileType, indicate the importance of the attachment. Higher numbers are more important',
  `deleted` tinyint(1) DEFAULT 0 COMMENT '1/TRUE if the file has been deleted',
  PRIMARY KEY (`autoProcProgramAttachmentId`),
  KEY `AutoProcProgramAttachmentIdx1` (`autoProcProgramId`),
  CONSTRAINT `AutoProcProgramAttachmentFk1` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1037384 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcProgramAttachment`
--

LOCK TABLES `AutoProcProgramAttachment` WRITE;
/*!40000 ALTER TABLE `AutoProcProgramAttachment` DISABLE KEYS */;
INSERT INTO `AutoProcProgramAttachment` VALUES
(1023947,56425592,'Log','fast_dp.log','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/tlys_jan_4_1_/fast_dp','2016-01-14 12:46:22',NULL,0),
(1023955,56425944,'Result','cm14451v1_xtlysjan41_free.mtz','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/tlys_jan_4_1_/xia2/3dii-run/DataFiles','2016-01-14 13:09:51',NULL,0),
(1023956,56425944,'Log','xia2.html','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/tlys_jan_4_1_/xia2/3dii-run','2016-01-14 13:09:51',NULL,0),
(1023969,56425952,'Result','cm14451v1_xtlysjan41_free.mtz','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/tlys_jan_4_1_/xia2/dials-run/DataFiles','2016-01-14 13:24:22',NULL,0),
(1023970,56425952,'Log','xia2.html','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/tlys_jan_4_1_/xia2/dials-run','2016-01-14 13:24:22',NULL,0),
(1023971,56425963,'Log','autoPROC.log','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/tlys_jan_4_1_/autoPROC/ap-run','2016-01-14 13:34:34',NULL,0),
(1023972,56425963,'Result','truncate-unique.mtz','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/tlys_jan_4_1_/autoPROC/ap-run','2016-01-14 13:34:34',NULL,0),
(1023973,56426286,'Result','AUTOMATIC_DEFAULT_free.mtz','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/linediffraction_1_/multi-xia2/dials/DataFiles','2016-01-14 14:01:57',NULL,0),
(1023974,56426286,'Log','xia2.html','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/linediffraction_1_/multi-xia2/dials','2016-01-14 14:01:57',NULL,0),
(1023975,56426287,'Result','AUTOMATIC_DEFAULT_free.mtz','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/linediffraction_1_/multi-xia2/3dii/DataFiles','2016-01-14 14:13:57',NULL,0),
(1023976,56426287,'Log','xia2.html','/dls/i03/data/2016/cm14451-1/processed/20160114/tlys_jan_4/linediffraction_1_/multi-xia2/3dii','2016-01-14 14:13:57',NULL,0),
(1037121,56983954,'Log','fast_dp.log','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/fast_dp','2016-01-22 11:34:03',NULL,0),
(1037160,56985584,'Result','cm14451v1_xins22_free.mtz','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/xia2/3d-run/DataFiles','2016-01-22 11:52:36',NULL,0),
(1037161,56985584,'Log','xia2.html','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/xia2/3d-run','2016-01-22 11:52:36',NULL,0),
(1037162,56985589,'Log','autoPROC.log','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/autoPROC/ap-run','2016-01-22 11:53:38',NULL,0),
(1037163,56985589,'Result','truncate-unique.mtz','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/autoPROC/ap-run','2016-01-22 11:53:38',NULL,0),
(1037168,56985592,'Result','cm14451v1_xins22_free.mtz','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/xia2/3dii-run/DataFiles','2016-01-22 11:54:01',NULL,0),
(1037169,56985592,'Log','xia2.html','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/xia2/3dii-run','2016-01-22 11:54:01',NULL,0),
(1037183,56986673,'Result','cm14451v1_xins22_free.mtz','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/xia2/dials-run/DataFiles','2016-01-22 12:01:59',NULL,0),
(1037184,56986673,'Log','xia2.html','/dls/i03/data/2016/cm14451-1/processed/20160122/gw/ins2/001/ins2_2_/xia2/dials-run','2016-01-22 12:01:59',NULL,0),
(1037185,56986674,'Input','--slow','/dls/i24/data/2018/cm19649-3/processed/test180731/hewlmesh_1/line4/hewlmesh_1_1_/xia2/3d-run/dimple','2018-07-31 08:57:10',NULL,0),
(1037186,56986674,'Input','--dls-naming','/dls/i24/data/2018/cm19649-3/processed/test180731/hewlmesh_1/line4/hewlmesh_1_1_/xia2/3d-run/dimple','2018-07-31 08:57:10',NULL,0),
(1037187,56986674,'Result','final.pdb','/dls/i24/data/2018/cm19649-3/processed/test180731/hewlmesh_1/line4/hewlmesh_1_1_/xia2/3d-run/dimple','2018-07-31 08:57:10',NULL,0),
(1037188,56986674,'Result','final.mtz','/dls/i24/data/2018/cm19649-3/processed/test180731/hewlmesh_1/line4/hewlmesh_1_1_/xia2/3d-run/dimple','2018-07-31 08:57:10',NULL,0),
(1037189,56986674,'Log','dimple.log','/dls/i24/data/2018/cm19649-3/processed/test180731/hewlmesh_1/line4/hewlmesh_1_1_/xia2/3d-run/dimple','2018-07-31 08:57:10',0,0),
(1037190,56986676,'Result','test.png','/mnt/',NULL,NULL,0),
(1037191,56986676,'Graph','test_xy_shift.json','/mnt/',NULL,NULL,0),
(1037192,56986677,'Result','test.png','/mnt/test.png',NULL,NULL,0),
(1037193,56986677,'Graph','test_xy_shift.json','/mnt/test_xy_shift.json',NULL,NULL,0),
(1037194,56986678,'Result','test.png','/mnt/test.png',NULL,NULL,0),
(1037195,56986678,'Graph','test_xy_shift.json','/mnt/test_xy_shift.json',NULL,NULL,0),
(1037196,56986679,'Result','test.png','/mnt/test.png',NULL,NULL,0),
(1037197,56986679,'Graph','test_xy_shift.json','/mnt/test_xy_shift.json',NULL,NULL,0);
/*!40000 ALTER TABLE `AutoProcProgramAttachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcProgramMessage`
--

DROP TABLE IF EXISTS `AutoProcProgramMessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcProgramMessage` (
  `autoProcProgramMessageId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `autoProcProgramId` int(10) unsigned DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `severity` enum('ERROR','WARNING','INFO') NOT NULL,
  `message` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`autoProcProgramMessageId`),
  KEY `AutoProcProgramMessage_fk1` (`autoProcProgramId`),
  CONSTRAINT `AutoProcProgramMessage_fk1` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcProgramMessage`
--

LOCK TABLES `AutoProcProgramMessage` WRITE;
/*!40000 ALTER TABLE `AutoProcProgramMessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `AutoProcProgramMessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcScaling`
--

DROP TABLE IF EXISTS `AutoProcScaling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcScaling` (
  `autoProcScalingId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `autoProcId` int(10) unsigned DEFAULT NULL COMMENT 'Related autoProc item (used by foreign key)',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`autoProcScalingId`),
  KEY `AutoProcScalingFk1` (`autoProcId`),
  KEY `AutoProcScalingIdx1` (`autoProcScalingId`,`autoProcId`),
  CONSTRAINT `AutoProcScalingFk1` FOREIGN KEY (`autoProcId`) REFERENCES `AutoProc` (`autoProcId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=603471 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcScaling`
--

LOCK TABLES `AutoProcScaling` WRITE;
/*!40000 ALTER TABLE `AutoProcScaling` DISABLE KEYS */;
INSERT INTO `AutoProcScaling` VALUES
(596133,596406,'2016-01-14 12:46:22'),
(596138,596411,'2016-01-14 13:09:51'),
(596145,596418,'2016-01-14 13:24:22'),
(596146,596419,'2016-01-14 13:34:35'),
(596147,596420,'2016-01-14 14:01:57'),
(596148,596421,'2016-01-14 14:13:57'),
(603434,603708,'2016-01-22 11:34:03'),
(603457,603731,'2016-01-22 11:52:36'),
(603458,603732,'2016-01-22 11:53:38'),
(603461,603735,'2016-01-22 11:54:01'),
(603470,603744,'2016-01-22 12:01:59');
/*!40000 ALTER TABLE `AutoProcScaling` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcScalingStatistics`
--

DROP TABLE IF EXISTS `AutoProcScalingStatistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcScalingStatistics` (
  `autoProcScalingStatisticsId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `autoProcScalingId` int(10) unsigned DEFAULT NULL COMMENT 'Related autoProcScaling item (used by foreign key)',
  `scalingStatisticsType` enum('overall','innerShell','outerShell') NOT NULL DEFAULT 'overall' COMMENT 'Scaling statistics type',
  `comments` varchar(255) DEFAULT NULL COMMENT 'Comments...',
  `resolutionLimitLow` float DEFAULT NULL COMMENT 'Low resolution limit',
  `resolutionLimitHigh` float DEFAULT NULL COMMENT 'High resolution limit',
  `rMerge` float DEFAULT NULL COMMENT 'Rmerge',
  `rMeasWithinIPlusIMinus` float DEFAULT NULL COMMENT 'Rmeas (within I+/I-)',
  `rMeasAllIPlusIMinus` float DEFAULT NULL COMMENT 'Rmeas (all I+ & I-)',
  `rPimWithinIPlusIMinus` float DEFAULT NULL COMMENT 'Rpim (within I+/I-) ',
  `rPimAllIPlusIMinus` float DEFAULT NULL COMMENT 'Rpim (all I+ & I-)',
  `fractionalPartialBias` float DEFAULT NULL COMMENT 'Fractional partial bias',
  `nTotalObservations` int(10) DEFAULT NULL COMMENT 'Total number of observations',
  `nTotalUniqueObservations` int(10) DEFAULT NULL COMMENT 'Total number unique',
  `meanIOverSigI` float DEFAULT NULL COMMENT 'Mean((I)/sd(I))',
  `completeness` float DEFAULT NULL COMMENT 'Completeness',
  `multiplicity` float DEFAULT NULL COMMENT 'Multiplicity',
  `anomalousCompleteness` float DEFAULT NULL COMMENT 'Anomalous completeness',
  `anomalousMultiplicity` float DEFAULT NULL COMMENT 'Anomalous multiplicity',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  `anomalous` tinyint(1) DEFAULT 0 COMMENT 'boolean type:0 noanoum - 1 anoum',
  `ccHalf` float DEFAULT NULL COMMENT 'information from XDS',
  `ccAnomalous` float DEFAULT NULL,
  `resIOverSigI2` float DEFAULT NULL COMMENT 'Resolution where I/Sigma(I) equals 2',
  PRIMARY KEY (`autoProcScalingStatisticsId`),
  KEY `AutoProcScalingStatistics_FKindexType` (`scalingStatisticsType`),
  KEY `AutoProcScalingStatistics_scalingId_statisticsType` (`autoProcScalingId`,`scalingStatisticsType`),
  CONSTRAINT `_AutoProcScalingStatisticsFk1` FOREIGN KEY (`autoProcScalingId`) REFERENCES `AutoProcScaling` (`autoProcScalingId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1792631 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcScalingStatistics`
--

LOCK TABLES `AutoProcScalingStatistics` WRITE;
/*!40000 ALTER TABLE `AutoProcScalingStatistics` DISABLE KEYS */;
INSERT INTO `AutoProcScalingStatistics` VALUES
(1770617,596133,'outerShell',NULL,1.65,1.61,0.766,NULL,0.789,NULL,NULL,NULL,105090,3089,5.5,97.8,34,96.8,17.8,'2016-01-14 12:46:22',0,91.7,15.8,NULL),
(1770618,596133,'innerShell',NULL,29.5,7.18,0.061,NULL,0.063,NULL,NULL,NULL,17093,593,61.7,98.6,28.8,100,19.5,'2016-01-14 12:46:22',0,99.9,73.4,NULL),
(1770619,596133,'overall',NULL,29.5,1.61,0.106,NULL,0.109,NULL,NULL,NULL,1588225,43478,30.2,99.8,36.5,99.8,19.4,'2016-01-14 12:46:22',0,99.9,60.5,NULL),
(1770632,596138,'outerShell',NULL,1.49,1.45,1.326,NULL,1.419,0.506,0.365,NULL,61482,4245,2,99.8,14.5,99.5,7.4,'2016-01-14 13:09:51',0,0.584,-0.059,NULL),
(1770633,596138,'innerShell',NULL,68.18,6.48,0.064,NULL,0.07,0.015,0.012,NULL,23609,800,58.6,99.8,29.5,100,19.7,'2016-01-14 13:09:51',0,0.998,0.732,NULL),
(1770634,596138,'overall',NULL,68.18,1.45,0.116,NULL,0.123,0.028,0.021,NULL,1942930,58601,22.9,99.9,33.2,99.9,17.4,'2016-01-14 13:09:51',0,0.999,0.592,NULL),
(1770653,596145,'outerShell',NULL,1.46,1.42,3.758,NULL,4.107,1.67,1.216,NULL,42977,4422,2.2,97.9,9.7,96.3,5,'2016-01-14 13:24:22',0,0.497,-0.012,NULL),
(1770654,596145,'innerShell',NULL,129.88,6.35,0.09,NULL,0.095,0.02,0.017,NULL,28041,858,32,100,32.7,100,21.3,'2016-01-14 13:24:22',0,0.996,0.556,NULL),
(1770655,596145,'overall',NULL,129.88,1.42,0.177,NULL,0.184,0.045,0.033,NULL,1942399,62483,16.4,99.8,31.1,99.7,16.2,'2016-01-14 13:24:22',0,0.999,0.343,NULL),
(1770656,596146,'outerShell',NULL,1.476,1.451,1.268,1.314,1.312,0.459,0.33,NULL,42945,2859,2.4,99.2,15,98.9,7.8,'2016-01-14 13:34:35',0,0.633,-0.059,NULL),
(1770657,596146,'innerShell',NULL,129.722,3.938,0.08,0.078,0.081,0.017,0.014,NULL,103297,3251,50.7,100,31.8,99.7,19.1,'2016-01-14 13:34:35',0,0.993,-0.169,NULL),
(1770658,596146,'overall',NULL,129.722,1.451,0.138,0.141,0.141,0.032,0.024,NULL,1953227,58523,22.5,100,33.4,100,17.8,'2016-01-14 13:34:35',0,0.996,0.035,NULL),
(1770659,596147,'outerShell',NULL,1.47,1.43,3.442,NULL,3.711,1.471,1.058,NULL,46996,4388,1.6,99,10.7,97.8,5.5,'2016-01-14 14:01:57',0,0.627,-0.004,NULL),
(1770660,596147,'innerShell',NULL,129.84,6.4,0.124,NULL,0.129,0.023,0.019,NULL,41147,842,27,100,48.9,100,31.8,'2016-01-14 14:01:57',0,0.996,0.532,NULL),
(1770661,596147,'overall',NULL,129.84,1.43,0.707,NULL,0.719,0.156,0.114,NULL,2865527,61286,14.1,99.9,46.8,99.8,24.3,'2016-01-14 14:01:57',0,0.998,0.175,NULL),
(1770662,596148,'outerShell',NULL,1.47,1.43,1.278,NULL,1.362,0.447,0.326,NULL,66780,4414,1.7,99.2,15.1,97,7.8,'2016-01-14 14:13:57',0,0.564,-0.056,NULL),
(1770663,596148,'innerShell',NULL,80.23,6.4,0.106,NULL,0.112,0.02,0.017,NULL,36380,837,58.7,100,43.5,100,28.9,'2016-01-14 14:13:57',0,0.987,0.717,NULL),
(1770664,596148,'overall',NULL,80.23,1.43,0.166,NULL,0.172,0.032,0.024,NULL,2926200,61215,22.9,99.9,47.8,99.8,25,'2016-01-14 14:13:57',0,0.997,0.589,NULL),
(1792520,603434,'outerShell',NULL,1.57,1.53,0.765,NULL,0.775,NULL,NULL,NULL,64789,889,7.4,97.6,72.9,97.3,37,'2016-01-22 11:34:03',0,97.7,-4.8,NULL),
(1792521,603434,'innerShell',NULL,27.63,6.84,0.043,NULL,0.044,NULL,NULL,NULL,10404,156,144.1,98.6,66.7,99,39.5,'2016-01-22 11:34:03',0,100,74.1,NULL),
(1792522,603434,'overall',NULL,27.63,1.53,0.073,NULL,0.074,NULL,NULL,NULL,946151,12186,50.8,99.8,77.6,99.8,40,'2016-01-22 11:34:03',0,100,41.3,NULL),
(1792589,603457,'outerShell',NULL,1.38,1.34,3.435,NULL,3.586,0.744,0.543,NULL,57789,1347,1.2,100,42.9,100,21.2,'2016-01-22 11:52:36',0,0.622,-0.017,NULL),
(1792590,603457,'innerShell',NULL,31.9,6,0.044,NULL,0.046,0.007,0.006,NULL,15766,225,131.3,99.6,70.1,100,40.5,'2016-01-22 11:52:36',0,1,0.665,NULL),
(1792591,603457,'overall',NULL,31.9,1.34,0.08,NULL,0.082,0.013,0.009,NULL,1309987,17989,34.2,100,72.8,100,37.2,'2016-01-22 11:52:36',0,1,0.484,NULL),
(1792592,603458,'outerShell',NULL,1.4,1.376,2.142,2.136,2.156,0.345,0.249,NULL,60591,813,2.4,100,74.5,100,38.1,'2016-01-22 11:53:38',0,0.908,0.059,NULL),
(1792593,603458,'innerShell',NULL,39.079,3.735,0.045,0.044,0.045,0.007,0.005,NULL,64542,887,114,99.9,72.8,99.9,40.2,'2016-01-22 11:53:38',0,1,0.267,NULL),
(1792594,603458,'overall',NULL,39.079,1.376,0.083,0.084,0.083,0.013,0.009,NULL,1275766,16626,35,100,76.7,100,39.9,'2016-01-22 11:53:38',0,1,0.217,NULL),
(1792601,603461,'outerShell',NULL,1.38,1.34,3.444,NULL,3.597,0.746,0.545,NULL,57746,1347,1.2,100,42.9,100,21.2,'2016-01-22 11:54:01',0,0.647,0.002,NULL),
(1792602,603461,'innerShell',NULL,31.9,6,0.044,NULL,0.046,0.007,0.006,NULL,15773,225,131.2,99.6,70.1,100,40.5,'2016-01-22 11:54:01',0,1,0.654,NULL),
(1792603,603461,'overall',NULL,31.9,1.34,0.08,NULL,0.082,0.013,0.009,NULL,1314502,17989,34.2,100,73.1,100,37.3,'2016-01-22 11:54:01',0,1,0.469,NULL),
(1792628,603470,'outerShell',NULL,1.36,1.33,3.124,NULL,3.246,0.711,0.515,NULL,53402,1370,1.3,100,39,100,19.2,'2016-01-22 12:01:59',0,0.703,0.017,NULL),
(1792629,603470,'innerShell',NULL,39.07,5.95,0.051,NULL,0.053,0.008,0.006,NULL,16799,235,117.7,99.7,71.5,100,41.9,'2016-01-22 12:01:59',0,1,0.654,NULL),
(1792630,603470,'overall',NULL,39.07,1.33,0.08,NULL,0.082,0.013,0.009,NULL,1305126,18395,30.9,100,71,100,36.1,'2016-01-22 12:01:59',0,1,0.482,NULL);
/*!40000 ALTER TABLE `AutoProcScalingStatistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcScaling_has_Int`
--

DROP TABLE IF EXISTS `AutoProcScaling_has_Int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcScaling_has_Int` (
  `autoProcScaling_has_IntId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `autoProcScalingId` int(10) unsigned DEFAULT NULL COMMENT 'AutoProcScaling item',
  `autoProcIntegrationId` int(10) unsigned NOT NULL COMMENT 'AutoProcIntegration item',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`autoProcScaling_has_IntId`),
  KEY `AutoProcScalingHasInt_FKIndex3` (`autoProcScalingId`,`autoProcIntegrationId`),
  KEY `AutoProcScal_has_IntIdx2` (`autoProcIntegrationId`),
  CONSTRAINT `AutoProcScaling_has_IntFk1` FOREIGN KEY (`autoProcScalingId`) REFERENCES `AutoProcScaling` (`autoProcScalingId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `AutoProcScaling_has_IntFk2` FOREIGN KEY (`autoProcIntegrationId`) REFERENCES `AutoProcIntegration` (`autoProcIntegrationId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=600376 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcScaling_has_Int`
--

LOCK TABLES `AutoProcScaling_has_Int` WRITE;
/*!40000 ALTER TABLE `AutoProcScaling_has_Int` DISABLE KEYS */;
INSERT INTO `AutoProcScaling_has_Int` VALUES
(592507,596133,592508,'2016-01-14 12:46:22'),
(592512,596138,592513,'2016-01-14 13:09:51'),
(592519,596145,592520,'2016-01-14 13:24:22'),
(592520,596146,592521,'2016-01-14 13:34:35'),
(592521,596147,592522,'2016-01-14 14:01:57'),
(592522,596147,592523,'2016-01-14 14:01:57'),
(592523,596148,592524,'2016-01-14 14:13:57'),
(592524,596148,592525,'2016-01-14 14:13:57'),
(600338,603434,600339,'2016-01-22 11:34:03'),
(600361,603457,600362,'2016-01-22 11:52:36'),
(600362,603458,600363,'2016-01-22 11:53:38'),
(600365,603461,600366,'2016-01-22 11:54:01'),
(600375,603470,600376,'2016-01-22 12:01:59');
/*!40000 ALTER TABLE `AutoProcScaling_has_Int` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoProcStatus`
--

DROP TABLE IF EXISTS `AutoProcStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AutoProcStatus` (
  `autoProcStatusId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `autoProcIntegrationId` int(10) unsigned NOT NULL,
  `step` enum('Indexing','Integration','Correction','Scaling','Importing') NOT NULL COMMENT 'autoprocessing step',
  `status` enum('Launched','Successful','Failed') NOT NULL COMMENT 'autoprocessing status',
  `comments` varchar(1024) DEFAULT NULL COMMENT 'comments',
  `bltimeStamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`autoProcStatusId`),
  KEY `AutoProcStatus_FKIndex1` (`autoProcIntegrationId`),
  CONSTRAINT `AutoProcStatus_ibfk_1` FOREIGN KEY (`autoProcIntegrationId`) REFERENCES `AutoProcIntegration` (`autoProcIntegrationId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='AutoProcStatus table is linked to AutoProcIntegration';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoProcStatus`
--

LOCK TABLES `AutoProcStatus` WRITE;
/*!40000 ALTER TABLE `AutoProcStatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `AutoProcStatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_automationError`
--

DROP TABLE IF EXISTS `BF_automationError`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_automationError` (
  `automationErrorId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `errorType` varchar(40) NOT NULL,
  `solution` text DEFAULT NULL,
  PRIMARY KEY (`automationErrorId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_automationError`
--

LOCK TABLES `BF_automationError` WRITE;
/*!40000 ALTER TABLE `BF_automationError` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_automationError` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_automationFault`
--

DROP TABLE IF EXISTS `BF_automationFault`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_automationFault` (
  `automationFaultId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `automationErrorId` int(10) unsigned DEFAULT NULL,
  `containerId` int(10) unsigned DEFAULT NULL,
  `severity` enum('1','2','3') DEFAULT NULL,
  `stacktrace` text DEFAULT NULL,
  `resolved` tinyint(1) DEFAULT NULL,
  `faultTimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`automationFaultId`),
  KEY `BF_automationFault_ibfk1` (`automationErrorId`),
  KEY `BF_automationFault_ibfk2` (`containerId`),
  CONSTRAINT `BF_automationFault_ibfk1` FOREIGN KEY (`automationErrorId`) REFERENCES `BF_automationError` (`automationErrorId`),
  CONSTRAINT `BF_automationFault_ibfk2` FOREIGN KEY (`containerId`) REFERENCES `Container` (`containerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_automationFault`
--

LOCK TABLES `BF_automationFault` WRITE;
/*!40000 ALTER TABLE `BF_automationFault` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_automationFault` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_component`
--

DROP TABLE IF EXISTS `BF_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_component` (
  `componentId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `systemId` int(10) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`componentId`),
  KEY `bf_component_FK1` (`systemId`),
  CONSTRAINT `bf_component_FK1` FOREIGN KEY (`systemId`) REFERENCES `BF_system` (`systemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_component`
--

LOCK TABLES `BF_component` WRITE;
/*!40000 ALTER TABLE `BF_component` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_component_beamline`
--

DROP TABLE IF EXISTS `BF_component_beamline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_component_beamline` (
  `component_beamlineId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `componentId` int(10) unsigned DEFAULT NULL,
  `beamlinename` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`component_beamlineId`),
  KEY `bf_component_beamline_FK1` (`componentId`),
  CONSTRAINT `bf_component_beamline_FK1` FOREIGN KEY (`componentId`) REFERENCES `BF_component` (`componentId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_component_beamline`
--

LOCK TABLES `BF_component_beamline` WRITE;
/*!40000 ALTER TABLE `BF_component_beamline` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_component_beamline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_fault`
--

DROP TABLE IF EXISTS `BF_fault`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_fault` (
  `faultId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sessionId` int(10) unsigned NOT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `subcomponentId` int(10) unsigned DEFAULT NULL,
  `starttime` datetime DEFAULT NULL,
  `endtime` datetime DEFAULT NULL,
  `beamtimelost` tinyint(1) DEFAULT NULL,
  `beamtimelost_starttime` datetime DEFAULT NULL,
  `beamtimelost_endtime` datetime DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `resolved` tinyint(1) DEFAULT NULL,
  `resolution` text DEFAULT NULL,
  `attachment` varchar(200) DEFAULT NULL,
  `eLogId` int(11) DEFAULT NULL,
  `assignee` varchar(50) DEFAULT NULL,
  `personId` int(10) unsigned DEFAULT NULL,
  `assigneeId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`faultId`),
  KEY `bf_fault_FK1` (`sessionId`),
  KEY `bf_fault_FK2` (`subcomponentId`),
  KEY `bf_fault_FK3` (`personId`),
  KEY `bf_fault_FK4` (`assigneeId`),
  CONSTRAINT `bf_fault_FK1` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`),
  CONSTRAINT `bf_fault_FK2` FOREIGN KEY (`subcomponentId`) REFERENCES `BF_subcomponent` (`subcomponentId`),
  CONSTRAINT `bf_fault_FK3` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`),
  CONSTRAINT `bf_fault_FK4` FOREIGN KEY (`assigneeId`) REFERENCES `Person` (`personId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_fault`
--

LOCK TABLES `BF_fault` WRITE;
/*!40000 ALTER TABLE `BF_fault` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_fault` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_subcomponent`
--

DROP TABLE IF EXISTS `BF_subcomponent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_subcomponent` (
  `subcomponentId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `componentId` int(10) unsigned DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`subcomponentId`),
  KEY `bf_subcomponent_FK1` (`componentId`),
  CONSTRAINT `bf_subcomponent_FK1` FOREIGN KEY (`componentId`) REFERENCES `BF_component` (`componentId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_subcomponent`
--

LOCK TABLES `BF_subcomponent` WRITE;
/*!40000 ALTER TABLE `BF_subcomponent` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_subcomponent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_subcomponent_beamline`
--

DROP TABLE IF EXISTS `BF_subcomponent_beamline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_subcomponent_beamline` (
  `subcomponent_beamlineId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subcomponentId` int(10) unsigned DEFAULT NULL,
  `beamlinename` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`subcomponent_beamlineId`),
  KEY `bf_subcomponent_beamline_FK1` (`subcomponentId`),
  CONSTRAINT `bf_subcomponent_beamline_FK1` FOREIGN KEY (`subcomponentId`) REFERENCES `BF_subcomponent` (`subcomponentId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_subcomponent_beamline`
--

LOCK TABLES `BF_subcomponent_beamline` WRITE;
/*!40000 ALTER TABLE `BF_subcomponent_beamline` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_subcomponent_beamline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_system`
--

DROP TABLE IF EXISTS `BF_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_system` (
  `systemId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`systemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_system`
--

LOCK TABLES `BF_system` WRITE;
/*!40000 ALTER TABLE `BF_system` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BF_system_beamline`
--

DROP TABLE IF EXISTS `BF_system_beamline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BF_system_beamline` (
  `system_beamlineId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `systemId` int(10) unsigned DEFAULT NULL,
  `beamlineName` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`system_beamlineId`),
  KEY `bf_system_beamline_FK1` (`systemId`),
  CONSTRAINT `bf_system_beamline_FK1` FOREIGN KEY (`systemId`) REFERENCES `BF_system` (`systemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BF_system_beamline`
--

LOCK TABLES `BF_system_beamline` WRITE;
/*!40000 ALTER TABLE `BF_system_beamline` DISABLE KEYS */;
/*!40000 ALTER TABLE `BF_system_beamline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BFactorFit`
--

DROP TABLE IF EXISTS `BFactorFit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BFactorFit` (
  `bFactorFitId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `particleClassificationId` int(11) unsigned NOT NULL,
  `resolution` float DEFAULT NULL COMMENT 'Resolution of a refined map using a given number of particles',
  `numberOfParticles` int(10) unsigned DEFAULT NULL COMMENT 'Number of particles used in refinement',
  `particleBatchSize` int(10) unsigned DEFAULT NULL COMMENT 'Number of particles in the batch that the B-factor analysis was performed on',
  PRIMARY KEY (`bFactorFitId`),
  KEY `BFactorFit_fk_particleClassificationId` (`particleClassificationId`),
  CONSTRAINT `BFactorFit_fk_particleClassificationId` FOREIGN KEY (`particleClassificationId`) REFERENCES `ParticleClassification` (`particleClassificationId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='CryoEM reconstruction resolution as a function of the number of particles for the creation of a Rosenthal-Henderson plot and the calculation of B-factors';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BFactorFit`
--

LOCK TABLES `BFactorFit` WRITE;
/*!40000 ALTER TABLE `BFactorFit` DISABLE KEYS */;
INSERT INTO `BFactorFit` VALUES
(1,1,1,1,1);
/*!40000 ALTER TABLE `BFactorFit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSample`
--

DROP TABLE IF EXISTS `BLSample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSample` (
  `blSampleId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `diffractionPlanId` int(10) unsigned DEFAULT NULL,
  `crystalId` int(10) unsigned DEFAULT NULL,
  `containerId` int(10) unsigned DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `code` varchar(45) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `holderLength` double DEFAULT NULL,
  `loopLength` double DEFAULT NULL,
  `loopType` varchar(45) DEFAULT NULL,
  `wireWidth` double DEFAULT NULL,
  `comments` varchar(1024) DEFAULT NULL,
  `completionStage` varchar(45) DEFAULT NULL,
  `structureStage` varchar(45) DEFAULT NULL,
  `publicationStage` varchar(45) DEFAULT NULL,
  `publicationComments` varchar(255) DEFAULT NULL,
  `blSampleStatus` varchar(20) DEFAULT NULL,
  `isInSampleChanger` tinyint(1) DEFAULT NULL,
  `lastKnownCenteringPosition` varchar(255) DEFAULT NULL,
  `POSITIONID` int(11) unsigned DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `SMILES` varchar(400) DEFAULT NULL COMMENT 'the symbolic description of the structure of a chemical compound',
  `blSubSampleId` int(11) unsigned DEFAULT NULL,
  `lastImageURL` varchar(255) DEFAULT NULL,
  `screenComponentGroupId` int(11) unsigned DEFAULT NULL,
  `volume` float DEFAULT NULL,
  `dimension1` double DEFAULT NULL,
  `dimension2` double DEFAULT NULL,
  `dimension3` double DEFAULT NULL,
  `shape` varchar(15) DEFAULT NULL,
  `packingFraction` float DEFAULT NULL,
  `preparationTemeprature` mediumint(9) DEFAULT NULL COMMENT 'Sample preparation temperature, Units: kelvin',
  `preparationHumidity` float DEFAULT NULL COMMENT 'Sample preparation humidity, Units: %',
  `blottingTime` int(11) unsigned DEFAULT NULL COMMENT 'Blotting time, Units: sec',
  `blottingForce` float DEFAULT NULL COMMENT 'Force used when blotting sample, Units: N?',
  `blottingDrainTime` int(11) unsigned DEFAULT NULL COMMENT 'Time sample left to drain after blotting, Units: sec',
  `support` varchar(50) DEFAULT NULL COMMENT 'Sample support material',
  `subLocation` smallint(5) unsigned DEFAULT NULL COMMENT 'Indicates the sample''s location on a multi-sample pin, where 1 is closest to the pin base',
  `staffComments` varchar(255) DEFAULT NULL COMMENT 'Any staff comments on the sample',
  `source` varchar(50) DEFAULT current_user(),
  PRIMARY KEY (`blSampleId`),
  KEY `BLSample_FKIndex1` (`containerId`),
  KEY `BLSample_FKIndex3` (`diffractionPlanId`),
  KEY `BLSample_FKIndex_Status` (`blSampleStatus`),
  KEY `BLSample_Index1` (`name`),
  KEY `crystalId` (`crystalId`,`containerId`),
  KEY `BLSampleImage_idx1` (`blSubSampleId`),
  KEY `BLSample_fk5` (`screenComponentGroupId`),
  CONSTRAINT `BLSample_fk5` FOREIGN KEY (`screenComponentGroupId`) REFERENCES `ScreenComponentGroup` (`screenComponentGroupId`),
  CONSTRAINT `BLSample_ibfk4` FOREIGN KEY (`blSubSampleId`) REFERENCES `BLSubSample` (`blSubSampleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `BLSample_ibfk_1` FOREIGN KEY (`containerId`) REFERENCES `Container` (`containerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSample_ibfk_2` FOREIGN KEY (`crystalId`) REFERENCES `Crystal` (`crystalId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSample_ibfk_3` FOREIGN KEY (`diffractionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=403495 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSample`
--

LOCK TABLES `BLSample` WRITE;
/*!40000 ALTER TABLE `BLSample` DISABLE KEYS */;
INSERT INTO `BLSample` VALUES
(11550,NULL,3918,1326,'Sample-001','SAM-011550','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:16:11',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11553,NULL,3921,1326,'Sample-002','SAM-011553','2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:21:43',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11556,NULL,3924,1326,'Sample-003','SAM-011556','3',NULL,NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11559,NULL,3927,1329,'Sample-004','SAM-011559','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11562,NULL,3930,1329,'Sample-005','SAM-011562','2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11565,NULL,3933,1329,'Sample-006','SAM-011565','3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11568,NULL,3936,1332,'Sample-007','SAM-011568','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11571,NULL,3939,1332,'Sample-008','SAM-011571','2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11574,NULL,3942,1332,'Sample-009','SAM-011574','3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11577,NULL,3942,1335,'Sample-010','SAM-011577','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11580,NULL,3942,1335,'Sample-011','SAM-011580','2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11583,NULL,3951,1335,'Sample-012','SAM-011583','3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11586,NULL,3954,NULL,'Sample-013','SAM-011586',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11589,NULL,3957,NULL,'Sample-014','SAM-011589',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(11592,NULL,3960,NULL,'Sample-015','SAM-011592',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:27:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(374695,NULL,310037,33049,'tlys_jan_4','HA00AU3712','4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-19 22:57:04',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398810,197784,333301,34864,'thau8','HA00AK8934','8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-19 22:57:05',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398816,197784,310037,34874,'thau88','HH00AU3788','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-09-30 14:21:28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398819,197784,310037,34877,'thau99','HH00AU3799','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-10-05 10:15:47',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398824,NULL,333308,34883,'XPDF-1','XPDF-0001',NULL,NULL,NULL,NULL,NULL,'Test sample for XPDF',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-10-26 14:47:58',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398827,NULL,333308,34883,'XPDF-2','XPDF-0002',NULL,NULL,NULL,NULL,NULL,'Test sample for XPDF',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-10-26 14:51:23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398828,NULL,NULL,34888,'hello','hello','1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2020-10-14 18:33:06',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398831,NULL,NULL,34894,'Sample 01',NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-01-04 15:05:52',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398832,NULL,NULL,34897,'Sample 01',NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-01-05 13:59:59',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(398833,NULL,NULL,34899,'Sample 01',NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-01-08 13:33:29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%');
/*!40000 ALTER TABLE `BLSample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleGroup`
--

DROP TABLE IF EXISTS `BLSampleGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleGroup` (
  `blSampleGroupId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT 'Human-readable name',
  `proposalId` int(10) unsigned DEFAULT NULL,
  `ownerId` int(10) unsigned DEFAULT NULL COMMENT 'Sample group owner',
  PRIMARY KEY (`blSampleGroupId`),
  KEY `BLSampleGroup_fk_proposalId` (`proposalId`),
  KEY `BLSampleGroup_fk_ownerId` (`ownerId`),
  CONSTRAINT `BLSampleGroup_fk_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `Person` (`personId`) ON UPDATE CASCADE,
  CONSTRAINT `BLSampleGroup_fk_proposalId` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleGroup`
--

LOCK TABLES `BLSampleGroup` WRITE;
/*!40000 ALTER TABLE `BLSampleGroup` DISABLE KEYS */;
INSERT INTO `BLSampleGroup` VALUES
(5,NULL,37027,NULL),
(6,'foo',37027,NULL),
(7,'bar',37027,NULL),
(10,'existingname',141666,NULL);
/*!40000 ALTER TABLE `BLSampleGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleGroup_has_BLSample`
--

DROP TABLE IF EXISTS `BLSampleGroup_has_BLSample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleGroup_has_BLSample` (
  `blSampleGroupId` int(11) unsigned NOT NULL,
  `blSampleId` int(11) unsigned NOT NULL,
  `groupOrder` mediumint(9) DEFAULT NULL,
  `type` enum('background','container','sample','calibrant','capillary') DEFAULT NULL,
  `blSampleTypeId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`blSampleGroupId`,`blSampleId`),
  KEY `BLSampleGroup_has_BLSample_ibfk2` (`blSampleId`),
  KEY `BLSampleGroup_has_BLSample_ibfk3` (`blSampleTypeId`),
  CONSTRAINT `BLSampleGroup_has_BLSample_ibfk1` FOREIGN KEY (`blSampleGroupId`) REFERENCES `BLSampleGroup` (`blSampleGroupId`),
  CONSTRAINT `BLSampleGroup_has_BLSample_ibfk2` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`),
  CONSTRAINT `BLSampleGroup_has_BLSample_ibfk3` FOREIGN KEY (`blSampleTypeId`) REFERENCES `BLSampleType` (`blSampleTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleGroup_has_BLSample`
--

LOCK TABLES `BLSampleGroup_has_BLSample` WRITE;
/*!40000 ALTER TABLE `BLSampleGroup_has_BLSample` DISABLE KEYS */;
INSERT INTO `BLSampleGroup_has_BLSample` VALUES
(5,398824,1,'background',NULL),
(5,398827,2,'sample',NULL),
(6,398810,NULL,NULL,NULL),
(7,374695,NULL,NULL,NULL),
(7,398810,NULL,NULL,NULL);
/*!40000 ALTER TABLE `BLSampleGroup_has_BLSample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImage`
--

DROP TABLE IF EXISTS `BLSampleImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImage` (
  `blSampleImageId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blSampleId` int(11) unsigned NOT NULL,
  `micronsPerPixelX` float DEFAULT NULL,
  `micronsPerPixelY` float DEFAULT NULL,
  `imageFullPath` varchar(255) DEFAULT NULL,
  `blSampleImageScoreId` int(11) unsigned DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `blTimeStamp` datetime DEFAULT NULL,
  `containerInspectionId` int(11) unsigned DEFAULT NULL,
  `modifiedTimeStamp` datetime DEFAULT NULL,
  `offsetX` int(11) NOT NULL DEFAULT 0 COMMENT 'The x offset of the image relative to the canvas',
  `offsetY` int(11) NOT NULL DEFAULT 0 COMMENT 'The y offset of the image relative to the canvas',
  PRIMARY KEY (`blSampleImageId`),
  UNIQUE KEY `BLSampleImage_imageFullPath` (`imageFullPath`),
  KEY `BLSampleImage_idx1` (`blSampleId`),
  KEY `BLSampleImage_fk2` (`containerInspectionId`),
  KEY `BLSampleImage_fk3` (`blSampleImageScoreId`),
  CONSTRAINT `BLSampleImage_fk1` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `BLSampleImage_fk2` FOREIGN KEY (`containerInspectionId`) REFERENCES `ContainerInspection` (`containerInspectionId`),
  CONSTRAINT `BLSampleImage_fk3` FOREIGN KEY (`blSampleImageScoreId`) REFERENCES `BLSampleImageScore` (`blSampleImageScoreId`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImage`
--

LOCK TABLES `BLSampleImage` WRITE;
/*!40000 ALTER TABLE `BLSampleImage` DISABLE KEYS */;
INSERT INTO `BLSampleImage` VALUES
(2,398819,NULL,NULL,'/dls/i03/data/2016/cm1234-5/something.jpg',NULL,NULL,'2016-10-05 11:23:33',NULL,NULL,0,0),
(5,398816,1.1,1.2,'/dls/i03/data/2016/cm1234-5/something-else.jpg',NULL,NULL,'2016-10-10 14:31:06',4,NULL,0,0);
/*!40000 ALTER TABLE `BLSampleImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImageAnalysis`
--

DROP TABLE IF EXISTS `BLSampleImageAnalysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImageAnalysis` (
  `blSampleImageAnalysisId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blSampleImageId` int(11) unsigned DEFAULT NULL,
  `oavSnapshotBefore` varchar(255) DEFAULT NULL,
  `oavSnapshotAfter` varchar(255) DEFAULT NULL,
  `deltaX` int(11) DEFAULT NULL,
  `deltaY` int(11) DEFAULT NULL,
  `goodnessOfFit` float DEFAULT NULL,
  `scaleFactor` float DEFAULT NULL,
  `resultCode` varchar(15) DEFAULT NULL,
  `matchStartTimeStamp` timestamp NULL DEFAULT current_timestamp(),
  `matchEndTimeStamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`blSampleImageAnalysisId`),
  KEY `BLSampleImageAnalysis_ibfk1` (`blSampleImageId`),
  CONSTRAINT `BLSampleImageAnalysis_ibfk1` FOREIGN KEY (`blSampleImageId`) REFERENCES `BLSampleImage` (`blSampleImageId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImageAnalysis`
--

LOCK TABLES `BLSampleImageAnalysis` WRITE;
/*!40000 ALTER TABLE `BLSampleImageAnalysis` DISABLE KEYS */;
INSERT INTO `BLSampleImageAnalysis` VALUES
(4,5,'/dls/i02-2/data/2016/cm14559-5/.ispyb/something.jpg',NULL,10,11,0.94,0.5,'OK','2016-12-09 12:32:24','2016-12-09 12:32:25');
/*!40000 ALTER TABLE `BLSampleImageAnalysis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImageAutoScoreClass`
--

DROP TABLE IF EXISTS `BLSampleImageAutoScoreClass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImageAutoScoreClass` (
  `blSampleImageAutoScoreClassId` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `blSampleImageAutoScoreSchemaId` tinyint(3) unsigned DEFAULT NULL,
  `scoreClass` varchar(15) NOT NULL COMMENT 'Thing being scored e.g. crystal, precipitant',
  PRIMARY KEY (`blSampleImageAutoScoreClassId`),
  KEY `BLSampleImageAutoScoreClass_fk1` (`blSampleImageAutoScoreSchemaId`),
  CONSTRAINT `BLSampleImageAutoScoreClass_fk1` FOREIGN KEY (`blSampleImageAutoScoreSchemaId`) REFERENCES `BLSampleImageAutoScoreSchema` (`blSampleImageAutoScoreSchemaId`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='The automated scoring classes - the thing being scored';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImageAutoScoreClass`
--

LOCK TABLES `BLSampleImageAutoScoreClass` WRITE;
/*!40000 ALTER TABLE `BLSampleImageAutoScoreClass` DISABLE KEYS */;
INSERT INTO `BLSampleImageAutoScoreClass` VALUES
(1,1,'clear'),
(2,1,'crystal'),
(3,1,'precipitant'),
(4,1,'other'),
(5,2,'clear'),
(6,2,'crystal'),
(7,2,'precipitant'),
(8,2,'other');
/*!40000 ALTER TABLE `BLSampleImageAutoScoreClass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImageAutoScoreSchema`
--

DROP TABLE IF EXISTS `BLSampleImageAutoScoreSchema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImageAutoScoreSchema` (
  `blSampleImageAutoScoreSchemaId` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `schemaName` varchar(25) NOT NULL COMMENT 'Name of the schema e.g. Hampton, MARCO',
  `enabled` tinyint(1) DEFAULT 1 COMMENT 'Whether this schema is enabled (could be configurable in the UI)',
  PRIMARY KEY (`blSampleImageAutoScoreSchemaId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Scoring schema name and whether it is enabled';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImageAutoScoreSchema`
--

LOCK TABLES `BLSampleImageAutoScoreSchema` WRITE;
/*!40000 ALTER TABLE `BLSampleImageAutoScoreSchema` DISABLE KEYS */;
INSERT INTO `BLSampleImageAutoScoreSchema` VALUES
(1,'MARCO',1),
(2,'CHIMP',1);
/*!40000 ALTER TABLE `BLSampleImageAutoScoreSchema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImageMeasurement`
--

DROP TABLE IF EXISTS `BLSampleImageMeasurement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImageMeasurement` (
  `blSampleImageMeasurementId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blSampleImageId` int(11) unsigned NOT NULL,
  `blSubSampleId` int(11) unsigned DEFAULT NULL,
  `startPosX` double DEFAULT NULL,
  `startPosY` double DEFAULT NULL,
  `endPosX` double DEFAULT NULL,
  `endPosY` double DEFAULT NULL,
  `blTimeStamp` datetime DEFAULT NULL,
  PRIMARY KEY (`blSampleImageMeasurementId`),
  KEY `BLSampleImageMeasurement_ibfk_1` (`blSampleImageId`),
  KEY `BLSampleImageMeasurement_ibfk_2` (`blSubSampleId`),
  CONSTRAINT `BLSampleImageMeasurement_ibfk_1` FOREIGN KEY (`blSampleImageId`) REFERENCES `BLSampleImage` (`blSampleImageId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSampleImageMeasurement_ibfk_2` FOREIGN KEY (`blSubSampleId`) REFERENCES `BLSubSample` (`blSubSampleId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='For measuring crystal growth over time';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImageMeasurement`
--

LOCK TABLES `BLSampleImageMeasurement` WRITE;
/*!40000 ALTER TABLE `BLSampleImageMeasurement` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSampleImageMeasurement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImageScore`
--

DROP TABLE IF EXISTS `BLSampleImageScore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImageScore` (
  `blSampleImageScoreId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `score` float DEFAULT NULL,
  `colour` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`blSampleImageScoreId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImageScore`
--

LOCK TABLES `BLSampleImageScore` WRITE;
/*!40000 ALTER TABLE `BLSampleImageScore` DISABLE KEYS */;
INSERT INTO `BLSampleImageScore` VALUES
(1,'Clear',0,'#cccccc'),
(2,'Contaminated',1,'#fffd96'),
(3,'Light Precipitate',2,'#fdfd96'),
(4,'Phase Separation',4,'#fdfd96'),
(5,'Spherulites',5,'#ffb347'),
(6,'Microcrystals',6,'#ffb347'),
(7,'1D Crystals',7,'#87ceeb'),
(8,'2D Crystals',8,'#77dd77'),
(9,'3D Crystals',9,'#77dd77'),
(10,'Heavy Precipitate',3,'#ff6961');
/*!40000 ALTER TABLE `BLSampleImageScore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImage_has_AutoScoreClass`
--

DROP TABLE IF EXISTS `BLSampleImage_has_AutoScoreClass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImage_has_AutoScoreClass` (
  `blSampleImageId` int(11) unsigned NOT NULL,
  `blSampleImageAutoScoreClassId` tinyint(3) unsigned NOT NULL,
  `probability` float DEFAULT NULL,
  PRIMARY KEY (`blSampleImageId`,`blSampleImageAutoScoreClassId`),
  KEY `BLSampleImage_has_AutoScoreClass_fk2` (`blSampleImageAutoScoreClassId`),
  CONSTRAINT `BLSampleImage_has_AutoScoreClass_fk1` FOREIGN KEY (`blSampleImageId`) REFERENCES `BLSampleImage` (`blSampleImageId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSampleImage_has_AutoScoreClass_fk2` FOREIGN KEY (`blSampleImageAutoScoreClassId`) REFERENCES `BLSampleImageAutoScoreClass` (`blSampleImageAutoScoreClassId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Many-to-many relationship between drop images and thing being scored, as well as the actual probability (score) that the drop image contains that thing';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImage_has_AutoScoreClass`
--

LOCK TABLES `BLSampleImage_has_AutoScoreClass` WRITE;
/*!40000 ALTER TABLE `BLSampleImage_has_AutoScoreClass` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSampleImage_has_AutoScoreClass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleImage_has_Positioner`
--

DROP TABLE IF EXISTS `BLSampleImage_has_Positioner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleImage_has_Positioner` (
  `blSampleImageHasPositionerId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `blSampleImageId` int(10) unsigned NOT NULL,
  `positionerId` int(10) unsigned NOT NULL,
  `value` float DEFAULT NULL COMMENT 'The position of this positioner for this blsampleimage',
  PRIMARY KEY (`blSampleImageHasPositionerId`),
  KEY `BLSampleImageHasPositioner_ibfk1` (`blSampleImageId`),
  KEY `BLSampleImageHasPositioner_ibfk2` (`positionerId`),
  CONSTRAINT `BLSampleImageHasPositioner_ibfk1` FOREIGN KEY (`blSampleImageId`) REFERENCES `BLSampleImage` (`blSampleImageId`),
  CONSTRAINT `BLSampleImageHasPositioner_ibfk2` FOREIGN KEY (`positionerId`) REFERENCES `Positioner` (`positionerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Allows a BLSampleImage to store motor positions along with the image';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleImage_has_Positioner`
--

LOCK TABLES `BLSampleImage_has_Positioner` WRITE;
/*!40000 ALTER TABLE `BLSampleImage_has_Positioner` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSampleImage_has_Positioner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSamplePosition`
--

DROP TABLE IF EXISTS `BLSamplePosition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSamplePosition` (
  `blSamplePositionId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `blSampleId` int(11) unsigned NOT NULL COMMENT 'FK, references parent sample',
  `posX` double DEFAULT NULL,
  `posY` double DEFAULT NULL,
  `posZ` double DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT current_timestamp(),
  `positionType` enum('dispensing') DEFAULT NULL COMMENT 'Type of marked position (e.g.: dispensing location)',
  PRIMARY KEY (`blSamplePositionId`),
  KEY `BLSamplePosition_fk_blSampleId` (`blSampleId`),
  CONSTRAINT `BLSamplePosition_fk_blSampleId` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSamplePosition`
--

LOCK TABLES `BLSamplePosition` WRITE;
/*!40000 ALTER TABLE `BLSamplePosition` DISABLE KEYS */;
INSERT INTO `BLSamplePosition` VALUES
(3,398833,1,1,1,'2025-05-14 08:22:40',NULL),
(4,398833,1,1,1,'2025-05-14 08:22:40','dispensing'),
(14,398832,1,1,1,'2025-05-14 08:22:40',NULL);
/*!40000 ALTER TABLE `BLSamplePosition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleType`
--

DROP TABLE IF EXISTS `BLSampleType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleType` (
  `blSampleTypeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `proposalType` varchar(10) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1 COMMENT '1=active, 0=inactive',
  PRIMARY KEY (`blSampleTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleType`
--

LOCK TABLES `BLSampleType` WRITE;
/*!40000 ALTER TABLE `BLSampleType` DISABLE KEYS */;
INSERT INTO `BLSampleType` VALUES
(1,'background','xpdf',1),
(2,'container','xpdf',1),
(3,'sample','xpdf',1),
(4,'calibrant','xpdf',1),
(5,'buffer','scm',1),
(6,'sample','scm',1),
(7,'sample','mx',1);
/*!40000 ALTER TABLE `BLSampleType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSampleType_has_Component`
--

DROP TABLE IF EXISTS `BLSampleType_has_Component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSampleType_has_Component` (
  `blSampleTypeId` int(10) unsigned NOT NULL,
  `componentId` int(10) unsigned NOT NULL,
  `abundance` float DEFAULT NULL,
  PRIMARY KEY (`blSampleTypeId`,`componentId`),
  KEY `blSampleType_has_Component_fk2` (`componentId`),
  CONSTRAINT `blSampleType_has_Component_fk1` FOREIGN KEY (`blSampleTypeId`) REFERENCES `Crystal` (`crystalId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `blSampleType_has_Component_fk2` FOREIGN KEY (`componentId`) REFERENCES `Protein` (`proteinId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSampleType_has_Component`
--

LOCK TABLES `BLSampleType_has_Component` WRITE;
/*!40000 ALTER TABLE `BLSampleType_has_Component` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSampleType_has_Component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSample_has_DataCollectionPlan`
--

DROP TABLE IF EXISTS `BLSample_has_DataCollectionPlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSample_has_DataCollectionPlan` (
  `blSampleId` int(11) unsigned NOT NULL,
  `dataCollectionPlanId` int(11) unsigned NOT NULL,
  `planOrder` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`blSampleId`,`dataCollectionPlanId`),
  KEY `BLSample_has_DataCollectionPlan_ibfk2` (`dataCollectionPlanId`),
  CONSTRAINT `BLSample_has_DataCollectionPlan_ibfk1` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`),
  CONSTRAINT `BLSample_has_DataCollectionPlan_ibfk2` FOREIGN KEY (`dataCollectionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSample_has_DataCollectionPlan`
--

LOCK TABLES `BLSample_has_DataCollectionPlan` WRITE;
/*!40000 ALTER TABLE `BLSample_has_DataCollectionPlan` DISABLE KEYS */;
INSERT INTO `BLSample_has_DataCollectionPlan` VALUES
(398824,197792,1),
(398827,197792,2);
/*!40000 ALTER TABLE `BLSample_has_DataCollectionPlan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSample_has_EnergyScan`
--

DROP TABLE IF EXISTS `BLSample_has_EnergyScan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSample_has_EnergyScan` (
  `blSampleId` int(10) unsigned NOT NULL DEFAULT 0,
  `energyScanId` int(10) unsigned NOT NULL DEFAULT 0,
  `blSampleHasEnergyScanId` int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`blSampleHasEnergyScanId`),
  KEY `BLSample_has_EnergyScan_FKIndex1` (`blSampleId`),
  KEY `BLSample_has_EnergyScan_FKIndex2` (`energyScanId`),
  CONSTRAINT `BLSample_has_EnergyScan_ibfk_1` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSample_has_EnergyScan_ibfk_2` FOREIGN KEY (`energyScanId`) REFERENCES `EnergyScan` (`energyScanId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSample_has_EnergyScan`
--

LOCK TABLES `BLSample_has_EnergyScan` WRITE;
/*!40000 ALTER TABLE `BLSample_has_EnergyScan` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSample_has_EnergyScan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSample_has_Ligand`
--

DROP TABLE IF EXISTS `BLSample_has_Ligand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSample_has_Ligand` (
  `blSampleId` int(10) unsigned NOT NULL,
  `ligandId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`blSampleId`,`ligandId`),
  KEY `BLSample_has_Ligand_fk2` (`ligandId`),
  CONSTRAINT `BLSample_has_Ligand_fk1` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSample_has_Ligand_fk2` FOREIGN KEY (`ligandId`) REFERENCES `Ligand` (`ligandId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Junction table for BLSample and Ligand';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSample_has_Ligand`
--

LOCK TABLES `BLSample_has_Ligand` WRITE;
/*!40000 ALTER TABLE `BLSample_has_Ligand` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSample_has_Ligand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSample_has_Positioner`
--

DROP TABLE IF EXISTS `BLSample_has_Positioner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSample_has_Positioner` (
  `blSampleHasPositioner` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `blSampleId` int(10) unsigned NOT NULL,
  `positionerId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`blSampleHasPositioner`),
  KEY `BLSampleHasPositioner_ibfk1` (`blSampleId`),
  KEY `BLSampleHasPositioner_ibfk2` (`positionerId`),
  CONSTRAINT `BLSampleHasPositioner_ibfk1` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`),
  CONSTRAINT `BLSampleHasPositioner_ibfk2` FOREIGN KEY (`positionerId`) REFERENCES `Positioner` (`positionerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSample_has_Positioner`
--

LOCK TABLES `BLSample_has_Positioner` WRITE;
/*!40000 ALTER TABLE `BLSample_has_Positioner` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSample_has_Positioner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSession`
--

DROP TABLE IF EXISTS `BLSession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSession` (
  `sessionId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `beamLineSetupId` int(10) unsigned DEFAULT NULL,
  `proposalId` int(10) unsigned NOT NULL DEFAULT 0,
  `beamCalendarId` int(10) unsigned DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `beamLineName` varchar(45) DEFAULT NULL,
  `scheduled` tinyint(1) DEFAULT NULL,
  `nbShifts` int(10) unsigned DEFAULT NULL,
  `comments` varchar(2000) DEFAULT NULL,
  `beamLineOperator` varchar(255) DEFAULT NULL,
  `bltimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `visit_number` int(10) unsigned DEFAULT 0,
  `usedFlag` tinyint(1) DEFAULT NULL COMMENT 'indicates if session has Datacollections or XFE or EnergyScans attached',
  `lastUpdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'last update timestamp: by default the end of the session, the last collect...',
  `externalId` binary(16) DEFAULT NULL,
  `archived` tinyint(1) DEFAULT 0 COMMENT 'The data for the session is archived and no longer available on disk',
  `riskRating` enum('Low','Medium','High','Not Permitted') DEFAULT NULL COMMENT 'ERA in user admin system',
  `purgedProcessedData` tinyint(1) DEFAULT 0 COMMENT 'Flag to indicate whether the processed folder in the associated visit directory has been purged',
  `icatId` int(11) unsigned DEFAULT NULL COMMENT 'The internal ICAT ID for this BLSession',
  PRIMARY KEY (`sessionId`),
  UNIQUE KEY `proposalId` (`proposalId`,`visit_number`),
  KEY `Session_FKIndex2` (`beamLineSetupId`),
  KEY `Session_FKIndexBeamLineName` (`beamLineName`),
  KEY `Session_FKIndexEndDate` (`endDate`),
  KEY `Session_FKIndexStartDate` (`startDate`),
  KEY `BLSession_fk_beamCalendarId` (`beamCalendarId`),
  CONSTRAINT `BLSession_fk_beamCalendarId` FOREIGN KEY (`beamCalendarId`) REFERENCES `BeamCalendar` (`beamCalendarId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `BLSession_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSession_ibfk_2` FOREIGN KEY (`beamLineSetupId`) REFERENCES `BeamLineSetup` (`beamLineSetupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27464464 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSession`
--

LOCK TABLES `BLSession` WRITE;
/*!40000 ALTER TABLE `BLSession` DISABLE KEYS */;
INSERT INTO `BLSession` VALUES
(9999,1,999999,1,'2016-03-11 09:00:00','2016-03-11 17:00:00','i02',NULL,NULL,'jhgjh',NULL,'2016-03-16 16:08:29',1,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(55167,1,37027,NULL,'2016-01-01 09:00:00','2016-01-01 17:00:00','i03',NULL,NULL,'ghfg',NULL,'2015-12-21 15:20:43',1,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(55168,1,37027,NULL,'2016-03-11 09:00:00','2016-03-11 17:00:00','i03',NULL,NULL,'jhgjh',NULL,'2015-12-21 15:20:44',2,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(339525,NULL,141666,NULL,'2016-03-11 09:00:00','2016-03-11 17:00:00','i03',NULL,NULL,NULL,NULL,'2016-03-16 16:08:29',1,NULL,'0000-00-00 00:00:00','3fefbfbd-5f64-5d',0,NULL,0,NULL),
(339528,NULL,141666,NULL,'2016-03-11 09:00:00','2016-03-11 17:00:00','i03',NULL,NULL,NULL,NULL,'2016-03-17 15:07:42',2,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(339531,NULL,141666,NULL,'2016-03-11 09:00:00','2016-03-11 17:00:00','i03',NULL,NULL,NULL,NULL,'2016-03-17 15:08:09',3,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(339535,NULL,37027,NULL,'2018-03-27 09:00:00','2018-07-27 09:00:00','i02-2',NULL,NULL,NULL,NULL,'2018-04-05 15:48:37',99,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(27464088,NULL,60858,NULL,'2022-10-21 09:00:00','2023-10-31 09:00:00','m12',0,NULL,NULL,NULL,'2021-12-14 14:51:19',5,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(27464089,NULL,60858,NULL,'2022-10-21 09:00:00','2022-10-31 09:00:00','m12',0,NULL,NULL,NULL,'2021-12-14 14:51:19',6,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(27464090,NULL,1000028,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-12-09 16:57:15',NULL,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL),
(27464172,NULL,1000327,NULL,NULL,NULL,'m12',NULL,NULL,NULL,NULL,'2025-04-24 10:11:06',1,NULL,'0000-00-00 00:00:00',NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `BLSession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSession_has_SCPosition`
--

DROP TABLE IF EXISTS `BLSession_has_SCPosition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSession_has_SCPosition` (
  `blsessionhasscpositionid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blsessionid` int(11) unsigned NOT NULL,
  `scContainer` smallint(5) unsigned DEFAULT NULL COMMENT 'Position of container within sample changer',
  `containerPosition` smallint(5) unsigned DEFAULT NULL COMMENT 'Position of sample within container',
  PRIMARY KEY (`blsessionhasscpositionid`),
  KEY `blsession_has_scposition_FK1` (`blsessionid`),
  CONSTRAINT `blsession_has_scposition_FK1` FOREIGN KEY (`blsessionid`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSession_has_SCPosition`
--

LOCK TABLES `BLSession_has_SCPosition` WRITE;
/*!40000 ALTER TABLE `BLSession_has_SCPosition` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSession_has_SCPosition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSubSample`
--

DROP TABLE IF EXISTS `BLSubSample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSubSample` (
  `blSubSampleId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `blSampleId` int(10) unsigned NOT NULL COMMENT 'sample',
  `diffractionPlanId` int(10) unsigned DEFAULT NULL COMMENT 'eventually diffractionPlan',
  `blSampleImageId` int(11) unsigned DEFAULT NULL,
  `positionId` int(11) unsigned DEFAULT NULL COMMENT 'position of the subsample',
  `position2Id` int(11) unsigned DEFAULT NULL,
  `motorPositionId` int(11) unsigned DEFAULT NULL COMMENT 'motor position',
  `blSubSampleUUID` varchar(45) DEFAULT NULL COMMENT 'uuid of the blsubsample',
  `imgFileName` varchar(255) DEFAULT NULL COMMENT 'image filename',
  `imgFilePath` varchar(1024) DEFAULT NULL COMMENT 'url image',
  `comments` varchar(1024) DEFAULT NULL COMMENT 'comments',
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `source` enum('manual','auto') DEFAULT 'manual',
  `type` varchar(10) DEFAULT NULL COMMENT 'The type of subsample, i.e. roi (region), poi (point), loi (line)',
  PRIMARY KEY (`blSubSampleId`),
  KEY `BLSubSample_FKIndex2` (`diffractionPlanId`),
  KEY `BLSubSample_FKIndex3` (`positionId`),
  KEY `BLSubSample_FKIndex4` (`motorPositionId`),
  KEY `BLSubSample_FKIndex5` (`position2Id`),
  KEY `BLSubSample_blSampleImagefk_1` (`blSampleImageId`),
  KEY `BLSubSample_blSampleId_source` (`blSampleId`,`source`),
  CONSTRAINT `BLSubSample_blSampleImagefk_1` FOREIGN KEY (`blSampleImageId`) REFERENCES `BLSampleImage` (`blSampleImageId`),
  CONSTRAINT `BLSubSample_blSamplefk_1` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSubSample_diffractionPlanfk_1` FOREIGN KEY (`diffractionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSubSample_motorPositionfk_1` FOREIGN KEY (`motorPositionId`) REFERENCES `MotorPosition` (`motorPositionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSubSample_positionfk_1` FOREIGN KEY (`positionId`) REFERENCES `Position` (`positionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BLSubSample_positionfk_2` FOREIGN KEY (`position2Id`) REFERENCES `Position` (`positionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSubSample`
--

LOCK TABLES `BLSubSample` WRITE;
/*!40000 ALTER TABLE `BLSubSample` DISABLE KEYS */;
INSERT INTO `BLSubSample` VALUES
(2,398816,197784,NULL,2,5,NULL,NULL,NULL,NULL,NULL,'2016-09-30 14:25:19','manual',NULL),
(5,398819,197784,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-10-05 10:16:44','manual',NULL);
/*!40000 ALTER TABLE `BLSubSample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BLSubSample_has_Positioner`
--

DROP TABLE IF EXISTS `BLSubSample_has_Positioner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLSubSample_has_Positioner` (
  `blSubSampleHasPositioner` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `blSubSampleId` int(10) unsigned NOT NULL,
  `positionerId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`blSubSampleHasPositioner`),
  KEY `BLSubSampleHasPositioner_ibfk1` (`blSubSampleId`),
  KEY `BLSubSampleHasPositioner_ibfk2` (`positionerId`),
  CONSTRAINT `BLSubSampleHasPositioner_ibfk1` FOREIGN KEY (`blSubSampleId`) REFERENCES `BLSubSample` (`blSubSampleId`),
  CONSTRAINT `BLSubSampleHasPositioner_ibfk2` FOREIGN KEY (`positionerId`) REFERENCES `Positioner` (`positionerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLSubSample_has_Positioner`
--

LOCK TABLES `BLSubSample_has_Positioner` WRITE;
/*!40000 ALTER TABLE `BLSubSample_has_Positioner` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLSubSample_has_Positioner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BeamApertures`
--

DROP TABLE IF EXISTS `BeamApertures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BeamApertures` (
  `beamAperturesid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `beamlineStatsId` int(11) unsigned DEFAULT NULL,
  `flux` double DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `apertureSize` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`beamAperturesid`),
  KEY `beamapertures_FK1` (`beamlineStatsId`),
  CONSTRAINT `beamapertures_FK1` FOREIGN KEY (`beamlineStatsId`) REFERENCES `BeamlineStats` (`beamlineStatsId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BeamApertures`
--

LOCK TABLES `BeamApertures` WRITE;
/*!40000 ALTER TABLE `BeamApertures` DISABLE KEYS */;
/*!40000 ALTER TABLE `BeamApertures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BeamCalendar`
--

DROP TABLE IF EXISTS `BeamCalendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BeamCalendar` (
  `beamCalendarId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `run` varchar(7) NOT NULL,
  `beamStatus` varchar(24) NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  PRIMARY KEY (`beamCalendarId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BeamCalendar`
--

LOCK TABLES `BeamCalendar` WRITE;
/*!40000 ALTER TABLE `BeamCalendar` DISABLE KEYS */;
INSERT INTO `BeamCalendar` VALUES
(1,'2016-01','User Mode','2015-12-30 09:00:00','2016-01-02 17:00:00');
/*!40000 ALTER TABLE `BeamCalendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BeamCentres`
--

DROP TABLE IF EXISTS `BeamCentres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BeamCentres` (
  `beamCentresid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `beamlineStatsId` int(11) unsigned DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `zoom` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`beamCentresid`),
  KEY `beamCentres_FK1` (`beamlineStatsId`),
  CONSTRAINT `beamCentres_FK1` FOREIGN KEY (`beamlineStatsId`) REFERENCES `BeamlineStats` (`beamlineStatsId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BeamCentres`
--

LOCK TABLES `BeamCentres` WRITE;
/*!40000 ALTER TABLE `BeamCentres` DISABLE KEYS */;
/*!40000 ALTER TABLE `BeamCentres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BeamLineSetup`
--

DROP TABLE IF EXISTS `BeamLineSetup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BeamLineSetup` (
  `beamLineSetupId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `detectorId` int(11) DEFAULT NULL,
  `synchrotronMode` varchar(255) DEFAULT NULL,
  `undulatorType1` varchar(45) DEFAULT NULL,
  `undulatorType2` varchar(45) DEFAULT NULL,
  `undulatorType3` varchar(45) DEFAULT NULL,
  `focalSpotSizeAtSample` float DEFAULT NULL,
  `focusingOptic` varchar(255) DEFAULT NULL,
  `beamDivergenceHorizontal` float DEFAULT NULL,
  `beamDivergenceVertical` float DEFAULT NULL,
  `polarisation` float DEFAULT NULL,
  `monochromatorType` varchar(255) DEFAULT NULL,
  `setupDate` datetime DEFAULT NULL,
  `synchrotronName` varchar(255) DEFAULT NULL,
  `maxExpTimePerDataCollection` double DEFAULT NULL,
  `maxExposureTimePerImage` float DEFAULT NULL COMMENT 'unit: seconds',
  `minExposureTimePerImage` double DEFAULT NULL,
  `goniostatMaxOscillationSpeed` double DEFAULT NULL,
  `goniostatMaxOscillationWidth` double DEFAULT NULL COMMENT 'unit: degrees',
  `goniostatMinOscillationWidth` double DEFAULT NULL,
  `maxTransmission` double DEFAULT NULL COMMENT 'unit: percentage',
  `minTransmission` double DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `CS` float DEFAULT NULL COMMENT 'Spherical Aberration, Units: mm?',
  `beamlineName` varchar(50) DEFAULT NULL COMMENT 'Beamline that this setup relates to',
  `beamSizeXMin` float DEFAULT NULL COMMENT 'unit: um',
  `beamSizeXMax` float DEFAULT NULL COMMENT 'unit: um',
  `beamSizeYMin` float DEFAULT NULL COMMENT 'unit: um',
  `beamSizeYMax` float DEFAULT NULL COMMENT 'unit: um',
  `energyMin` float DEFAULT NULL COMMENT 'unit: eV',
  `energyMax` float DEFAULT NULL COMMENT 'unit: eV',
  `omegaMin` float DEFAULT NULL COMMENT 'unit: degrees',
  `omegaMax` float DEFAULT NULL COMMENT 'unit: degrees',
  `kappaMin` float DEFAULT NULL COMMENT 'unit: degrees',
  `kappaMax` float DEFAULT NULL COMMENT 'unit: degrees',
  `phiMin` float DEFAULT NULL COMMENT 'unit: degrees',
  `phiMax` float DEFAULT NULL COMMENT 'unit: degrees',
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `numberOfImagesMax` mediumint(8) unsigned DEFAULT NULL,
  `numberOfImagesMin` mediumint(8) unsigned DEFAULT NULL,
  `boxSizeXMin` double DEFAULT NULL COMMENT 'For gridscans, unit: um',
  `boxSizeXMax` double DEFAULT NULL COMMENT 'For gridscans, unit: um',
  `boxSizeYMin` double DEFAULT NULL COMMENT 'For gridscans, unit: um',
  `boxSizeYMax` double DEFAULT NULL COMMENT 'For gridscans, unit: um',
  `monoBandwidthMin` double DEFAULT NULL COMMENT 'unit: percentage',
  `monoBandwidthMax` double DEFAULT NULL COMMENT 'unit: percentage',
  `preferredDataCentre` varchar(30) DEFAULT NULL COMMENT 'Relevant datacentre to use to process data from this beamline',
  `amplitudeContrast` float DEFAULT NULL COMMENT 'Needed for cryo-ET',
  PRIMARY KEY (`beamLineSetupId`),
  KEY `BeamLineSetup_ibfk_1` (`detectorId`),
  CONSTRAINT `BeamLineSetup_ibfk_1` FOREIGN KEY (`detectorId`) REFERENCES `Detector` (`detectorId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BeamLineSetup`
--

LOCK TABLES `BeamLineSetup` WRITE;
/*!40000 ALTER TABLE `BeamLineSetup` DISABLE KEYS */;
INSERT INTO `BeamLineSetup` VALUES
(1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-04-26 00:00:00','Diamond Light Source',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-19 22:56:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `BeamLineSetup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BeamlineAction`
--

DROP TABLE IF EXISTS `BeamlineAction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BeamlineAction` (
  `beamlineActionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sessionId` int(11) unsigned DEFAULT NULL,
  `startTimestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `endTimestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `message` varchar(255) DEFAULT NULL,
  `parameter` varchar(50) DEFAULT NULL,
  `value` varchar(30) DEFAULT NULL,
  `loglevel` enum('DEBUG','CRITICAL','INFO') DEFAULT NULL,
  `status` enum('PAUSED','RUNNING','TERMINATED','COMPLETE','ERROR','EPICSFAIL') DEFAULT NULL,
  PRIMARY KEY (`beamlineActionId`),
  KEY `BeamlineAction_ibfk1` (`sessionId`),
  CONSTRAINT `BeamlineAction_ibfk1` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BeamlineAction`
--

LOCK TABLES `BeamlineAction` WRITE;
/*!40000 ALTER TABLE `BeamlineAction` DISABLE KEYS */;
/*!40000 ALTER TABLE `BeamlineAction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BeamlineStats`
--

DROP TABLE IF EXISTS `BeamlineStats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BeamlineStats` (
  `beamlineStatsId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `beamline` varchar(10) DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT NULL,
  `ringCurrent` float DEFAULT NULL,
  `energy` float DEFAULT NULL,
  `gony` float DEFAULT NULL,
  `beamW` float DEFAULT NULL,
  `beamH` float DEFAULT NULL,
  `flux` double DEFAULT NULL,
  `scanFileW` varchar(255) DEFAULT NULL,
  `scanFileH` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`beamlineStatsId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BeamlineStats`
--

LOCK TABLES `BeamlineStats` WRITE;
/*!40000 ALTER TABLE `BeamlineStats` DISABLE KEYS */;
/*!40000 ALTER TABLE `BeamlineStats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CTF`
--

DROP TABLE IF EXISTS `CTF`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CTF` (
  `ctfId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `motionCorrectionId` int(11) unsigned DEFAULT NULL,
  `autoProcProgramId` int(11) unsigned DEFAULT NULL,
  `boxSizeX` float DEFAULT NULL COMMENT 'Box size in x, Units: pixels',
  `boxSizeY` float DEFAULT NULL COMMENT 'Box size in y, Units: pixels',
  `minResolution` float DEFAULT NULL COMMENT 'Minimum resolution for CTF, Units: A',
  `maxResolution` float DEFAULT NULL COMMENT 'Units: A',
  `minDefocus` float DEFAULT NULL COMMENT 'Units: A',
  `maxDefocus` float DEFAULT NULL COMMENT 'Units: A',
  `defocusStepSize` float DEFAULT NULL COMMENT 'Units: A',
  `astigmatism` float DEFAULT NULL COMMENT 'Units: A',
  `astigmatismAngle` float DEFAULT NULL COMMENT 'Units: deg?',
  `estimatedResolution` float DEFAULT NULL COMMENT 'Units: A',
  `estimatedDefocus` float DEFAULT NULL COMMENT 'Units: A',
  `amplitudeContrast` float DEFAULT NULL COMMENT 'Units: %?',
  `ccValue` float DEFAULT NULL COMMENT 'Correlation value',
  `fftTheoreticalFullPath` varchar(255) DEFAULT NULL COMMENT 'Full path to the jpg image of the simulated FFT',
  `comments` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ctfId`),
  KEY `CTF_ibfk1` (`motionCorrectionId`),
  KEY `CTF_ibfk2` (`autoProcProgramId`),
  CONSTRAINT `CTF_ibfk1` FOREIGN KEY (`motionCorrectionId`) REFERENCES `MotionCorrection` (`motionCorrectionId`),
  CONSTRAINT `CTF_ibfk2` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CTF`
--

LOCK TABLES `CTF` WRITE;
/*!40000 ALTER TABLE `CTF` DISABLE KEYS */;
INSERT INTO `CTF` VALUES
(1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,NULL,5,5,NULL,NULL,'/mnt/test.png','a'),
(2,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,NULL,7,8,NULL,NULL,'/mnt/test.png','b'),
(3,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,9,11,NULL,NULL,'/mnt/test.png','d'),
(4,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,11,14,NULL,NULL,'/mnt/test.png','c'),
(5,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,13,17,NULL,NULL,'/mnt/test.png',NULL),
(6,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,NULL,5,5,NULL,NULL,'/mnt/test.png',NULL),
(7,7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,NULL,7,8,NULL,NULL,'/mnt/test.png',NULL),
(8,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,9,11,NULL,NULL,'/mnt/test.png',NULL),
(9,9,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,11,14,NULL,NULL,'/mnt/test.png',NULL),
(10,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,13,17,NULL,NULL,'/mnt/test.png',NULL),
(11,11,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,NULL,5,5,NULL,NULL,'/mnt/test.png',NULL),
(12,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,NULL,7,8,NULL,NULL,'/mnt/test.png',NULL),
(13,13,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,9,11,NULL,NULL,'/mnt/test.png',NULL),
(14,14,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,11,14,NULL,NULL,'/mnt/test.png',NULL),
(15,15,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,13,17,NULL,NULL,'/mnt/test.png',NULL),
(16,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,NULL,5,5,NULL,NULL,'/mnt/test.png',NULL),
(17,17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,NULL,7,8,NULL,NULL,'/mnt/test.png',NULL),
(18,18,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,9,11,NULL,NULL,'/mnt/test.png',NULL),
(19,19,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,11,14,NULL,NULL,'/mnt/test.png',NULL),
(20,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,13,17,NULL,NULL,'/mnt/test.png',NULL),
(21,21,56986680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,NULL,5,5,NULL,NULL,'/mnt/test.png',NULL),
(22,22,56986680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,NULL,7,8,NULL,NULL,'/mnt/test.png',NULL),
(23,23,56986680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,9,11,NULL,NULL,'/mnt/test.png',NULL),
(24,24,56986680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,11,14,NULL,NULL,'/mnt/test.png',NULL),
(25,25,56986680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,13,17,NULL,NULL,'/mnt/test.png',NULL),
(26,NULL,56986803,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,NULL,NULL,NULL,NULL),
(27,30,56986680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,9,12,NULL,NULL,'/mnt/test.png',NULL),
(28,30,56986680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,NULL,11,14,NULL,NULL,'/mnt/test.png',NULL);
/*!40000 ALTER TABLE `CTF` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CalendarHash`
--

DROP TABLE IF EXISTS `CalendarHash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CalendarHash` (
  `calendarHashId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(50) DEFAULT NULL,
  `hash` varchar(128) DEFAULT NULL,
  `beamline` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`calendarHashId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Lets people get to their calendars without logging in using a private (hash) url';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CalendarHash`
--

LOCK TABLES `CalendarHash` WRITE;
/*!40000 ALTER TABLE `CalendarHash` DISABLE KEYS */;
/*!40000 ALTER TABLE `CalendarHash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Component`
--

DROP TABLE IF EXISTS `Component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Component` (
  `componentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `componentTypeId` int(11) unsigned NOT NULL,
  `proposalId` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `composition` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`componentId`),
  KEY `componentTypeId` (`componentTypeId`),
  KEY `proposalId` (`proposalId`),
  CONSTRAINT `Component_ibfk_1` FOREIGN KEY (`componentTypeId`) REFERENCES `ComponentType` (`componentTypeId`),
  CONSTRAINT `Component_ibfk_2` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Description of a component that can be used inside a crystal or a sample.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Component`
--

LOCK TABLES `Component` WRITE;
/*!40000 ALTER TABLE `Component` DISABLE KEYS */;
/*!40000 ALTER TABLE `Component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ComponentLattice`
--

DROP TABLE IF EXISTS `ComponentLattice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ComponentLattice` (
  `componentLatticeId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `componentId` int(10) unsigned DEFAULT NULL,
  `spaceGroup` varchar(20) DEFAULT NULL,
  `cell_a` double DEFAULT NULL,
  `cell_b` double DEFAULT NULL,
  `cell_c` double DEFAULT NULL,
  `cell_alpha` double DEFAULT NULL,
  `cell_beta` double DEFAULT NULL,
  `cell_gamma` double DEFAULT NULL,
  PRIMARY KEY (`componentLatticeId`),
  KEY `ComponentLattice_ibfk1` (`componentId`),
  CONSTRAINT `ComponentLattice_ibfk1` FOREIGN KEY (`componentId`) REFERENCES `Protein` (`proteinId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ComponentLattice`
--

LOCK TABLES `ComponentLattice` WRITE;
/*!40000 ALTER TABLE `ComponentLattice` DISABLE KEYS */;
INSERT INTO `ComponentLattice` VALUES
(1,123497,'P21',10.1,11.1,12.1,90.1,90.2,90.3);
/*!40000 ALTER TABLE `ComponentLattice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ComponentSubType`
--

DROP TABLE IF EXISTS `ComponentSubType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ComponentSubType` (
  `componentSubTypeId` int(11) unsigned NOT NULL,
  `name` varchar(31) NOT NULL,
  `hasPh` tinyint(1) DEFAULT 0,
  `proposalType` varchar(10) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1 COMMENT '1=active, 0=inactive',
  PRIMARY KEY (`componentSubTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ComponentSubType`
--

LOCK TABLES `ComponentSubType` WRITE;
/*!40000 ALTER TABLE `ComponentSubType` DISABLE KEYS */;
INSERT INTO `ComponentSubType` VALUES
(1,'Buffer',1,NULL,1),
(2,'Precipitant',0,NULL,1),
(3,'Salt',0,NULL,1),
(4,'Cell',0,'scm',1),
(5,'Matrix',0,'scm',1),
(6,'Powder',0,'scm',1),
(7,'Solution',1,'scm',1),
(8,'Powder',0,'cy',1);
/*!40000 ALTER TABLE `ComponentSubType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ComponentType`
--

DROP TABLE IF EXISTS `ComponentType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ComponentType` (
  `componentTypeId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(31) NOT NULL,
  PRIMARY KEY (`componentTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ComponentType`
--

LOCK TABLES `ComponentType` WRITE;
/*!40000 ALTER TABLE `ComponentType` DISABLE KEYS */;
INSERT INTO `ComponentType` VALUES
(1,'Protein'),
(2,'DNA'),
(3,'Small Molecule'),
(4,'RNA');
/*!40000 ALTER TABLE `ComponentType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Component_has_SubType`
--

DROP TABLE IF EXISTS `Component_has_SubType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Component_has_SubType` (
  `componentId` int(10) unsigned NOT NULL,
  `componentSubTypeId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`componentId`,`componentSubTypeId`),
  KEY `component_has_SubType_fk2` (`componentSubTypeId`),
  CONSTRAINT `component_has_SubType_fk1` FOREIGN KEY (`componentId`) REFERENCES `Protein` (`proteinId`) ON DELETE CASCADE,
  CONSTRAINT `component_has_SubType_fk2` FOREIGN KEY (`componentSubTypeId`) REFERENCES `ComponentSubType` (`componentSubTypeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Component_has_SubType`
--

LOCK TABLES `Component_has_SubType` WRITE;
/*!40000 ALTER TABLE `Component_has_SubType` DISABLE KEYS */;
/*!40000 ALTER TABLE `Component_has_SubType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ConcentrationType`
--

DROP TABLE IF EXISTS `ConcentrationType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ConcentrationType` (
  `concentrationTypeId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(31) NOT NULL,
  `symbol` varchar(8) NOT NULL,
  `proposalType` varchar(10) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1 COMMENT '1=active, 0=inactive',
  PRIMARY KEY (`concentrationTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ConcentrationType`
--

LOCK TABLES `ConcentrationType` WRITE;
/*!40000 ALTER TABLE `ConcentrationType` DISABLE KEYS */;
INSERT INTO `ConcentrationType` VALUES
(1,'Molar','M',NULL,1),
(2,'Percentage Weight / Volume','%(w/v)',NULL,1),
(3,'Percentage Volume / Volume','%(v/v)',NULL,1),
(4,'Milligrams / Millilitre','mg/ml',NULL,1),
(5,'Grams','g',NULL,1),
(6,'Microlitre','uL','scm',1),
(7,'Millilitre','ml','scm',1);
/*!40000 ALTER TABLE `ConcentrationType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Container`
--

DROP TABLE IF EXISTS `Container`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Container` (
  `containerId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dewarId` int(10) unsigned DEFAULT NULL,
  `code` varchar(45) DEFAULT NULL,
  `containerType` varchar(20) DEFAULT NULL,
  `capacity` int(10) unsigned DEFAULT NULL,
  `sampleChangerLocation` varchar(20) DEFAULT NULL,
  `containerStatus` varchar(45) DEFAULT NULL,
  `bltimeStamp` datetime DEFAULT NULL,
  `beamlineLocation` varchar(20) DEFAULT NULL,
  `screenId` int(11) unsigned DEFAULT NULL,
  `scheduleId` int(11) unsigned DEFAULT NULL,
  `barcode` varchar(45) DEFAULT NULL,
  `imagerId` int(11) unsigned DEFAULT NULL,
  `sessionId` int(10) unsigned DEFAULT NULL,
  `ownerId` int(10) unsigned DEFAULT NULL,
  `requestedImagerId` int(11) unsigned DEFAULT NULL,
  `requestedReturn` tinyint(1) DEFAULT 0 COMMENT 'True for requesting return, False means container will be disposed',
  `comments` varchar(255) DEFAULT NULL,
  `experimentType` varchar(20) DEFAULT NULL,
  `storageTemperature` float DEFAULT NULL COMMENT 'NULL=ambient',
  `containerRegistryId` int(11) unsigned DEFAULT NULL,
  `scLocationUpdated` datetime DEFAULT NULL,
  `priorityPipelineId` int(11) unsigned DEFAULT 6 COMMENT 'Processing pipeline to prioritise, defaults to 6 which is xia2/DIALS',
  `experimentTypeId` int(10) unsigned DEFAULT NULL,
  `containerTypeId` int(10) unsigned DEFAULT NULL,
  `currentDewarId` int(10) unsigned DEFAULT NULL COMMENT 'The dewar with which the container is currently associated',
  `parentContainerId` int(10) unsigned DEFAULT NULL,
  `source` varchar(50) DEFAULT current_user(),
  PRIMARY KEY (`containerId`),
  UNIQUE KEY `Container_UNIndex1` (`barcode`),
  KEY `Container_FKIndex` (`beamlineLocation`),
  KEY `Container_FKIndex1` (`dewarId`),
  KEY `Container_FKIndexStatus` (`containerStatus`),
  KEY `Container_ibfk2` (`screenId`),
  KEY `Container_ibfk3` (`scheduleId`),
  KEY `Container_ibfk4` (`imagerId`),
  KEY `Container_ibfk5` (`ownerId`),
  KEY `Container_ibfk7` (`requestedImagerId`),
  KEY `Container_ibfk8` (`containerRegistryId`),
  KEY `Container_ibfk6` (`sessionId`),
  KEY `Container_ibfk9` (`priorityPipelineId`),
  KEY `Container_fk_experimentTypeId` (`experimentTypeId`),
  KEY `Container_ibfk10` (`containerTypeId`),
  KEY `Container_fk_currentDewarId` (`currentDewarId`),
  KEY `Container_fk_parentContainerId` (`parentContainerId`),
  CONSTRAINT `Container_fk_currentDewarId` FOREIGN KEY (`currentDewarId`) REFERENCES `Dewar` (`dewarId`),
  CONSTRAINT `Container_fk_experimentTypeId` FOREIGN KEY (`experimentTypeId`) REFERENCES `ExperimentType` (`experimentTypeId`),
  CONSTRAINT `Container_fk_parentContainerId` FOREIGN KEY (`parentContainerId`) REFERENCES `Container` (`containerId`),
  CONSTRAINT `Container_ibfk10` FOREIGN KEY (`containerTypeId`) REFERENCES `ContainerType` (`containerTypeId`),
  CONSTRAINT `Container_ibfk2` FOREIGN KEY (`screenId`) REFERENCES `Screen` (`screenId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Container_ibfk3` FOREIGN KEY (`scheduleId`) REFERENCES `Schedule` (`scheduleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Container_ibfk4` FOREIGN KEY (`imagerId`) REFERENCES `Imager` (`imagerId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Container_ibfk5` FOREIGN KEY (`ownerId`) REFERENCES `Person` (`personId`),
  CONSTRAINT `Container_ibfk6` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Container_ibfk7` FOREIGN KEY (`requestedImagerId`) REFERENCES `Imager` (`imagerId`),
  CONSTRAINT `Container_ibfk8` FOREIGN KEY (`containerRegistryId`) REFERENCES `ContainerRegistry` (`containerRegistryId`),
  CONSTRAINT `Container_ibfk9` FOREIGN KEY (`priorityPipelineId`) REFERENCES `ProcessingPipeline` (`processingPipelineId`),
  CONSTRAINT `Container_ibfk_1` FOREIGN KEY (`dewarId`) REFERENCES `Dewar` (`dewarId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39025 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Container`
--

LOCK TABLES `Container` WRITE;
/*!40000 ALTER TABLE `Container` DISABLE KEYS */;
INSERT INTO `Container` VALUES
(1326,573,'Container-1-cm0001-1','Puck-16',16,'3','processing',NULL,'i03',NULL,NULL,'container-cm0001-1-0000001',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(1329,573,'Container-2-cm0001-1','Puck-16',16,'4','processing',NULL,'i03',NULL,NULL,'container-cm0001-1-0000002',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(1332,576,'Container-3-cm0001-1','Puck-16',16,'5','processing',NULL,'i03',NULL,NULL,'container-cm0001-1-0000003',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(1335,579,'Container-4-cm0001-2','Puck-16',16,'6','processing',NULL,'i03',NULL,NULL,'container-cm0001-2-0001335',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(1338,582,'Container-5-cm0001-3','Puck-16',16,'7','processing',NULL,'i03',NULL,NULL,'container-cm0001-3-0001338',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(1341,573,'Manual',NULL,NULL,'9',NULL,NULL,'i03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(33049,8287,'cm14451-1_i03r-002','Puck',16,NULL,'at DLS',NULL,'i03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(34864,8572,'I03R-001','Puck',16,'29','processing','2016-02-24 12:13:05','i03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(34874,8572,'test_plate2','CrystalQuickX',192,'3','in_storage','2016-02-12 09:20:44','i03',NULL,2,'test_plate2',2,NULL,NULL,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(34877,8572,'test_plate3','CrystalQuickX',192,'3','in_storage','2016-10-04 10:50:05','i03',NULL,2,'test_plate3',2,NULL,NULL,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(34879,8572,'test_plate4','CrystalQuickX',192,'4','processing',NULL,'i02-2',NULL,2,'test_plate4',2,NULL,NULL,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(34883,NULL,'XPDF-container-1','XPDF container',NULL,NULL,'processing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(34888,8578,'TestSim01','CrystalQuickX',192,'1','in_storage',NULL,'i02-2',NULL,2,'VMXiSim-001',7,339535,1,7,0,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(34893,8581,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'What',NULL,NULL,4,NULL,6,NULL,NULL,NULL,NULL,'root@%'),
(34894,NULL,NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'Test Comment!',NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,34893,'root@%'),
(34895,8581,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'What',NULL,NULL,4,NULL,6,NULL,NULL,NULL,NULL,'root@%'),
(34896,8582,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,'root@%'),
(34897,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'Test Comment!',NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,34896,'root@%'),
(34898,8583,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,NULL,'root@%'),
(34899,NULL,NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'Test Comment!',NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,34898,'root@%'),
(34900,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'',NULL,NULL,NULL,NULL,6,NULL,NULL,NULL,34898,'root@%'),
(34901,8583,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'',NULL,NULL,4,NULL,6,NULL,NULL,NULL,NULL,'root@%');
/*!40000 ALTER TABLE `Container` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerHistory`
--

DROP TABLE IF EXISTS `ContainerHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerHistory` (
  `containerHistoryId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `containerId` int(10) unsigned DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `blTimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(45) DEFAULT NULL,
  `beamlineName` varchar(20) DEFAULT NULL,
  `currentDewarId` int(10) unsigned DEFAULT NULL COMMENT 'The dewar with which the container was associated at the creation of this row',
  PRIMARY KEY (`containerHistoryId`),
  KEY `ContainerHistory_ibfk1` (`containerId`),
  KEY `ContainerHistory_fk_dewarId` (`currentDewarId`),
  CONSTRAINT `ContainerHistory_fk_dewarId` FOREIGN KEY (`currentDewarId`) REFERENCES `Dewar` (`dewarId`),
  CONSTRAINT `ContainerHistory_ibfk1` FOREIGN KEY (`containerId`) REFERENCES `Container` (`containerId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerHistory`
--

LOCK TABLES `ContainerHistory` WRITE;
/*!40000 ALTER TABLE `ContainerHistory` DISABLE KEYS */;
INSERT INTO `ContainerHistory` VALUES
(6,34874,'3','2016-09-30 12:56:21','in_localstorage','i03',NULL),
(7,34874,'3','2017-10-19 13:35:34','in_storage','i02-2',NULL);
/*!40000 ALTER TABLE `ContainerHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerInspection`
--

DROP TABLE IF EXISTS `ContainerInspection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerInspection` (
  `containerInspectionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `containerId` int(11) unsigned NOT NULL,
  `inspectionTypeId` int(11) unsigned NOT NULL,
  `imagerId` int(11) unsigned DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `blTimeStamp` datetime DEFAULT NULL,
  `scheduleComponentid` int(11) unsigned DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `priority` smallint(6) DEFAULT NULL,
  `manual` tinyint(1) DEFAULT NULL,
  `scheduledTimeStamp` datetime DEFAULT NULL,
  `completedTimeStamp` datetime DEFAULT NULL,
  PRIMARY KEY (`containerInspectionId`),
  KEY `ContainerInspection_idx2` (`inspectionTypeId`),
  KEY `ContainerInspection_idx3` (`imagerId`),
  KEY `ContainerInspection_fk4` (`scheduleComponentid`),
  KEY `ContainerInspection_idx4` (`containerId`,`scheduleComponentid`,`state`,`manual`),
  CONSTRAINT `ContainerInspection_fk1` FOREIGN KEY (`containerId`) REFERENCES `Container` (`containerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ContainerInspection_fk2` FOREIGN KEY (`inspectionTypeId`) REFERENCES `InspectionType` (`inspectionTypeId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ContainerInspection_fk3` FOREIGN KEY (`imagerId`) REFERENCES `Imager` (`imagerId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ContainerInspection_fk4` FOREIGN KEY (`scheduleComponentid`) REFERENCES `ScheduleComponent` (`scheduleComponentId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerInspection`
--

LOCK TABLES `ContainerInspection` WRITE;
/*!40000 ALTER TABLE `ContainerInspection` DISABLE KEYS */;
INSERT INTO `ContainerInspection` VALUES
(4,34874,1,NULL,NULL,'2018-08-07 15:20:00',NULL,'Completed',99,NULL,'2018-08-07 12:08:00','2018-08-07 15:36:00');
/*!40000 ALTER TABLE `ContainerInspection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerQueue`
--

DROP TABLE IF EXISTS `ContainerQueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerQueue` (
  `containerQueueId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `containerId` int(10) unsigned NOT NULL,
  `personId` int(10) unsigned DEFAULT NULL,
  `createdTimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `completedTimeStamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`containerQueueId`),
  KEY `ContainerQueue_ibfk1` (`containerId`),
  KEY `ContainerQueue_ibfk2` (`personId`),
  KEY `ContainerQueue_idx1` (`containerId`,`completedTimeStamp`),
  CONSTRAINT `ContainerQueue_ibfk1` FOREIGN KEY (`containerId`) REFERENCES `Container` (`containerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ContainerQueue_ibfk2` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerQueue`
--

LOCK TABLES `ContainerQueue` WRITE;
/*!40000 ALTER TABLE `ContainerQueue` DISABLE KEYS */;
INSERT INTO `ContainerQueue` VALUES
(2,34874,NULL,'2016-09-30 12:56:21',NULL),
(8,34877,NULL,'2016-10-05 09:09:59',NULL);
/*!40000 ALTER TABLE `ContainerQueue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerQueueSample`
--

DROP TABLE IF EXISTS `ContainerQueueSample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerQueueSample` (
  `containerQueueSampleId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `containerQueueId` int(11) unsigned DEFAULT NULL,
  `blSubSampleId` int(11) unsigned DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL COMMENT 'The status of the queued item, i.e. skipped, reinspect. Completed / failed should be inferred from related DataCollection',
  `startTime` datetime DEFAULT NULL COMMENT 'Start time of processing the queue item',
  `endTime` datetime DEFAULT NULL COMMENT 'End time of processing the queue item',
  `dataCollectionPlanId` int(10) unsigned DEFAULT NULL,
  `blSampleId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`containerQueueSampleId`),
  KEY `ContainerQueueSample_ibfk1` (`containerQueueId`),
  KEY `ContainerQueueSample_ibfk2` (`blSubSampleId`),
  KEY `ContainerQueueSample_dataCollectionPlanId` (`dataCollectionPlanId`),
  KEY `ContainerQueueSample_blSampleId` (`blSampleId`),
  CONSTRAINT `ContainerQueueSample_blSampleId` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ContainerQueueSample_dataCollectionPlanId` FOREIGN KEY (`dataCollectionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ContainerQueueSample_ibfk1` FOREIGN KEY (`containerQueueId`) REFERENCES `ContainerQueue` (`containerQueueId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ContainerQueueSample_ibfk2` FOREIGN KEY (`blSubSampleId`) REFERENCES `BLSubSample` (`blSubSampleId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerQueueSample`
--

LOCK TABLES `ContainerQueueSample` WRITE;
/*!40000 ALTER TABLE `ContainerQueueSample` DISABLE KEYS */;
INSERT INTO `ContainerQueueSample` VALUES
(2,2,2,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ContainerQueueSample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerRegistry`
--

DROP TABLE IF EXISTS `ContainerRegistry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerRegistry` (
  `containerRegistryId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `barcode` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `recordTimestamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`containerRegistryId`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerRegistry`
--

LOCK TABLES `ContainerRegistry` WRITE;
/*!40000 ALTER TABLE `ContainerRegistry` DISABLE KEYS */;
INSERT INTO `ContainerRegistry` VALUES
(4,'DLS-0001',NULL,'2017-09-21 10:01:07'),
(5,'VMXiSim-001',NULL,'2019-03-22 11:48:43'),
(6,'DLS-0002',NULL,'2024-12-09 16:58:17'),
(7,'DLS-0003',NULL,'2017-09-21 10:01:07');
/*!40000 ALTER TABLE `ContainerRegistry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerRegistry_has_Proposal`
--

DROP TABLE IF EXISTS `ContainerRegistry_has_Proposal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerRegistry_has_Proposal` (
  `containerRegistryHasProposalId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `containerRegistryId` int(11) unsigned DEFAULT NULL,
  `proposalId` int(10) unsigned DEFAULT NULL,
  `personId` int(10) unsigned DEFAULT NULL COMMENT 'Person registering the container',
  `recordTimestamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`containerRegistryHasProposalId`),
  UNIQUE KEY `containerRegistryId` (`containerRegistryId`,`proposalId`),
  KEY `ContainerRegistry_has_Proposal_ibfk2` (`proposalId`),
  KEY `ContainerRegistry_has_Proposal_ibfk3` (`personId`),
  CONSTRAINT `ContainerRegistry_has_Proposal_ibfk1` FOREIGN KEY (`containerRegistryId`) REFERENCES `ContainerRegistry` (`containerRegistryId`),
  CONSTRAINT `ContainerRegistry_has_Proposal_ibfk2` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`),
  CONSTRAINT `ContainerRegistry_has_Proposal_ibfk3` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerRegistry_has_Proposal`
--

LOCK TABLES `ContainerRegistry_has_Proposal` WRITE;
/*!40000 ALTER TABLE `ContainerRegistry_has_Proposal` DISABLE KEYS */;
INSERT INTO `ContainerRegistry_has_Proposal` VALUES
(1,4,141666,NULL,'2023-09-14 09:00:51'),
(2,6,1000028,NULL,'2024-12-09 16:58:05'),
(4,7,141666,NULL,'2023-09-14 09:00:51');
/*!40000 ALTER TABLE `ContainerRegistry_has_Proposal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerReport`
--

DROP TABLE IF EXISTS `ContainerReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerReport` (
  `containerReportId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `containerRegistryId` int(11) unsigned DEFAULT NULL,
  `personId` int(10) unsigned DEFAULT NULL COMMENT 'Person making report',
  `report` text DEFAULT NULL,
  `attachmentFilePath` varchar(255) DEFAULT NULL,
  `recordTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`containerReportId`),
  KEY `ContainerReport_ibfk1` (`containerRegistryId`),
  KEY `ContainerReport_ibfk2` (`personId`),
  CONSTRAINT `ContainerReport_ibfk1` FOREIGN KEY (`containerRegistryId`) REFERENCES `ContainerRegistry` (`containerRegistryId`),
  CONSTRAINT `ContainerReport_ibfk2` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerReport`
--

LOCK TABLES `ContainerReport` WRITE;
/*!40000 ALTER TABLE `ContainerReport` DISABLE KEYS */;
/*!40000 ALTER TABLE `ContainerReport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContainerType`
--

DROP TABLE IF EXISTS `ContainerType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContainerType` (
  `containerTypeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `proposalType` varchar(10) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1 COMMENT '1=active, 0=inactive',
  `capacity` int(11) DEFAULT NULL,
  `wellPerRow` smallint(6) DEFAULT NULL,
  `dropPerWellX` smallint(6) DEFAULT NULL,
  `dropPerWellY` smallint(6) DEFAULT NULL,
  `dropHeight` float DEFAULT NULL,
  `dropWidth` float DEFAULT NULL,
  `dropOffsetX` float DEFAULT NULL,
  `dropOffsetY` float DEFAULT NULL,
  `wellDrop` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`containerTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='A lookup table for different types of containers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContainerType`
--

LOCK TABLES `ContainerType` WRITE;
/*!40000 ALTER TABLE `ContainerType` DISABLE KEYS */;
INSERT INTO `ContainerType` VALUES
(1,'B21_8+1','saxs',1,9,9,1,1,1,1,0,0,-1),
(2,'B21_96','saxs',1,192,12,2,1,0.5,1,0,0,-1),
(3,'B21_1tube','saxs',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'I22_Capillary_Rack_20','saxs',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,'I22_Grid_100','saxs',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,'I22_Grid_45','saxs',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,'P38_Capillary_Rack_27','saxs',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,'P38_Solids','saxs',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,'P38_Powder','saxs',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,'B22_6','saxs',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(11,'I11_Capillary_Rack_6','saxs',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(12,'Puck','mx',1,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(13,'ReferencePlate','mx',1,16,2,1,1,1,1,0,0,-1),
(14,'CrystalQuickX','mx',1,192,12,2,1,0.5,1,0,0,-1),
(15,'MitegenInSitu','mx',1,192,12,2,1,0.5,1,0,0,-1),
(16,'FilmBatch','mx',1,96,12,1,1,1,1,0,0,-1),
(17,'MitegenInSitu_3_Drop','mx',1,288,12,3,1,0.5,1,0,0,-1),
(18,'Greiner 3 Drop','mx',1,288,12,3,1,0.5,1,0,0,-1),
(19,'MRC Maxi','mx',1,48,6,1,1,1,0.5,0,0,-1),
(20,'MRC 2 Drop','mx',1,192,12,1,2,1,0.5,0.5,0,-1),
(21,'Griener 1536','mx',1,1536,12,4,4,1,1,0,0,-1),
(22,'3 Drop Square','mx',1,288,12,2,2,1,1,0,0,3),
(23,'SWISSCI 3 Drop','mx',1,288,12,2,2,1,1,0,0,1),
(24,'1 drop','mx',1,96,12,1,1,0.5,0.5,0,0,-1),
(25,'LCP Glass','mx',1,96,12,1,1,1,1,0,0,-1),
(26,'PCRStrip','saxs',1,9,9,1,1,1,1,0,0,-1),
(27,'Basket','mx',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(28,'Cane','mx',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(29,'Terasaki72','mx',0,72,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(30,'Puck-16','mx',1,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(31,'Block-4','mx',1,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(32,'Box','xpdf',1,25,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(33,'Puck-22','xpdf',1,22,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(34,'I22_Grid_81','saxs',1,81,9,1,1,1,1,0,0,-1),
(35,'I22_Capillary_Rack_25','saxs',1,25,25,1,1,1,1,0,0,-1),
(38,'Cryo-EM Puck','mx',1,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ContainerType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CourierTermsAccepted`
--

DROP TABLE IF EXISTS `CourierTermsAccepted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CourierTermsAccepted` (
  `courierTermsAcceptedId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `proposalId` int(10) unsigned NOT NULL,
  `personId` int(10) unsigned NOT NULL,
  `shippingName` varchar(100) DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `shippingId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`courierTermsAcceptedId`),
  KEY `CourierTermsAccepted_ibfk_1` (`proposalId`),
  KEY `CourierTermsAccepted_ibfk_2` (`personId`),
  KEY `CourierTermsAccepted_ibfk_3` (`shippingId`),
  CONSTRAINT `CourierTermsAccepted_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`),
  CONSTRAINT `CourierTermsAccepted_ibfk_2` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`),
  CONSTRAINT `CourierTermsAccepted_ibfk_3` FOREIGN KEY (`shippingId`) REFERENCES `Shipping` (`shippingId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Records acceptances of the courier T and C';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CourierTermsAccepted`
--

LOCK TABLES `CourierTermsAccepted` WRITE;
/*!40000 ALTER TABLE `CourierTermsAccepted` DISABLE KEYS */;
/*!40000 ALTER TABLE `CourierTermsAccepted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CryoemInitialModel`
--

DROP TABLE IF EXISTS `CryoemInitialModel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CryoemInitialModel` (
  `cryoemInitialModelId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `resolution` float DEFAULT NULL COMMENT 'Unit: Angstroms',
  `numberOfParticles` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`cryoemInitialModelId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Initial cryo-EM model generation results';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CryoemInitialModel`
--

LOCK TABLES `CryoemInitialModel` WRITE;
/*!40000 ALTER TABLE `CryoemInitialModel` DISABLE KEYS */;
INSERT INTO `CryoemInitialModel` VALUES
(1,15,15);
/*!40000 ALTER TABLE `CryoemInitialModel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Crystal`
--

DROP TABLE IF EXISTS `Crystal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Crystal` (
  `crystalId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `diffractionPlanId` int(10) unsigned DEFAULT NULL,
  `proteinId` int(10) unsigned NOT NULL DEFAULT 0,
  `crystalUUID` varchar(45) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `spaceGroup` varchar(20) DEFAULT NULL,
  `morphology` varchar(255) DEFAULT NULL,
  `color` varchar(45) DEFAULT NULL,
  `size_X` double DEFAULT NULL,
  `size_Y` double DEFAULT NULL,
  `size_Z` double DEFAULT NULL,
  `cell_a` double DEFAULT NULL,
  `cell_b` double DEFAULT NULL,
  `cell_c` double DEFAULT NULL,
  `cell_alpha` double DEFAULT NULL,
  `cell_beta` double DEFAULT NULL,
  `cell_gamma` double DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `pdbFileName` varchar(255) DEFAULT NULL COMMENT 'pdb file name',
  `pdbFilePath` varchar(1024) DEFAULT NULL COMMENT 'pdb file path',
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `abundance` float DEFAULT NULL,
  `theoreticalDensity` float DEFAULT NULL,
  PRIMARY KEY (`crystalId`),
  KEY `Crystal_FKIndex1` (`proteinId`),
  KEY `Crystal_FKIndex2` (`diffractionPlanId`),
  CONSTRAINT `Crystal_ibfk_1` FOREIGN KEY (`proteinId`) REFERENCES `Protein` (`proteinId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Crystal_ibfk_2` FOREIGN KEY (`diffractionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=337170 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Crystal`
--

LOCK TABLES `Crystal` WRITE;
/*!40000 ALTER TABLE `Crystal` DISABLE KEYS */;
INSERT INTO `Crystal` VALUES
(3918,NULL,4380,NULL,'Crystal 01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3921,NULL,4383,NULL,'Crystal 02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3924,NULL,4386,NULL,'Crystal 03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3927,NULL,4389,NULL,'Crystal 04',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3930,NULL,4392,NULL,'Crystal 05',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3933,NULL,4395,NULL,'Crystal 06',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3936,NULL,4398,NULL,'Crystal 07',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3939,NULL,4401,NULL,'Crystal 08',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3942,NULL,4404,NULL,'Crystal 09',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3945,NULL,4407,NULL,'Crystal 10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3948,NULL,4407,NULL,'Crystal 11',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3951,NULL,4410,NULL,'Crystal 12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3954,NULL,4410,NULL,'Crystal 13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3957,NULL,4413,NULL,'Crystal 14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(3960,NULL,4413,NULL,'Crystal 15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-17 16:11:19',NULL,NULL),
(310037,NULL,121393,NULL,'crystal-4-cm14451-1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-19 22:58:00',NULL,NULL),
(333301,NULL,123491,NULL,NULL,'P41212',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-19 22:58:00',NULL,NULL),
(333308,NULL,123497,NULL,'SampleType01','P12121',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'sample type comments ...',NULL,NULL,'2017-03-23 22:06:42',NULL,NULL);
/*!40000 ALTER TABLE `Crystal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CrystalComposition`
--

DROP TABLE IF EXISTS `CrystalComposition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CrystalComposition` (
  `crystalCompositionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `componentId` int(11) unsigned NOT NULL,
  `crystalId` int(11) unsigned NOT NULL,
  `concentrationTypeId` int(10) unsigned DEFAULT NULL,
  `abundance` float DEFAULT NULL COMMENT 'Abundance or concentration in the unit defined by concentrationTypeId.',
  `ratio` float DEFAULT NULL,
  `pH` float DEFAULT NULL,
  PRIMARY KEY (`crystalCompositionId`),
  KEY `componentId` (`componentId`),
  KEY `crystalId` (`crystalId`),
  KEY `concentrationTypeId` (`concentrationTypeId`),
  CONSTRAINT `CrystalComposition_ibfk_1` FOREIGN KEY (`componentId`) REFERENCES `Component` (`componentId`),
  CONSTRAINT `CrystalComposition_ibfk_2` FOREIGN KEY (`crystalId`) REFERENCES `Crystal` (`crystalId`),
  CONSTRAINT `CrystalComposition_ibfk_3` FOREIGN KEY (`concentrationTypeId`) REFERENCES `ConcentrationType` (`concentrationTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Links a crystal to its components with a specified abundance or ratio.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CrystalComposition`
--

LOCK TABLES `CrystalComposition` WRITE;
/*!40000 ALTER TABLE `CrystalComposition` DISABLE KEYS */;
/*!40000 ALTER TABLE `CrystalComposition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Crystal_has_UUID`
--

DROP TABLE IF EXISTS `Crystal_has_UUID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Crystal_has_UUID` (
  `crystal_has_UUID_Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `crystalId` int(10) unsigned NOT NULL,
  `UUID` varchar(45) DEFAULT NULL,
  `imageURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`crystal_has_UUID_Id`),
  KEY `Crystal_has_UUID_FKIndex1` (`crystalId`),
  KEY `Crystal_has_UUID_FKIndex2` (`UUID`),
  CONSTRAINT `ibfk_1` FOREIGN KEY (`crystalId`) REFERENCES `Crystal` (`crystalId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Crystal_has_UUID`
--

LOCK TABLES `Crystal_has_UUID` WRITE;
/*!40000 ALTER TABLE `Crystal_has_UUID` DISABLE KEYS */;
/*!40000 ALTER TABLE `Crystal_has_UUID` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataAcquisition`
--

DROP TABLE IF EXISTS `DataAcquisition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataAcquisition` (
  `dataAcquisitionId` int(10) NOT NULL AUTO_INCREMENT,
  `sampleCellId` int(10) NOT NULL,
  `framesCount` varchar(45) DEFAULT NULL,
  `energy` varchar(45) DEFAULT NULL,
  `waitTime` varchar(45) DEFAULT NULL,
  `detectorDistance` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`dataAcquisitionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataAcquisition`
--

LOCK TABLES `DataAcquisition` WRITE;
/*!40000 ALTER TABLE `DataAcquisition` DISABLE KEYS */;
/*!40000 ALTER TABLE `DataAcquisition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataCollection`
--

DROP TABLE IF EXISTS `DataCollection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataCollection` (
  `dataCollectionId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `BLSAMPLEID` int(11) unsigned DEFAULT NULL,
  `SESSIONID` int(11) unsigned DEFAULT 0,
  `experimenttype` varchar(24) DEFAULT NULL,
  `dataCollectionNumber` int(10) unsigned DEFAULT NULL,
  `startTime` datetime DEFAULT NULL COMMENT 'Start time of the dataCollection',
  `endTime` datetime DEFAULT NULL COMMENT 'end time of the dataCollection',
  `runStatus` varchar(45) DEFAULT NULL,
  `axisStart` float DEFAULT NULL,
  `axisEnd` float DEFAULT NULL,
  `axisRange` float DEFAULT NULL,
  `overlap` float DEFAULT NULL,
  `numberOfImages` int(10) unsigned DEFAULT NULL,
  `startImageNumber` int(10) unsigned DEFAULT NULL,
  `numberOfPasses` int(10) unsigned DEFAULT NULL,
  `exposureTime` float DEFAULT NULL,
  `imageDirectory` varchar(255) DEFAULT NULL COMMENT 'The directory where files reside - should end with a slash',
  `imagePrefix` varchar(45) DEFAULT NULL,
  `imageSuffix` varchar(45) DEFAULT NULL,
  `imageContainerSubPath` varchar(255) DEFAULT NULL COMMENT 'Internal path of a HDF5 file pointing to the data for this data collection',
  `fileTemplate` varchar(255) DEFAULT NULL,
  `wavelength` float DEFAULT NULL,
  `resolution` float DEFAULT NULL,
  `detectorDistance` float DEFAULT NULL,
  `xBeam` float DEFAULT NULL,
  `yBeam` float DEFAULT NULL,
  `comments` varchar(1024) DEFAULT NULL,
  `printableForReport` tinyint(1) unsigned DEFAULT 1,
  `CRYSTALCLASS` varchar(20) DEFAULT NULL,
  `slitGapVertical` float DEFAULT NULL,
  `slitGapHorizontal` float DEFAULT NULL,
  `transmission` float DEFAULT NULL,
  `synchrotronMode` varchar(20) DEFAULT NULL,
  `xtalSnapshotFullPath1` varchar(255) DEFAULT NULL,
  `xtalSnapshotFullPath2` varchar(255) DEFAULT NULL,
  `xtalSnapshotFullPath3` varchar(255) DEFAULT NULL,
  `xtalSnapshotFullPath4` varchar(255) DEFAULT NULL,
  `rotationAxis` enum('Omega','Kappa','Phi') DEFAULT NULL,
  `phiStart` float DEFAULT NULL,
  `kappaStart` float DEFAULT NULL,
  `omegaStart` float DEFAULT NULL,
  `chiStart` float DEFAULT NULL,
  `resolutionAtCorner` float DEFAULT NULL,
  `detector2Theta` float DEFAULT NULL,
  `DETECTORMODE` varchar(255) DEFAULT NULL,
  `undulatorGap1` float DEFAULT NULL,
  `undulatorGap2` float DEFAULT NULL,
  `undulatorGap3` float DEFAULT NULL,
  `beamSizeAtSampleX` float DEFAULT NULL,
  `beamSizeAtSampleY` float DEFAULT NULL,
  `centeringMethod` varchar(255) DEFAULT NULL,
  `averageTemperature` float DEFAULT NULL,
  `ACTUALSAMPLEBARCODE` varchar(45) DEFAULT NULL,
  `ACTUALSAMPLESLOTINCONTAINER` int(11) unsigned DEFAULT NULL,
  `ACTUALCONTAINERBARCODE` varchar(45) DEFAULT NULL,
  `ACTUALCONTAINERSLOTINSC` int(11) unsigned DEFAULT NULL,
  `actualCenteringPosition` varchar(255) DEFAULT NULL,
  `beamShape` varchar(45) DEFAULT NULL,
  `dataCollectionGroupId` int(11) NOT NULL COMMENT 'references DataCollectionGroup table',
  `POSITIONID` int(11) unsigned DEFAULT NULL,
  `detectorId` int(11) DEFAULT NULL COMMENT 'references Detector table',
  `FOCALSPOTSIZEATSAMPLEX` float DEFAULT NULL,
  `POLARISATION` float DEFAULT NULL,
  `FOCALSPOTSIZEATSAMPLEY` float DEFAULT NULL,
  `APERTUREID` int(11) unsigned DEFAULT NULL,
  `screeningOrigId` int(11) unsigned DEFAULT NULL,
  `startPositionId` int(11) unsigned DEFAULT NULL,
  `endPositionId` int(11) unsigned DEFAULT NULL,
  `flux` double DEFAULT NULL,
  `strategySubWedgeOrigId` int(10) unsigned DEFAULT NULL COMMENT 'references ScreeningStrategySubWedge table',
  `blSubSampleId` int(11) unsigned DEFAULT NULL,
  `flux_end` double DEFAULT NULL COMMENT 'flux measured after the collect',
  `bestWilsonPlotPath` varchar(255) DEFAULT NULL,
  `processedDataFile` varchar(255) DEFAULT NULL,
  `datFullPath` varchar(255) DEFAULT NULL,
  `magnification` float unsigned DEFAULT NULL COMMENT 'Calibrated magnification, Units: dimensionless',
  `totalAbsorbedDose` float DEFAULT NULL COMMENT 'Unit: e-/A^2 for EM',
  `binning` tinyint(1) DEFAULT 1 COMMENT '1 or 2. Number of pixels to process as 1. (Use mean value.)',
  `particleDiameter` float DEFAULT NULL COMMENT 'Unit: nm',
  `boxSize_CTF` float DEFAULT NULL COMMENT 'Unit: pixels',
  `minResolution` float DEFAULT NULL COMMENT 'Unit: A',
  `minDefocus` float DEFAULT NULL COMMENT 'Unit: A',
  `maxDefocus` float DEFAULT NULL COMMENT 'Unit: A',
  `defocusStepSize` float DEFAULT NULL COMMENT 'Unit: A',
  `amountAstigmatism` float DEFAULT NULL COMMENT 'Unit: A',
  `extractSize` float DEFAULT NULL COMMENT 'Unit: pixels',
  `bgRadius` float DEFAULT NULL COMMENT 'Unit: nm',
  `voltage` float DEFAULT NULL COMMENT 'Unit: kV',
  `objAperture` float DEFAULT NULL COMMENT 'Unit: um',
  `c1aperture` float DEFAULT NULL COMMENT 'Unit: um',
  `c2aperture` float DEFAULT NULL COMMENT 'Unit: um',
  `c3aperture` float DEFAULT NULL COMMENT 'Unit: um',
  `c1lens` float DEFAULT NULL COMMENT 'Unit: %',
  `c2lens` float DEFAULT NULL COMMENT 'Unit: %',
  `c3lens` float DEFAULT NULL COMMENT 'Unit: %',
  `totalExposedDose` float DEFAULT NULL COMMENT 'Units: e-/A^2',
  `nominalMagnification` float unsigned DEFAULT NULL COMMENT 'Nominal magnification: Units: dimensionless',
  `nominalDefocus` float unsigned DEFAULT NULL COMMENT 'Nominal defocus, Units: A',
  `imageSizeX` mediumint(8) unsigned DEFAULT NULL COMMENT 'Image size in x, incase crop has been used, Units: pixels',
  `imageSizeY` mediumint(8) unsigned DEFAULT NULL COMMENT 'Image size in y, Units: pixels',
  `pixelSizeOnImage` float DEFAULT NULL COMMENT 'Pixel size on image, calculated from magnification, duplicate? Units: um?',
  `phasePlate` tinyint(1) DEFAULT NULL COMMENT 'Whether the phase plate was used',
  `dataCollectionPlanId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`dataCollectionId`),
  KEY `blSubSampleId` (`blSubSampleId`),
  KEY `DataCollection_FKIndex1` (`dataCollectionGroupId`),
  KEY `DataCollection_FKIndex2` (`strategySubWedgeOrigId`),
  KEY `DataCollection_FKIndex3` (`detectorId`),
  KEY `DataCollection_FKIndexDCNumber` (`dataCollectionNumber`),
  KEY `DataCollection_FKIndexImageDirectory` (`imageDirectory`),
  KEY `DataCollection_FKIndexImagePrefix` (`imagePrefix`),
  KEY `DataCollection_FKIndexStartTime` (`startTime`),
  KEY `endPositionId` (`endPositionId`),
  KEY `startPositionId` (`startPositionId`),
  KEY `DataCollection_FKIndex0` (`BLSAMPLEID`),
  KEY `DataCollection_FKIndex00` (`SESSIONID`),
  KEY `DataCollection_dataCollectionGroupId_startTime` (`dataCollectionGroupId`,`startTime`),
  KEY `DataCollection_dataCollectionPlanId` (`dataCollectionPlanId`),
  CONSTRAINT `DataCollection_dataCollectionPlanId` FOREIGN KEY (`dataCollectionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `DataCollection_ibfk_1` FOREIGN KEY (`strategySubWedgeOrigId`) REFERENCES `ScreeningStrategySubWedge` (`screeningStrategySubWedgeId`),
  CONSTRAINT `DataCollection_ibfk_2` FOREIGN KEY (`detectorId`) REFERENCES `Detector` (`detectorId`),
  CONSTRAINT `DataCollection_ibfk_3` FOREIGN KEY (`dataCollectionGroupId`) REFERENCES `DataCollectionGroup` (`dataCollectionGroupId`),
  CONSTRAINT `DataCollection_ibfk_6` FOREIGN KEY (`startPositionId`) REFERENCES `MotorPosition` (`motorPositionId`),
  CONSTRAINT `DataCollection_ibfk_7` FOREIGN KEY (`endPositionId`) REFERENCES `MotorPosition` (`motorPositionId`),
  CONSTRAINT `DataCollection_ibfk_8` FOREIGN KEY (`blSubSampleId`) REFERENCES `BLSubSample` (`blSubSampleId`)
) ENGINE=InnoDB AUTO_INCREMENT=6018040 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataCollection`
--

LOCK TABLES `DataCollection` WRITE;
/*!40000 ALTER TABLE `DataCollection` DISABLE KEYS */;
INSERT INTO `DataCollection` VALUES
(993677,374695,55167,NULL,1,'2016-01-14 12:40:34','2016-01-14 12:41:54','DataCollection Successful',45,0.1,0.1,0,3600,1,1,0.02,'/dls/i03/data/2016/cm14451-1/20160114/tlys_jan_4/','tlys_jan_4','cbf',NULL,'tlys_jan_4_1_####.cbf',1.28255,1.6,193.087,215.62,208.978,'(-402,345,142) EDNAStrategy4: subWedge:1Aperture: Medium',1,NULL,0.059918,0.099937,40.1936,'User','/dls/i03/data/2016/cm14451-1/jpegs/20160114/tlys_jan_4/tlys_jan_4_1_1_315.0.png','/dls/i03/data/2016/cm14451-1/jpegs/20160114/tlys_jan_4/tlys_jan_4_1_1_225.0.png','/dls/i03/data/2016/cm14451-1/jpegs/20160114/tlys_jan_4/tlys_jan_4_1_1_135.0.png','/dls/i03/data/2016/cm14451-1/jpegs/20160114/tlys_jan_4/tlys_jan_4_1_1_45.0.png','Omega',NULL,NULL,45,NULL,NULL,NULL,NULL,5.685,NULL,NULL,0.05,0.02,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,988855,2,NULL,80,NULL,20,6,NULL,NULL,NULL,833107367454.3083,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(1002287,NULL,55167,NULL,2,'2016-01-22 11:25:18','2016-01-22 11:28:23','DataCollection Successful',0,0.1,0.1,0,7200,1,1,0.025,'/dls/i03/data/2016/cm14451-1/20160122/gw/ins2/001/','ins2','cbf',NULL,'ins2_2_####.cbf',1.2,1.41777,175,215.618,209.102,'(-307,322,-184) Aperture: Large',1,NULL,0.059918,0.099937,0.999423,'User','/dls/i03/data/2016/cm14451-1/jpegs/20160122/gw/ins2/001/ins2_2_1_270.0.png','/dls/i03/data/2016/cm14451-1/jpegs/20160122/gw/ins2/001/ins2_2_1_180.0.png','/dls/i03/data/2016/cm14451-1/jpegs/20160122/gw/ins2/001/ins2_2_1_90.0.png','/dls/i03/data/2016/cm14451-1/jpegs/20160122/gw/ins2/001/ins2_2_1_0.0.png','Omega',NULL,NULL,0,NULL,NULL,NULL,NULL,6.1213,NULL,NULL,0.08,0.02,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,996311,602072,NULL,80,NULL,20,3752,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(1052494,NULL,55168,NULL,1,'2016-04-13 12:18:12','2016-04-13 12:18:50','DataCollection Successful',0,0.4,0.4,-89.6,2,1,1,0.01,'/dls/i03/data/2016/cm14451-2/20160413/test_xtal/','xtal1','cbf',NULL,'xtal1_1_####.cbf',0.976254,1.24362,200,214.33,208.71,'(-703,-47,-74) Aperture: Large',1,NULL,0.059918,0.099937,100,'User','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_1_1_90.0.png','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_1_1_0.0.png',NULL,NULL,'Omega',NULL,NULL,0,NULL,NULL,NULL,NULL,5.30095,NULL,NULL,0.08,0.02,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1040398,647536,NULL,80,NULL,20,3752,NULL,NULL,NULL,1959830505829.428,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(1052503,NULL,55168,NULL,3,'2016-04-13 12:21:26','2016-04-13 12:21:54','DataCollection Successful',93,0.3,0.3,-44.7,3,1,1,0.01,'/dls/i03/data/2016/cm14451-2/20160413/test_xtal/','xtal1','cbf',NULL,'xtal1_3_####.cbf',0.976253,1.5,266.693,214.372,208.299,'(-703,-47,-74) Aperture: Large',1,NULL,0.059918,0.099937,100,'User','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_1_183.0.png','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_1_93.0.png',NULL,NULL,'Omega',NULL,NULL,93,NULL,NULL,NULL,NULL,5.30095,NULL,NULL,0.08,0.02,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1040407,647545,NULL,80,NULL,20,3752,NULL,NULL,NULL,1972385107622.2878,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(1066786,398810,55168,NULL,2,'2016-04-18 11:04:44','2016-04-18 11:04:57','DataCollection Successful',0,0.5,0.5,-44.5,3,1,1,0.1,'/dls/i03/data/2016/cm14451-2/gw/20160418/thau/edna_test/','thau','cbf',NULL,'thau_2_####.cbf',0.976253,1.5,266.693,214.372,208.299,'(-345,-241,-185) Aperture: Large',1,NULL,0.059918,0.099937,5.00016,'User','/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_1_90.0.png','/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_1_0.0.png',NULL,NULL,'Omega',NULL,NULL,0,NULL,NULL,NULL,NULL,5.301,NULL,NULL,0.08,0.02,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1054243,661459,NULL,80,NULL,20,3752,NULL,NULL,NULL,57087013071.909134,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6017405,374695,55167,NULL,1,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',210,0,0,0,480,1,1,0.004,'/dls/i03/data/2021/proposal/data','Lys_6','.h5',NULL,'file.h5',0.976254,4.2989,337,78.0483,83.9258,'Xray centring - Diffraction grid scan of 30 by 16 images, Top left [304,229], Bottom right [1024,599]',1,NULL,0.499922,0.49994,100,'User','/dls/i03/data/2021/cm28170-1/jpegs/xraycentring/screening/TestLysozyme/Lys_6/Lys_6_1_210.0.png','/dls/i03/data/2021/cm28170-1/jpegs/xraycentring/screening/TestLysozyme/Lys_6/Lys_6_1_210.0.png','/dls/i03/data/2021/cm28170-1/jpegs/xraycentring/screening/TestLysozyme/Lys_6/Lys_6_1_210.0.png',NULL,NULL,0,NULL,210,-0.000047,NULL,NULL,NULL,5.28695,NULL,NULL,0.02,0.02,'UNSPECIFIED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440739,4642226,78,80,NULL,20,NULL,NULL,NULL,NULL,731694586254.7522,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6017406,NULL,27464088,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls/m07/data/2024/nr21005-393/raw7','test','.tiff',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'A Totally Creative Title for a Tomogram',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440740,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,0,NULL),
(6017407,NULL,27464089,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Yet Another Title',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440741,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6017408,NULL,27464089,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Yet Another Title',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440742,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6017409,NULL,27464089,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Yet Another Title',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440743,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,300,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6017410,NULL,27464089,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Yet Another Title',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440743,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6017411,NULL,27464089,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'A Tomogram That Is Still Being Processed',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440744,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,300,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,12,10,NULL,NULL),
(6017412,NULL,27464088,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'A Tomogram That Is Still Being Processed',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440740,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,300,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,12,10,1,NULL),
(6017413,NULL,27464088,NULL,NULL,'2021-02-25 10:15:06','2021-02-25 10:15:47','DataCollection Successful',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls/m12/data/2022/cm31111-5/raw/',NULL,'.tif',NULL,'GridSquare_*/Data/*.tif',NULL,NULL,NULL,NULL,NULL,'A Tomogram That Is Still Being Processed',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5440740,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,300,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,12,10,NULL,NULL);
/*!40000 ALTER TABLE `DataCollection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataCollectionComment`
--

DROP TABLE IF EXISTS `DataCollectionComment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataCollectionComment` (
  `dataCollectionCommentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned NOT NULL,
  `personId` int(10) unsigned NOT NULL,
  `comments` varchar(4000) DEFAULT NULL,
  `createTime` datetime NOT NULL DEFAULT current_timestamp(),
  `modTime` date DEFAULT NULL,
  PRIMARY KEY (`dataCollectionCommentId`),
  KEY `dataCollectionComment_fk1` (`dataCollectionId`),
  KEY `dataCollectionComment_fk2` (`personId`),
  CONSTRAINT `dataCollectionComment_fk1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `dataCollectionComment_fk2` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataCollectionComment`
--

LOCK TABLES `DataCollectionComment` WRITE;
/*!40000 ALTER TABLE `DataCollectionComment` DISABLE KEYS */;
/*!40000 ALTER TABLE `DataCollectionComment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataCollectionFileAttachment`
--

DROP TABLE IF EXISTS `DataCollectionFileAttachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataCollectionFileAttachment` (
  `dataCollectionFileAttachmentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned NOT NULL,
  `fileFullPath` varchar(255) NOT NULL,
  `fileType` enum('snapshot','log','xy','recip','pia','warning','params') DEFAULT NULL,
  `createTime` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`dataCollectionFileAttachmentId`),
  KEY `_dataCollectionFileAttachmentId_fk1` (`dataCollectionId`),
  CONSTRAINT `_dataCollectionFileAttachmentId_fk1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataCollectionFileAttachment`
--

LOCK TABLES `DataCollectionFileAttachment` WRITE;
/*!40000 ALTER TABLE `DataCollectionFileAttachment` DISABLE KEYS */;
INSERT INTO `DataCollectionFileAttachment` VALUES
(1,6017413,'/dls/test.txt','params','2025-06-25 08:06:46'),
(2,6017413,'/dls/log.txt','log','2025-06-25 08:06:46');
/*!40000 ALTER TABLE `DataCollectionFileAttachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataCollectionGroup`
--

DROP TABLE IF EXISTS `DataCollectionGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataCollectionGroup` (
  `dataCollectionGroupId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `sessionId` int(10) unsigned NOT NULL COMMENT 'references Session table',
  `comments` varchar(1024) DEFAULT NULL COMMENT 'comments',
  `blSampleId` int(10) unsigned DEFAULT NULL COMMENT 'references BLSample table',
  `experimentType` enum('SAD','SAD - Inverse Beam','OSC','Collect - Multiwedge','MAD','Helical','Multi-positional','Mesh','Burn','MAD - Inverse Beam','Characterization','Dehydration','tomo','experiment','EM','PDF','PDF+Bragg','Bragg','single particle','Serial Fixed','Serial Jet','Standard','Time Resolved','Diamond Anvil High Pressure','Custom','XRF map','Energy scan','XRF spectrum','XRF map xas','Mesh3D','Screening') DEFAULT NULL COMMENT 'Standard: Routine structure determination experiment. Time Resolved: Investigate the change of a system over time. Custom: Special or non-standard data collection.',
  `startTime` datetime DEFAULT NULL COMMENT 'Start time of the dataCollectionGroup',
  `endTime` datetime DEFAULT NULL COMMENT 'end time of the dataCollectionGroup',
  `crystalClass` varchar(20) DEFAULT NULL COMMENT 'Crystal Class for industrials users',
  `detectorMode` varchar(255) DEFAULT NULL COMMENT 'Detector mode',
  `actualSampleBarcode` varchar(45) DEFAULT NULL COMMENT 'Actual sample barcode',
  `actualSampleSlotInContainer` int(10) unsigned DEFAULT NULL COMMENT 'Actual sample slot number in container',
  `actualContainerBarcode` varchar(45) DEFAULT NULL COMMENT 'Actual container barcode',
  `actualContainerSlotInSC` int(10) unsigned DEFAULT NULL COMMENT 'Actual container slot number in sample changer',
  `xtalSnapshotFullPath` varchar(255) DEFAULT NULL,
  `scanParameters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`scanParameters`)),
  `experimentTypeId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`dataCollectionGroupId`),
  KEY `DataCollectionGroup_FKIndex1` (`blSampleId`),
  KEY `DataCollectionGroup_FKIndex2` (`sessionId`),
  KEY `DataCollectionGroup_ibfk_4` (`experimentTypeId`),
  CONSTRAINT `DataCollectionGroup_ibfk_1` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `DataCollectionGroup_ibfk_2` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `DataCollectionGroup_ibfk_4` FOREIGN KEY (`experimentTypeId`) REFERENCES `ExperimentType` (`experimentTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=5441293 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='a dataCollectionGroup is a group of dataCollection for a spe';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataCollectionGroup`
--

LOCK TABLES `DataCollectionGroup` WRITE;
/*!40000 ALTER TABLE `DataCollectionGroup` DISABLE KEYS */;
INSERT INTO `DataCollectionGroup` VALUES
(988855,55167,NULL,374695,'SAD',NULL,NULL,NULL,'Ext. Trigger','HA00AU3712',NULL,NULL,NULL,NULL,NULL,NULL),
(996311,55167,NULL,NULL,'SAD',NULL,NULL,NULL,'Ext. Trigger',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(1040398,55168,NULL,NULL,'SAD',NULL,NULL,NULL,'Ext. Trigger',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(1040407,55168,NULL,NULL,'SAD',NULL,NULL,NULL,'Ext. Trigger',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(1054243,55168,NULL,398810,'SAD',NULL,NULL,NULL,'Ext. Trigger','CA00AG9993',NULL,NULL,NULL,NULL,NULL,NULL),
(5440739,55167,NULL,374695,'Mesh',NULL,NULL,NULL,NULL,'NR',NULL,NULL,NULL,NULL,NULL,NULL),
(5440740,27464088,NULL,NULL,'Mesh',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,36),
(5440741,27464089,NULL,NULL,'Mesh',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5440742,27464089,'Processed',NULL,'Mesh',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,36),
(5440743,27464089,NULL,NULL,'Mesh',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,36),
(5440744,27464089,NULL,NULL,'Mesh',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,36);
/*!40000 ALTER TABLE `DataCollectionGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataCollectionPlan_has_Detector`
--

DROP TABLE IF EXISTS `DataCollectionPlan_has_Detector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataCollectionPlan_has_Detector` (
  `dataCollectionPlanHasDetectorId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionPlanId` int(11) unsigned NOT NULL,
  `detectorId` int(11) NOT NULL,
  `exposureTime` double DEFAULT NULL,
  `distance` double DEFAULT NULL,
  `roll` double DEFAULT NULL,
  PRIMARY KEY (`dataCollectionPlanHasDetectorId`),
  UNIQUE KEY `dataCollectionPlanId` (`dataCollectionPlanId`,`detectorId`),
  KEY `DataCollectionPlan_has_Detector_ibfk2` (`detectorId`),
  CONSTRAINT `DataCollectionPlan_has_Detector_ibfk1` FOREIGN KEY (`dataCollectionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`),
  CONSTRAINT `DataCollectionPlan_has_Detector_ibfk2` FOREIGN KEY (`detectorId`) REFERENCES `Detector` (`detectorId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataCollectionPlan_has_Detector`
--

LOCK TABLES `DataCollectionPlan_has_Detector` WRITE;
/*!40000 ALTER TABLE `DataCollectionPlan_has_Detector` DISABLE KEYS */;
INSERT INTO `DataCollectionPlan_has_Detector` VALUES
(4,197792,8,5.4,136.86,45);
/*!40000 ALTER TABLE `DataCollectionPlan_has_Detector` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Detector`
--

DROP TABLE IF EXISTS `Detector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Detector` (
  `detectorId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `detectorType` varchar(255) DEFAULT NULL,
  `detectorManufacturer` varchar(255) DEFAULT NULL,
  `detectorModel` varchar(255) DEFAULT NULL,
  `detectorPixelSizeHorizontal` float DEFAULT NULL,
  `detectorPixelSizeVertical` float DEFAULT NULL,
  `DETECTORMAXRESOLUTION` float DEFAULT NULL,
  `DETECTORMINRESOLUTION` float DEFAULT NULL,
  `detectorSerialNumber` varchar(30) DEFAULT NULL,
  `detectorDistanceMin` double DEFAULT NULL,
  `detectorDistanceMax` double DEFAULT NULL,
  `trustedPixelValueRangeLower` double DEFAULT NULL,
  `trustedPixelValueRangeUpper` double DEFAULT NULL,
  `sensorThickness` float DEFAULT NULL,
  `overload` float DEFAULT NULL,
  `XGeoCorr` varchar(255) DEFAULT NULL,
  `YGeoCorr` varchar(255) DEFAULT NULL,
  `detectorMode` varchar(255) DEFAULT NULL,
  `density` float DEFAULT NULL,
  `composition` varchar(16) DEFAULT NULL,
  `numberOfPixelsX` mediumint(9) DEFAULT NULL COMMENT 'Detector number of pixels in x',
  `numberOfPixelsY` mediumint(9) DEFAULT NULL COMMENT 'Detector number of pixels in y',
  `detectorRollMin` double DEFAULT NULL COMMENT 'unit: degrees',
  `detectorRollMax` double DEFAULT NULL COMMENT 'unit: degrees',
  `localName` varchar(40) DEFAULT NULL COMMENT 'Colloquial name for the detector',
  PRIMARY KEY (`detectorId`),
  UNIQUE KEY `Detector_ibuk1` (`detectorSerialNumber`),
  KEY `Detector_FKIndex1` (`detectorType`,`detectorManufacturer`,`detectorModel`,`detectorPixelSizeHorizontal`,`detectorPixelSizeVertical`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Detector table is linked to a dataCollection';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Detector`
--

LOCK TABLES `Detector` WRITE;
/*!40000 ALTER TABLE `Detector` DISABLE KEYS */;
INSERT INTO `Detector` VALUES
(4,'Photon counting','In-house','Excalibur',NULL,NULL,NULL,NULL,'1109-434',100,300,NULL,NULL,NULL,NULL,NULL,NULL,NULL,55,'CrO3Br5Sr10',NULL,NULL,NULL,NULL,NULL),
(8,'Diamond XPDF detector',NULL,NULL,NULL,NULL,NULL,NULL,'1109-761',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10.4,'C+Br+He',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Detector` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Dewar`
--

DROP TABLE IF EXISTS `Dewar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Dewar` (
  `dewarId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `shippingId` int(10) unsigned DEFAULT NULL,
  `code` varchar(45) DEFAULT NULL,
  `comments` tinytext DEFAULT NULL,
  `storageLocation` varchar(45) DEFAULT NULL,
  `dewarStatus` varchar(45) DEFAULT NULL,
  `bltimeStamp` datetime DEFAULT NULL,
  `isStorageDewar` tinyint(1) DEFAULT 0,
  `barCode` varchar(45) DEFAULT NULL,
  `firstExperimentId` int(10) unsigned DEFAULT NULL,
  `customsValue` int(11) unsigned DEFAULT NULL,
  `transportValue` int(11) unsigned DEFAULT NULL,
  `trackingNumberToSynchrotron` varchar(30) DEFAULT NULL,
  `trackingNumberFromSynchrotron` varchar(30) DEFAULT NULL,
  `type` enum('Dewar','Toolbox','Parcel') NOT NULL DEFAULT 'Dewar',
  `facilityCode` varchar(20) DEFAULT NULL,
  `weight` float DEFAULT NULL COMMENT 'dewar weight in kg',
  `deliveryAgent_barcode` varchar(30) DEFAULT NULL COMMENT 'Courier piece barcode (not the airway bill)',
  `externalShippingIdFromSynchrotron` int(11) unsigned DEFAULT NULL COMMENT 'ID for shipping from synchrotron in external application',
  `source` varchar(50) DEFAULT current_user(),
  `extra` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JSON column for facility-specific or hard-to-define attributes, e.g. LN2 top-ups and contents checks' CHECK (json_valid(`extra`)),
  `dewarRegistryId` int(11) unsigned DEFAULT NULL COMMENT 'Reference to the registered dewar i.e. the physical item',
  PRIMARY KEY (`dewarId`),
  UNIQUE KEY `barCode` (`barCode`),
  KEY `Dewar_FKIndex1` (`shippingId`),
  KEY `Dewar_FKIndex2` (`firstExperimentId`),
  KEY `Dewar_FKIndexCode` (`code`),
  KEY `Dewar_FKIndexStatus` (`dewarStatus`),
  KEY `Dewar_fk_dewarRegistryId` (`dewarRegistryId`),
  CONSTRAINT `Dewar_fk_dewarRegistryId` FOREIGN KEY (`dewarRegistryId`) REFERENCES `DewarRegistry` (`dewarRegistryId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Dewar_fk_firstExperimentId` FOREIGN KEY (`firstExperimentId`) REFERENCES `BLSession` (`sessionId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Dewar_ibfk_1` FOREIGN KEY (`shippingId`) REFERENCES `Shipping` (`shippingId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12569 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Dewar`
--

LOCK TABLES `Dewar` WRITE;
/*!40000 ALTER TABLE `Dewar` DISABLE KEYS */;
INSERT INTO `Dewar` VALUES
(573,474,'Dewar-1-cm0001-1',NULL,NULL,'processing',NULL,0,'dewar-cm0001-1-0000001',NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(576,474,'Dewar-2-cm0001-1',NULL,NULL,'at DLS',NULL,0,'dewar-cm0001-1-0000002',NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(579,477,'Dewar-3-cm0001-2',NULL,NULL,'processing',NULL,0,'dewar-cm0001-2-0000477',NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(582,480,'Dewar-4-cm0001-3',NULL,NULL,'processing',NULL,0,'dewar-cm0001-3-0000480',NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(8287,6988,'Default Dewar:cm14451-1',NULL,NULL,'processing',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(8572,7227,'cm14451-2_Dewar1',NULL,NULL,'processing','2016-02-10 13:03:07',0,NULL,NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(8578,7231,'Dewar_1',NULL,NULL,'opened',NULL,0,'cm14451-12345',NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(8581,7241,'DLS-1',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(8582,7242,'DLS-1',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL),
(8583,7243,'DLS-1',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'Dewar',NULL,NULL,NULL,NULL,'root@%',NULL,NULL);
/*!40000 ALTER TABLE `Dewar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DewarLocation`
--

DROP TABLE IF EXISTS `DewarLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DewarLocation` (
  `eventId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dewarNumber` varchar(128) NOT NULL COMMENT 'Dewar number',
  `userId` varchar(128) DEFAULT NULL COMMENT 'User who locates the dewar',
  `dateTime` datetime DEFAULT NULL COMMENT 'Date and time of locatization',
  `locationName` varchar(128) DEFAULT NULL COMMENT 'Location of the dewar',
  `courierName` varchar(128) DEFAULT NULL COMMENT 'Carrier name who''s shipping back the dewar',
  `courierTrackingNumber` varchar(128) DEFAULT NULL COMMENT 'Tracking number of the shippment',
  PRIMARY KEY (`eventId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='ISPyB Dewar location table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DewarLocation`
--

LOCK TABLES `DewarLocation` WRITE;
/*!40000 ALTER TABLE `DewarLocation` DISABLE KEYS */;
/*!40000 ALTER TABLE `DewarLocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DewarLocationList`
--

DROP TABLE IF EXISTS `DewarLocationList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DewarLocationList` (
  `locationId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locationName` varchar(128) NOT NULL DEFAULT '' COMMENT 'Location',
  PRIMARY KEY (`locationId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='List of locations for dewars';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DewarLocationList`
--

LOCK TABLES `DewarLocationList` WRITE;
/*!40000 ALTER TABLE `DewarLocationList` DISABLE KEYS */;
/*!40000 ALTER TABLE `DewarLocationList` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DewarRegistry`
--

DROP TABLE IF EXISTS `DewarRegistry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DewarRegistry` (
  `dewarRegistryId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `facilityCode` varchar(20) NOT NULL,
  `proposalId` int(11) unsigned DEFAULT NULL,
  `labContactId` int(11) unsigned DEFAULT NULL,
  `purchaseDate` datetime DEFAULT NULL,
  `bltimestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `manufacturerSerialNumber` varchar(15) DEFAULT NULL COMMENT 'Dewar serial number as given by manufacturer. Used to be typically 5 or 6 digits, more likely to be 11 alphanumeric chars in future',
  `type` enum('Dewar','Toolbox','Thermal Shipper') NOT NULL DEFAULT 'Dewar',
  PRIMARY KEY (`dewarRegistryId`),
  UNIQUE KEY `facilityCode` (`facilityCode`),
  KEY `DewarRegistry_ibfk_1` (`proposalId`),
  KEY `DewarRegistry_ibfk_2` (`labContactId`),
  CONSTRAINT `DewarRegistry_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `DewarRegistry_ibfk_2` FOREIGN KEY (`labContactId`) REFERENCES `LabContact` (`labContactId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=539 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DewarRegistry`
--

LOCK TABLES `DewarRegistry` WRITE;
/*!40000 ALTER TABLE `DewarRegistry` DISABLE KEYS */;
INSERT INTO `DewarRegistry` VALUES
(1,'DLS-EM-0000',141666,NULL,NULL,'2023-09-14 09:19:21',NULL,'Dewar'),
(2,'DLS-EM-0001',37027,NULL,NULL,'2023-09-14 09:19:21',NULL,'Dewar'),
(217,'DLS-EM-0002',141666,NULL,NULL,'2023-09-14 09:19:21',NULL,'Dewar');
/*!40000 ALTER TABLE `DewarRegistry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DewarRegistry_has_Proposal`
--

DROP TABLE IF EXISTS `DewarRegistry_has_Proposal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DewarRegistry_has_Proposal` (
  `dewarRegistryHasProposalId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dewarRegistryId` int(11) unsigned DEFAULT NULL,
  `proposalId` int(10) unsigned DEFAULT NULL,
  `personId` int(10) unsigned DEFAULT NULL COMMENT 'Person registering the dewar',
  `recordTimestamp` datetime DEFAULT current_timestamp(),
  `labContactId` int(11) unsigned DEFAULT NULL COMMENT 'Owner of the dewar',
  PRIMARY KEY (`dewarRegistryHasProposalId`),
  UNIQUE KEY `dewarRegistryId` (`dewarRegistryId`,`proposalId`),
  KEY `DewarRegistry_has_Proposal_ibfk2` (`proposalId`),
  KEY `DewarRegistry_has_Proposal_ibfk3` (`personId`),
  KEY `DewarRegistry_has_Proposal_ibfk4` (`labContactId`),
  CONSTRAINT `DewarRegistry_has_Proposal_ibfk1` FOREIGN KEY (`dewarRegistryId`) REFERENCES `DewarRegistry` (`dewarRegistryId`),
  CONSTRAINT `DewarRegistry_has_Proposal_ibfk2` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`),
  CONSTRAINT `DewarRegistry_has_Proposal_ibfk3` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`),
  CONSTRAINT `DewarRegistry_has_Proposal_ibfk4` FOREIGN KEY (`labContactId`) REFERENCES `LabContact` (`labContactId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=353 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DewarRegistry_has_Proposal`
--

LOCK TABLES `DewarRegistry_has_Proposal` WRITE;
/*!40000 ALTER TABLE `DewarRegistry_has_Proposal` DISABLE KEYS */;
INSERT INTO `DewarRegistry_has_Proposal` VALUES
(1,1,141666,NULL,'2023-09-14 09:22:50',NULL),
(138,217,141666,NULL,'2023-09-14 09:22:50',NULL);
/*!40000 ALTER TABLE `DewarRegistry_has_Proposal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DewarReport`
--

DROP TABLE IF EXISTS `DewarReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DewarReport` (
  `dewarReportId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `facilityCode` varchar(20) NOT NULL,
  `report` text DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `bltimestamp` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`dewarReportId`),
  KEY `DewarReportIdx1` (`facilityCode`),
  CONSTRAINT `DewarReport_ibfk_1` FOREIGN KEY (`facilityCode`) REFERENCES `DewarRegistry` (`facilityCode`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DewarReport`
--

LOCK TABLES `DewarReport` WRITE;
/*!40000 ALTER TABLE `DewarReport` DISABLE KEYS */;
/*!40000 ALTER TABLE `DewarReport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DewarTransportHistory`
--

DROP TABLE IF EXISTS `DewarTransportHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DewarTransportHistory` (
  `DewarTransportHistoryId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dewarId` int(10) unsigned DEFAULT NULL,
  `dewarStatus` varchar(45) NOT NULL,
  `storageLocation` varchar(45) DEFAULT NULL,
  `arrivalDate` datetime DEFAULT NULL,
  PRIMARY KEY (`DewarTransportHistoryId`),
  KEY `DewarTransportHistory_FKIndex1` (`dewarId`),
  CONSTRAINT `DewarTransportHistory_ibfk_1` FOREIGN KEY (`dewarId`) REFERENCES `Dewar` (`dewarId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DewarTransportHistory`
--

LOCK TABLES `DewarTransportHistory` WRITE;
/*!40000 ALTER TABLE `DewarTransportHistory` DISABLE KEYS */;
INSERT INTO `DewarTransportHistory` VALUES
(1,576,'at-facility','','2025-01-01 00:00:00'),
(2,576,'opened','','2025-01-01 02:00:00');
/*!40000 ALTER TABLE `DewarTransportHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DiffractionPlan`
--

DROP TABLE IF EXISTS `DiffractionPlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DiffractionPlan` (
  `diffractionPlanId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `experimentKind` enum('Default','MXPressE','MXPressO','MXPressE_SAD','MXScore','MXPressM','MAD','SAD','Fixed','Ligand binding','Refinement','OSC','MAD - Inverse Beam','SAD - Inverse Beam','MESH','XFE','Stepped transmission','XChem High Symmetry','XChem Low Symmetry','Commissioning') DEFAULT NULL,
  `observedResolution` float DEFAULT NULL,
  `minimalResolution` float DEFAULT NULL,
  `exposureTime` float DEFAULT NULL,
  `oscillationRange` float DEFAULT NULL,
  `maximalResolution` float DEFAULT NULL,
  `screeningResolution` float DEFAULT NULL,
  `radiationSensitivity` float DEFAULT NULL,
  `anomalousScatterer` varchar(255) DEFAULT NULL,
  `preferredBeamSizeX` float DEFAULT NULL,
  `preferredBeamSizeY` float DEFAULT NULL,
  `preferredBeamDiameter` float DEFAULT NULL,
  `comments` varchar(1024) DEFAULT NULL,
  `DIFFRACTIONPLANUUID` varchar(1000) DEFAULT NULL,
  `aimedCompleteness` double DEFAULT NULL,
  `aimedIOverSigmaAtHighestRes` double DEFAULT NULL,
  `aimedMultiplicity` double DEFAULT NULL,
  `aimedResolution` double DEFAULT NULL,
  `anomalousData` tinyint(1) DEFAULT 0,
  `complexity` varchar(45) DEFAULT NULL,
  `estimateRadiationDamage` tinyint(1) DEFAULT 0,
  `forcedSpaceGroup` varchar(45) DEFAULT NULL,
  `requiredCompleteness` double DEFAULT NULL,
  `requiredMultiplicity` double DEFAULT NULL,
  `requiredResolution` double DEFAULT NULL,
  `strategyOption` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`strategyOption`)),
  `kappaStrategyOption` varchar(45) DEFAULT NULL,
  `numberOfPositions` int(11) DEFAULT NULL,
  `minDimAccrossSpindleAxis` double DEFAULT NULL COMMENT 'minimum dimension accross the spindle axis',
  `maxDimAccrossSpindleAxis` double DEFAULT NULL COMMENT 'maximum dimension accross the spindle axis',
  `radiationSensitivityBeta` double DEFAULT NULL,
  `radiationSensitivityGamma` double DEFAULT NULL,
  `minOscWidth` float DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `monochromator` varchar(8) DEFAULT NULL COMMENT 'DMM or DCM',
  `energy` float DEFAULT NULL COMMENT 'eV',
  `transmission` float DEFAULT NULL COMMENT 'Decimal fraction in range [0,1]',
  `boxSizeX` float DEFAULT NULL COMMENT 'microns',
  `boxSizeY` float DEFAULT NULL COMMENT 'microns',
  `kappaStart` float DEFAULT NULL COMMENT 'degrees',
  `axisStart` float DEFAULT NULL COMMENT 'degrees',
  `axisRange` float DEFAULT NULL COMMENT 'degrees',
  `numberOfImages` mediumint(9) DEFAULT NULL COMMENT 'The number of images requested',
  `presetForProposalId` int(10) unsigned DEFAULT NULL COMMENT 'Indicates this plan is available to all sessions on given proposal',
  `beamLineName` varchar(45) DEFAULT NULL COMMENT 'Indicates this plan is available to all sessions on given beamline',
  `detectorId` int(11) DEFAULT NULL,
  `distance` double DEFAULT NULL,
  `orientation` double DEFAULT NULL,
  `monoBandwidth` double DEFAULT NULL,
  `centringMethod` enum('xray','loop','diffraction','optical') DEFAULT NULL,
  `userPath` varchar(100) DEFAULT NULL COMMENT 'User-specified relative "root" path inside the session directory to be used for holding collected data',
  `robotPlateTemperature` float DEFAULT NULL COMMENT 'units: kelvin',
  `exposureTemperature` float DEFAULT NULL COMMENT 'units: kelvin',
  `experimentTypeId` int(10) unsigned DEFAULT NULL,
  `purificationColumnId` int(10) unsigned DEFAULT NULL,
  `collectionMode` enum('auto','manual') DEFAULT NULL COMMENT 'The requested collection mode, possible values are auto, manual',
  `priority` int(4) DEFAULT NULL COMMENT 'The priority of this sample relative to others in the shipment',
  `qMin` float DEFAULT NULL COMMENT 'minimum in qRange, unit: nm^-1, needed for SAXS',
  `qMax` float DEFAULT NULL COMMENT 'maximum in qRange, unit: nm^-1, needed for SAXS',
  `reductionParametersAveraging` enum('All','Fastest Dimension','1D') DEFAULT NULL COMMENT 'Post processing params for SAXS',
  `scanParameters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JSON serialised scan parameters, useful for parameters without designated columns' CHECK (json_valid(`scanParameters`)),
  PRIMARY KEY (`diffractionPlanId`),
  KEY `DiffractionPlan_ibfk1` (`presetForProposalId`),
  KEY `DataCollectionPlan_ibfk3` (`detectorId`),
  KEY `DiffractionPlan_ibfk3` (`experimentTypeId`),
  KEY `DiffractionPlan_ibfk2` (`purificationColumnId`),
  CONSTRAINT `DataCollectionPlan_ibfk3` FOREIGN KEY (`detectorId`) REFERENCES `Detector` (`detectorId`) ON UPDATE CASCADE,
  CONSTRAINT `DiffractionPlan_ibfk1` FOREIGN KEY (`presetForProposalId`) REFERENCES `Proposal` (`proposalId`),
  CONSTRAINT `DiffractionPlan_ibfk2` FOREIGN KEY (`purificationColumnId`) REFERENCES `PurificationColumn` (`purificationColumnId`),
  CONSTRAINT `DiffractionPlan_ibfk3` FOREIGN KEY (`experimentTypeId`) REFERENCES `ExperimentType` (`experimentTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=202968 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DiffractionPlan`
--

LOCK TABLES `DiffractionPlan` WRITE;
/*!40000 ALTER TABLE `DiffractionPlan` DISABLE KEYS */;
INSERT INTO `DiffractionPlan` VALUES
(197784,NULL,'OSC',NULL,NULL,0.2,NULL,NULL,NULL,NULL,NULL,10.5,10.5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,0,NULL,NULL,NULL,1.1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-03-20 23:50:27',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(197788,NULL,NULL,NULL,NULL,10,NULL,NULL,NULL,NULL,NULL,160,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2016-10-26 15:28:12',NULL,150,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,162.5,45,330.6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(197792,'XPDF-1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2017-03-22 10:56:32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `DiffractionPlan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EnergyScan`
--

DROP TABLE IF EXISTS `EnergyScan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EnergyScan` (
  `energyScanId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sessionId` int(10) unsigned NOT NULL,
  `blSampleId` int(10) unsigned DEFAULT NULL,
  `fluorescenceDetector` varchar(255) DEFAULT NULL,
  `scanFileFullPath` varchar(255) DEFAULT NULL,
  `jpegChoochFileFullPath` varchar(255) DEFAULT NULL,
  `element` varchar(45) DEFAULT NULL,
  `startEnergy` float DEFAULT NULL,
  `endEnergy` float DEFAULT NULL,
  `transmissionFactor` float DEFAULT NULL,
  `exposureTime` float DEFAULT NULL,
  `axisPosition` float DEFAULT NULL,
  `synchrotronCurrent` float DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `peakEnergy` float DEFAULT NULL,
  `peakFPrime` float DEFAULT NULL,
  `peakFDoublePrime` float DEFAULT NULL,
  `inflectionEnergy` float DEFAULT NULL,
  `inflectionFPrime` float DEFAULT NULL,
  `inflectionFDoublePrime` float DEFAULT NULL,
  `xrayDose` float DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `edgeEnergy` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `beamSizeVertical` float DEFAULT NULL,
  `beamSizeHorizontal` float DEFAULT NULL,
  `choochFileFullPath` varchar(255) DEFAULT NULL,
  `crystalClass` varchar(20) DEFAULT NULL,
  `comments` varchar(1024) DEFAULT NULL,
  `flux` double DEFAULT NULL COMMENT 'flux measured before the energyScan',
  `flux_end` double DEFAULT NULL COMMENT 'flux measured after the energyScan',
  `workingDirectory` varchar(45) DEFAULT NULL,
  `blSubSampleId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`energyScanId`),
  KEY `EnergyScan_FKIndex2` (`sessionId`),
  KEY `ES_ibfk_2` (`blSampleId`),
  KEY `ES_ibfk_3` (`blSubSampleId`),
  CONSTRAINT `ES_ibfk_1` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ES_ibfk_2` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`),
  CONSTRAINT `ES_ibfk_3` FOREIGN KEY (`blSubSampleId`) REFERENCES `BLSubSample` (`blSubSampleId`)
) ENGINE=InnoDB AUTO_INCREMENT=50291 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EnergyScan`
--

LOCK TABLES `EnergyScan` WRITE;
/*!40000 ALTER TABLE `EnergyScan` DISABLE KEYS */;
INSERT INTO `EnergyScan` VALUES
(49661,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/fe1.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/fe1_chooch.png','Fe',7062.75,7170.88,0.016,1,NULL,298.569,100,7115.73,-4.79,4.66,7095.13,-7.26,1.66,0,'2016-01-12 14:51:20','2016-01-12 14:58:33','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49662,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/fe1.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/fe1_chooch.png','Fe',7062.75,7170.88,0.256,1,NULL,299.986,100,7131.44,-6.26,5.1,7122.6,-8.69,2.52,0,'2016-01-12 15:00:34','2016-01-12 15:05:28','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49668,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn1.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn1_chooch.png','Zn',9626.73,9692.41,0.256,1,NULL,301.465,100,9673.5,-8.73,3.05,9672.94,-9.04,0.48,0,'2016-01-13 15:55:39','2016-01-13 16:02:15','K',NULL,20,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49669,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn1.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn1_chooch.png','Zn',9626.73,9692.41,0.256,1,NULL,299.054,100,9674.62,-7.78,3.36,9674.62,-7.78,3.36,0,'2016-01-13 16:02:39','2016-01-13 16:07:38','K',NULL,20,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49671,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn1.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn1_chooch.png','Zn',9626.73,9692.41,0.004,1,NULL,301.497,100,9663.49,-10.11,8.51,9660.14,-13.87,3.89,0,'2016-01-13 16:16:35','2016-01-13 16:22:27','K',NULL,20,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49673,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn2.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn2_chooch.png','Zn',9626.73,9692.41,0.064,1,NULL,298.34,100,9685.13,-6.16,3.78,9671.27,-7.05,2.64,0,'2016-01-13 16:24:38','2016-01-13 16:29:33','K',NULL,20,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49674,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn3.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn3_chooch.png','Zn',9626.73,9692.41,0.064,1,NULL,299.716,100,9643.43,-7.52,4.09,9636.73,-8.25,1.59,0,'2016-01-13 16:30:48','2016-01-13 16:35:37','K',NULL,20,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49675,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn_1730_13th.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn_1730_13th_chooch.png','Zn',9626.73,9692.41,0.002,1,NULL,298.912,100,9667.37,-6.92,6.36,9660.69,-11.35,3.51,0,'2016-01-13 17:31:04','2016-01-13 17:37:43','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49676,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn_1738_13th.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn_1738_13th_chooch.png','Zn',9626.73,9692.41,0.006,1,NULL,300.82,100,9664.04,-8.7,6.42,9660.69,-11.37,3.59,0,'2016-01-13 17:39:01','2016-01-13 17:43:37','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49677,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/cu1.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/cu1_chooch.png','Cu',8942.19,9019.21,0.032,1,NULL,298.45,100,8991.12,-6.37,4.03,8977.04,-8.12,1.82,0,'2016-01-13 19:51:26','2016-01-13 19:58:15','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49678,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/se1.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/se1_chooch.png','Se',12628,12688,0.004,1,NULL,298.837,100,12653,-8.84,8.25,12651,-12.16,4.46,0,'2016-01-13 20:20:25','2016-01-13 20:27:01','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49679,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/se2.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/se2_chooch.png','Se',12628,12688,0.002,1,NULL,300.543,100,12664,-7.91,9.44,12662.5,-11.35,5.87,0,'2016-01-14 09:48:06','2016-01-14 09:53:34','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49680,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/se3.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/se3_chooch.png','Se',12628,12688,0.002,1,NULL,299.851,100,12658.5,-7.03,11.31,12656.5,-12.74,6.37,0,'2016-01-14 10:00:43','2016-01-14 10:05:39','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49681,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/se4.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/se4_chooch.png','Se',12628,12688,0.002,1,NULL,299.856,100,12660,-7.58,11.19,12658,-12.64,5.98,0,'2016-01-14 10:09:58','2016-01-14 10:14:56','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(49682,55167,374695,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/zn_1401_1125.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/zn_1401_1125_chooch.png','Zn',9626.73,9692.41,0.004,1,NULL,301.75,100,9666.82,-7.77,6.51,9661.25,-11.11,3.49,0,'2016-01-14 11:24:43','2016-01-14 11:31:22','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50165,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/20160224/testZn.fluo','/dls/i03/data/2016/cm14451-1/20160224/fluorescence_scans/testZn_chooch.png','Zn',9626.73,9692.41,0.004,1,NULL,300.402,100,9668.43,-6.85,5.95,9658.43,-9.83,1.07,0,'2016-02-24 14:42:38','2016-02-24 14:44:02','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50166,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/testZn.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/testZn_chooch.png','Zn',9626.73,9692.41,0.004,1,NULL,298.566,100,9668.43,-6.9,5.96,9658.43,-9.91,1.13,0,'2016-02-24 14:46:33','2016-02-24 14:48:20','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50167,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/20160224b/testZn.fluo','/dls/i03/data/2016/cm14451-1/20160224b/fluorescence_scans/testZn_chooch.png','Zn',9626.73,9692.41,0.004,1,NULL,298.913,100,9663.43,-9.53,6.11,9658.43,-10,1.09,0,'2016-02-24 14:55:42','2016-02-24 14:57:34','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50168,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/20160224c/testZn.fluo','/dls/i03/data/2016/cm14451-1/20160224c/fluorescence_scans/testZn_chooch.png','Zn',9626.73,9692.41,0.004,1,NULL,299.834,100,9663.44,-9.95,7.45,9658.43,-10.89,1.32,0,'2016-02-24 15:03:55','2016-02-24 15:05:33','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50169,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/20160224d/testZn.fluo','/dls/i03/data/2016/cm14451-1/20160224d/fluorescence_scans/testZn_chooch.png','Zn',9626.73,9692.41,0.004,1,NULL,298.071,100,9663.43,-9.56,6.37,9658.44,-10.1,1.15,0,'2016-02-24 15:07:49','2016-02-24 15:09:42','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50261,55167,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-1/se_sb.fluo','/dls/i03/data/2016/cm14451-1/fluorescence_scans/se_sb_chooch.png','Se',12628,12688,0.5,1,NULL,9.67282,100,12660.5,-7.64,10.63,12659,-11.08,7.15,0,'2016-03-09 10:48:58','2016-03-09 10:54:35','K',NULL,20,80,NULL,NULL,'null _FLAG_',NULL,NULL,NULL,NULL),
(50263,55168,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-2/se_test1.fluo',NULL,NULL,12628,12688,1,1,NULL,-0.000965,100,NULL,NULL,NULL,NULL,NULL,NULL,0,'2016-03-30 14:36:51','2016-03-30 14:42:06',NULL,NULL,20,80,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50266,55168,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-2/test_1.fluo',NULL,NULL,12628,12688,0.2,1,NULL,0.000111,100,NULL,NULL,NULL,NULL,NULL,NULL,0,'2016-03-31 10:14:15','2016-03-31 10:19:01',NULL,NULL,20,80,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50269,55168,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-2/se1.fluo','/dls/i03/data/2016/cm14451-2/fluorescence_scans/se1_chooch.png','Se',12628,12688,0.128,1,NULL,198.223,100,12660.5,-7.26,9.79,12656,-10.42,4.21,0,'2016-04-05 16:43:16','2016-04-05 16:49:58','K',NULL,20,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50284,55168,NULL,'Vortex1_MCAScaler','/dls/i03/data/2016/cm14451-2/zn.fluo','/dls/i03/data/2016/cm14451-2/fluorescence_scans/zn_chooch.png','Zn',9626.73,9692.41,0.016,1,NULL,301.691,100,9666.82,-7.09,9.24,9661.81,-12.08,3.36,0,'2016-04-06 16:36:18','2016-04-06 16:42:43','K',NULL,20,50,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50287,55168,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(50290,55168,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `EnergyScan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Event`
--

DROP TABLE IF EXISTS `Event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Event` (
  `eventId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `eventChainId` int(11) unsigned NOT NULL,
  `componentId` int(11) unsigned DEFAULT NULL,
  `eventTypeId` int(11) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `offset` float NOT NULL COMMENT 'Start of the event relative to data collection start time in seconds.',
  `duration` float DEFAULT NULL COMMENT 'Duration of the event if applicable.',
  `period` float DEFAULT NULL COMMENT 'Repetition period if applicable in seconds.',
  `repetition` float DEFAULT NULL COMMENT 'Number of repetitions if applicable.',
  PRIMARY KEY (`eventId`),
  KEY `eventChainId` (`eventChainId`),
  KEY `componentId` (`componentId`),
  KEY `eventTypeId` (`eventTypeId`),
  CONSTRAINT `Event_ibfk_1` FOREIGN KEY (`eventChainId`) REFERENCES `EventChain` (`eventChainId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Event_ibfk_2` FOREIGN KEY (`componentId`) REFERENCES `Component` (`componentId`),
  CONSTRAINT `Event_ibfk_3` FOREIGN KEY (`eventTypeId`) REFERENCES `EventType` (`eventTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Describes an event that occurred during a data collection and should be taken into account for data analysis. Can optionally be repeated at a specified frequency.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Event`
--

LOCK TABLES `Event` WRITE;
/*!40000 ALTER TABLE `Event` DISABLE KEYS */;
/*!40000 ALTER TABLE `Event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EventChain`
--

DROP TABLE IF EXISTS `EventChain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventChain` (
  `eventChainId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`eventChainId`),
  KEY `dataCollectionId` (`dataCollectionId`),
  CONSTRAINT `EventChain_ibfk_1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Groups events together in a data collection.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EventChain`
--

LOCK TABLES `EventChain` WRITE;
/*!40000 ALTER TABLE `EventChain` DISABLE KEYS */;
/*!40000 ALTER TABLE `EventChain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EventType`
--

DROP TABLE IF EXISTS `EventType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventType` (
  `eventTypeId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`eventTypeId`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Defines the list of event types which can occur during a data collection.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EventType`
--

LOCK TABLES `EventType` WRITE;
/*!40000 ALTER TABLE `EventType` DISABLE KEYS */;
INSERT INTO `EventType` VALUES
(3,'LaserExcitation'),
(4,'ReactionTrigger'),
(1,'XrayDetection'),
(2,'XrayExposure');
/*!40000 ALTER TABLE `EventType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExperimentKindDetails`
--

DROP TABLE IF EXISTS `ExperimentKindDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ExperimentKindDetails` (
  `experimentKindId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `diffractionPlanId` int(10) unsigned NOT NULL,
  `exposureIndex` int(10) unsigned DEFAULT NULL,
  `dataCollectionType` varchar(45) DEFAULT NULL,
  `dataCollectionKind` varchar(45) DEFAULT NULL,
  `wedgeValue` float DEFAULT NULL,
  PRIMARY KEY (`experimentKindId`),
  KEY `ExperimentKindDetails_FKIndex1` (`diffractionPlanId`),
  CONSTRAINT `EKD_ibfk_1` FOREIGN KEY (`diffractionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExperimentKindDetails`
--

LOCK TABLES `ExperimentKindDetails` WRITE;
/*!40000 ALTER TABLE `ExperimentKindDetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `ExperimentKindDetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExperimentType`
--

DROP TABLE IF EXISTS `ExperimentType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ExperimentType` (
  `experimentTypeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `proposalType` varchar(10) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1 COMMENT '1=active, 0=inactive',
  PRIMARY KEY (`experimentTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='A lookup table for different types of experients';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExperimentType`
--

LOCK TABLES `ExperimentType` WRITE;
/*!40000 ALTER TABLE `ExperimentType` DISABLE KEYS */;
INSERT INTO `ExperimentType` VALUES
(1,'Default',NULL,1),
(2,'MXPressE','mx',1),
(3,'MXPressO','mx',1),
(4,'MXPressE_SAD','mx',1),
(5,'MXScore','mx',1),
(6,'MXPressM','mx',1),
(7,'MAD','mx',1),
(8,'SAD','mx',1),
(9,'Fixed','mx',1),
(10,'Ligand binding','mx',1),
(11,'Refinement','mx',1),
(12,'OSC','mx',1),
(13,'MAD - Inverse Beam','mx',1),
(14,'SAD - Inverse Beam','mx',1),
(15,'MESH','mx',1),
(16,'XFE','mx',1),
(17,'Stepped transmission','mx',1),
(18,'XChem High Symmetry','mx',1),
(19,'XChem Low Symmetry','mx',1),
(20,'Commissioning','mx',1),
(21,'HPLC','saxs',1),
(22,'Robot','saxs',1),
(23,'Rack','saxs',1),
(24,'Grid','saxs',1),
(25,'Solids','saxs',1),
(26,'Powder','saxs',1),
(27,'Peltier','saxs',1),
(28,'Spectroscopy','saxs',1),
(29,'CD Spectroscopy','saxs',1),
(30,'Microscopy','saxs',1),
(31,'Imaging','saxs',1),
(32,'CD Thermal Melt','saxs',1),
(33,'Fixed Energy At Ambient With Robot','saxs',1),
(34,'Mesh3D','mx',1),
(35,'Screening','sm',1),
(36,'Tomography','em',1),
(37,'Single Particle','em',1);
/*!40000 ALTER TABLE `ExperimentType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FoilHole`
--

DROP TABLE IF EXISTS `FoilHole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `FoilHole` (
  `foilHoleId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gridSquareId` int(11) unsigned NOT NULL,
  `foilHoleLabel` varchar(30) NOT NULL COMMENT 'foil hole reference name from acquisition software',
  `foilHoleImage` varchar(255) DEFAULT NULL COMMENT 'path to foil hole image, nullable as there is not always a foil hole image',
  `pixelLocationX` int(11) DEFAULT NULL COMMENT 'pixel location of foil hole centre on grid square image (x)',
  `pixelLocationY` int(11) DEFAULT NULL COMMENT 'pixel location of foil hole centre on grid square image (y)',
  `diameter` int(11) DEFAULT NULL COMMENT 'foil hole diameter on grid square image in pixels',
  `stageLocationX` float DEFAULT NULL COMMENT 'x stage position (microns)',
  `stageLocationY` float DEFAULT NULL COMMENT 'y stage position (microns)',
  `qualityIndicator` float DEFAULT NULL COMMENT 'metric for determining quality of foil hole',
  `pixelSize` float DEFAULT NULL COMMENT 'pixel size of foil hole image',
  PRIMARY KEY (`foilHoleId`),
  KEY `FoilHole_fk_gridSquareId` (`gridSquareId`),
  CONSTRAINT `FoilHole_fk_gridSquareId` FOREIGN KEY (`gridSquareId`) REFERENCES `GridSquare` (`gridSquareId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Details of a Cryo-EM foil hole within a grid square including image captured at foil hole magnification if applicable';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FoilHole`
--

LOCK TABLES `FoilHole` WRITE;
/*!40000 ALTER TABLE `FoilHole` DISABLE KEYS */;
INSERT INTO `FoilHole` VALUES
(1,1,'1','/dls/foil.png',1,1,1,1,1,1,1);
/*!40000 ALTER TABLE `FoilHole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GeometryClassname`
--

DROP TABLE IF EXISTS `GeometryClassname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `GeometryClassname` (
  `geometryClassnameId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `geometryClassname` varchar(45) DEFAULT NULL,
  `geometryOrder` int(2) NOT NULL,
  PRIMARY KEY (`geometryClassnameId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GeometryClassname`
--

LOCK TABLES `GeometryClassname` WRITE;
/*!40000 ALTER TABLE `GeometryClassname` DISABLE KEYS */;
/*!40000 ALTER TABLE `GeometryClassname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GridImageMap`
--

DROP TABLE IF EXISTS `GridImageMap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `GridImageMap` (
  `gridImageMapId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned DEFAULT NULL,
  `imageNumber` int(11) unsigned DEFAULT NULL COMMENT 'Movie number, sequential 1-n in time order',
  `outputFileId` varchar(80) DEFAULT NULL COMMENT 'File number, file 1 may not be movie 1',
  `positionX` float DEFAULT NULL COMMENT 'X position of stage, Units: um',
  `positionY` float DEFAULT NULL COMMENT 'Y position of stage, Units: um',
  PRIMARY KEY (`gridImageMapId`),
  KEY `_GridImageMap_ibfk1` (`dataCollectionId`),
  CONSTRAINT `_GridImageMap_ibfk1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GridImageMap`
--

LOCK TABLES `GridImageMap` WRITE;
/*!40000 ALTER TABLE `GridImageMap` DISABLE KEYS */;
/*!40000 ALTER TABLE `GridImageMap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GridInfo`
--

DROP TABLE IF EXISTS `GridInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `GridInfo` (
  `gridInfoId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `xOffset` double DEFAULT NULL,
  `yOffset` double DEFAULT NULL,
  `dx_mm` double DEFAULT NULL,
  `dy_mm` double DEFAULT NULL,
  `steps_x` double DEFAULT NULL,
  `steps_y` double DEFAULT NULL,
  `meshAngle` double DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `workflowMeshId` int(11) unsigned DEFAULT NULL,
  `orientation` enum('vertical','horizontal') DEFAULT 'horizontal',
  `dataCollectionGroupId` int(11) DEFAULT NULL,
  `pixelsPerMicronX` float DEFAULT NULL,
  `pixelsPerMicronY` float DEFAULT NULL,
  `snapshot_offsetXPixel` float DEFAULT NULL,
  `snapshot_offsetYPixel` float DEFAULT NULL,
  `snaked` tinyint(1) DEFAULT 0 COMMENT 'True: The images associated with the DCG were collected in a snaked pattern',
  `dataCollectionId` int(11) unsigned DEFAULT NULL,
  `patchesX` int(10) DEFAULT 1 COMMENT 'Number of patches the grid is made up of in the X direction',
  `patchesY` int(10) DEFAULT 1 COMMENT 'Number of patches the grid is made up of in the Y direction',
  `micronsPerPixelX` float DEFAULT NULL,
  `micronsPerPixelY` float DEFAULT NULL,
  PRIMARY KEY (`gridInfoId`),
  KEY `workflowMeshId` (`workflowMeshId`),
  KEY `GridInfo_ibfk_2` (`dataCollectionGroupId`),
  KEY `GridInfo_fk_dataCollectionId` (`dataCollectionId`),
  CONSTRAINT `GridInfo_fk_dataCollectionId` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `GridInfo_ibfk_2` FOREIGN KEY (`dataCollectionGroupId`) REFERENCES `DataCollectionGroup` (`dataCollectionGroupId`)
) ENGINE=InnoDB AUTO_INCREMENT=1281657 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GridInfo`
--

LOCK TABLES `GridInfo` WRITE;
/*!40000 ALTER TABLE `GridInfo` DISABLE KEYS */;
INSERT INTO `GridInfo` VALUES
(1281212,NULL,NULL,0.02,0.02,30,16,NULL,'2021-02-25 10:15:06',NULL,'horizontal',5440739,0.83,0.83,304,229.75,1,6017405,1,1,NULL,NULL);
/*!40000 ALTER TABLE `GridInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GridSquare`
--

DROP TABLE IF EXISTS `GridSquare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `GridSquare` (
  `gridSquareId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `atlasId` int(11) unsigned NOT NULL,
  `gridSquareLabel` int(11) DEFAULT NULL COMMENT 'grid square reference from acquisition software',
  `gridSquareImage` varchar(255) DEFAULT NULL COMMENT 'path to grid square image',
  `pixelLocationX` int(11) DEFAULT NULL COMMENT 'pixel location of grid square centre on atlas image (x)',
  `pixelLocationY` int(11) DEFAULT NULL COMMENT 'pixel location of grid square centre on atlas image (y)',
  `height` int(11) DEFAULT NULL COMMENT 'grid square height on atlas image in pixels',
  `width` int(11) DEFAULT NULL COMMENT 'grid square width on atlas image in pixels',
  `angle` float DEFAULT NULL COMMENT 'angle of grid square relative to atlas image',
  `stageLocationX` float DEFAULT NULL COMMENT 'x stage position (microns)',
  `stageLocationY` float DEFAULT NULL COMMENT 'y stage position (microns)',
  `qualityIndicator` float DEFAULT NULL COMMENT 'metric for determining quality of grid square',
  `pixelSize` float DEFAULT NULL COMMENT 'pixel size of grid square image',
  PRIMARY KEY (`gridSquareId`),
  KEY `GridSquare_fk_atlasId` (`atlasId`),
  CONSTRAINT `GridSquare_fk_atlasId` FOREIGN KEY (`atlasId`) REFERENCES `Atlas` (`atlasId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Details of a Cryo-EM grid square including image captured at grid square magnification';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GridSquare`
--

LOCK TABLES `GridSquare` WRITE;
/*!40000 ALTER TABLE `GridSquare` DISABLE KEYS */;
INSERT INTO `GridSquare` VALUES
(1,1,1,'/dls/test.png',1,1,1,1,1,1,1,1,1),
(2,1,2,NULL,2,2,1,1,1,2,2,1,1);
/*!40000 ALTER TABLE `GridSquare` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Image`
--

DROP TABLE IF EXISTS `Image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Image` (
  `imageId` int(12) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned NOT NULL DEFAULT 0,
  `imageNumber` int(10) unsigned DEFAULT NULL,
  `fileName` varchar(255) DEFAULT NULL,
  `fileLocation` varchar(255) DEFAULT NULL,
  `measuredIntensity` float DEFAULT NULL,
  `jpegFileFullPath` varchar(255) DEFAULT NULL,
  `jpegThumbnailFileFullPath` varchar(255) DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `cumulativeIntensity` float DEFAULT NULL,
  `synchrotronCurrent` float DEFAULT NULL,
  `comments` varchar(1024) DEFAULT NULL,
  `machineMessage` varchar(1024) DEFAULT NULL,
  `BLTIMESTAMP` timestamp NOT NULL DEFAULT current_timestamp(),
  `motorPositionId` int(11) unsigned DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`imageId`),
  KEY `Image_FKIndex1` (`dataCollectionId`),
  KEY `Image_FKIndex2` (`imageNumber`),
  KEY `Image_Index3` (`fileLocation`,`fileName`),
  KEY `motorPositionId` (`motorPositionId`),
  CONSTRAINT `Image_ibfk_1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Image_ibfk_2` FOREIGN KEY (`motorPositionId`) REFERENCES `MotorPosition` (`motorPositionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=284718121 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Image`
--

LOCK TABLES `Image` WRITE;
/*!40000 ALTER TABLE `Image` DISABLE KEYS */;
INSERT INTO `Image` VALUES
(274837165,1052494,1,'xtal1_1_0001.cbf','/dls/i03/data/2016/cm14451-2/20160413/test_xtal',0,'/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_1_0001.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_1_0001.thumb.jpeg',294,0,298.847,NULL,NULL,'2016-04-13 11:18:39',NULL,'2016-04-13 11:18:39'),
(274837168,1052494,2,'xtal1_1_0002.cbf','/dls/i03/data/2016/cm14451-2/20160413/test_xtal',0,'/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_1_0002.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_1_0002.thumb.jpeg',294,0,298.74,NULL,NULL,'2016-04-13 11:18:50',NULL,'2016-04-13 11:18:50'),
(274837177,1052503,1,'xtal1_3_0001.cbf','/dls/i03/data/2016/cm14451-2/20160413/test_xtal',0,'/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_0001.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_0001.thumb.jpeg',294,0,302.004,NULL,NULL,'2016-04-13 11:21:36',NULL,'2016-04-13 11:21:36'),
(274837180,1052503,2,'xtal1_3_0002.cbf','/dls/i03/data/2016/cm14451-2/20160413/test_xtal',0,'/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_0002.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_0002.thumb.jpeg',294,0,301.922,NULL,NULL,'2016-04-13 11:21:45',NULL,'2016-04-13 11:21:45'),
(274837183,1052503,3,'xtal1_3_0003.cbf','/dls/i03/data/2016/cm14451-2/20160413/test_xtal',0,'/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_0003.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/20160413/test_xtal/xtal1_3_0003.thumb.jpeg',294,0,301.842,NULL,NULL,'2016-04-13 11:21:54',NULL,'2016-04-13 11:21:54'),
(284717989,1066786,1,'thau_2_0001.cbf','/dls/i03/data/2016/cm14451-2/gw/20160418/thau/edna_test',0,'/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_0001.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_0001.thumb.jpeg',294,0,299.987,NULL,NULL,'2016-04-14 02:19:04',NULL,'2016-04-14 02:19:04'),
(284718055,1066786,2,'thau_2_0002.cbf','/dls/i03/data/2016/cm14451-2/gw/20160418/thau/edna_test',0,'/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_0002.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_0002.thumb.jpeg',294,0,299.933,NULL,NULL,'2016-04-14 02:19:04',NULL,'2016-04-14 02:19:04'),
(284718118,1066786,3,'thau_2_0003.cbf','/dls/i03/data/2016/cm14451-2/gw/20160418/thau/edna_test',0,'/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_0003.jpeg','/dls/i03/data/2016/cm14451-2/jpegs/gw/20160418/thau/edna_test/thau_2_0003.thumb.jpeg',294,0,299.908,NULL,NULL,'2016-04-14 02:19:04',NULL,'2016-04-14 02:19:04'),
(284718120,6017412,1,NULL,NULL,NULL,'/mnt/test.png','/mnt/test.png',NULL,NULL,NULL,NULL,NULL,'2022-12-20 13:58:16',NULL,'2022-12-20 13:58:16');
/*!40000 ALTER TABLE `Image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ImageQualityIndicators`
--

DROP TABLE IF EXISTS `ImageQualityIndicators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ImageQualityIndicators` (
  `dataCollectionId` int(11) unsigned NOT NULL,
  `imageNumber` mediumint(8) unsigned NOT NULL,
  `imageId` int(12) DEFAULT NULL,
  `autoProcProgramId` int(10) unsigned DEFAULT NULL COMMENT 'Foreign key to the AutoProcProgram table',
  `spotTotal` int(10) DEFAULT NULL COMMENT 'Total number of spots',
  `inResTotal` int(10) DEFAULT NULL COMMENT 'Total number of spots in resolution range',
  `goodBraggCandidates` int(10) DEFAULT NULL COMMENT 'Total number of Bragg diffraction spots',
  `iceRings` int(10) DEFAULT NULL COMMENT 'Number of ice rings identified',
  `method1Res` float DEFAULT NULL COMMENT 'Resolution estimate 1 (see publication)',
  `method2Res` float DEFAULT NULL COMMENT 'Resolution estimate 2 (see publication)',
  `maxUnitCell` float DEFAULT NULL COMMENT 'Estimation of the largest possible unit cell edge',
  `pctSaturationTop50Peaks` float DEFAULT NULL COMMENT 'The fraction of the dynamic range being used',
  `inResolutionOvrlSpots` int(10) DEFAULT NULL COMMENT 'Number of spots overloaded',
  `binPopCutOffMethod2Res` float DEFAULT NULL COMMENT 'Cut off used in resolution limit calculation',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  `totalIntegratedSignal` double DEFAULT NULL,
  `dozor_score` double DEFAULT NULL COMMENT 'dozor_score',
  `driftFactor` float DEFAULT NULL COMMENT 'EM movie drift factor',
  PRIMARY KEY (`dataCollectionId`,`imageNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ImageQualityIndicators`
--

LOCK TABLES `ImageQualityIndicators` WRITE;
/*!40000 ALTER TABLE `ImageQualityIndicators` DISABLE KEYS */;
INSERT INTO `ImageQualityIndicators` VALUES
(1052494,1,NULL,NULL,296,296,259,0,2.03,2.03,0,0,0,0,NULL,2.61,NULL,NULL),
(1052494,2,NULL,NULL,239,239,224,0,2.12,2.12,0,0,0,0,NULL,2.95,NULL,NULL),
(1052503,1,274837177,NULL,217,217,202,0,2.07,2.07,0,0,0,0,NULL,2.99,NULL,NULL),
(1052503,2,NULL,NULL,257,257,236,0,2.06,2.06,0,0,0,0,NULL,3.02,NULL,NULL),
(1052503,3,NULL,NULL,306,306,278,0,2.04,2.04,0,0,0,0,NULL,2.75,NULL,NULL),
(1066786,1,284717989,NULL,1132,1132,872,0,1.63,1.63,0,0,0,0,NULL,2.09,NULL,NULL),
(1066786,2,284718055,NULL,848,848,652,0,1.56,1.56,0,0,0,0,NULL,2.03,NULL,NULL),
(1066786,3,284718118,NULL,922,922,735,0,1.57,1.57,0,0,0,0,NULL,2.13,NULL,NULL);
/*!40000 ALTER TABLE `ImageQualityIndicators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Imager`
--

DROP TABLE IF EXISTS `Imager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Imager` (
  `imagerId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `temperature` float DEFAULT NULL,
  `serial` varchar(45) DEFAULT NULL,
  `capacity` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`imagerId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Imager`
--

LOCK TABLES `Imager` WRITE;
/*!40000 ALTER TABLE `Imager` DISABLE KEYS */;
INSERT INTO `Imager` VALUES
(2,'Imager1 20c',20,'Z125434',1000),
(7,'VMXi sim',20,'RI1000-0000',750);
/*!40000 ALTER TABLE `Imager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `InspectionType`
--

DROP TABLE IF EXISTS `InspectionType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `InspectionType` (
  `inspectionTypeId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`inspectionTypeId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InspectionType`
--

LOCK TABLES `InspectionType` WRITE;
/*!40000 ALTER TABLE `InspectionType` DISABLE KEYS */;
INSERT INTO `InspectionType` VALUES
(1,'Visible'),
(2,'UV');
/*!40000 ALTER TABLE `InspectionType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IspybCrystalClass`
--

DROP TABLE IF EXISTS `IspybCrystalClass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `IspybCrystalClass` (
  `crystalClassId` int(11) NOT NULL AUTO_INCREMENT,
  `crystalClass_code` varchar(20) NOT NULL,
  `crystalClass_name` varchar(255) NOT NULL,
  PRIMARY KEY (`crystalClassId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='ISPyB crystal class values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IspybCrystalClass`
--

LOCK TABLES `IspybCrystalClass` WRITE;
/*!40000 ALTER TABLE `IspybCrystalClass` DISABLE KEYS */;
/*!40000 ALTER TABLE `IspybCrystalClass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IspybReference`
--

DROP TABLE IF EXISTS `IspybReference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `IspybReference` (
  `referenceId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `referenceName` varchar(255) DEFAULT NULL COMMENT 'reference name',
  `referenceUrl` varchar(1024) DEFAULT NULL COMMENT 'url of the reference',
  `referenceBibtext` blob DEFAULT NULL COMMENT 'bibtext value of the reference',
  `beamline` enum('All','ID14-4','ID23-1','ID23-2','ID29','XRF','AllXRF','Mesh') DEFAULT NULL COMMENT 'beamline involved',
  PRIMARY KEY (`referenceId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IspybReference`
--

LOCK TABLES `IspybReference` WRITE;
/*!40000 ALTER TABLE `IspybReference` DISABLE KEYS */;
/*!40000 ALTER TABLE `IspybReference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LDAPSearchBase`
--

DROP TABLE IF EXISTS `LDAPSearchBase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `LDAPSearchBase` (
  `ldapSearchBaseId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ldapSearchParametersId` int(11) unsigned NOT NULL COMMENT 'The other LDAP search parameters to be used with this search base',
  `searchBase` varchar(200) NOT NULL COMMENT 'Name of the object we search for',
  `sequenceNumber` tinyint(3) unsigned NOT NULL COMMENT 'The number in the sequence of searches where this search base should be attempted',
  PRIMARY KEY (`ldapSearchBaseId`),
  KEY `LDAPSearchBase_fk_ldapSearchParametersId` (`ldapSearchParametersId`),
  CONSTRAINT `LDAPSearchBase_fk_ldapSearchParametersId` FOREIGN KEY (`ldapSearchParametersId`) REFERENCES `LDAPSearchParameters` (`ldapSearchParametersId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='LDAP search base and the sequence number in which it should be attempted';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LDAPSearchBase`
--

LOCK TABLES `LDAPSearchBase` WRITE;
/*!40000 ALTER TABLE `LDAPSearchBase` DISABLE KEYS */;
INSERT INTO `LDAPSearchBase` VALUES
(1,1,'foo',1),
(2,2,'bar',1);
/*!40000 ALTER TABLE `LDAPSearchBase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LDAPSearchParameters`
--

DROP TABLE IF EXISTS `LDAPSearchParameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `LDAPSearchParameters` (
  `ldapSearchParametersId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `accountType` enum('group_member','staff_account','functional_account') NOT NULL COMMENT 'The entity type returned by the search',
  `accountTypeGroupName` varchar(100) DEFAULT NULL COMMENT 'all accounts of this type must be members of this group',
  `oneOrMany` enum('one','many') NOT NULL COMMENT 'Expected number of search results',
  `hostURL` varchar(200) NOT NULL COMMENT 'URL for the LDAP host',
  `filter` varchar(200) DEFAULT NULL COMMENT 'A filter string for the search',
  `attributes` varchar(255) NOT NULL COMMENT 'Comma-separated list of search attributes',
  PRIMARY KEY (`ldapSearchParametersId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='All necessary parameters to run an LDAP search, except the search base';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LDAPSearchParameters`
--

LOCK TABLES `LDAPSearchParameters` WRITE;
/*!40000 ALTER TABLE `LDAPSearchParameters` DISABLE KEYS */;
INSERT INTO `LDAPSearchParameters` VALUES
(1,'group_member','name','one','http://foo.ac.uk','(some=filter)','test'),
(2,'group_member','name','one','http://bar.ac.uk','(some=filter)','test');
/*!40000 ALTER TABLE `LDAPSearchParameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LabContact`
--

DROP TABLE IF EXISTS `LabContact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `LabContact` (
  `labContactId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `personId` int(10) unsigned NOT NULL,
  `cardName` varchar(40) NOT NULL,
  `proposalId` int(10) unsigned NOT NULL,
  `defaultCourrierCompany` varchar(45) DEFAULT NULL,
  `courierAccount` varchar(45) DEFAULT NULL,
  `billingReference` varchar(45) DEFAULT NULL,
  `dewarAvgCustomsValue` int(10) unsigned NOT NULL DEFAULT 0,
  `dewarAvgTransportValue` int(10) unsigned NOT NULL DEFAULT 0,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`labContactId`),
  UNIQUE KEY `cardNameAndProposal` (`cardName`,`proposalId`),
  UNIQUE KEY `personAndProposal` (`personId`,`proposalId`),
  KEY `LabContact_FKIndex1` (`proposalId`),
  CONSTRAINT `LabContact_ibfk_1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `LabContact_ibfk_2` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LabContact`
--

LOCK TABLES `LabContact` WRITE;
/*!40000 ALTER TABLE `LabContact` DISABLE KEYS */;
INSERT INTO `LabContact` VALUES
(1,18660,'Stirling Moss',141666,NULL,NULL,NULL,0,0,'2023-09-14 09:15:30');
/*!40000 ALTER TABLE `LabContact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Laboratory`
--

DROP TABLE IF EXISTS `Laboratory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Laboratory` (
  `laboratoryId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `laboratoryUUID` varchar(45) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `organization` varchar(45) DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `laboratoryPk` int(10) DEFAULT NULL,
  `postcode` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`laboratoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Laboratory`
--

LOCK TABLES `Laboratory` WRITE;
/*!40000 ALTER TABLE `Laboratory` DISABLE KEYS */;
/*!40000 ALTER TABLE `Laboratory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ligand`
--

DROP TABLE IF EXISTS `Ligand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ligand` (
  `ligandId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `proposalId` int(10) unsigned NOT NULL COMMENT 'References Proposal table',
  `name` varchar(30) NOT NULL COMMENT 'Ligand name',
  `SMILES` varchar(400) DEFAULT NULL COMMENT 'Chemical structure',
  `libraryName` varchar(30) DEFAULT NULL COMMENT 'Name of ligand library, to preserve provenance',
  `libraryBatchNumber` varchar(30) DEFAULT NULL COMMENT 'Batch number of library, to preserve provenance',
  `plateBarcode` varchar(30) DEFAULT NULL COMMENT 'Specific barcode of the plate it came from, to preserve provenance',
  `sourceWell` varchar(30) DEFAULT NULL COMMENT 'Location within that plate, to preserve provenance',
  PRIMARY KEY (`ligandId`),
  KEY `Ligand_fk_proposalId` (`proposalId`),
  CONSTRAINT `Ligand_fk_proposalId` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Ligands in biochemistry are substances that bind to biomolecules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ligand`
--

LOCK TABLES `Ligand` WRITE;
/*!40000 ALTER TABLE `Ligand` DISABLE KEYS */;
/*!40000 ALTER TABLE `Ligand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ligand_has_PDB`
--

DROP TABLE IF EXISTS `Ligand_has_PDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ligand_has_PDB` (
  `ligandId` int(11) unsigned NOT NULL,
  `pdbId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`ligandId`,`pdbId`),
  KEY `Ligand_Has_PDB_fk2` (`pdbId`),
  CONSTRAINT `Ligand_Has_PDB_fk1` FOREIGN KEY (`ligandId`) REFERENCES `Ligand` (`ligandId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Ligand_Has_PDB_fk2` FOREIGN KEY (`pdbId`) REFERENCES `PDB` (`pdbId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Junction table for Ligand and PDB';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ligand_has_PDB`
--

LOCK TABLES `Ligand_has_PDB` WRITE;
/*!40000 ALTER TABLE `Ligand_has_PDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `Ligand_has_PDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MXMRRun`
--

DROP TABLE IF EXISTS `MXMRRun`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MXMRRun` (
  `mxMRRunId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `autoProcScalingId` int(11) unsigned NOT NULL,
  `rValueStart` float DEFAULT NULL,
  `rValueEnd` float DEFAULT NULL,
  `rFreeValueStart` float DEFAULT NULL,
  `rFreeValueEnd` float DEFAULT NULL,
  `LLG` float DEFAULT NULL COMMENT 'Log Likelihood Gain',
  `TFZ` float DEFAULT NULL COMMENT 'Translation Function Z-score',
  `spaceGroup` varchar(45) DEFAULT NULL COMMENT 'Space group of the MR solution',
  `autoProcProgramId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`mxMRRunId`),
  KEY `mxMRRun_FK1` (`autoProcScalingId`),
  KEY `mxMRRun_FK2` (`autoProcProgramId`),
  CONSTRAINT `mxMRRun_FK1` FOREIGN KEY (`autoProcScalingId`) REFERENCES `AutoProcScaling` (`autoProcScalingId`),
  CONSTRAINT `mxMRRun_FK2` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`)
) ENGINE=InnoDB AUTO_INCREMENT=672901 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MXMRRun`
--

LOCK TABLES `MXMRRun` WRITE;
/*!40000 ALTER TABLE `MXMRRun` DISABLE KEYS */;
INSERT INTO `MXMRRun` VALUES
(672897,603470,0.1812,0.1682,0.1896,0.1888,NULL,NULL,NULL,56986674),
(672900,603470,NULL,NULL,NULL,NULL,NULL,NULL,NULL,56986675);
/*!40000 ALTER TABLE `MXMRRun` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MXMRRunBlob`
--

DROP TABLE IF EXISTS `MXMRRunBlob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MXMRRunBlob` (
  `mxMRRunBlobId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mxMRRunId` int(11) unsigned NOT NULL,
  `view1` varchar(255) DEFAULT NULL,
  `view2` varchar(255) DEFAULT NULL,
  `view3` varchar(255) DEFAULT NULL,
  `filePath` varchar(255) DEFAULT NULL COMMENT 'File path corresponding to the filenames in the view* columns',
  `x` float DEFAULT NULL COMMENT 'Fractional x coordinate of blob in range [-1, 1]',
  `y` float DEFAULT NULL COMMENT 'Fractional y coordinate of blob in range [-1, 1]',
  `z` float DEFAULT NULL COMMENT 'Fractional z coordinate of blob in range [-1, 1]',
  `height` float DEFAULT NULL COMMENT 'Blob height (sigmas)',
  `occupancy` float DEFAULT NULL COMMENT 'Site occupancy factor in range [0, 1]',
  `nearestAtomName` varchar(4) DEFAULT NULL COMMENT 'Name of nearest atom',
  `nearestAtomChainId` varchar(2) DEFAULT NULL COMMENT 'Chain identifier of nearest atom',
  `nearestAtomResName` varchar(4) DEFAULT NULL COMMENT 'Residue name of nearest atom',
  `nearestAtomResSeq` mediumint(8) unsigned DEFAULT NULL COMMENT 'Residue sequence number of nearest atom',
  `nearestAtomDistance` float DEFAULT NULL COMMENT 'Distance in Angstrom to nearest atom',
  `mapType` enum('anomalous','difference') DEFAULT NULL COMMENT 'Type of electron density map corresponding to this blob',
  PRIMARY KEY (`mxMRRunBlobId`),
  KEY `mxMRRunBlob_FK1` (`mxMRRunId`),
  CONSTRAINT `mxMRRunBlob_FK1` FOREIGN KEY (`mxMRRunId`) REFERENCES `MXMRRun` (`mxMRRunId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MXMRRunBlob`
--

LOCK TABLES `MXMRRunBlob` WRITE;
/*!40000 ALTER TABLE `MXMRRunBlob` DISABLE KEYS */;
/*!40000 ALTER TABLE `MXMRRunBlob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ModelBuilding`
--

DROP TABLE IF EXISTS `ModelBuilding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ModelBuilding` (
  `modelBuildingId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingAnalysisId` int(11) unsigned NOT NULL COMMENT 'Related phasing analysis item',
  `phasingProgramRunId` int(11) unsigned NOT NULL COMMENT 'Related program item',
  `spaceGroupId` int(10) unsigned DEFAULT NULL COMMENT 'Related spaceGroup',
  `lowRes` double DEFAULT NULL,
  `highRes` double DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`modelBuildingId`),
  KEY `ModelBuilding_FKIndex1` (`phasingAnalysisId`),
  KEY `ModelBuilding_FKIndex2` (`phasingProgramRunId`),
  KEY `ModelBuilding_FKIndex3` (`spaceGroupId`),
  CONSTRAINT `ModelBuilding_phasingAnalysisfk_1` FOREIGN KEY (`phasingAnalysisId`) REFERENCES `PhasingAnalysis` (`phasingAnalysisId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ModelBuilding_phasingProgramRunfk_1` FOREIGN KEY (`phasingProgramRunId`) REFERENCES `PhasingProgramRun` (`phasingProgramRunId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ModelBuilding_spaceGroupfk_1` FOREIGN KEY (`spaceGroupId`) REFERENCES `SpaceGroup` (`spaceGroupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ModelBuilding`
--

LOCK TABLES `ModelBuilding` WRITE;
/*!40000 ALTER TABLE `ModelBuilding` DISABLE KEYS */;
/*!40000 ALTER TABLE `ModelBuilding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MotionCorrection`
--

DROP TABLE IF EXISTS `MotionCorrection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MotionCorrection` (
  `motionCorrectionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned DEFAULT NULL,
  `autoProcProgramId` int(11) unsigned DEFAULT NULL,
  `imageNumber` smallint(5) unsigned DEFAULT NULL COMMENT 'Movie number, sequential in time 1-n',
  `firstFrame` smallint(5) unsigned DEFAULT NULL COMMENT 'First frame of movie used',
  `lastFrame` smallint(5) unsigned DEFAULT NULL COMMENT 'Last frame of movie used',
  `dosePerFrame` float DEFAULT NULL COMMENT 'Dose per frame, Units: e-/A^2',
  `doseWeight` float DEFAULT NULL COMMENT 'Dose weight, Units: dimensionless',
  `totalMotion` float DEFAULT NULL COMMENT 'Total motion, Units: A',
  `averageMotionPerFrame` float DEFAULT NULL COMMENT 'Average motion per frame, Units: A',
  `driftPlotFullPath` varchar(255) DEFAULT NULL COMMENT 'Full path to the drift plot',
  `micrographFullPath` varchar(255) DEFAULT NULL COMMENT 'Full path to the micrograph',
  `micrographSnapshotFullPath` varchar(255) DEFAULT NULL COMMENT 'Full path to a snapshot (jpg) of the micrograph',
  `patchesUsedX` mediumint(8) unsigned DEFAULT NULL COMMENT 'Number of patches used in x (for motioncor2)',
  `patchesUsedY` mediumint(8) unsigned DEFAULT NULL COMMENT 'Number of patches used in y (for motioncor2)',
  `fftFullPath` varchar(255) DEFAULT NULL COMMENT 'Full path to the jpg image of the raw micrograph FFT',
  `fftCorrectedFullPath` varchar(255) DEFAULT NULL COMMENT 'Full path to the jpg image of the drift corrected micrograph FFT',
  `comments` varchar(255) DEFAULT NULL,
  `movieId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`motionCorrectionId`),
  KEY `MotionCorrection_ibfk2` (`autoProcProgramId`),
  KEY `MotionCorrection_ibfk3` (`movieId`),
  KEY `_MotionCorrection_ibfk1` (`dataCollectionId`),
  CONSTRAINT `MotionCorrection_ibfk2` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`),
  CONSTRAINT `MotionCorrection_ibfk3` FOREIGN KEY (`movieId`) REFERENCES `Movie` (`movieId`),
  CONSTRAINT `_MotionCorrection_ibfk1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MotionCorrection`
--

LOCK TABLES `MotionCorrection` WRITE;
/*!40000 ALTER TABLE `MotionCorrection` DISABLE KEYS */;
INSERT INTO `MotionCorrection` VALUES
(1,6017406,NULL,1,NULL,NULL,NULL,NULL,70,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,1),
(2,6017406,NULL,2,NULL,NULL,NULL,NULL,210,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,2),
(3,6017406,NULL,3,NULL,NULL,NULL,NULL,160,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,3),
(4,6017406,NULL,4,NULL,NULL,NULL,NULL,170,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,4),
(5,6017406,NULL,5,NULL,NULL,NULL,NULL,60,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,5),
(6,6017408,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,6),
(7,6017408,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,7),
(8,6017408,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,8),
(9,6017408,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,9),
(10,6017408,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,10),
(11,6017409,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,11),
(12,6017409,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,12),
(13,6017409,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_4500_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,13),
(14,6017409,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,14),
(15,6017409,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/Position_2_11_45.00_abc.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,15),
(16,6017411,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,16),
(17,6017411,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,17),
(18,6017411,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,18),
(19,6017411,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,19),
(20,6017411,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,20),
(21,6017412,56986680,1,NULL,NULL,NULL,NULL,70,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,21),
(22,6017412,56986680,2,NULL,NULL,NULL,NULL,210,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,22),
(23,6017412,56986680,3,NULL,NULL,NULL,NULL,160,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,23),
(24,6017412,56986680,4,NULL,NULL,NULL,NULL,170,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,24),
(25,6017412,56986680,5,NULL,NULL,NULL,NULL,60,NULL,'/mnt/test_xy_shift.json',NULL,'/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,25),
(26,6017413,56986803,1,NULL,NULL,NULL,NULL,60,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/broken.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,26),
(30,6017408,56986677,1,NULL,NULL,NULL,NULL,NULL,NULL,'/mnt/test_xy_shift.json','/dls/m02/raw/broken.jpeg','/mnt/fft.png',NULL,NULL,'/mnt/fft.png',NULL,NULL,27);
/*!40000 ALTER TABLE `MotionCorrection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MotionCorrectionDrift`
--

DROP TABLE IF EXISTS `MotionCorrectionDrift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MotionCorrectionDrift` (
  `motionCorrectionDriftId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `motionCorrectionId` int(11) unsigned DEFAULT NULL,
  `frameNumber` smallint(5) unsigned DEFAULT NULL COMMENT 'Frame number of the movie these drift values relate to',
  `deltaX` float DEFAULT NULL COMMENT 'Drift in x, Units: A',
  `deltaY` float DEFAULT NULL COMMENT 'Drift in y, Units: A',
  PRIMARY KEY (`motionCorrectionDriftId`),
  KEY `MotionCorrectionDrift_ibfk1` (`motionCorrectionId`),
  CONSTRAINT `MotionCorrectionDrift_ibfk1` FOREIGN KEY (`motionCorrectionId`) REFERENCES `MotionCorrection` (`motionCorrectionId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MotionCorrectionDrift`
--

LOCK TABLES `MotionCorrectionDrift` WRITE;
/*!40000 ALTER TABLE `MotionCorrectionDrift` DISABLE KEYS */;
INSERT INTO `MotionCorrectionDrift` VALUES
(1,1,1,1,1),
(2,1,2,4,1),
(3,1,3,9,1);
/*!40000 ALTER TABLE `MotionCorrectionDrift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MotorPosition`
--

DROP TABLE IF EXISTS `MotorPosition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MotorPosition` (
  `motorPositionId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phiX` double DEFAULT NULL,
  `phiY` double DEFAULT NULL,
  `phiZ` double DEFAULT NULL,
  `sampX` double DEFAULT NULL,
  `sampY` double DEFAULT NULL,
  `omega` double DEFAULT NULL,
  `kappa` double DEFAULT NULL,
  `phi` double DEFAULT NULL,
  `chi` double DEFAULT NULL,
  `gridIndexY` int(11) DEFAULT NULL,
  `gridIndexZ` int(11) DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`motorPositionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MotorPosition`
--

LOCK TABLES `MotorPosition` WRITE;
/*!40000 ALTER TABLE `MotorPosition` DISABLE KEYS */;
/*!40000 ALTER TABLE `MotorPosition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Movie`
--

DROP TABLE IF EXISTS `Movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Movie` (
  `movieId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned DEFAULT NULL,
  `movieNumber` mediumint(8) unsigned DEFAULT NULL,
  `movieFullPath` varchar(255) DEFAULT NULL,
  `createdTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `positionX` float DEFAULT NULL,
  `positionY` float DEFAULT NULL,
  `nominalDefocus` float unsigned DEFAULT NULL COMMENT 'Nominal defocus, Units: A',
  `angle` float DEFAULT NULL COMMENT 'unit: degrees relative to perpendicular to beam',
  `fluence` float DEFAULT NULL COMMENT 'accumulated electron fluence from start to end of acquisition of this movie (commonly, but incorrectly, referred to as ‘dose’)',
  `numberOfFrames` int(11) unsigned DEFAULT NULL COMMENT 'number of frames per movie. This should be equivalent to the number of MotionCorrectionDrift entries, but the latter is a property of data analysis, whereas the number of frames is an intrinsic property of acquisition.',
  `foilHoleId` int(11) unsigned DEFAULT NULL,
  `templateLabel` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`movieId`),
  KEY `Movie_ibfk1` (`dataCollectionId`),
  KEY `Movie_fk_foilHoleId` (`foilHoleId`),
  CONSTRAINT `Movie_fk_foilHoleId` FOREIGN KEY (`foilHoleId`) REFERENCES `FoilHole` (`foilHoleId`) ON UPDATE CASCADE,
  CONSTRAINT `Movie_ibfk1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Movie`
--

LOCK TABLES `Movie` WRITE;
/*!40000 ALTER TABLE `Movie` DISABLE KEYS */;
INSERT INTO `Movie` VALUES
(1,6017406,NULL,NULL,'2022-11-14 14:02:14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,6017406,NULL,NULL,'2022-11-14 14:02:14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,6017406,NULL,NULL,'2022-11-14 14:02:14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,6017406,NULL,NULL,'2022-11-14 14:02:14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,6017406,NULL,NULL,'2022-11-14 14:02:14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,6017408,NULL,NULL,'2022-11-16 13:19:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,6017408,NULL,NULL,'2022-11-16 13:19:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,6017408,NULL,NULL,'2022-11-16 13:19:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,6017408,NULL,NULL,'2022-11-16 13:19:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,6017408,NULL,NULL,'2022-11-16 13:19:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(11,6017409,NULL,NULL,'2022-11-16 15:47:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(12,6017409,NULL,NULL,'2022-11-16 15:47:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(13,6017409,NULL,NULL,'2022-11-16 15:47:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(14,6017409,NULL,NULL,'2022-11-16 15:47:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(15,6017409,NULL,NULL,'2022-11-16 15:47:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(16,6017411,NULL,NULL,'2022-11-25 14:40:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(17,6017411,NULL,NULL,'2022-11-25 14:40:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(18,6017411,NULL,NULL,'2022-11-25 14:40:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(19,6017411,NULL,NULL,'2022-11-25 14:40:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(20,6017411,NULL,NULL,'2022-11-25 14:40:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(21,6017412,NULL,NULL,'2022-11-30 09:06:02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(22,6017412,NULL,NULL,'2022-11-30 09:06:02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(23,6017412,NULL,NULL,'2022-11-30 09:06:02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(24,6017412,NULL,NULL,'2022-11-30 09:06:02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(25,6017412,NULL,NULL,'2022-11-30 09:06:02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(26,6017413,NULL,NULL,'2023-02-14 14:56:10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(27,6017408,NULL,NULL,'2024-11-26 16:47:06',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL);
/*!40000 ALTER TABLE `Movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PDB`
--

DROP TABLE IF EXISTS `PDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PDB` (
  `pdbId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `contents` mediumtext DEFAULT NULL,
  `code` varchar(4) DEFAULT NULL,
  `source` varchar(30) DEFAULT NULL COMMENT 'Could be e.g. AlphaFold or RoseTTAFold',
  PRIMARY KEY (`pdbId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PDB`
--

LOCK TABLES `PDB` WRITE;
/*!40000 ALTER TABLE `PDB` DISABLE KEYS */;
INSERT INTO `PDB` VALUES
(6,'ceo2','\r\ndata_\r\n_chemical_name_mineral ?CeO2?\r\n_cell_length_a  5.411223\r\n_cell_length_b  5.411223\r\n_cell_length_c  5.411223\r\n_cell_angle_alpha 90\r\n_cell_angle_beta  90\r\n_cell_angle_gamma 90\r\n_cell_volume 158.4478\r\n_symmetry_space_group_name_H-M     \'Fm3m\'\r\nloop_\r\n_symmetry_equiv_pos_as_xyz\r\n	\'-x, -y, -z\'\r\n	\'-x, -y, z\'\r\n	\'-x, -y+1/2, -z+1/2\'\r\n	\'-x, -y+1/2, z+1/2\'\r\n	\'-x, -z, -y\'\r\n	\'-x, -z, y\'\r\n	\'-x, -z+1/2, -y+1/2\'\r\n	\'-x, -z+1/2, y+1/2\'\r\n	\'-x, z, -y\'\r\n	\'-x, z, y\'\r\n	\'-x, z+1/2, -y+1/2\'\r\n	\'-x, z+1/2, y+1/2\'\r\n	\'-x, y, -z\'\r\n	\'-x, y, z\'\r\n	\'-x, y+1/2, -z+1/2\'\r\n	\'-x, y+1/2, z+1/2\'\r\n	\'-x+1/2, -y, -z+1/2\'\r\n	\'-x+1/2, -y, z+1/2\'\r\n	\'-x+1/2, -y+1/2, -z\'\r\n	\'-x+1/2, -y+1/2, z\'\r\n	\'-x+1/2, -z, -y+1/2\'\r\n	\'-x+1/2, -z, y+1/2\'\r\n	\'-x+1/2, -z+1/2, -y\'\r\n	\'-x+1/2, -z+1/2, y\'\r\n	\'-x+1/2, z, -y+1/2\'\r\n	\'-x+1/2, z, y+1/2\'\r\n	\'-x+1/2, z+1/2, -y\'\r\n	\'-x+1/2, z+1/2, y\'\r\n	\'-x+1/2, y, -z+1/2\'\r\n	\'-x+1/2, y, z+1/2\'\r\n	\'-x+1/2, y+1/2, -z\'\r\n	\'-x+1/2, y+1/2, z\'\r\n	\'-y, -x, -z\'\r\n	\'-y, -x, z\'\r\n	\'-y, -x+1/2, -z+1/2\'\r\n	\'-y, -x+1/2, z+1/2\'\r\n	\'-y, -z, -x\'\r\n	\'-y, -z, x\'\r\n	\'-y, -z+1/2, -x+1/2\'\r\n	\'-y, -z+1/2, x+1/2\'\r\n	\'-y, z, -x\'\r\n	\'-y, z, x\'\r\n	\'-y, z+1/2, -x+1/2\'\r\n	\'-y, z+1/2, x+1/2\'\r\n	\'-y, x, -z\'\r\n	\'-y, x, z\'\r\n	\'-y, x+1/2, -z+1/2\'\r\n	\'-y, x+1/2, z+1/2\'\r\n	\'-y+1/2, -x, -z+1/2\'\r\n	\'-y+1/2, -x, z+1/2\'\r\n	\'-y+1/2, -x+1/2, -z\'\r\n	\'-y+1/2, -x+1/2, z\'\r\n	\'-y+1/2, -z, -x+1/2\'\r\n	\'-y+1/2, -z, x+1/2\'\r\n	\'-y+1/2, -z+1/2, -x\'\r\n	\'-y+1/2, -z+1/2, x\'\r\n	\'-y+1/2, z, -x+1/2\'\r\n	\'-y+1/2, z, x+1/2\'\r\n	\'-y+1/2, z+1/2, -x\'\r\n	\'-y+1/2, z+1/2, x\'\r\n	\'-y+1/2, x, -z+1/2\'\r\n	\'-y+1/2, x, z+1/2\'\r\n	\'-y+1/2, x+1/2, -z\'\r\n	\'-y+1/2, x+1/2, z\'\r\n	\'-z, -x, -y\'\r\n	\'-z, -x, y\'\r\n	\'-z, -x+1/2, -y+1/2\'\r\n	\'-z, -x+1/2, y+1/2\'\r\n	\'-z, -y, -x\'\r\n	\'-z, -y, x\'\r\n	\'-z, -y+1/2, -x+1/2\'\r\n	\'-z, -y+1/2, x+1/2\'\r\n	\'-z, y, -x\'\r\n	\'-z, y, x\'\r\n	\'-z, y+1/2, -x+1/2\'\r\n	\'-z, y+1/2, x+1/2\'\r\n	\'-z, x, -y\'\r\n	\'-z, x, y\'\r\n	\'-z, x+1/2, -y+1/2\'\r\n	\'-z, x+1/2, y+1/2\'\r\n	\'-z+1/2, -x, -y+1/2\'\r\n	\'-z+1/2, -x, y+1/2\'\r\n	\'-z+1/2, -x+1/2, -y\'\r\n	\'-z+1/2, -x+1/2, y\'\r\n	\'-z+1/2, -y, -x+1/2\'\r\n	\'-z+1/2, -y, x+1/2\'\r\n	\'-z+1/2, -y+1/2, -x\'\r\n	\'-z+1/2, -y+1/2, x\'\r\n	\'-z+1/2, y, -x+1/2\'\r\n	\'-z+1/2, y, x+1/2\'\r\n	\'-z+1/2, y+1/2, -x\'\r\n	\'-z+1/2, y+1/2, x\'\r\n	\'-z+1/2, x, -y+1/2\'\r\n	\'-z+1/2, x, y+1/2\'\r\n	\'-z+1/2, x+1/2, -y\'\r\n	\'-z+1/2, x+1/2, y\'\r\n	\'z, -x, -y\'\r\n	\'z, -x, y\'\r\n	\'z, -x+1/2, -y+1/2\'\r\n	\'z, -x+1/2, y+1/2\'\r\n	\'z, -y, -x\'\r\n	\'z, -y, x\'\r\n	\'z, -y+1/2, -x+1/2\'\r\n	\'z, -y+1/2, x+1/2\'\r\n	\'z, y, -x\'\r\n	\'z, y, x\'\r\n	\'z, y+1/2, -x+1/2\'\r\n	\'z, y+1/2, x+1/2\'\r\n	\'z, x, -y\'\r\n	\'z, x, y\'\r\n	\'z, x+1/2, -y+1/2\'\r\n	\'z, x+1/2, y+1/2\'\r\n	\'z+1/2, -x, -y+1/2\'\r\n	\'z+1/2, -x, y+1/2\'\r\n	\'z+1/2, -x+1/2, -y\'\r\n	\'z+1/2, -x+1/2, y\'\r\n	\'z+1/2, -y, -x+1/2\'\r\n	\'z+1/2, -y, x+1/2\'\r\n	\'z+1/2, -y+1/2, -x\'\r\n	\'z+1/2, -y+1/2, x\'\r\n	\'z+1/2, y, -x+1/2\'\r\n	\'z+1/2, y, x+1/2\'\r\n	\'z+1/2, y+1/2, -x\'\r\n	\'z+1/2, y+1/2, x\'\r\n	\'z+1/2, x, -y+1/2\'\r\n	\'z+1/2, x, y+1/2\'\r\n	\'z+1/2, x+1/2, -y\'\r\n	\'z+1/2, x+1/2, y\'\r\n	\'y, -x, -z\'\r\n	\'y, -x, z\'\r\n	\'y, -x+1/2, -z+1/2\'\r\n	\'y, -x+1/2, z+1/2\'\r\n	\'y, -z, -x\'\r\n	\'y, -z, x\'\r\n	\'y, -z+1/2, -x+1/2\'\r\n	\'y, -z+1/2, x+1/2\'\r\n	\'y, z, -x\'\r\n	\'y, z, x\'\r\n	\'y, z+1/2, -x+1/2\'\r\n	\'y, z+1/2, x+1/2\'\r\n	\'y, x, -z\'\r\n	\'y, x, z\'\r\n	\'y, x+1/2, -z+1/2\'\r\n	\'y, x+1/2, z+1/2\'\r\n	\'y+1/2, -x, -z+1/2\'\r\n	\'y+1/2, -x, z+1/2\'\r\n	\'y+1/2, -x+1/2, -z\'\r\n	\'y+1/2, -x+1/2, z\'\r\n	\'y+1/2, -z, -x+1/2\'\r\n	\'y+1/2, -z, x+1/2\'\r\n	\'y+1/2, -z+1/2, -x\'\r\n	\'y+1/2, -z+1/2, x\'\r\n	\'y+1/2, z, -x+1/2\'\r\n	\'y+1/2, z, x+1/2\'\r\n	\'y+1/2, z+1/2, -x\'\r\n	\'y+1/2, z+1/2, x\'\r\n	\'y+1/2, x, -z+1/2\'\r\n	\'y+1/2, x, z+1/2\'\r\n	\'y+1/2, x+1/2, -z\'\r\n	\'y+1/2, x+1/2, z\'\r\n	\'x, -y, -z\'\r\n	\'x, -y, z\'\r\n	\'x, -y+1/2, -z+1/2\'\r\n	\'x, -y+1/2, z+1/2\'\r\n	\'x, -z, -y\'\r\n	\'x, -z, y\'\r\n	\'x, -z+1/2, -y+1/2\'\r\n	\'x, -z+1/2, y+1/2\'\r\n	\'x, z, -y\'\r\n	\'x, z, y\'\r\n	\'x, z+1/2, -y+1/2\'\r\n	\'x, z+1/2, y+1/2\'\r\n	\'x, y, -z\'\r\n	\'x, y, z\'\r\n	\'x, y+1/2, -z+1/2\'\r\n	\'x, y+1/2, z+1/2\'\r\n	\'x+1/2, -y, -z+1/2\'\r\n	\'x+1/2, -y, z+1/2\'\r\n	\'x+1/2, -y+1/2, -z\'\r\n	\'x+1/2, -y+1/2, z\'\r\n	\'x+1/2, -z, -y+1/2\'\r\n	\'x+1/2, -z, y+1/2\'\r\n	\'x+1/2, -z+1/2, -y\'\r\n	\'x+1/2, -z+1/2, y\'\r\n	\'x+1/2, z, -y+1/2\'\r\n	\'x+1/2, z, y+1/2\'\r\n	\'x+1/2, z+1/2, -y\'\r\n	\'x+1/2, z+1/2, y\'\r\n	\'x+1/2, y, -z+1/2\'\r\n	\'x+1/2, y, z+1/2\'\r\n	\'x+1/2, y+1/2, -z\'\r\n	\'x+1/2, y+1/2, z\'\r\nloop_\r\n_atom_site_label\r\n_atom_site_type_symbol\r\n_atom_site_symmetry_multiplicity\r\n_atom_site_fract_x\r\n_atom_site_fract_y\r\n_atom_site_fract_z\r\n_atom_site_occupancy\r\n_atom_site_B_iso_or_equiv\r\nCe1 Ce   0 0 0 0 1 0.127911\r\nO1 O   0 0.25 0.25 0.25 1 0.07795472',NULL,NULL);
/*!40000 ALTER TABLE `PDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PDBEntry`
--

DROP TABLE IF EXISTS `PDBEntry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PDBEntry` (
  `pdbEntryId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `autoProcProgramId` int(11) unsigned NOT NULL,
  `code` varchar(4) DEFAULT NULL,
  `cell_a` float DEFAULT NULL,
  `cell_b` float DEFAULT NULL,
  `cell_c` float DEFAULT NULL,
  `cell_alpha` float DEFAULT NULL,
  `cell_beta` float DEFAULT NULL,
  `cell_gamma` float DEFAULT NULL,
  `resolution` float DEFAULT NULL,
  `pdbTitle` varchar(255) DEFAULT NULL,
  `pdbAuthors` varchar(600) DEFAULT NULL,
  `pdbDate` datetime DEFAULT NULL,
  `pdbBeamlineName` varchar(50) DEFAULT NULL,
  `beamlines` varchar(100) DEFAULT NULL,
  `distance` float DEFAULT NULL,
  `autoProcCount` smallint(6) DEFAULT NULL,
  `dataCollectionCount` smallint(6) DEFAULT NULL,
  `beamlineMatch` tinyint(1) DEFAULT NULL,
  `authorMatch` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`pdbEntryId`),
  KEY `pdbEntryIdx1` (`autoProcProgramId`),
  CONSTRAINT `pdbEntry_FK1` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PDBEntry`
--

LOCK TABLES `PDBEntry` WRITE;
/*!40000 ALTER TABLE `PDBEntry` DISABLE KEYS */;
/*!40000 ALTER TABLE `PDBEntry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PDBEntry_has_AutoProcProgram`
--

DROP TABLE IF EXISTS `PDBEntry_has_AutoProcProgram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PDBEntry_has_AutoProcProgram` (
  `pdbEntryHasAutoProcId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pdbEntryId` int(11) unsigned NOT NULL,
  `autoProcProgramId` int(11) unsigned NOT NULL,
  `distance` float DEFAULT NULL,
  PRIMARY KEY (`pdbEntryHasAutoProcId`),
  KEY `pdbEntry_AutoProcProgramIdx1` (`pdbEntryId`),
  KEY `pdbEntry_AutoProcProgramIdx2` (`autoProcProgramId`),
  CONSTRAINT `pdbEntry_AutoProcProgram_FK1` FOREIGN KEY (`pdbEntryId`) REFERENCES `PDBEntry` (`pdbEntryId`) ON DELETE CASCADE,
  CONSTRAINT `pdbEntry_AutoProcProgram_FK2` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PDBEntry_has_AutoProcProgram`
--

LOCK TABLES `PDBEntry_has_AutoProcProgram` WRITE;
/*!40000 ALTER TABLE `PDBEntry_has_AutoProcProgram` DISABLE KEYS */;
/*!40000 ALTER TABLE `PDBEntry_has_AutoProcProgram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ParticleClassification`
--

DROP TABLE IF EXISTS `ParticleClassification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ParticleClassification` (
  `particleClassificationId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `classNumber` int(10) unsigned DEFAULT NULL COMMENT 'Identified of the class. A unique ID given by Relion',
  `classImageFullPath` varchar(255) DEFAULT NULL COMMENT 'The PNG of the class',
  `particlesPerClass` int(10) unsigned DEFAULT NULL COMMENT 'Number of particles within the selected class, can then be used together with the total number above to calculate the percentage',
  `rotationAccuracy` float DEFAULT NULL COMMENT '???',
  `translationAccuracy` float DEFAULT NULL COMMENT 'Unit: Angstroms',
  `estimatedResolution` float DEFAULT NULL COMMENT '???, Unit: Angstroms',
  `overallFourierCompleteness` float DEFAULT NULL,
  `particleClassificationGroupId` int(10) unsigned DEFAULT NULL,
  `classDistribution` float DEFAULT NULL COMMENT 'Provides a figure of merit for the class, higher number is better',
  `selected` tinyint(1) DEFAULT 0 COMMENT 'Indicates whether the group is selected for processing or not.',
  `bFactorFitIntercept` float DEFAULT NULL COMMENT 'Intercept of quadratic fit to refinement resolution against the logarithm of the number of particles',
  `bFactorFitLinear` float DEFAULT NULL COMMENT 'Linear coefficient of quadratic fit to refinement resolution against the logarithm of the number of particles, equal to half of the B factor',
  `bFactorFitQuadratic` float DEFAULT NULL COMMENT 'Quadratic coefficient of quadratic fit to refinement resolution against the logarithm of the number of particles',
  `angularEfficiency` float DEFAULT NULL COMMENT 'Variation in resolution across different angles, 1-2sig/mean',
  `suggestedTilt` float DEFAULT NULL COMMENT 'Suggested stage tilt angle to improve angular efficiency. Unit: degrees',
  PRIMARY KEY (`particleClassificationId`),
  KEY `ParticleClassification_fk_particleClassificationGroupId` (`particleClassificationGroupId`),
  CONSTRAINT `ParticleClassification_fk_particleClassificationGroupId` FOREIGN KEY (`particleClassificationGroupId`) REFERENCES `ParticleClassificationGroup` (`particleClassificationGroupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Results of 2D or 2D classification';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ParticleClassification`
--

LOCK TABLES `ParticleClassification` WRITE;
/*!40000 ALTER TABLE `ParticleClassification` DISABLE KEYS */;
INSERT INTO `ParticleClassification` VALUES
(1,1,'/mnt/test.jpg',20000,15,15,9,15,1,0.1,0,NULL,NULL,NULL,NULL,NULL),
(2,1,'/mnt/test.jpg',40000,15,15,12,15,1,0.2,0,NULL,NULL,NULL,NULL,NULL),
(3,1,'/mnt/test.jpg',60000,15,15,0,15,1,0.1,0,NULL,NULL,NULL,NULL,NULL),
(4,1,'/mnt/test.jpg',25000,15,15,18,15,1,0.01,1,NULL,NULL,NULL,NULL,NULL),
(5,1,'/mnt/test.jpg',30000,15,15,10,15,1,0.3,1,NULL,NULL,NULL,NULL,NULL),
(6,1,'/mnt/test.jpg',30000,15,15,10,15,2,0.3,1,NULL,NULL,NULL,NULL,NULL),
(7,1,'/mnt/test.jpg',40000,15,15,0,15,2,0.2,1,NULL,NULL,NULL,NULL,NULL),
(8,1,'/mnt/test.jpg',60000,15,15,15,15,2,0.1,1,NULL,NULL,NULL,NULL,NULL),
(9,1,'/mnt/test.jpg',60000,15,15,15,15,3,0.1,1,NULL,1,NULL,NULL,NULL),
(10,1,'/mnt/test.jpg',60000,15,15,15,15,4,0.1,1,NULL,1,NULL,NULL,NULL),
(11,1,'/mnt/test.jpg',60000,15,15,15,15,5,0.1,1,NULL,1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ParticleClassification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ParticleClassificationGroup`
--

DROP TABLE IF EXISTS `ParticleClassificationGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ParticleClassificationGroup` (
  `particleClassificationGroupId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `particlePickerId` int(10) unsigned DEFAULT NULL,
  `programId` int(10) unsigned DEFAULT NULL,
  `type` enum('2D','3D') DEFAULT NULL COMMENT 'Indicates the type of particle classification',
  `batchNumber` int(10) unsigned DEFAULT NULL COMMENT 'Corresponding to batch number',
  `numberOfParticlesPerBatch` int(10) unsigned DEFAULT NULL COMMENT 'total number of particles per batch (a large integer)',
  `numberOfClassesPerBatch` int(10) unsigned DEFAULT NULL,
  `symmetry` varchar(20) DEFAULT NULL,
  `binnedPixelSize` float DEFAULT NULL COMMENT 'Binned pixel size. Unit: Angstroms',
  PRIMARY KEY (`particleClassificationGroupId`),
  KEY `ParticleClassificationGroup_fk_particlePickerId` (`particlePickerId`),
  KEY `ParticleClassificationGroup_fk_programId` (`programId`),
  CONSTRAINT `ParticleClassificationGroup_fk_particlePickerId` FOREIGN KEY (`particlePickerId`) REFERENCES `ParticlePicker` (`particlePickerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ParticleClassificationGroup_fk_programId` FOREIGN KEY (`programId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ParticleClassificationGroup`
--

LOCK TABLES `ParticleClassificationGroup` WRITE;
/*!40000 ALTER TABLE `ParticleClassificationGroup` DISABLE KEYS */;
INSERT INTO `ParticleClassificationGroup` VALUES
(1,1,56986680,'2D',1,10000,20000,'1',NULL),
(2,3,56986680,'3D',1,10000,20000,'1',NULL),
(3,4,56986805,'3D',1,10000,20000,'C1',NULL),
(4,4,56986804,'3D',1,10000,20000,'C1',NULL),
(5,4,56986806,'3D',1,10000,20000,'C1',NULL);
/*!40000 ALTER TABLE `ParticleClassificationGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ParticleClassification_has_CryoemInitialModel`
--

DROP TABLE IF EXISTS `ParticleClassification_has_CryoemInitialModel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ParticleClassification_has_CryoemInitialModel` (
  `particleClassificationId` int(10) unsigned NOT NULL,
  `cryoemInitialModelId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`particleClassificationId`,`cryoemInitialModelId`),
  KEY `ParticleClassification_has_InitialModel_fk2` (`cryoemInitialModelId`),
  CONSTRAINT `ParticleClassification_has_CryoemInitialModel_fk1` FOREIGN KEY (`particleClassificationId`) REFERENCES `ParticleClassification` (`particleClassificationId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ParticleClassification_has_InitialModel_fk2` FOREIGN KEY (`cryoemInitialModelId`) REFERENCES `CryoemInitialModel` (`cryoemInitialModelId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ParticleClassification_has_CryoemInitialModel`
--

LOCK TABLES `ParticleClassification_has_CryoemInitialModel` WRITE;
/*!40000 ALTER TABLE `ParticleClassification_has_CryoemInitialModel` DISABLE KEYS */;
INSERT INTO `ParticleClassification_has_CryoemInitialModel` VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1);
/*!40000 ALTER TABLE `ParticleClassification_has_CryoemInitialModel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ParticlePicker`
--

DROP TABLE IF EXISTS `ParticlePicker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ParticlePicker` (
  `particlePickerId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `programId` int(10) unsigned DEFAULT NULL,
  `firstMotionCorrectionId` int(10) unsigned DEFAULT NULL,
  `particlePickingTemplate` varchar(255) DEFAULT NULL COMMENT 'Cryolo model',
  `particleDiameter` float DEFAULT NULL COMMENT 'Unit: nm',
  `numberOfParticles` int(10) unsigned DEFAULT NULL,
  `summaryImageFullPath` varchar(255) DEFAULT NULL COMMENT 'Generated summary micrograph image with highlighted particles',
  PRIMARY KEY (`particlePickerId`),
  KEY `ParticlePicker_fk_particlePickerProgramId` (`programId`),
  KEY `ParticlePicker_fk_motionCorrectionId` (`firstMotionCorrectionId`),
  CONSTRAINT `ParticlePicker_fk_motionCorrectionId` FOREIGN KEY (`firstMotionCorrectionId`) REFERENCES `MotionCorrection` (`motionCorrectionId`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `ParticlePicker_fk_programId` FOREIGN KEY (`programId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='An instance of a particle picker program that was run';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ParticlePicker`
--

LOCK TABLES `ParticlePicker` WRITE;
/*!40000 ALTER TABLE `ParticlePicker` DISABLE KEYS */;
INSERT INTO `ParticlePicker` VALUES
(1,56986680,21,NULL,1,10,'/mnt/test.jpg'),
(2,56986680,21,NULL,1,40,'/mnt/test.jpg'),
(3,56986680,21,NULL,1,40,'/mnt/test.jpg'),
(4,56986803,3,NULL,1,60,'/mnt/test.jpg'),
(5,56986803,4,NULL,2,40,'/mnt/test.jpg'),
(6,56986673,6,NULL,1,40,''),
(7,56986677,30,NULL,1,30,NULL),
(8,56986677,30,NULL,1,40,NULL);
/*!40000 ALTER TABLE `ParticlePicker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Permission`
--

DROP TABLE IF EXISTS `Permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Permission` (
  `permissionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(15) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`permissionId`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Permission`
--

LOCK TABLES `Permission` WRITE;
/*!40000 ALTER TABLE `Permission` DISABLE KEYS */;
INSERT INTO `Permission` VALUES
(1,'mx_admin','MX Administrator'),
(2,'manage_groups','Manage User Groups'),
(4,'manage_perms','Manage User Group Permissions'),
(5,'global_stats','View Global Statistics'),
(6,'fault_view','View Fault Reports'),
(7,'saxs_admin','SAXS Administrator'),
(8,'em_admin','EM Administrator'),
(9,'gen_admin','Powder Admin'),
(10,'tomo_admin','Tomo Admin'),
(11,'super_admin','Site Admin'),
(12,'fault_global','Globally edit all faults'),
(13,'schedules','Manage Imaging Schedules'),
(15,'schedule_comps','Manage Imaging Schedule Components'),
(16,'imaging_dash','Imaging Dashboard'),
(17,'vmxi_queue','VMXi Data Collection Queue'),
(18,'sm_admin','Small Molecule Admin'),
(20,'pow_admin','Power Admin'),
(23,'all_dewars','View All Dewars'),
(26,'all_prop_stats','View All Proposal Stats'),
(29,'all_breakdown','View Aggregated Visit Breakdown Stats'),
(32,'disp_cont','VMXi Dispose Container'),
(37,'view_manifest','View Shipping Manifest'),
(43,'schedule_comp','typo fill in'),
(49,'xpdf_admin','XPDF Admin'),
(55,'edit_presets','Edit Beamline DC Presets'),
(58,'manage_params','Edit Beamline Parameter Limits'),
(64,'manage_detector','Manage Beamline Detector Limits'),
(69,'auto_dash','AutoCollect Dashboard'),
(77,'fault_admin','Edit Fault Categories'),
(80,'fault_add','Add New Fault Reports');
/*!40000 ALTER TABLE `Permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person`
--

DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person` (
  `personId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `laboratoryId` int(10) unsigned DEFAULT NULL,
  `siteId` int(11) DEFAULT NULL,
  `personUUID` varchar(45) DEFAULT NULL,
  `familyName` varchar(100) DEFAULT NULL,
  `givenName` varchar(45) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `emailAddress` varchar(60) DEFAULT NULL,
  `phoneNumber` varchar(45) DEFAULT NULL,
  `login` varchar(45) DEFAULT NULL,
  `faxNumber` varchar(45) DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `cache` text DEFAULT NULL,
  `externalId` binary(16) DEFAULT NULL,
  PRIMARY KEY (`personId`),
  UNIQUE KEY `Person_FKIndex_Login` (`login`),
  KEY `Person_FKIndex1` (`laboratoryId`),
  KEY `Person_FKIndexFamilyName` (`familyName`),
  KEY `siteId` (`siteId`),
  CONSTRAINT `Person_ibfk_1` FOREIGN KEY (`laboratoryId`) REFERENCES `Laboratory` (`laboratoryId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=46631 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES
(1,NULL,NULL,NULL,'McBoatface','Boaty','Mr','boaty@diamond.ac.uk',NULL,'boaty',NULL,'2016-03-20 13:56:45','a:1:{s:9:\"container\";N;}',NULL),
(16000,NULL,NULL,NULL,'Lauda','Niki','Mr',NULL,NULL,'mx_admin',NULL,'2022-11-16 09:49:44',NULL,NULL),
(17000,NULL,NULL,NULL,'Doe','John','Mr',NULL,NULL,'yrh59256',NULL,'2022-11-16 09:49:44',NULL,NULL),
(18549,NULL,NULL,NULL,'Hunt','James','Dr',NULL,NULL,'admin',NULL,'2022-10-21 09:00:00',NULL,NULL),
(18600,NULL,NULL,NULL,'Bohr','Niels','Dr',NULL,NULL,'user',NULL,'2022-10-21 09:00:00',NULL,NULL),
(18650,NULL,NULL,NULL,'Hill','Graham','Mr',NULL,NULL,'empty',NULL,'2022-10-21 09:00:00',NULL,NULL),
(18660,NULL,NULL,NULL,'Moss','Stirling','Dr',NULL,NULL,'em_admin',NULL,'2022-10-21 09:00:00',NULL,NULL),
(46266,NULL,NULL,NULL,NULL,NULL,'User',NULL,NULL,NULL,NULL,'2016-03-16 15:53:55',NULL,NULL),
(46269,NULL,NULL,NULL,NULL,NULL,'User',NULL,NULL,NULL,NULL,'2016-03-16 15:59:22',NULL,NULL),
(46270,NULL,NULL,NULL,'Hill','Damon','Mr',NULL,NULL,'session_no_proposal',NULL,'2016-03-16 15:59:22',NULL,'?�_dWEb��'),
(46435,NULL,NULL,NULL,'Villeneuve','Giles','Dr',NULL,NULL,'industrial',NULL,'2025-04-24 11:16:02',NULL,NULL),
(46436,NULL,NULL,NULL,'Hakkinen','Mika','Mr',NULL,NULL,'abc12345',NULL,'2025-04-24 12:27:17',NULL,NULL);
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Phasing`
--

DROP TABLE IF EXISTS `Phasing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Phasing` (
  `phasingId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingAnalysisId` int(11) unsigned NOT NULL COMMENT 'Related phasing analysis item',
  `phasingProgramRunId` int(11) unsigned NOT NULL COMMENT 'Related program item',
  `spaceGroupId` int(10) unsigned DEFAULT NULL COMMENT 'Related spaceGroup',
  `method` enum('solvent flattening','solvent flipping','e','SAD','shelxe') DEFAULT NULL COMMENT 'phasing method',
  `solventContent` double DEFAULT NULL,
  `enantiomorph` tinyint(1) DEFAULT NULL COMMENT '0 or 1',
  `lowRes` double DEFAULT NULL,
  `highRes` double DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`phasingId`),
  KEY `Phasing_FKIndex1` (`phasingAnalysisId`),
  KEY `Phasing_FKIndex2` (`phasingProgramRunId`),
  KEY `Phasing_FKIndex3` (`spaceGroupId`),
  CONSTRAINT `Phasing_phasingAnalysisfk_1` FOREIGN KEY (`phasingAnalysisId`) REFERENCES `PhasingAnalysis` (`phasingAnalysisId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Phasing_phasingProgramRunfk_1` FOREIGN KEY (`phasingProgramRunId`) REFERENCES `PhasingProgramRun` (`phasingProgramRunId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Phasing_spaceGroupfk_1` FOREIGN KEY (`spaceGroupId`) REFERENCES `SpaceGroup` (`spaceGroupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Phasing`
--

LOCK TABLES `Phasing` WRITE;
/*!40000 ALTER TABLE `Phasing` DISABLE KEYS */;
/*!40000 ALTER TABLE `Phasing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PhasingAnalysis`
--

DROP TABLE IF EXISTS `PhasingAnalysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PhasingAnalysis` (
  `phasingAnalysisId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`phasingAnalysisId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PhasingAnalysis`
--

LOCK TABLES `PhasingAnalysis` WRITE;
/*!40000 ALTER TABLE `PhasingAnalysis` DISABLE KEYS */;
/*!40000 ALTER TABLE `PhasingAnalysis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PhasingProgramAttachment`
--

DROP TABLE IF EXISTS `PhasingProgramAttachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PhasingProgramAttachment` (
  `phasingProgramAttachmentId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingProgramRunId` int(11) unsigned NOT NULL COMMENT 'Related program item',
  `fileType` enum('Map','Logfile','PDB','CSV','INS','RES','TXT') DEFAULT NULL COMMENT 'file type',
  `fileName` varchar(45) DEFAULT NULL COMMENT 'file name',
  `filePath` varchar(255) DEFAULT NULL COMMENT 'file path',
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`phasingProgramAttachmentId`),
  KEY `PhasingProgramAttachment_FKIndex1` (`phasingProgramRunId`),
  CONSTRAINT `Phasing_phasingProgramAttachmentfk_1` FOREIGN KEY (`phasingProgramRunId`) REFERENCES `PhasingProgramRun` (`phasingProgramRunId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PhasingProgramAttachment`
--

LOCK TABLES `PhasingProgramAttachment` WRITE;
/*!40000 ALTER TABLE `PhasingProgramAttachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `PhasingProgramAttachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PhasingProgramRun`
--

DROP TABLE IF EXISTS `PhasingProgramRun`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PhasingProgramRun` (
  `phasingProgramRunId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingCommandLine` varchar(255) DEFAULT NULL COMMENT 'Command line for phasing',
  `phasingPrograms` varchar(255) DEFAULT NULL COMMENT 'Phasing programs (comma separated)',
  `phasingStatus` tinyint(1) DEFAULT NULL COMMENT 'success (1) / fail (0)',
  `phasingMessage` varchar(255) DEFAULT NULL COMMENT 'warning, error,...',
  `phasingStartTime` datetime DEFAULT NULL COMMENT 'Processing start time',
  `phasingEndTime` datetime DEFAULT NULL COMMENT 'Processing end time',
  `phasingEnvironment` varchar(255) DEFAULT NULL COMMENT 'Cpus, Nodes,...',
  `recordTimeStamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`phasingProgramRunId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PhasingProgramRun`
--

LOCK TABLES `PhasingProgramRun` WRITE;
/*!40000 ALTER TABLE `PhasingProgramRun` DISABLE KEYS */;
/*!40000 ALTER TABLE `PhasingProgramRun` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PhasingStatistics`
--

DROP TABLE IF EXISTS `PhasingStatistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PhasingStatistics` (
  `phasingStatisticsId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingHasScalingId1` int(11) unsigned NOT NULL COMMENT 'the dataset in question',
  `phasingHasScalingId2` int(11) unsigned DEFAULT NULL COMMENT 'if this is MIT or MAD, which scaling are being compared, null otherwise',
  `phasingStepId` int(10) unsigned DEFAULT NULL,
  `numberOfBins` int(11) DEFAULT NULL COMMENT 'the total number of bins',
  `binNumber` int(11) DEFAULT NULL COMMENT 'binNumber, 999 for overall',
  `lowRes` double DEFAULT NULL COMMENT 'low resolution cutoff of this binfloat',
  `highRes` double DEFAULT NULL COMMENT 'high resolution cutoff of this binfloat',
  `metric` enum('Rcullis','Average Fragment Length','Chain Count','Residues Count','CC','PhasingPower','FOM','<d"/sig>','Best CC','CC(1/2)','Weak CC','CFOM','Pseudo_free_CC','CC of partial model') DEFAULT NULL COMMENT 'metric',
  `statisticsValue` double DEFAULT NULL COMMENT 'the statistics value',
  `nReflections` int(11) DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`phasingStatisticsId`),
  KEY `PhasingStatistics_FKIndex1` (`phasingHasScalingId1`),
  KEY `PhasingStatistics_FKIndex2` (`phasingHasScalingId2`),
  KEY `fk_PhasingStatistics_phasingStep_idx` (`phasingStepId`),
  CONSTRAINT `PhasingStatistics_phasingHasScalingfk_1` FOREIGN KEY (`phasingHasScalingId1`) REFERENCES `Phasing_has_Scaling` (`phasingHasScalingId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PhasingStatistics_phasingHasScalingfk_2` FOREIGN KEY (`phasingHasScalingId2`) REFERENCES `Phasing_has_Scaling` (`phasingHasScalingId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_PhasingStatistics_phasingStep` FOREIGN KEY (`phasingStepId`) REFERENCES `PhasingStep` (`phasingStepId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PhasingStatistics`
--

LOCK TABLES `PhasingStatistics` WRITE;
/*!40000 ALTER TABLE `PhasingStatistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `PhasingStatistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PhasingStep`
--

DROP TABLE IF EXISTS `PhasingStep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PhasingStep` (
  `phasingStepId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `previousPhasingStepId` int(10) unsigned DEFAULT NULL,
  `programRunId` int(10) unsigned DEFAULT NULL,
  `spaceGroupId` int(10) unsigned DEFAULT NULL,
  `autoProcScalingId` int(10) unsigned DEFAULT NULL,
  `phasingAnalysisId` int(10) unsigned DEFAULT NULL,
  `phasingStepType` enum('PREPARE','SUBSTRUCTUREDETERMINATION','PHASING','MODELBUILDING') DEFAULT NULL,
  `method` varchar(45) DEFAULT NULL,
  `solventContent` varchar(45) DEFAULT NULL,
  `enantiomorph` varchar(45) DEFAULT NULL,
  `lowRes` varchar(45) DEFAULT NULL,
  `highRes` varchar(45) DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`phasingStepId`),
  KEY `FK_programRun_id` (`programRunId`),
  KEY `FK_spacegroup_id` (`spaceGroupId`),
  KEY `FK_autoprocScaling_id` (`autoProcScalingId`),
  KEY `FK_phasingAnalysis_id` (`phasingAnalysisId`),
  CONSTRAINT `FK_autoprocScaling` FOREIGN KEY (`autoProcScalingId`) REFERENCES `AutoProcScaling` (`autoProcScalingId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_program` FOREIGN KEY (`programRunId`) REFERENCES `PhasingProgramRun` (`phasingProgramRunId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_spacegroup` FOREIGN KEY (`spaceGroupId`) REFERENCES `SpaceGroup` (`spaceGroupId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PhasingStep`
--

LOCK TABLES `PhasingStep` WRITE;
/*!40000 ALTER TABLE `PhasingStep` DISABLE KEYS */;
/*!40000 ALTER TABLE `PhasingStep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Phasing_has_Scaling`
--

DROP TABLE IF EXISTS `Phasing_has_Scaling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Phasing_has_Scaling` (
  `phasingHasScalingId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingAnalysisId` int(11) unsigned NOT NULL COMMENT 'Related phasing analysis item',
  `autoProcScalingId` int(10) unsigned NOT NULL COMMENT 'Related autoProcScaling item',
  `datasetNumber` int(11) DEFAULT NULL COMMENT 'serial number of the dataset and always reserve 0 for the reference',
  `recordTimeStamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`phasingHasScalingId`),
  KEY `PhasingHasScaling_FKIndex1` (`phasingAnalysisId`),
  KEY `PhasingHasScaling_FKIndex2` (`autoProcScalingId`),
  CONSTRAINT `PhasingHasScaling_autoProcScalingfk_1` FOREIGN KEY (`autoProcScalingId`) REFERENCES `AutoProcScaling` (`autoProcScalingId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PhasingHasScaling_phasingAnalysisfk_1` FOREIGN KEY (`phasingAnalysisId`) REFERENCES `PhasingAnalysis` (`phasingAnalysisId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Phasing_has_Scaling`
--

LOCK TABLES `Phasing_has_Scaling` WRITE;
/*!40000 ALTER TABLE `Phasing_has_Scaling` DISABLE KEYS */;
/*!40000 ALTER TABLE `Phasing_has_Scaling` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Position`
--

DROP TABLE IF EXISTS `Position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Position` (
  `positionId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `relativePositionId` int(11) unsigned DEFAULT NULL COMMENT 'relative position, null otherwise',
  `posX` double DEFAULT NULL,
  `posY` double DEFAULT NULL,
  `posZ` double DEFAULT NULL,
  `scale` double DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  `X` double GENERATED ALWAYS AS (`posX`) VIRTUAL,
  `Y` double GENERATED ALWAYS AS (`posY`) VIRTUAL,
  `Z` double GENERATED ALWAYS AS (`posZ`) VIRTUAL,
  PRIMARY KEY (`positionId`),
  KEY `Position_FKIndex1` (`relativePositionId`),
  CONSTRAINT `Position_relativePositionfk_1` FOREIGN KEY (`relativePositionId`) REFERENCES `Position` (`positionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=420 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Position`
--

LOCK TABLES `Position` WRITE;
/*!40000 ALTER TABLE `Position` DISABLE KEYS */;
INSERT INTO `Position` VALUES
(2,NULL,NULL,NULL,NULL,NULL,'2024-01-01 00:00:00',NULL,NULL,NULL),
(5,NULL,NULL,NULL,NULL,NULL,'2024-01-01 00:00:00',NULL,NULL,NULL);
/*!40000 ALTER TABLE `Position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Positioner`
--

DROP TABLE IF EXISTS `Positioner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Positioner` (
  `positionerId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `positioner` varchar(50) NOT NULL,
  `value` float NOT NULL,
  PRIMARY KEY (`positionerId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='An arbitrary positioner and its value, could be e.g. a motor. Allows for instance to store some positions with a sample or subsample';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Positioner`
--

LOCK TABLES `Positioner` WRITE;
/*!40000 ALTER TABLE `Positioner` DISABLE KEYS */;
/*!40000 ALTER TABLE `Positioner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PreparePhasingData`
--

DROP TABLE IF EXISTS `PreparePhasingData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PreparePhasingData` (
  `preparePhasingDataId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingAnalysisId` int(11) unsigned NOT NULL COMMENT 'Related phasing analysis item',
  `phasingProgramRunId` int(11) unsigned NOT NULL COMMENT 'Related program item',
  `spaceGroupId` int(10) unsigned DEFAULT NULL COMMENT 'Related spaceGroup',
  `lowRes` double DEFAULT NULL,
  `highRes` double DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`preparePhasingDataId`),
  KEY `PreparePhasingData_FKIndex1` (`phasingAnalysisId`),
  KEY `PreparePhasingData_FKIndex2` (`phasingProgramRunId`),
  KEY `PreparePhasingData_FKIndex3` (`spaceGroupId`),
  CONSTRAINT `PreparePhasingData_phasingAnalysisfk_1` FOREIGN KEY (`phasingAnalysisId`) REFERENCES `PhasingAnalysis` (`phasingAnalysisId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PreparePhasingData_phasingProgramRunfk_1` FOREIGN KEY (`phasingProgramRunId`) REFERENCES `PhasingProgramRun` (`phasingProgramRunId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PreparePhasingData_spaceGroupfk_1` FOREIGN KEY (`spaceGroupId`) REFERENCES `SpaceGroup` (`spaceGroupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PreparePhasingData`
--

LOCK TABLES `PreparePhasingData` WRITE;
/*!40000 ALTER TABLE `PreparePhasingData` DISABLE KEYS */;
/*!40000 ALTER TABLE `PreparePhasingData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProcessedTomogram`
--

DROP TABLE IF EXISTS `ProcessedTomogram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProcessedTomogram` (
  `processedTomogramId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tomogramId` int(11) unsigned NOT NULL COMMENT 'references Tomogram table',
  `filePath` varchar(255) DEFAULT NULL COMMENT 'location on disk for the tomogram file',
  `processingType` varchar(255) DEFAULT NULL COMMENT 'nature of the processed tomogram',
  PRIMARY KEY (`processedTomogramId`),
  KEY `tomogramId` (`tomogramId`),
  CONSTRAINT `ProcessedTomogram_ibfk_1` FOREIGN KEY (`tomogramId`) REFERENCES `Tomogram` (`tomogramId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Indicates the sample''s location on a multi-sample pin, where 1 is closest to the pin base or a sample''s position in a cryo-EM cassette';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProcessedTomogram`
--

LOCK TABLES `ProcessedTomogram` WRITE;
/*!40000 ALTER TABLE `ProcessedTomogram` DISABLE KEYS */;
INSERT INTO `ProcessedTomogram` VALUES
(1,3,'/dls/test.denoised.mrc','Denoised'),
(2,3,'/dls/test.denoised_segmented.mrc','Segmented'),
(3,3,'/dls/test.picked.cbox','Picked');
/*!40000 ALTER TABLE `ProcessedTomogram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProcessingJob`
--

DROP TABLE IF EXISTS `ProcessingJob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProcessingJob` (
  `processingJobId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned DEFAULT NULL,
  `displayName` varchar(80) DEFAULT NULL COMMENT 'xia2, fast_dp, dimple, etc',
  `comments` varchar(255) DEFAULT NULL COMMENT 'For users to annotate the job and see the motivation for the job',
  `recordTimestamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'When job was submitted',
  `recipe` varchar(50) DEFAULT NULL COMMENT 'What we want to run (xia, dimple, etc).',
  `automatic` tinyint(1) DEFAULT NULL COMMENT 'Whether this processing job was triggered automatically or not',
  PRIMARY KEY (`processingJobId`),
  KEY `ProcessingJob_ibfk1` (`dataCollectionId`),
  CONSTRAINT `ProcessingJob_ibfk1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`)
) ENGINE=InnoDB AUTO_INCREMENT=3990 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='From this we get both job times and lag times';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProcessingJob`
--

LOCK TABLES `ProcessingJob` WRITE;
/*!40000 ALTER TABLE `ProcessingJob` DISABLE KEYS */;
INSERT INTO `ProcessingJob` VALUES
(5,1002287,'test job 01','Testing the job submission system','2017-10-16 11:02:12','DIALS/xia2',0),
(6,6017406,NULL,NULL,'2022-11-14 14:02:14',NULL,0),
(7,6017408,NULL,NULL,'2022-11-16 13:19:56',NULL,0),
(8,6017409,NULL,NULL,'2022-11-16 15:47:00',NULL,0),
(9,6017411,NULL,NULL,'2022-11-25 14:40:33',NULL,0),
(10,6017412,NULL,NULL,'2022-11-30 09:06:02',NULL,0),
(17,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 08:26:49','em-tomo-align-reproc',NULL),
(18,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 09:44:48','em-tomo-align-reproc',NULL),
(19,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 09:46:06','em-tomo-align-reproc',NULL),
(20,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 09:49:47','em-tomo-align-reproc',NULL),
(21,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 09:50:01','em-tomo-align-reproc',NULL),
(22,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 09:53:41','em-tomo-align-reproc',NULL),
(23,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 09:53:49','em-tomo-align-reproc',NULL),
(36,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:25:29','em-tomo-align-reproc',NULL),
(38,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:31:50','em-tomo-align-reproc',NULL),
(39,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:32:51','em-tomo-align-reproc',NULL),
(40,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:33:05','em-tomo-align-reproc',NULL),
(41,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:33:49','em-tomo-align-reproc',NULL),
(42,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:36:31','em-tomo-align-reproc',NULL),
(43,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:44:46','em-tomo-align-reproc',NULL),
(44,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:45:45','em-tomo-align-reproc',NULL),
(45,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:47:37','em-tomo-align-reproc',NULL),
(46,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:48:06','em-tomo-align-reproc',NULL),
(47,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:49:37','em-tomo-align-reproc',NULL),
(48,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:50:39','em-tomo-align-reproc',NULL),
(49,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:54:50','em-tomo-align-reproc',NULL),
(50,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:55:39','em-tomo-align-reproc',NULL),
(51,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 10:55:50','em-spa-refine',NULL),
(52,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 12:53:58','em-spa-class3d',NULL),
(53,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 12:54:08','em-spa-class2d',NULL),
(54,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 12:54:31','em-spa-preprocess',NULL),
(55,6017406,'Tomogram Reconstruction',NULL,'2023-02-14 12:54:42','em-tomo-align-reproc',NULL),
(1265,6017413,'Tomogram Reconstruction',NULL,'2023-02-14 12:54:42','em-tomo-align-reproc',NULL);
/*!40000 ALTER TABLE `ProcessingJob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProcessingJobImageSweep`
--

DROP TABLE IF EXISTS `ProcessingJobImageSweep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProcessingJobImageSweep` (
  `processingJobImageSweepId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `processingJobId` int(11) unsigned DEFAULT NULL,
  `dataCollectionId` int(11) unsigned DEFAULT NULL,
  `startImage` mediumint(8) unsigned DEFAULT NULL,
  `endImage` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`processingJobImageSweepId`),
  KEY `ProcessingJobImageSweep_ibfk1` (`processingJobId`),
  KEY `ProcessingJobImageSweep_ibfk2` (`dataCollectionId`),
  CONSTRAINT `ProcessingJobImageSweep_ibfk1` FOREIGN KEY (`processingJobId`) REFERENCES `ProcessingJob` (`processingJobId`),
  CONSTRAINT `ProcessingJobImageSweep_ibfk2` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='This allows multiple sweeps per processing job for multi-xia2';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProcessingJobImageSweep`
--

LOCK TABLES `ProcessingJobImageSweep` WRITE;
/*!40000 ALTER TABLE `ProcessingJobImageSweep` DISABLE KEYS */;
INSERT INTO `ProcessingJobImageSweep` VALUES
(5,5,1002287,1,270),
(8,5,1002287,271,360);
/*!40000 ALTER TABLE `ProcessingJobImageSweep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProcessingJobParameter`
--

DROP TABLE IF EXISTS `ProcessingJobParameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProcessingJobParameter` (
  `processingJobParameterId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `processingJobId` int(11) unsigned DEFAULT NULL,
  `parameterKey` varchar(80) DEFAULT NULL COMMENT 'E.g. resolution, spacegroup, pipeline',
  `parameterValue` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`processingJobParameterId`),
  KEY `ProcessingJobParameter_ibfk1` (`processingJobId`),
  KEY `ProcessingJobParameter_idx_paramKey_procJobId` (`parameterKey`,`processingJobId`),
  CONSTRAINT `ProcessingJobParameter_ibfk1` FOREIGN KEY (`processingJobId`) REFERENCES `ProcessingJob` (`processingJobId`)
) ENGINE=InnoDB AUTO_INCREMENT=27355 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProcessingJobParameter`
--

LOCK TABLES `ProcessingJobParameter` WRITE;
/*!40000 ALTER TABLE `ProcessingJobParameter` DISABLE KEYS */;
INSERT INTO `ProcessingJobParameter` VALUES
(5,5,'vortex factor','1.8*10^102'),
(8,5,'80s factor','0.87*10^-93');
/*!40000 ALTER TABLE `ProcessingJobParameter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProcessingPipeline`
--

DROP TABLE IF EXISTS `ProcessingPipeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProcessingPipeline` (
  `processingPipelineId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `processingPipelineCategoryId` int(11) unsigned DEFAULT NULL,
  `name` varchar(20) NOT NULL,
  `discipline` varchar(10) NOT NULL,
  `pipelineStatus` enum('automatic','optional','deprecated') DEFAULT NULL COMMENT 'Is the pipeline in operation or available',
  `reprocessing` tinyint(1) DEFAULT 1 COMMENT 'Pipeline is available for re-processing',
  PRIMARY KEY (`processingPipelineId`),
  KEY `ProcessingPipeline_fk1` (`processingPipelineCategoryId`),
  CONSTRAINT `ProcessingPipeline_fk1` FOREIGN KEY (`processingPipelineCategoryId`) REFERENCES `ProcessingPipelineCategory` (`processingPipelineCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='A lookup table for different processing pipelines and their categories';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProcessingPipeline`
--

LOCK TABLES `ProcessingPipeline` WRITE;
/*!40000 ALTER TABLE `ProcessingPipeline` DISABLE KEYS */;
INSERT INTO `ProcessingPipeline` VALUES
(1,1,'Mosflm','MX','automatic',0),
(2,1,'EDNA','MX','automatic',0),
(3,2,'Fast DP','MX','automatic',1),
(4,2,'xia2/3dii','MX','deprecated',0),
(5,2,'xia2/Multiplex','MX','automatic',1),
(6,2,'xia2/DIALS','MX','optional',1),
(7,2,'xia2/XDS','MX','optional',1),
(8,2,'autoPROC','MX','optional',1),
(9,3,'Fast EP','MX','automatic',0),
(10,3,'Dimple','MX','automatic',0),
(11,3,'MrBUMP','MX','automatic',0),
(12,3,'Big EP/XDS','MX','automatic',0),
(13,3,'Big EP/DIALS','MX','automatic',0);
/*!40000 ALTER TABLE `ProcessingPipeline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProcessingPipelineCategory`
--

DROP TABLE IF EXISTS `ProcessingPipelineCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProcessingPipelineCategory` (
  `processingPipelineCategoryId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`processingPipelineCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='A lookup table for the category of processing pipeline';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProcessingPipelineCategory`
--

LOCK TABLES `ProcessingPipelineCategory` WRITE;
/*!40000 ALTER TABLE `ProcessingPipelineCategory` DISABLE KEYS */;
INSERT INTO `ProcessingPipelineCategory` VALUES
(1,'screening'),
(2,'processing'),
(3,'post processing');
/*!40000 ALTER TABLE `ProcessingPipelineCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project`
--

DROP TABLE IF EXISTS `Project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project` (
  `projectId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `personId` int(11) unsigned DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `acronym` varchar(100) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`projectId`),
  KEY `Project_FK1` (`personId`),
  CONSTRAINT `Project_FK1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project`
--

LOCK TABLES `Project` WRITE;
/*!40000 ALTER TABLE `Project` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_BLSample`
--

DROP TABLE IF EXISTS `Project_has_BLSample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_BLSample` (
  `projectId` int(11) unsigned NOT NULL,
  `blSampleId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`projectId`,`blSampleId`),
  KEY `Project_has_BLSample_FK2` (`blSampleId`),
  CONSTRAINT `Project_has_BLSample_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Project_has_BLSample_FK2` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_BLSample`
--

LOCK TABLES `Project_has_BLSample` WRITE;
/*!40000 ALTER TABLE `Project_has_BLSample` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_BLSample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_DCGroup`
--

DROP TABLE IF EXISTS `Project_has_DCGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_DCGroup` (
  `projectId` int(11) unsigned NOT NULL,
  `dataCollectionGroupId` int(11) NOT NULL,
  PRIMARY KEY (`projectId`,`dataCollectionGroupId`),
  KEY `Project_has_DCGroup_FK2` (`dataCollectionGroupId`),
  CONSTRAINT `Project_has_DCGroup_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Project_has_DCGroup_FK2` FOREIGN KEY (`dataCollectionGroupId`) REFERENCES `DataCollectionGroup` (`dataCollectionGroupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_DCGroup`
--

LOCK TABLES `Project_has_DCGroup` WRITE;
/*!40000 ALTER TABLE `Project_has_DCGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_DCGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_EnergyScan`
--

DROP TABLE IF EXISTS `Project_has_EnergyScan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_EnergyScan` (
  `projectId` int(11) unsigned NOT NULL,
  `energyScanId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`projectId`,`energyScanId`),
  KEY `project_has_energyscan_FK2` (`energyScanId`),
  CONSTRAINT `project_has_energyscan_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `project_has_energyscan_FK2` FOREIGN KEY (`energyScanId`) REFERENCES `EnergyScan` (`energyScanId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_EnergyScan`
--

LOCK TABLES `Project_has_EnergyScan` WRITE;
/*!40000 ALTER TABLE `Project_has_EnergyScan` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_EnergyScan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_Person`
--

DROP TABLE IF EXISTS `Project_has_Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_Person` (
  `projectId` int(11) unsigned NOT NULL,
  `personId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`projectId`,`personId`),
  KEY `project_has_person_FK2` (`personId`),
  CONSTRAINT `project_has_person_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE,
  CONSTRAINT `project_has_person_FK2` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_Person`
--

LOCK TABLES `Project_has_Person` WRITE;
/*!40000 ALTER TABLE `Project_has_Person` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_Protein`
--

DROP TABLE IF EXISTS `Project_has_Protein`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_Protein` (
  `projectId` int(11) unsigned NOT NULL,
  `proteinId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`projectId`,`proteinId`),
  KEY `project_has_protein_FK2` (`proteinId`),
  CONSTRAINT `project_has_protein_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE,
  CONSTRAINT `project_has_protein_FK2` FOREIGN KEY (`proteinId`) REFERENCES `Protein` (`proteinId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_Protein`
--

LOCK TABLES `Project_has_Protein` WRITE;
/*!40000 ALTER TABLE `Project_has_Protein` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_Protein` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_Session`
--

DROP TABLE IF EXISTS `Project_has_Session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_Session` (
  `projectId` int(11) unsigned NOT NULL,
  `sessionId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`projectId`,`sessionId`),
  KEY `project_has_session_FK2` (`sessionId`),
  CONSTRAINT `project_has_session_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `project_has_session_FK2` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_Session`
--

LOCK TABLES `Project_has_Session` WRITE;
/*!40000 ALTER TABLE `Project_has_Session` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_Session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_Shipping`
--

DROP TABLE IF EXISTS `Project_has_Shipping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_Shipping` (
  `projectId` int(11) unsigned NOT NULL,
  `shippingId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`projectId`,`shippingId`),
  KEY `project_has_shipping_FK2` (`shippingId`),
  CONSTRAINT `project_has_shipping_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE,
  CONSTRAINT `project_has_shipping_FK2` FOREIGN KEY (`shippingId`) REFERENCES `Shipping` (`shippingId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_Shipping`
--

LOCK TABLES `Project_has_Shipping` WRITE;
/*!40000 ALTER TABLE `Project_has_Shipping` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_Shipping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_User`
--

DROP TABLE IF EXISTS `Project_has_User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_User` (
  `projecthasuserid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `projectid` int(11) unsigned NOT NULL,
  `username` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`projecthasuserid`),
  KEY `Project_Has_user_FK1` (`projectid`),
  CONSTRAINT `Project_Has_user_FK1` FOREIGN KEY (`projectid`) REFERENCES `Project` (`projectId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_User`
--

LOCK TABLES `Project_has_User` WRITE;
/*!40000 ALTER TABLE `Project_has_User` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project_has_XFEFSpectrum`
--

DROP TABLE IF EXISTS `Project_has_XFEFSpectrum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project_has_XFEFSpectrum` (
  `projectId` int(11) unsigned NOT NULL,
  `xfeFluorescenceSpectrumId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`projectId`,`xfeFluorescenceSpectrumId`),
  KEY `project_has_xfefspectrum_FK2` (`xfeFluorescenceSpectrumId`),
  CONSTRAINT `project_has_xfefspectrum_FK1` FOREIGN KEY (`projectId`) REFERENCES `Project` (`projectId`) ON DELETE CASCADE,
  CONSTRAINT `project_has_xfefspectrum_FK2` FOREIGN KEY (`xfeFluorescenceSpectrumId`) REFERENCES `XFEFluorescenceSpectrum` (`xfeFluorescenceSpectrumId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project_has_XFEFSpectrum`
--

LOCK TABLES `Project_has_XFEFSpectrum` WRITE;
/*!40000 ALTER TABLE `Project_has_XFEFSpectrum` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project_has_XFEFSpectrum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Proposal`
--

DROP TABLE IF EXISTS `Proposal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Proposal` (
  `proposalId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `personId` int(10) unsigned NOT NULL DEFAULT 0,
  `title` varchar(200) DEFAULT NULL,
  `proposalCode` varchar(45) DEFAULT NULL,
  `proposalNumber` varchar(45) DEFAULT NULL,
  `bltimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `proposalType` varchar(2) DEFAULT NULL COMMENT 'Proposal type: MX, BX',
  `externalId` binary(16) DEFAULT NULL,
  `state` enum('Open','Closed','Cancelled') DEFAULT 'Open',
  PRIMARY KEY (`proposalId`),
  UNIQUE KEY `Proposal_FKIndexCodeNumber` (`proposalCode`,`proposalNumber`),
  KEY `Proposal_FKIndex1` (`personId`),
  CONSTRAINT `Proposal_ibfk_1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1000622 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proposal`
--

LOCK TABLES `Proposal` WRITE;
/*!40000 ALTER TABLE `Proposal` DISABLE KEYS */;
INSERT INTO `Proposal` VALUES
(37027,1,'I03 Commissioning Directory 2016','cm','14451','2015-12-21 15:20:43',NULL,NULL,'Open'),
(60858,18549,'Software commissioning 2022 visits for all EM','cm','31111','2021-12-14 14:50:02',NULL,NULL,'Open'),
(141666,46266,'Test Proposal cm-0001','cm','1','2016-03-16 16:01:34',NULL,NULL,'Open'),
(999999,1,'Test Proposal bi-0001','bi','8','2021-12-14 14:50:02',NULL,NULL,'Open'),
(1000024,1,'Proposal with shipment','cm','33333','2024-12-09 16:54:31',NULL,NULL,'Open'),
(1000028,1,'Proposal with null session','cm','22222','2024-12-09 16:56:33',NULL,NULL,'Open'),
(1000327,46435,'Industrial proposal','in','1','2025-04-24 10:10:43',NULL,NULL,'Open');
/*!40000 ALTER TABLE `Proposal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProposalHasPerson`
--

DROP TABLE IF EXISTS `ProposalHasPerson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProposalHasPerson` (
  `proposalHasPersonId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `proposalId` int(10) unsigned NOT NULL,
  `personId` int(10) unsigned NOT NULL,
  `role` enum('Co-Investigator','Principal Investigator','Alternate Contact','ERA Admin','Associate') DEFAULT NULL,
  PRIMARY KEY (`proposalHasPersonId`),
  KEY `fk_ProposalHasPerson_Proposal` (`proposalId`),
  KEY `fk_ProposalHasPerson_Personal` (`personId`),
  CONSTRAINT `fk_ProposalHasPerson_Personal` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ProposalHasPerson_Proposal` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProposalHasPerson`
--

LOCK TABLES `ProposalHasPerson` WRITE;
/*!40000 ALTER TABLE `ProposalHasPerson` DISABLE KEYS */;
INSERT INTO `ProposalHasPerson` VALUES
(4,37027,1,'Principal Investigator'),
(5,60858,18600,'Principal Investigator'),
(6,1000028,1,'Principal Investigator'),
(7,1000327,46435,'Principal Investigator');
/*!40000 ALTER TABLE `ProposalHasPerson` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Protein`
--

DROP TABLE IF EXISTS `Protein`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Protein` (
  `proteinId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `proposalId` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  `acronym` varchar(45) DEFAULT NULL,
  `description` text DEFAULT NULL COMMENT 'A description/summary using words and sentences',
  `hazardGroup` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT 'A.k.a. risk group',
  `containmentLevel` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT 'A.k.a. biosafety level, which indicates the level of containment required',
  `safetyLevel` enum('GREEN','YELLOW','RED') DEFAULT NULL,
  `molecularMass` double DEFAULT NULL,
  `proteinType` varchar(45) DEFAULT NULL,
  `personId` int(10) unsigned DEFAULT NULL,
  `bltimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `isCreatedBySampleSheet` tinyint(1) DEFAULT 0,
  `sequence` text DEFAULT NULL,
  `MOD_ID` varchar(20) DEFAULT NULL,
  `componentTypeId` int(11) unsigned DEFAULT NULL,
  `concentrationTypeId` int(11) unsigned DEFAULT NULL,
  `global` tinyint(1) DEFAULT 0,
  `externalId` binary(16) DEFAULT NULL,
  `density` float DEFAULT NULL,
  `abundance` float DEFAULT NULL COMMENT 'Deprecated',
  `isotropy` enum('isotropic','anisotropic') DEFAULT NULL,
  PRIMARY KEY (`proteinId`),
  KEY `ProteinAcronym_Index` (`proposalId`,`acronym`),
  KEY `Protein_FKIndex2` (`personId`),
  KEY `Protein_Index2` (`acronym`),
  KEY `protein_fk3` (`componentTypeId`),
  KEY `protein_fk4` (`concentrationTypeId`),
  CONSTRAINT `Protein_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `protein_fk3` FOREIGN KEY (`componentTypeId`) REFERENCES `ComponentType` (`componentTypeId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `protein_fk4` FOREIGN KEY (`concentrationTypeId`) REFERENCES `ConcentrationType` (`concentrationTypeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123884 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Protein`
--

LOCK TABLES `Protein` WRITE;
/*!40000 ALTER TABLE `Protein` DISABLE KEYS */;
INSERT INTO `Protein` VALUES
(4380,141666,'Protein 01','PRT-01',NULL,1,1,'GREEN',NULL,NULL,NULL,'2016-03-17 15:57:52',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4383,141666,'Protein 02','PRT-02',NULL,1,1,'GREEN',NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4386,141666,'Protein 03','PRT-03',NULL,1,1,'YELLOW',NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4389,141666,'Protein 04','PRT-04',NULL,1,1,'YELLOW',NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4392,141666,'Protein 05','PRT-05',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4395,141666,'Protein 06','PRT-06',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4398,141666,'Protein 07','PRT-07',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4401,141666,'Protein 08','PRT-08',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4404,141666,'Protein 09','PRT-09',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4407,141666,'Protein 10','PRT-10',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4410,141666,'Protein 11','PRT-11',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(4413,141666,'LSCF.1','LSCF',NULL,1,1,NULL,NULL,NULL,NULL,'2016-03-17 16:02:07',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(121393,37027,'therm','therm',NULL,1,1,NULL,NULL,NULL,NULL,'2016-01-13 13:50:20',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),
(123491,37027,NULL,'thau',NULL,1,1,NULL,NULL,NULL,NULL,'2016-02-24 12:12:16',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(123497,37027,'XPDF comp1','xpdf-comp-01',NULL,1,1,NULL,NULL,NULL,NULL,'2017-03-23 22:03:40',0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Protein` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Protein_has_PDB`
--

DROP TABLE IF EXISTS `Protein_has_PDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Protein_has_PDB` (
  `proteinhaspdbid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `proteinid` int(11) unsigned NOT NULL,
  `pdbid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`proteinhaspdbid`),
  KEY `Protein_Has_PDB_fk1` (`proteinid`),
  KEY `Protein_Has_PDB_fk2` (`pdbid`),
  CONSTRAINT `Protein_Has_PDB_fk1` FOREIGN KEY (`proteinid`) REFERENCES `Protein` (`proteinId`),
  CONSTRAINT `Protein_Has_PDB_fk2` FOREIGN KEY (`pdbid`) REFERENCES `PDB` (`pdbId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Protein_has_PDB`
--

LOCK TABLES `Protein_has_PDB` WRITE;
/*!40000 ALTER TABLE `Protein_has_PDB` DISABLE KEYS */;
INSERT INTO `Protein_has_PDB` VALUES
(5,123497,6);
/*!40000 ALTER TABLE `Protein_has_PDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PurificationColumn`
--

DROP TABLE IF EXISTS `PurificationColumn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PurificationColumn` (
  `purificationColumnId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1 COMMENT '1=active, 0=inactive',
  PRIMARY KEY (`purificationColumnId`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Size exclusion chromotography (SEC) lookup table for BioSAXS';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PurificationColumn`
--

LOCK TABLES `PurificationColumn` WRITE;
/*!40000 ALTER TABLE `PurificationColumn` DISABLE KEYS */;
INSERT INTO `PurificationColumn` VALUES
(1,'user supplied',1),
(2,'s75',1),
(3,'s200',1),
(4,'superose6',1),
(5,'kw402.5',1),
(6,'kw403',1),
(7,'kw404',1),
(8,'kw405',1);
/*!40000 ALTER TABLE `PurificationColumn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RelativeIceThickness`
--

DROP TABLE IF EXISTS `RelativeIceThickness`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RelativeIceThickness` (
  `relativeIceThicknessId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `motionCorrectionId` int(11) unsigned DEFAULT NULL,
  `autoProcProgramId` int(11) unsigned DEFAULT NULL,
  `minimum` float DEFAULT NULL COMMENT 'Minimum relative ice thickness, Unitless',
  `q1` float DEFAULT NULL COMMENT 'Quartile 1, unitless',
  `median` float DEFAULT NULL COMMENT 'Median relative ice thickness, Unitless',
  `q3` float DEFAULT NULL COMMENT 'Quartile 3, unitless',
  `maximum` float DEFAULT NULL COMMENT 'Minimum relative ice thickness, Unitless',
  PRIMARY KEY (`relativeIceThicknessId`),
  KEY `RelativeIceThickness_fk_programId` (`autoProcProgramId`),
  KEY `RelativeIceThickness_fk_motionCorrectionId` (`motionCorrectionId`),
  CONSTRAINT `RelativeIceThickness_fk_motionCorrectionId` FOREIGN KEY (`motionCorrectionId`) REFERENCES `MotionCorrection` (`motionCorrectionId`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RelativeIceThickness_fk_programId` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RelativeIceThickness`
--

LOCK TABLES `RelativeIceThickness` WRITE;
/*!40000 ALTER TABLE `RelativeIceThickness` DISABLE KEYS */;
INSERT INTO `RelativeIceThickness` VALUES
(1,23,56986680,1,2,3,4,5),
(2,24,56986680,2,2,3,4,5),
(3,26,56986680,3,4,5,6,7),
(4,25,56986680,3,2,4,4,5);
/*!40000 ALTER TABLE `RelativeIceThickness` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RobotAction`
--

DROP TABLE IF EXISTS `RobotAction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RobotAction` (
  `robotActionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blsessionId` int(11) unsigned NOT NULL,
  `blsampleId` int(11) unsigned DEFAULT NULL,
  `actionType` enum('LOAD','UNLOAD','DISPOSE','STORE','WASH','ANNEAL','MOSAIC') DEFAULT NULL,
  `startTimestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `endTimestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` enum('SUCCESS','ERROR','CRITICAL','WARNING','EPICSFAIL','COMMANDNOTSENT') DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `containerLocation` smallint(6) DEFAULT NULL,
  `dewarLocation` smallint(6) DEFAULT NULL,
  `sampleBarcode` varchar(45) DEFAULT NULL,
  `xtalSnapshotBefore` varchar(255) DEFAULT NULL,
  `xtalSnapshotAfter` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`robotActionId`),
  KEY `RobotAction_FK1` (`blsessionId`),
  KEY `RobotAction_FK2` (`blsampleId`),
  CONSTRAINT `RobotAction_FK1` FOREIGN KEY (`blsessionId`) REFERENCES `BLSession` (`sessionId`),
  CONSTRAINT `RobotAction_FK2` FOREIGN KEY (`blsampleId`) REFERENCES `BLSample` (`blSampleId`)
) ENGINE=InnoDB AUTO_INCREMENT=584 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Robot actions as reported by GDA';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RobotAction`
--

LOCK TABLES `RobotAction` WRITE;
/*!40000 ALTER TABLE `RobotAction` DISABLE KEYS */;
INSERT INTO `RobotAction` VALUES
(14,27464088,NULL,'LOAD','2024-03-14 11:44:06','2024-02-29 13:02:32','SUCCESS','string',0,0,'string','/dls/file.png','/dls/file.png'),
(18,27464088,NULL,'LOAD','2024-03-14 11:44:06','2024-02-29 13:02:32','SUCCESS','longstring',0,0,'string','/dls/file.png','/dls/file.png');
/*!40000 ALTER TABLE `RobotAction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SSXDataCollection`
--

DROP TABLE IF EXISTS `SSXDataCollection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SSXDataCollection` (
  `dataCollectionId` int(11) unsigned NOT NULL COMMENT 'Primary key is same as dataCollection (1 to 1).',
  `repetitionRate` float DEFAULT NULL,
  `energyBandwidth` float DEFAULT NULL,
  `monoStripe` varchar(255) DEFAULT NULL,
  `jetSpeed` float DEFAULT NULL COMMENT 'For jet experiments.',
  `jetSize` float DEFAULT NULL COMMENT 'For jet experiments.',
  `chipPattern` varchar(255) DEFAULT NULL COMMENT 'For chip experiments.',
  `chipModel` varchar(255) DEFAULT NULL COMMENT 'For chip experiments.',
  `reactionDuration` float DEFAULT NULL COMMENT 'When images are taken at constant time relative to reaction start.',
  `laserEnergy` float DEFAULT NULL,
  `experimentName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dataCollectionId`),
  CONSTRAINT `SSXDataCollection_ibfk_1` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Extends DataCollection with SSX-specific fields.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SSXDataCollection`
--

LOCK TABLES `SSXDataCollection` WRITE;
/*!40000 ALTER TABLE `SSXDataCollection` DISABLE KEYS */;
/*!40000 ALTER TABLE `SSXDataCollection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SW_onceToken`
--

DROP TABLE IF EXISTS `SW_onceToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SW_onceToken` (
  `onceTokenId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(128) DEFAULT NULL,
  `personId` int(10) unsigned DEFAULT NULL,
  `proposalId` int(10) unsigned DEFAULT NULL,
  `validity` varchar(200) DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`onceTokenId`),
  KEY `SW_onceToken_fk1` (`personId`),
  KEY `SW_onceToken_fk2` (`proposalId`),
  KEY `SW_onceToken_recordTimeStamp_idx` (`recordTimeStamp`),
  CONSTRAINT `SW_onceToken_fk1` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`),
  CONSTRAINT `SW_onceToken_fk2` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='One-time use tokens needed for token auth in order to grant access to file downloads and webcams (and some images)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SW_onceToken`
--

LOCK TABLES `SW_onceToken` WRITE;
/*!40000 ALTER TABLE `SW_onceToken` DISABLE KEYS */;
/*!40000 ALTER TABLE `SW_onceToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SampleComposition`
--

DROP TABLE IF EXISTS `SampleComposition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SampleComposition` (
  `sampleCompositionId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `componentId` int(11) unsigned NOT NULL,
  `blSampleId` int(11) unsigned NOT NULL,
  `concentrationTypeId` int(11) unsigned DEFAULT NULL,
  `abundance` float DEFAULT NULL COMMENT 'Abundance or concentration in the unit defined by concentrationTypeId.',
  `ratio` float DEFAULT NULL,
  `pH` float DEFAULT NULL,
  PRIMARY KEY (`sampleCompositionId`),
  KEY `componentId` (`componentId`),
  KEY `blSampleId` (`blSampleId`),
  KEY `concentrationTypeId` (`concentrationTypeId`),
  CONSTRAINT `SampleComposition_ibfk_1` FOREIGN KEY (`componentId`) REFERENCES `Component` (`componentId`),
  CONSTRAINT `SampleComposition_ibfk_2` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`),
  CONSTRAINT `SampleComposition_ibfk_3` FOREIGN KEY (`concentrationTypeId`) REFERENCES `ConcentrationType` (`concentrationTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Links a sample to its components with a specified abundance or ratio.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SampleComposition`
--

LOCK TABLES `SampleComposition` WRITE;
/*!40000 ALTER TABLE `SampleComposition` DISABLE KEYS */;
/*!40000 ALTER TABLE `SampleComposition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScanParametersModel`
--

DROP TABLE IF EXISTS `ScanParametersModel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScanParametersModel` (
  `scanParametersModelId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `scanParametersServiceId` int(10) unsigned DEFAULT NULL,
  `dataCollectionPlanId` int(11) unsigned DEFAULT NULL,
  `sequenceNumber` tinyint(3) unsigned DEFAULT NULL,
  `start` double DEFAULT NULL,
  `stop` double DEFAULT NULL,
  `step` double DEFAULT NULL,
  `array` text DEFAULT NULL,
  `duration` mediumint(8) unsigned DEFAULT NULL COMMENT 'Duration for parameter change in seconds',
  PRIMARY KEY (`scanParametersModelId`),
  KEY `PDF_Model_ibfk1` (`scanParametersServiceId`),
  KEY `PDF_Model_ibfk2` (`dataCollectionPlanId`),
  CONSTRAINT `PDF_Model_ibfk1` FOREIGN KEY (`scanParametersServiceId`) REFERENCES `ScanParametersService` (`scanParametersServiceId`) ON UPDATE CASCADE,
  CONSTRAINT `PDF_Model_ibfk2` FOREIGN KEY (`dataCollectionPlanId`) REFERENCES `DiffractionPlan` (`diffractionPlanId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScanParametersModel`
--

LOCK TABLES `ScanParametersModel` WRITE;
/*!40000 ALTER TABLE `ScanParametersModel` DISABLE KEYS */;
INSERT INTO `ScanParametersModel` VALUES
(4,4,197788,1,0,90,10,NULL,NULL),
(7,4,197788,2,90,180,5,NULL,NULL),
(10,4,197788,3,180,270,1,NULL,NULL),
(13,4,197788,3,270,360,0.5,NULL,NULL),
(16,7,197788,4,20,120,10,NULL,NULL),
(20,7,197792,1,0,90,5,NULL,NULL),
(23,7,197792,2,90,120,1,NULL,NULL);
/*!40000 ALTER TABLE `ScanParametersModel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScanParametersService`
--

DROP TABLE IF EXISTS `ScanParametersService`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScanParametersService` (
  `scanParametersServiceId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`scanParametersServiceId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScanParametersService`
--

LOCK TABLES `ScanParametersService` WRITE;
/*!40000 ALTER TABLE `ScanParametersService` DISABLE KEYS */;
INSERT INTO `ScanParametersService` VALUES
(4,'Temperature','Temperature in Celsius'),
(7,'Pressure','Pressure in pascal (Pa)');
/*!40000 ALTER TABLE `ScanParametersService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Schedule`
--

DROP TABLE IF EXISTS `Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Schedule` (
  `scheduleId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`scheduleId`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Schedule`
--

LOCK TABLES `Schedule` WRITE;
/*!40000 ALTER TABLE `Schedule` DISABLE KEYS */;
INSERT INTO `Schedule` VALUES
(1,'Daily - 1 week'),
(2,'Schedule 2'),
(11,'Fibonacci'),
(15,'3 Hour Interval');
/*!40000 ALTER TABLE `Schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScheduleComponent`
--

DROP TABLE IF EXISTS `ScheduleComponent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScheduleComponent` (
  `scheduleComponentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `scheduleId` int(11) unsigned NOT NULL,
  `offset_hours` int(11) DEFAULT NULL,
  `inspectionTypeId` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`scheduleComponentId`),
  KEY `ScheduleComponent_idx1` (`scheduleId`),
  KEY `ScheduleComponent_fk2` (`inspectionTypeId`),
  CONSTRAINT `ScheduleComponent_fk1` FOREIGN KEY (`scheduleId`) REFERENCES `Schedule` (`scheduleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ScheduleComponent_fk2` FOREIGN KEY (`inspectionTypeId`) REFERENCES `InspectionType` (`inspectionTypeId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScheduleComponent`
--

LOCK TABLES `ScheduleComponent` WRITE;
/*!40000 ALTER TABLE `ScheduleComponent` DISABLE KEYS */;
INSERT INTO `ScheduleComponent` VALUES
(1,1,0,1),
(2,1,12,1),
(3,1,24,1),
(4,1,96,1),
(5,1,48,1),
(6,1,72,1),
(8,2,24,1),
(11,2,48,2),
(14,11,0,1),
(17,11,12,1),
(20,11,24,1),
(23,11,36,1),
(26,11,60,1),
(29,11,96,1),
(32,11,156,1),
(35,11,252,1),
(38,11,408,1),
(41,11,660,1),
(44,11,1068,1),
(47,11,1728,1),
(50,11,2796,1),
(54,15,3,1),
(57,15,6,1),
(60,15,9,1),
(63,15,12,1),
(66,15,18,1),
(69,15,24,1),
(72,15,30,1),
(75,15,36,1),
(78,15,42,1),
(81,15,48,1),
(84,1,120,1),
(87,1,144,1),
(90,1,168,1),
(93,1,336,1),
(96,1,504,1);
/*!40000 ALTER TABLE `ScheduleComponent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SchemaStatus`
--

DROP TABLE IF EXISTS `SchemaStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SchemaStatus` (
  `schemaStatusId` int(11) NOT NULL AUTO_INCREMENT,
  `scriptName` varchar(100) NOT NULL,
  `schemaStatus` varchar(10) DEFAULT NULL,
  `recordTimeStamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`schemaStatusId`),
  UNIQUE KEY `scriptName` (`scriptName`)
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SchemaStatus`
--

LOCK TABLES `SchemaStatus` WRITE;
/*!40000 ALTER TABLE `SchemaStatus` DISABLE KEYS */;
INSERT INTO `SchemaStatus` VALUES
(6,'20180213_BLSample_subLocation.sql','DONE','2018-02-13 13:27:19'),
(12,'20180213_DataCollectionFileAttachment_fileType.sql','DONE','2018-02-13 15:12:54'),
(16,'20180303_v_run_to_table.sql','DONE','2018-07-25 15:11:18'),
(19,'20180328_ImageQualityIndicators_alter_table.sql','DONE','2018-07-25 15:11:18'),
(22,'20180410_BeamLineSetup_alter.sql','DONE','2018-07-25 15:11:18'),
(25,'20180413_BeamLineSetup_and_Detector_alter.sql','DONE','2018-07-25 15:11:18'),
(28,'20180501_DataCollectionGroup_experimentType_enum.sql','DONE','2018-07-25 15:11:18'),
(31,'20180531_ScreeningOutput_alignmentSuccess.sql','DONE','2018-07-25 15:11:18'),
(34,'20180629_DataCollection_imageContainerSubPath.sql','DONE','2018-07-25 15:11:18'),
(35,'20180913_BeamCalendar.sql','DONE','2018-09-19 09:52:45'),
(36,'2018_09_19_DataCollection_imageDirectory_comment.sql','DONE','2018-09-19 12:38:01'),
(37,'2018_09_27_increase_schema_version.sql','DONE','2018-09-27 13:17:15'),
(38,'2018_11_01_XrayCenteringResult.sql','DONE','2018-11-01 13:36:53'),
(39,'2018_11_01_AutoProcProgram_dataCollectionId.sql','DONE','2018-11-01 15:10:38'),
(40,'2018_11_01_AutoProcProgramMessage.sql','DONE','2018-11-01 15:28:17'),
(44,'2018_11_01_DiffractionPlan_centeringMethod.sql','DONE','2018-11-01 22:51:36'),
(45,'2018_11_02_DataCollectionGroup_experimentType_enum.sql','DONE','2018-11-02 11:54:15'),
(47,'2018_11_05_spelling_of_centring.sql','DONE','2018-11-05 15:31:38'),
(48,'2018_11_09_AutoProcProgram_update_processing_program.sql','DONE','2018-11-09 16:38:34'),
(49,'2018_11_14_AutoProcProgramMessage_autoinc.sql','DONE','2018-11-14 10:15:27'),
(50,'2018_11_22_AutoProcProgram_processingStatus_update.sql','DONE','2018-11-22 16:11:15'),
(51,'2018_12_04_EnergyScan_and_XFEFluorescenceSpectrum_add_axisPosition.sql','DONE','2018-12-04 14:13:23'),
(52,'2018_12_20_DataCollectionGroup_scanParameters.sql','DONE','2018-12-20 17:30:04'),
(53,'2019_01_14_Proposal_state.sql','DONE','2019-01-14 12:13:31'),
(54,'2019_01_14_ProcessingJobParameter_parameterValue.sql','DONE','2019-01-14 14:00:02'),
(57,'2019_01_15_Detector_localName.sql','DONE','2019-01-15 23:01:15'),
(58,'2019_02_04_BLSession_unique_index.sql','DONE','2019-02-04 13:52:19'),
(59,'2019_03_29_BLSession_archived.sql','DONE','2019-04-03 14:43:08'),
(60,'2019_04_03_UserGroup_and_Permission.sql','DONE','2019-04-03 14:51:04'),
(61,'2019_04_07_AdminVar_bump_version.sql','DONE','2019-04-07 11:35:06'),
(62,'2019_04_08_AdminVar_bump_version.sql','DONE','2019-04-08 15:38:01'),
(63,'2019_04_23_AdminVar_bump_version.sql','DONE','2019-04-23 11:13:27'),
(64,'2019_04_23_drop_v_run_view.sql','DONE','2019-04-23 11:13:35'),
(67,'2019_04_23_v_run_additional_runs.sql','DONE','2019-04-23 12:39:47'),
(68,'2019_05_28_AdminVar_bump_version.sql','DONE','2019-05-28 13:29:27'),
(72,'2019_07_17_BLSample_crystalId_default.sql','DONE','2019-07-17 15:21:59'),
(73,'2019_08_15_Sleeve.sql','DONE','2019-08-15 08:34:34'),
(74,'2019_08_15_AdminVar_bump_version.sql','DONE','2019-08-15 08:57:37'),
(75,'2019_08_28_AdminVar_bump_version.sql','DONE','2019-08-28 13:30:13'),
(76,'2019_08_30_AdminVar_bump_version.sql','DONE','2019-08-30 11:58:16'),
(77,'2019_10_06_BLSampleImage_fk3.sql','DONE','2019-10-06 16:55:44'),
(78,'2019_10_08_DiffractionPlan_experimentKind.sql','DONE','2019-10-08 12:47:10'),
(79,'2019_11_07_AutoProcProgramAttachment_importanceRank.sql','DONE','2019-11-07 16:35:25'),
(80,'2019_11_07_AdminVar_bump_version.sql','DONE','2019-11-07 16:45:44'),
(81,'2019_11_08_AdminVar_bump_version.sql','DONE','2019-11-08 16:09:52'),
(82,'2019_11_26_v_run_idx1.sql','DONE','2019-11-26 15:00:21'),
(83,'2019_12_02_AdminVar_bump_version.sql','DONE','2019-12-02 11:29:05'),
(84,'2019_12_02_AdminVar_bump_version_v2.sql','DONE','2019-12-02 18:14:11'),
(85,'2020_01_03_BLSampleImage_tables.sql','DONE','2020-01-03 16:05:45'),
(86,'2020_01_06_AdminVar_bump_version.sql','DONE','2020-01-06 11:45:02'),
(87,'2020_01_07_AdminVar_bump_version.sql','DONE','2020-01-07 09:45:25'),
(88,'2020_01_07_AdminVar_bump_version_v2.sql','DONE','2020-01-07 10:24:54'),
(89,'2020_01_07_AdminVar_bump_version_v3.sql','DONE','2020-01-07 11:16:09'),
(90,'2020_01_20_AdminVar_bump_version.sql','DONE','2020-01-20 13:40:52'),
(91,'2020_01_20_AdminVar_bump_version_v2.sql','DONE','2020-01-20 16:27:37'),
(92,'2020_02_13_SpaceGroup_data.sql','DONE','2020-02-13 16:52:53'),
(93,'2020_01_21_DiffractionPlan_experimentKind.sql','DONE','2020-02-13 17:13:17'),
(94,'2020_02_21_ProposalHasPerson_role_enum.sql','DONE','2020-02-21 14:36:10'),
(95,'2020_02_21_Session_has_Person_role_enum.sql','DONE','2020-02-21 14:36:17'),
(96,'2020_02_27_Container_scLocationUpdated.sql','DONE','2020-02-27 13:43:51'),
(97,'2020_03_09_Reprocessing_drop_tables.sql','DONE','2020-03-09 11:05:09'),
(98,'2020_03_24_ProcessingPipeline_tables.sql','DONE','2020-03-26 16:37:29'),
(99,'2020_03_25_ProcessingPipeline_ren_col.sql','DONE','2020-03-26 16:37:34'),
(100,'2020_03_27_AdminVar_bump_version.sql','DONE','2020-03-27 08:51:52'),
(101,'2020_03_27_AdminVar_bump_version_v2.sql','DONE','2020-03-27 15:07:56'),
(102,'2020_04_06_alterProtein.sql','DONE','2020-04-06 13:40:18'),
(103,'2020_04_27_BLSampleImageAutoScoreSchema_insert_CHIMP.sql','DONE','2020-04-27 14:37:41'),
(104,'2020_05_21_BLSampleImageAutoScoreClass_insert_CHIMP.sql','DONE','2020-05-21 17:52:54'),
(105,'2020_06_01_DewarRegistry_and_DewarRegistry_has_Proposal.sql','DONE','2020-06-01 10:29:19'),
(106,'2020_06_01_Protein_new_columns.sql','DONE','2020-06-01 10:29:32'),
(107,'2020_06_01_AdminVar_bump_version.sql','DONE','2020-06-01 10:46:11'),
(108,'2020_06_08_Shipping_comments.sql','DONE','2020-06-08 16:44:26'),
(109,'2020_06_10_DiffractionPlan_experimentKind.sql','DONE','2020-06-10 14:35:18'),
(110,'2020_06_15_Shipping_comments.sql','DONE','2020-06-15 14:01:25'),
(111,'2020_06_24_BLSampleGroup_name.sql','DONE','2020-06-24 10:56:25'),
(112,'2020_06_24_DiffractionPlan_userPath.sql','DONE','2020-06-24 10:56:30'),
(113,'2020_07_01_DewarRegistry_and_DewarRegistry_has_Proposal.sql','DONE','2020-07-01 13:51:49'),
(114,'2020_07_06_DewarRegistry_to_DewarRegistry_has_Proposal_data.sql','DONE','2020-07-06 10:59:22'),
(115,'2020_07_13_AdminVar_bump_version.sql','DONE','2020-07-13 18:14:39'),
(116,'2020_08_03_AdminVar_bump_version.sql','DONE','2020-08-03 15:19:36'),
(117,'2020_09_02_AutoProcScalingStatistics_new_index.sql','DONE','2020-09-02 17:02:33'),
(118,'2020_09_08_DewarRegistry_modify_fks.sql','DONE','2020-09-08 15:26:14'),
(119,'2020_08_28_ComponentSubType_changes.sql','DONE','2020-10-14 18:15:55'),
(120,'2020_08_28_ConcentrationType_changes.sql','DONE','2020-10-14 18:15:55'),
(121,'2020_08_28_Dewar_type.sql','DONE','2020-10-14 18:15:55'),
(122,'2020_08_28_DiffractionPlan_new_temperature_cols.sql','DONE','2020-10-14 18:15:55'),
(123,'2020_08_28_ExperimentType.sql','DONE','2020-10-14 18:15:55'),
(124,'2020_08_28_PurificationColumn.sql','DONE','2020-10-14 18:15:55'),
(125,'2020_08_29_BLSampleType.sql','DONE','2020-10-14 18:15:55'),
(126,'2020_08_29_Protein_isotropy.sql','DONE','2020-10-14 18:15:55'),
(127,'2020_10_16_AdminVar_bump_version.sql','DONE','2020-10-16 22:05:36'),
(128,'2020_10_19_AdminVar_bump_version.sql','DONE','2020-10-20 04:21:23'),
(129,'2020_10_22_GridInfo_dcId.sql','DONE','2020-11-09 13:57:27'),
(130,'2020_11_09_Phasing_method_enum.sql','DONE','2020-11-09 13:57:27'),
(133,'2020_11_09_AdminVar_bump_version.sql','DONE','2020-11-09 22:26:13'),
(134,'2020_11_10_SpaceGroup_update.sql','DONE','2020-11-20 17:49:46'),
(135,'2020_11_13_Dewar_facilityCode.sql','DONE','2020-11-20 17:49:46'),
(136,'2020_11_20_AdminVar_bump_version.sql','DONE','2020-11-20 17:49:46'),
(137,'2020_12_01_AdminVar_bump_version.sql','DONE','2020-12-01 12:21:43'),
(138,'2020_12_04_Container_experimentTypeId_FK.sql','DONE','2020-12-04 16:34:05'),
(139,'2020_12_04_AdminVar_bump_version.sql','DONE','2020-12-04 16:40:14'),
(140,'2020_11_22_diffractionplan_priority_and_mode.sql','DONE','2020-12-29 18:29:08'),
(141,'2020_12_07_AutoProc_index_unit_cell.sql','DONE','2020-12-29 18:29:08'),
(142,'2020_12_07_DataCollection_index_startTime.sql','DONE','2020-12-29 18:29:08'),
(143,'2020_12_10_BLSubSample_source.sql','DONE','2020-12-29 18:29:08'),
(144,'2020_12_30_AdminVar_bump_version.sql','DONE','2020-12-30 14:36:17'),
(145,'2021_01_13_AdminVar_bump_version.sql','DONE','2021-01-13 12:12:57'),
(146,'2021_01_14_AdminVar_bump_version.sql','DONE','2021-01-14 11:04:57'),
(147,'2020_07_31_add_offset_blsampleimage.sql','DONE','2021-02-22 12:28:16'),
(148,'2020_07_31_add_type_blsubsample.sql','DONE','2021-02-22 12:28:16'),
(149,'2020_07_31_extend_dcattachment_enum.sql','DONE','2021-02-22 12:28:16'),
(150,'2020_07_31_extend_dcg_type_enum.sql','DONE','2021-02-22 12:28:16'),
(151,'2020_07_31_extend_robotaction_enum.sql','DONE','2021-02-22 12:28:16'),
(152,'2020_07_31_refactor_xrfmapping.sql','DONE','2021-02-22 12:28:16'),
(153,'2020_11_22_blsample_staff_comments.sql','DONE','2021-02-22 12:28:16'),
(154,'2021_01_28_beamlinesetup_add_datacentre.sql','DONE','2021-02-22 12:28:16'),
(155,'2021_02_04_DiffractionPlan_strategyOption.sql','DONE','2021-02-22 12:28:16'),
(156,'2021_02_22_AdminVar_bump_version.sql','DONE','2021-02-22 13:06:57'),
(157,'2021_02_22_AdminVar_bump_version_v2.sql','DONE','2021-02-22 15:37:45'),
(158,'2020_08_28_ContainerType.sql','DONE','2021-03-05 16:09:40'),
(159,'2021_03_03_BF_automationError.sql','DONE','2021-03-05 16:09:41'),
(160,'2021_03_03_BF_automationFault.sql','DONE','2021-03-05 16:09:41'),
(161,'2021_03_03_cryoEMv2_0_tables.sql','DONE','2021-03-05 16:09:41'),
(162,'2021_03_05_AdminVar_bump_version.sql','DONE','2021-03-05 16:09:41'),
(163,'2021_03_05_ContainerType_update.sql','DONE','2021-04-13 15:50:39'),
(164,'2021_03_08_ContainerType_update.sql','DONE','2021-04-13 15:50:39'),
(165,'2021_03_09_SpaceGroup_update.sql','DONE','2021-04-13 15:50:39'),
(166,'2021_03_19_add_drop_indices.sql','DONE','2021-04-13 15:50:39'),
(167,'2021_03_19_ExperimentType_update.sql','DONE','2021-04-13 15:50:39'),
(168,'2021_04_01_BLSampleGroup_has_BLSample_modify_type.sql','DONE','2021-04-13 15:50:39'),
(169,'2021_04_01_ContainerType_insert.sql','DONE','2021-04-13 15:50:39'),
(170,'2021_04_12_cryoEMv2_1.sql','DONE','2021-04-13 15:50:39'),
(171,'2021_04_13_AdminVar_bump_version.sql','DONE','2021-04-13 16:17:12'),
(173,'2021_04_13_ContainerType_update.sql','DONE','2021-04-13 16:42:57'),
(174,'2021_04_20_AdminVar_bump_version.sql','DONE','2021-04-20 17:05:50'),
(175,'2020_11_19_ContainerQueueSample.sql','DONE','2021-05-14 16:07:45'),
(176,'2020_11_19_DataCollection.sql','DONE','2021-05-14 16:07:45'),
(177,'2021_04_23_Dewar_fk_constraint.sql','DONE','2021-05-14 16:07:46'),
(178,'2021_05_12_ParticleClassification_rotationAccuracy.sql','DONE','2021-05-14 16:07:46'),
(179,'2021_05_14_AdminVar_bump_version.sql','DONE','2021-05-14 16:21:50'),
(180,'2021_05_19_AdminVar_bump_version.sql','DONE','2021-05-19 16:01:54'),
(181,'2021_05_20_AdminVar_bump_version.sql','DONE','2021-05-20 10:30:35'),
(182,'2021_05_28_AdminVar_bump_version.sql','DONE','2021-05-28 15:46:50'),
(183,'2020_08_28_DiffractionPlan_new_cols.sql','DONE','2021-07-07 09:32:34'),
(184,'2021_06_01_BLSampleGroup_fk_proposalId.sql','DONE','2021-07-07 09:32:34'),
(185,'2021_06_09_DataCollectionGroup_experimentType_enum.sql','DONE','2021-07-07 09:32:34'),
(186,'2021_06_11_DataCollectionGroup_experimentType_enum.sql','DONE','2021-07-07 09:32:34'),
(187,'2021_06_17_SpaceGroup_update.sql','DONE','2021-07-07 09:32:34'),
(188,'2021_06_30_zc_ZocaloBuffer.sql','DONE','2021-07-07 09:32:34'),
(189,'2021_07_01_ParticleClassification_classDistribution.sql','DONE','2021-07-07 09:32:34'),
(190,'2021_07_01_ParticlePicker_summaryImageFullPath.sql','DONE','2021-07-07 09:32:34'),
(191,'2021_07_02_UserGroup_insert.sql','DONE','2021-07-07 09:32:34'),
(192,'2021_07_07_AdminVar_bump_version.sql','DONE','2021-07-07 10:35:39'),
(193,'2021_07_07_AdminVar_bump_version_v2.sql','DONE','2021-07-07 11:37:27'),
(194,'2021_07_08_AutoProcScalingStatistics_resIOverSigI2.sql','DONE','2021-07-23 17:36:44'),
(195,'2021_07_08_Screening_autoProcProgramId.sql','DONE','2021-07-23 17:36:45'),
(196,'2021_07_09_ProposalHasPerson_role_enum.sql','DONE','2021-07-23 17:36:45'),
(197,'2021_07_09_Session_has_Person_role_enum.sql','DONE','2021-07-23 17:36:45'),
(198,'2021_07_21_Positioner_tables.sql','DONE','2021-07-23 17:36:45'),
(199,'2021_07_23_AdminVar_bump_version.sql','DONE','2021-07-23 17:36:45'),
(200,'2021_07_23_AutoProcProgram_drop_dataCollectionId.sql','DONE','2021-07-23 17:36:45'),
(201,'2021_07_26_AdminVar_bump_version.sql','DONE','2021-07-26 10:41:54'),
(202,'2021_07_27_PDB_source.sql','DONE','2021-07-27 14:49:59'),
(204,'2021_07_28_AdminVar_bump_version.sql','DONE','2021-07-28 11:13:27'),
(205,'2021_06_18_ContainerType_update.sql','DONE','2021-08-31 10:04:06'),
(206,'2021_08_09_AdminVar_bump_version.sql','DONE','2021-08-31 10:04:06'),
(208,'2021_08_31_AdminVar_bump_version.sql','DONE','2021-08-31 10:30:39'),
(209,'2021_09_14_RelativeIceThickness.sql','DONE','2021-09-14 10:54:10'),
(210,'2021_09_15_AdminVar_bump_version.sql','DONE','2021-09-15 17:35:02'),
(211,'2021_08_05_MXMRRun_update.sql','DONE','2021-11-23 12:56:56'),
(212,'2021_09_23_BLSampleGroup_update_proposalId.sql','DONE','2021-11-23 12:56:56'),
(213,'2021_11_12_BLSampleImage_fullImagePath_idx.sql','DONE','2021-11-23 12:56:56'),
(214,'2021_11_23_AdminVar_bump_version.sql','DONE','2021-11-23 17:20:13'),
(215,'2022_01_12_Container_and_ContainerHistory_update.sql','DONE','2022-02-14 11:02:17'),
(216,'2022_01_20_Container_priorityPipelineId_default.sql','DONE','2022-02-14 11:02:18'),
(217,'2022_02_04_Pod.sql','DONE','2022-02-14 11:02:18'),
(218,'2022_02_14_AdminVar_bump_version.sql','DONE','2022-02-14 11:02:18'),
(219,'2022_03_07_SW_onceToken_recordTimeStamp_idx.sql','DONE','2022-06-22 12:09:07'),
(220,'2022_04_12_BLSession_fk_beamCalendarId_set_null.sql','DONE','2022-06-22 12:09:07'),
(221,'2022_05_12_Pod_app_modify_enum.sql','DONE','2022-06-22 12:09:07'),
(222,'2022_06_22_AdminVar_bump_version.sql','DONE','2022-06-22 12:09:07'),
(223,'2022_06_22_cryo-ET_tables.sql','DONE','2022-06-22 12:09:07'),
(224,'2022_07_17_BLSubSample_update_blSampleImageId.sql','DONE','2022-08-08 12:03:49'),
(225,'2022_08_08_AdminVar_bump_version.sql','DONE','2022-08-08 16:40:14'),
(226,'2022_06_28_diffractionplan_scanparameters.sql','DONE','2022-08-22 11:57:56'),
(227,'2022_06_28_gridinfo_patches.sql','DONE','2022-08-22 11:57:56'),
(228,'2022_06_28_sampleimage_positioner.sql','DONE','2022-08-22 11:57:56'),
(229,'2022_08_25_AdminVar_bump_version.sql','DONE','2022-08-25 15:55:14'),
(230,'2022_09_14_BLSample_has_DataCollectionPlan_modify_planOrder.sql','DONE','2022-09-16 11:31:04'),
(231,'2022_09_21_ExperimentType_add_em_types.sql','DONE','2022-09-21 07:17:23'),
(232,'2022_09_28_ContainerType_update.sql','DONE','2022-09-28 10:04:59'),
(233,'2022_10_17_BLSession_drop_constraint.sql','DONE','2022-10-17 11:25:35'),
(234,'2022_10_21_Shipping_extra.sql','DONE','2022-11-02 17:04:27'),
(235,'2022_11_02_AdminVar_bump_version.sql','DONE','2022-11-02 17:04:27'),
(236,'2023_07_19_Container_parentContainerId.sql','DONE','2023-09-28 14:38:28'),
(237,'2024_03_26_AutoProc_index_refined_unit_cell.sql','DONE','2024-04-08 08:09:46'),
(238,'2024_03_20_Shipping_Dewar_externalIds.sql','DONE','2024-04-08 08:09:46'),
(239,'2024_03_19_ProcessingJobParameter_index.sql','DONE','2024-04-08 08:09:46'),
(240,'2024_03_19_ContainerQueue_containerId_not_null.sql','DONE','2024-04-08 08:10:06'),
(241,'2024_03_19_AutoProcProgramMessage_severity_not_null.sql','DONE','2024-04-08 08:10:06'),
(242,'2024_03_05_BLSubSample_replace_index.sql','DONE','2024-04-08 08:11:21'),
(243,'2024_03_12_source_column.sql','DONE','2024-04-08 08:11:21'),
(244,'2023_08_15_DewarRegistry_manufacturerSerialNumber.sql','DONE','2024-04-08 08:49:13'),
(245,'2023_05_05_Dewar_extra.sql','DONE','2024-04-08 08:50:19'),
(247,'2024_09_04_ProcessedTomogram_comment','ONGOING','2024-09-06 08:57:56'),
(248,'2024_08_08_ProcessedTomogram.sql','DONE','2024-09-06 08:58:07'),
(250,'2024_12_04_AutoProcProgramAttachment_deleted.sql','DONE','2024-12-18 11:30:15'),
(251,'2024_09_25_AutoProcProgram_processingPipelineId.sql','DONE','2024-12-18 11:48:43'),
(253,'2025_03_05_Dewar_dewarRegistryId.sql','DONE','2025-04-28 11:05:07'),
(255,'2025_04_11_Position_blSampleId_positionType.sql','DONE','2025-05-14 08:13:36'),
(256,'2025_03_20_ParticleClassification_angularEfficiency_suggestedTilt.sql','ONGOING','2025-05-14 08:13:46'),
(257,'2025_04_16_labContacts_fk_on_delete_set_null.sql','DONE','2025-05-14 08:13:55'),
(258,'2025_04_29_DewarRegistry_fk_labContactId_on_delete_set_null.sql','DONE','2025-05-14 08:14:00'),
(259,'2025_04_30_Shipping_fk_personId_on_delete_set_null.sql','DONE','2025-05-14 08:14:05'),
(260,'2025_05_01_BLSamplePosition.sql','DONE','2025-05-14 08:14:11'),
(261,'2025_05_01_XrayCentringResult_fk_blSampleId.sql','DONE','2025-05-14 08:14:16'),
(262,'2025_05_02_BLSamplePosition_rename_column.sql','DONE','2025-05-14 08:14:21'),
(263,'2025_05_12_AdminVar_bump_version.sql','DONE','2025-05-14 08:14:27'),
(264,'2025_05_28_BLSession_icatId.sql','ONGOING','2025-07-09 09:38:07'),
(265,'2025_06_27_undo_ParticleClassification_set_Tomogram_pixelLocation.sql','DONE','2025-07-09 09:38:54');
/*!40000 ALTER TABLE `SchemaStatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Screen`
--

DROP TABLE IF EXISTS `Screen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Screen` (
  `screenId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `proposalId` int(10) unsigned DEFAULT NULL,
  `global` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`screenId`),
  KEY `Screen_fk1` (`proposalId`),
  CONSTRAINT `Screen_fk1` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Screen`
--

LOCK TABLES `Screen` WRITE;
/*!40000 ALTER TABLE `Screen` DISABLE KEYS */;
/*!40000 ALTER TABLE `Screen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreenComponent`
--

DROP TABLE IF EXISTS `ScreenComponent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreenComponent` (
  `screenComponentId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `screenComponentGroupId` int(11) unsigned NOT NULL,
  `componentId` int(11) unsigned DEFAULT NULL,
  `concentration` float DEFAULT NULL,
  `pH` float DEFAULT NULL,
  PRIMARY KEY (`screenComponentId`),
  KEY `ScreenComponent_fk1` (`screenComponentGroupId`),
  KEY `ScreenComponent_fk2` (`componentId`),
  CONSTRAINT `ScreenComponent_fk1` FOREIGN KEY (`screenComponentGroupId`) REFERENCES `ScreenComponentGroup` (`screenComponentGroupId`),
  CONSTRAINT `ScreenComponent_fk2` FOREIGN KEY (`componentId`) REFERENCES `Protein` (`proteinId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreenComponent`
--

LOCK TABLES `ScreenComponent` WRITE;
/*!40000 ALTER TABLE `ScreenComponent` DISABLE KEYS */;
/*!40000 ALTER TABLE `ScreenComponent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreenComponentGroup`
--

DROP TABLE IF EXISTS `ScreenComponentGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreenComponentGroup` (
  `screenComponentGroupId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `screenId` int(11) unsigned NOT NULL,
  `position` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`screenComponentGroupId`),
  KEY `ScreenComponentGroup_fk1` (`screenId`),
  CONSTRAINT `ScreenComponentGroup_fk1` FOREIGN KEY (`screenId`) REFERENCES `Screen` (`screenId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreenComponentGroup`
--

LOCK TABLES `ScreenComponentGroup` WRITE;
/*!40000 ALTER TABLE `ScreenComponentGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `ScreenComponentGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Screening`
--

DROP TABLE IF EXISTS `Screening`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Screening` (
  `screeningId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned DEFAULT NULL,
  `bltimeStamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `programVersion` varchar(45) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `shortComments` varchar(20) DEFAULT NULL,
  `diffractionPlanId` int(10) unsigned DEFAULT NULL COMMENT 'references DiffractionPlan',
  `dataCollectionGroupId` int(11) DEFAULT NULL,
  `xmlSampleInformation` longblob DEFAULT NULL,
  `autoProcProgramId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`screeningId`),
  KEY `Screening_FKIndexDiffractionPlanId` (`diffractionPlanId`),
  KEY `dcgroupId` (`dataCollectionGroupId`),
  KEY `_Screening_ibfk2` (`dataCollectionId`),
  KEY `Screening_fk_autoProcProgramId` (`autoProcProgramId`),
  CONSTRAINT `Screening_fk_autoProcProgramId` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Screening_ibfk_1` FOREIGN KEY (`dataCollectionGroupId`) REFERENCES `DataCollectionGroup` (`dataCollectionGroupId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `_Screening_ibfk2` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1927991 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Screening`
--

LOCK TABLES `Screening` WRITE;
/*!40000 ALTER TABLE `Screening` DISABLE KEYS */;
INSERT INTO `Screening` VALUES
(1894770,1052494,'2016-10-26 08:50:31','mosflm',NULL,'Mosflm native',NULL,1040398,NULL,NULL),
(1894773,1052494,'2016-10-26 08:50:31','mosflm',NULL,'Mosflm anomalous',NULL,1040398,NULL,NULL),
(1894774,1052494,'2016-10-26 08:50:31','EDNA MXv1','Standard Native Dataset Multiplicity=3 I/sig=2 Maxlifespan=202 s','EDNAStrategy1',NULL,1040398,NULL,NULL),
(1894777,1052494,'2016-10-26 08:50:31','EDNA MXv1','strategy with target multiplicity=16, target I/sig=2 Maxlifespan=202 s','EDNAStrategy3',NULL,1040398,NULL,NULL),
(1894780,1052494,'2016-10-26 08:50:31','EDNA MXv1','Gentle: Target Multiplicity=2 and target I/Sig 2 and Maxlifespan=20 s','EDNAStrategy4',NULL,1040398,NULL,NULL),
(1894783,1052494,'2016-10-26 08:50:31','EDNA MXv1','Standard Anomalous Dataset Multiplicity=3 I/sig=2 Maxlifespan=202 s','EDNAStrategy2',NULL,1040398,NULL,NULL),
(1894786,1052494,'2016-10-26 08:50:31','EDNA MXv1','UnderDEV Anomalous Dataset, RadDamage of standard protein','EDNAStrategy5',NULL,1040398,NULL,NULL),
(1894807,1052503,'2016-10-26 08:50:31','EDNA MXv1','strategy with target multiplicity=16, target I/sig=2 Maxlifespan=202 s','EDNAStrategy3',NULL,1040407,NULL,NULL),
(1894810,1052503,'2016-10-26 08:50:31','EDNA MXv1','Standard Anomalous Dataset Multiplicity=3 I/sig=2 Maxlifespan=202 s','EDNAStrategy2',NULL,1040407,NULL,NULL),
(1894812,1052503,'2016-10-26 08:50:31','mosflm',NULL,'Mosflm native',NULL,1040407,NULL,NULL),
(1894815,1052503,'2016-10-26 08:50:31','mosflm',NULL,'Mosflm anomalous',NULL,1040407,NULL,NULL),
(1894816,1052503,'2016-10-26 08:50:31','EDNA MXv1','Gentle: Target Multiplicity=2 and target I/Sig 2 and Maxlifespan=20 s','EDNAStrategy4',NULL,1040407,NULL,NULL),
(1894819,1052503,'2016-10-26 08:50:31','EDNA MXv1','UnderDEV Anomalous Dataset, RadDamage of standard protein','EDNAStrategy5',NULL,1040407,NULL,NULL),
(1894822,1052503,'2016-10-26 08:50:31','EDNA MXv1','Standard Native Dataset Multiplicity=3 I/sig=2 Maxlifespan=202 s','EDNAStrategy1',NULL,1040407,NULL,NULL),
(1927968,1066786,'2016-10-26 08:50:31','mosflm',NULL,'Mosflm native',NULL,1054243,NULL,NULL),
(1927971,1066786,'2016-10-26 08:50:31','mosflm',NULL,'Mosflm anomalous',NULL,1054243,NULL,NULL),
(1927972,1066786,'2016-10-26 08:50:31','EDNA MXv1','Standard Native Dataset Multiplicity=3 I/sig=2 Maxlifespan=4034 s','EDNAStrategy1',NULL,1054243,NULL,NULL),
(1927981,1066786,'2016-10-26 08:50:31','EDNA MXv1','Gentle: Target Multiplicity=2 and target I/Sig 2 and Maxlifespan=403 s','EDNAStrategy4',NULL,1054243,NULL,NULL),
(1927984,1066786,'2016-10-26 08:50:31','EDNA MXv1','strategy with target multiplicity=16, target I/sig=2 Maxlifespan=4034 s','EDNAStrategy3',NULL,1054243,NULL,NULL),
(1927987,1066786,'2016-10-26 08:50:31','EDNA MXv1','Standard Anomalous Dataset Multiplicity=3 I/sig=2 Maxlifespan=4034 s','EDNAStrategy2',NULL,1054243,NULL,NULL),
(1927990,1066786,'2016-10-26 08:50:31','EDNA MXv1','UnderDEV Anomalous Dataset, RadDamage of standard protein','EDNAStrategy5',NULL,1054243,NULL,NULL);
/*!40000 ALTER TABLE `Screening` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningInput`
--

DROP TABLE IF EXISTS `ScreeningInput`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningInput` (
  `screeningInputId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screeningId` int(10) unsigned NOT NULL DEFAULT 0,
  `beamX` float DEFAULT NULL,
  `beamY` float DEFAULT NULL,
  `rmsErrorLimits` float DEFAULT NULL,
  `minimumFractionIndexed` float DEFAULT NULL,
  `maximumFractionRejected` float DEFAULT NULL,
  `minimumSignalToNoise` float DEFAULT NULL,
  `diffractionPlanId` int(10) DEFAULT NULL COMMENT 'references DiffractionPlan table',
  `xmlSampleInformation` longblob DEFAULT NULL,
  PRIMARY KEY (`screeningInputId`),
  KEY `ScreeningInput_FKIndex1` (`screeningId`),
  CONSTRAINT `ScreeningInput_ibfk_1` FOREIGN KEY (`screeningId`) REFERENCES `Screening` (`screeningId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1013165 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningInput`
--

LOCK TABLES `ScreeningInput` WRITE;
/*!40000 ALTER TABLE `ScreeningInput` DISABLE KEYS */;
INSERT INTO `ScreeningInput` VALUES
(983791,1894774,208.731,214.298,NULL,NULL,NULL,NULL,NULL,NULL),
(983794,1894777,208.731,214.298,NULL,NULL,NULL,NULL,NULL,NULL),
(983797,1894780,208.731,214.298,NULL,NULL,NULL,NULL,NULL,NULL),
(983800,1894783,208.731,214.298,NULL,NULL,NULL,NULL,NULL,NULL),
(983803,1894786,208.731,214.298,NULL,NULL,NULL,NULL,NULL,NULL),
(983821,1894807,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(983824,1894810,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(983827,1894816,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(983830,1894819,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(983833,1894822,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(1013146,1927972,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(1013155,1927981,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(1013158,1927984,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(1013161,1927987,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL),
(1013164,1927990,208.32,214.339,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ScreeningInput` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningOutput`
--

DROP TABLE IF EXISTS `ScreeningOutput`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningOutput` (
  `screeningOutputId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screeningId` int(10) unsigned NOT NULL DEFAULT 0,
  `statusDescription` varchar(1024) DEFAULT NULL,
  `rejectedReflections` int(10) unsigned DEFAULT NULL,
  `resolutionObtained` float DEFAULT NULL,
  `spotDeviationR` float DEFAULT NULL,
  `spotDeviationTheta` float DEFAULT NULL,
  `beamShiftX` float DEFAULT NULL,
  `beamShiftY` float DEFAULT NULL,
  `numSpotsFound` int(10) unsigned DEFAULT NULL,
  `numSpotsUsed` int(10) unsigned DEFAULT NULL,
  `numSpotsRejected` int(10) unsigned DEFAULT NULL,
  `mosaicity` float DEFAULT NULL,
  `iOverSigma` float DEFAULT NULL,
  `diffractionRings` tinyint(1) DEFAULT NULL,
  `SCREENINGSUCCESS` tinyint(1) DEFAULT 0 COMMENT 'Column to be deleted',
  `mosaicityEstimated` tinyint(1) NOT NULL DEFAULT 0,
  `rankingResolution` double DEFAULT NULL,
  `program` varchar(45) DEFAULT NULL,
  `doseTotal` double DEFAULT NULL,
  `totalExposureTime` double DEFAULT NULL,
  `totalRotationRange` double DEFAULT NULL,
  `totalNumberOfImages` int(11) DEFAULT NULL,
  `rFriedel` double DEFAULT NULL,
  `indexingSuccess` tinyint(1) NOT NULL DEFAULT 0,
  `strategySuccess` tinyint(1) NOT NULL DEFAULT 0,
  `alignmentSuccess` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`screeningOutputId`),
  KEY `ScreeningOutput_FKIndex1` (`screeningId`),
  CONSTRAINT `ScreeningOutput_ibfk_1` FOREIGN KEY (`screeningId`) REFERENCES `Screening` (`screeningId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1522619 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningOutput`
--

LOCK TABLES `ScreeningOutput` WRITE;
/*!40000 ALTER TABLE `ScreeningOutput` DISABLE KEYS */;
INSERT INTO `ScreeningOutput` VALUES
(1489401,1894770,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489404,1894773,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489405,1894774,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.197,NULL,-0.0094,-0.0618,303,303,0,1.2,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489408,1894777,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.197,NULL,-0.0094,-0.0618,303,303,0,1.2,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489411,1894780,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.197,NULL,-0.0094,-0.0618,303,303,0,1.2,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489414,1894783,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.197,NULL,-0.0094,-0.0618,303,303,0,1.2,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489417,1894786,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.197,NULL,-0.0094,-0.0618,303,303,0,1.2,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489438,1894807,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.184,NULL,0.0495,-0.0405,294,294,0,1.35,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489441,1894810,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.184,NULL,0.0495,-0.0405,294,294,0,1.35,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489443,1894812,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1.6,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489446,1894815,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1.6,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489447,1894816,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.184,NULL,0.0495,-0.0405,294,294,0,1.35,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489450,1894819,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.184,NULL,0.0495,-0.0405,294,294,0,1.35,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1489453,1894822,'Labelit: Indexing successful (I23). Integration successful. Strategy calculation successful.',NULL,NULL,0.184,NULL,0.0495,-0.0405,294,294,0,1.35,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1522596,1927968,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.8,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1522599,1927971,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.8,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1522600,1927972,'Labelit: Indexing successful (P4). Integration successful. Strategy calculation successful.',NULL,NULL,0.166,NULL,0.0195,-0.0105,434,434,0,0.7,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1522609,1927981,'Labelit: Indexing successful (P4). Integration successful. Strategy calculation successful.',NULL,NULL,0.166,NULL,0.0195,-0.0105,434,434,0,0.7,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1522612,1927984,'Labelit: Indexing successful (P4). Integration successful. Strategy calculation successful.',NULL,NULL,0.166,NULL,0.0195,-0.0105,434,434,0,0.7,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1522615,1927987,'Labelit: Indexing successful (P4). Integration successful. Strategy calculation successful.',NULL,NULL,0.166,NULL,0.0195,-0.0105,434,434,0,0.7,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0),
(1522618,1927990,'Labelit: Indexing successful (P4). Integration successful. Strategy calculation successful.',NULL,NULL,0.166,NULL,0.0195,-0.0105,434,434,0,0.7,NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0);
/*!40000 ALTER TABLE `ScreeningOutput` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningOutputLattice`
--

DROP TABLE IF EXISTS `ScreeningOutputLattice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningOutputLattice` (
  `screeningOutputLatticeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screeningOutputId` int(10) unsigned NOT NULL DEFAULT 0,
  `spaceGroup` varchar(45) DEFAULT NULL,
  `pointGroup` varchar(45) DEFAULT NULL,
  `bravaisLattice` varchar(45) DEFAULT NULL,
  `rawOrientationMatrix_a_x` float DEFAULT NULL,
  `rawOrientationMatrix_a_y` float DEFAULT NULL,
  `rawOrientationMatrix_a_z` float DEFAULT NULL,
  `rawOrientationMatrix_b_x` float DEFAULT NULL,
  `rawOrientationMatrix_b_y` float DEFAULT NULL,
  `rawOrientationMatrix_b_z` float DEFAULT NULL,
  `rawOrientationMatrix_c_x` float DEFAULT NULL,
  `rawOrientationMatrix_c_y` float DEFAULT NULL,
  `rawOrientationMatrix_c_z` float DEFAULT NULL,
  `unitCell_a` float DEFAULT NULL,
  `unitCell_b` float DEFAULT NULL,
  `unitCell_c` float DEFAULT NULL,
  `unitCell_alpha` float DEFAULT NULL,
  `unitCell_beta` float DEFAULT NULL,
  `unitCell_gamma` float DEFAULT NULL,
  `bltimeStamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `labelitIndexing` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`screeningOutputLatticeId`),
  KEY `ScreeningOutputLattice_FKIndex1` (`screeningOutputId`),
  CONSTRAINT `ScreeningOutputLattice_ibfk_1` FOREIGN KEY (`screeningOutputId`) REFERENCES `ScreeningOutput` (`screeningOutputId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1323848 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningOutputLattice`
--

LOCK TABLES `ScreeningOutputLattice` WRITE;
/*!40000 ALTER TABLE `ScreeningOutputLattice` DISABLE KEYS */;
INSERT INTO `ScreeningOutputLattice` VALUES
(1309566,1489401,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.339,76.339,76.339,90,90,90,'2016-04-13 11:19:21',0),
(1309569,1489404,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.339,76.339,76.339,90,90,90,'2016-04-13 11:19:21',0),
(1309570,1489405,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.3,76.3,76.3,90,90,90,'2016-04-13 11:19:24',0),
(1309573,1489408,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.3,76.3,76.3,90,90,90,'2016-04-13 11:19:27',0),
(1309576,1489411,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.3,76.3,76.3,90,90,90,'2016-04-13 11:19:29',0),
(1309579,1489414,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.3,76.3,76.3,90,90,90,'2016-04-13 11:19:34',0),
(1309582,1489417,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.3,76.3,76.3,90,90,90,'2016-04-13 11:19:34',0),
(1309603,1489438,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.52,76.52,76.52,90,90,90,'2016-04-13 11:22:30',0),
(1309606,1489441,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.52,76.52,76.52,90,90,90,'2016-04-13 11:22:35',0),
(1309608,1489443,'C2221',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.645,108.218,108.03,90,90,90,'2016-04-13 11:22:36',0),
(1309611,1489446,'C2221',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.645,108.218,108.03,90,90,90,'2016-04-13 11:22:36',0),
(1309612,1489447,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.52,76.52,76.52,90,90,90,'2016-04-13 11:22:39',0),
(1309615,1489450,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.52,76.52,76.52,90,90,90,'2016-04-13 11:22:40',0),
(1309618,1489453,'I23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,76.52,76.52,76.52,90,90,90,'2016-04-13 11:22:44',0),
(1323825,1522596,'P41212',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57.334,57.334,148.969,90,90,90,'2016-04-18 10:05:24',0),
(1323828,1522599,'P41212',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57.334,57.334,148.969,90,90,90,'2016-04-18 10:05:24',0),
(1323829,1522600,'P4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57.29,57.29,149.07,90,90,90,'2016-04-14 02:19:04',0),
(1323838,1522609,'P4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57.29,57.29,149.07,90,90,90,'2016-04-14 02:19:04',0),
(1323841,1522612,'P4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57.29,57.29,149.07,90,90,90,'2016-04-14 02:19:04',0),
(1323844,1522615,'P4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57.29,57.29,149.07,90,90,90,'2016-04-14 02:19:04',0),
(1323847,1522618,'P4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,57.29,57.29,149.07,90,90,90,'2016-04-14 02:19:04',0);
/*!40000 ALTER TABLE `ScreeningOutputLattice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningRank`
--

DROP TABLE IF EXISTS `ScreeningRank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningRank` (
  `screeningRankId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screeningRankSetId` int(10) unsigned NOT NULL DEFAULT 0,
  `screeningId` int(10) unsigned NOT NULL DEFAULT 0,
  `rankValue` float DEFAULT NULL,
  `rankInformation` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`screeningRankId`),
  KEY `ScreeningRank_FKIndex1` (`screeningId`),
  KEY `ScreeningRank_FKIndex2` (`screeningRankSetId`),
  CONSTRAINT `ScreeningRank_ibfk_1` FOREIGN KEY (`screeningId`) REFERENCES `Screening` (`screeningId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ScreeningRank_ibfk_2` FOREIGN KEY (`screeningRankSetId`) REFERENCES `ScreeningRankSet` (`screeningRankSetId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningRank`
--

LOCK TABLES `ScreeningRank` WRITE;
/*!40000 ALTER TABLE `ScreeningRank` DISABLE KEYS */;
/*!40000 ALTER TABLE `ScreeningRank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningRankSet`
--

DROP TABLE IF EXISTS `ScreeningRankSet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningRankSet` (
  `screeningRankSetId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rankEngine` varchar(255) DEFAULT NULL,
  `rankingProjectFileName` varchar(255) DEFAULT NULL,
  `rankingSummaryFileName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`screeningRankSetId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningRankSet`
--

LOCK TABLES `ScreeningRankSet` WRITE;
/*!40000 ALTER TABLE `ScreeningRankSet` DISABLE KEYS */;
/*!40000 ALTER TABLE `ScreeningRankSet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningStrategy`
--

DROP TABLE IF EXISTS `ScreeningStrategy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningStrategy` (
  `screeningStrategyId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screeningOutputId` int(10) unsigned NOT NULL DEFAULT 0,
  `phiStart` float DEFAULT NULL,
  `phiEnd` float DEFAULT NULL,
  `rotation` float DEFAULT NULL,
  `exposureTime` float DEFAULT NULL,
  `resolution` float DEFAULT NULL,
  `completeness` float DEFAULT NULL,
  `multiplicity` float DEFAULT NULL,
  `anomalous` tinyint(1) NOT NULL DEFAULT 0,
  `program` varchar(45) DEFAULT NULL,
  `rankingResolution` float DEFAULT NULL,
  `transmission` float DEFAULT NULL COMMENT 'Transmission for the strategy as given by the strategy program.',
  PRIMARY KEY (`screeningStrategyId`),
  KEY `ScreeningStrategy_FKIndex1` (`screeningOutputId`),
  CONSTRAINT `ScreeningStrategy_ibfk_1` FOREIGN KEY (`screeningOutputId`) REFERENCES `ScreeningOutput` (`screeningOutputId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1507124 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningStrategy`
--

LOCK TABLES `ScreeningStrategy` WRITE;
/*!40000 ALTER TABLE `ScreeningStrategy` DISABLE KEYS */;
INSERT INTO `ScreeningStrategy` VALUES
(1473909,1489401,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'mosflm - native',NULL,NULL),
(1473912,1489404,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'mosflm - anomalous',NULL,NULL),
(1473913,1489405,NULL,NULL,NULL,0.428,NULL,NULL,NULL,0,'BEST',1.41,NULL),
(1473916,1489408,NULL,NULL,NULL,0.112,NULL,NULL,NULL,0,'BEST',1.41,NULL),
(1473919,1489411,NULL,NULL,NULL,0.049,NULL,NULL,NULL,0,'BEST',1.49,NULL),
(1473922,1489414,NULL,NULL,NULL,0.365,NULL,NULL,NULL,1,'BEST',1.41,NULL),
(1473925,1489417,NULL,NULL,NULL,0.365,NULL,NULL,NULL,1,'BEST',1.41,NULL),
(1473946,1489438,NULL,NULL,NULL,0.073,NULL,NULL,NULL,0,'BEST',1.44,NULL),
(1473949,1489441,NULL,NULL,NULL,0.333,NULL,NULL,NULL,1,'BEST',1.47,NULL),
(1473951,1489443,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'mosflm - native',NULL,NULL),
(1473954,1489446,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'mosflm - anomalous',NULL,NULL),
(1473955,1489447,NULL,NULL,NULL,0.086,NULL,NULL,NULL,0,'BEST',1.57,NULL),
(1473958,1489450,NULL,NULL,NULL,0.333,NULL,NULL,NULL,1,'BEST',1.47,NULL),
(1473961,1489453,NULL,NULL,NULL,0.296,NULL,NULL,NULL,0,'BEST',1.44,NULL),
(1507101,1522596,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'mosflm - native',NULL,NULL),
(1507104,1522599,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'mosflm - anomalous',NULL,NULL),
(1507105,1522600,NULL,NULL,NULL,0.01,NULL,NULL,NULL,0,'BEST',1.13,NULL),
(1507114,1522609,NULL,NULL,NULL,0.01,NULL,NULL,NULL,0,'BEST',1.23,NULL),
(1507117,1522612,NULL,NULL,NULL,0.01,NULL,NULL,NULL,0,'BEST',1.14,NULL),
(1507120,1522615,NULL,NULL,NULL,0.01,NULL,NULL,NULL,1,'BEST',1.16,NULL),
(1507123,1522618,NULL,NULL,NULL,0.01,NULL,NULL,NULL,1,'BEST',1.16,NULL);
/*!40000 ALTER TABLE `ScreeningStrategy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningStrategySubWedge`
--

DROP TABLE IF EXISTS `ScreeningStrategySubWedge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningStrategySubWedge` (
  `screeningStrategySubWedgeId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `screeningStrategyWedgeId` int(10) unsigned DEFAULT NULL COMMENT 'Foreign key to parent table',
  `subWedgeNumber` int(10) unsigned DEFAULT NULL COMMENT 'The number of this subwedge within the wedge',
  `rotationAxis` varchar(45) DEFAULT NULL COMMENT 'Angle where subwedge starts',
  `axisStart` float DEFAULT NULL COMMENT 'Angle where subwedge ends',
  `axisEnd` float DEFAULT NULL COMMENT 'Exposure time for subwedge',
  `exposureTime` float DEFAULT NULL COMMENT 'Transmission for subwedge',
  `transmission` float DEFAULT NULL,
  `oscillationRange` float DEFAULT NULL,
  `completeness` float DEFAULT NULL,
  `multiplicity` float DEFAULT NULL,
  `RESOLUTION` float DEFAULT NULL,
  `doseTotal` float DEFAULT NULL COMMENT 'Total dose for this subwedge',
  `numberOfImages` int(10) unsigned DEFAULT NULL COMMENT 'Number of images for this subwedge',
  `comments` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`screeningStrategySubWedgeId`),
  KEY `ScreeningStrategySubWedge_FK1` (`screeningStrategyWedgeId`),
  CONSTRAINT `ScreeningStrategySubWedge_FK1` FOREIGN KEY (`screeningStrategyWedgeId`) REFERENCES `ScreeningStrategyWedge` (`screeningStrategyWedgeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1123988 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningStrategySubWedge`
--

LOCK TABLES `ScreeningStrategySubWedge` WRITE;
/*!40000 ALTER TABLE `ScreeningStrategySubWedge` DISABLE KEYS */;
INSERT INTO `ScreeningStrategySubWedge` VALUES
(1111566,1143792,NULL,'Omega',64,109,0,NULL,1.4,1,NULL,1.22,NULL,33,NULL),
(1111569,1143795,NULL,'Omega',74,119,0,NULL,1.4,0.98,NULL,1.22,NULL,33,NULL),
(1111570,1143796,1,'Omega',7,40,0.428,100,0.15,1,4.07,1.41,NULL,220,NULL),
(1111573,1143799,1,'Omega',30,160.05,0.112,100,0.15,1,16.02,1.41,NULL,867,NULL),
(1111576,1143802,1,'Omega',93,123.15,0.049,100,0.15,1,3.71,1.49,NULL,202,NULL),
(1111579,1143805,1,'Omega',225,273,0.365,100,0.1,0.997,3.08,1.41,NULL,480,NULL),
(1111582,1143808,1,'Omega',225,273,0.365,100,0.1,0.997,3.08,1.41,NULL,480,NULL),
(1111603,1143829,1,'Omega',42,171,0.073,100,0.15,1,15.93,1.51,NULL,860,NULL),
(1111606,1143832,1,'Omega',39,91.05,0.333,100,0.15,0.999,3.35,1.51,NULL,347,NULL),
(1111608,1143834,NULL,'Omega',265,355,0,NULL,0.2,0.99,NULL,1.47,NULL,450,NULL),
(1111611,1143837,NULL,'Omega',265,355,0,NULL,0.2,0.92,NULL,1.47,NULL,450,NULL),
(1111612,1143838,1,'Omega',7,39.1,0.086,100,0.15,1,3.95,1.57,NULL,215,NULL),
(1111615,1143841,1,'Omega',39,91.05,0.333,100,0.15,0.999,3.35,1.51,NULL,347,NULL),
(1111618,1143844,1,'Omega',144,175.05,0.296,100,0.15,1,3.83,1.51,NULL,208,NULL),
(1123965,1156191,NULL,'Omega',48,93,0,NULL,0.5,0.99,NULL,1.47,NULL,90,NULL),
(1123968,1156194,NULL,'Omega',43,88,0,NULL,0.5,0.93,NULL,1.47,NULL,90,NULL),
(1123969,1156195,1,'Omega',9,88,0.01,71.7436,0.1,0.999,3.34,1.51,NULL,790,NULL),
(1123978,1156204,1,'Omega',10,88,0.01,72.4236,0.1,0.999,3.3,1.51,NULL,780,NULL),
(1123981,1156207,1,'Omega',0,360,0.01,16.1595,0.1,1,15.21,1.51,NULL,3600,NULL),
(1123984,1156210,1,'Omega',87,239,0.01,72.2048,0.1,0.99,3.29,1.51,NULL,1520,NULL),
(1123987,1156213,1,'Omega',87,239,0.01,72.2048,0.1,0.99,3.29,1.51,NULL,1520,NULL);
/*!40000 ALTER TABLE `ScreeningStrategySubWedge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ScreeningStrategyWedge`
--

DROP TABLE IF EXISTS `ScreeningStrategyWedge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ScreeningStrategyWedge` (
  `screeningStrategyWedgeId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `screeningStrategyId` int(10) unsigned DEFAULT NULL COMMENT 'Foreign key to parent table',
  `wedgeNumber` int(10) unsigned DEFAULT NULL COMMENT 'The number of this wedge within the strategy',
  `resolution` float DEFAULT NULL,
  `completeness` float DEFAULT NULL,
  `multiplicity` float DEFAULT NULL,
  `doseTotal` float DEFAULT NULL COMMENT 'Total dose for this wedge',
  `numberOfImages` int(10) unsigned DEFAULT NULL COMMENT 'Number of images for this wedge',
  `phi` float DEFAULT NULL,
  `kappa` float DEFAULT NULL,
  `chi` float DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `wavelength` double DEFAULT NULL,
  PRIMARY KEY (`screeningStrategyWedgeId`),
  KEY `ScreeningStrategyWedge_IBFK_1` (`screeningStrategyId`),
  CONSTRAINT `ScreeningStrategyWedge_IBFK_1` FOREIGN KEY (`screeningStrategyId`) REFERENCES `ScreeningStrategy` (`screeningStrategyId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1156214 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ScreeningStrategyWedge`
--

LOCK TABLES `ScreeningStrategyWedge` WRITE;
/*!40000 ALTER TABLE `ScreeningStrategyWedge` DISABLE KEYS */;
INSERT INTO `ScreeningStrategyWedge` VALUES
(1143792,1473909,1,1.22,1,NULL,NULL,33,NULL,NULL,NULL,NULL,NULL),
(1143795,1473912,1,1.22,0.98,NULL,NULL,33,NULL,NULL,NULL,NULL,NULL),
(1143796,1473913,1,1.41,1,4.07,0,220,NULL,NULL,NULL,NULL,NULL),
(1143799,1473916,1,1.41,1,16.02,0,867,NULL,NULL,NULL,NULL,NULL),
(1143802,1473919,1,1.49,1,3.71,0,202,NULL,NULL,NULL,NULL,NULL),
(1143805,1473922,1,1.41,0.997,3.08,0,480,NULL,NULL,NULL,NULL,NULL),
(1143808,1473925,1,1.41,0.997,3.08,0,480,NULL,NULL,NULL,NULL,NULL),
(1143829,1473946,1,1.51,1,15.93,0,860,NULL,NULL,NULL,NULL,NULL),
(1143832,1473949,1,1.51,0.999,3.35,0,347,NULL,NULL,NULL,NULL,NULL),
(1143834,1473951,1,1.47,0.99,NULL,NULL,450,NULL,NULL,NULL,NULL,NULL),
(1143837,1473954,1,1.47,0.92,NULL,NULL,450,NULL,NULL,NULL,NULL,NULL),
(1143838,1473955,1,1.57,1,3.95,0,215,NULL,NULL,NULL,NULL,NULL),
(1143841,1473958,1,1.51,0.999,3.35,0,347,NULL,NULL,NULL,NULL,NULL),
(1143844,1473961,1,1.51,1,3.83,0,208,NULL,NULL,NULL,NULL,NULL),
(1156191,1507101,1,1.47,0.99,NULL,NULL,90,NULL,NULL,NULL,NULL,NULL),
(1156194,1507104,1,1.47,0.93,NULL,NULL,90,NULL,NULL,NULL,NULL,NULL),
(1156195,1507105,1,1.51,0.999,3.34,0,790,NULL,NULL,NULL,NULL,NULL),
(1156204,1507114,1,1.51,0.999,3.3,0,780,NULL,NULL,NULL,NULL,NULL),
(1156207,1507117,1,1.51,1,15.21,0,3600,NULL,NULL,NULL,NULL,NULL),
(1156210,1507120,1,1.51,0.99,3.29,0,1520,NULL,NULL,NULL,NULL,NULL),
(1156213,1507123,1,1.51,0.99,3.29,0,1520,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ScreeningStrategyWedge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SessionType`
--

DROP TABLE IF EXISTS `SessionType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SessionType` (
  `sessionTypeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sessionId` int(10) unsigned NOT NULL,
  `typeName` varchar(31) NOT NULL,
  PRIMARY KEY (`sessionTypeId`),
  KEY `SessionType_FKIndex1` (`sessionId`),
  CONSTRAINT `SessionType_ibfk_1` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=248 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SessionType`
--

LOCK TABLES `SessionType` WRITE;
/*!40000 ALTER TABLE `SessionType` DISABLE KEYS */;
/*!40000 ALTER TABLE `SessionType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Session_has_Person`
--

DROP TABLE IF EXISTS `Session_has_Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Session_has_Person` (
  `sessionId` int(10) unsigned NOT NULL DEFAULT 0,
  `personId` int(10) unsigned NOT NULL DEFAULT 0,
  `role` enum('Local Contact','Local Contact 2','Staff','Team Leader','Co-Investigator','Principal Investigator','Alternate Contact','Data Access','Team Member','ERA Admin','Associate') DEFAULT NULL,
  `remote` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`sessionId`,`personId`),
  KEY `Session_has_Person_FKIndex2` (`personId`),
  CONSTRAINT `Session_has_Person_ibfk_1` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Session_has_Person_ibfk_2` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session_has_Person`
--

LOCK TABLES `Session_has_Person` WRITE;
/*!40000 ALTER TABLE `Session_has_Person` DISABLE KEYS */;
INSERT INTO `Session_has_Person` VALUES
(55167,1,'Co-Investigator',0),
(55168,1,'Co-Investigator',0),
(27464088,46270,'Data Access',0),
(27464088,46436,'Local Contact',0),
(27464089,18600,'Principal Investigator',0),
(27464090,1,'Local Contact',0),
(27464172,46435,'Principal Investigator',0);
/*!40000 ALTER TABLE `Session_has_Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Shipping`
--

DROP TABLE IF EXISTS `Shipping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Shipping` (
  `shippingId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `proposalId` int(10) unsigned NOT NULL DEFAULT 0,
  `shippingName` varchar(45) DEFAULT NULL,
  `deliveryAgent_agentName` varchar(45) DEFAULT NULL,
  `deliveryAgent_shippingDate` date DEFAULT NULL,
  `deliveryAgent_deliveryDate` date DEFAULT NULL,
  `deliveryAgent_agentCode` varchar(45) DEFAULT NULL,
  `deliveryAgent_flightCode` varchar(45) DEFAULT NULL,
  `shippingStatus` varchar(45) DEFAULT NULL,
  `bltimeStamp` datetime DEFAULT NULL,
  `laboratoryId` int(10) unsigned DEFAULT NULL,
  `isStorageShipping` tinyint(1) DEFAULT 0,
  `creationDate` datetime DEFAULT NULL,
  `comments` varchar(1000) DEFAULT NULL,
  `sendingLabContactId` int(10) unsigned DEFAULT NULL,
  `returnLabContactId` int(10) unsigned DEFAULT NULL,
  `returnCourier` varchar(45) DEFAULT NULL,
  `dateOfShippingToUser` datetime DEFAULT NULL,
  `shippingType` varchar(45) DEFAULT NULL,
  `SAFETYLEVEL` varchar(8) DEFAULT NULL,
  `deliveryAgent_flightCodeTimestamp` timestamp NULL DEFAULT NULL COMMENT 'Date flight code created, if automatic',
  `deliveryAgent_label` text DEFAULT NULL COMMENT 'Base64 encoded pdf of airway label',
  `readyByTime` time DEFAULT NULL COMMENT 'Time shipment will be ready',
  `closeTime` time DEFAULT NULL COMMENT 'Time after which shipment cannot be picked up',
  `physicalLocation` varchar(50) DEFAULT NULL COMMENT 'Where shipment can be picked up from: i.e. Stores',
  `deliveryAgent_pickupConfirmationTimestamp` timestamp NULL DEFAULT NULL COMMENT 'Date picked confirmed',
  `deliveryAgent_pickupConfirmation` varchar(10) DEFAULT NULL COMMENT 'Confirmation number of requested pickup',
  `deliveryAgent_readyByTime` time DEFAULT NULL COMMENT 'Confirmed ready-by time',
  `deliveryAgent_callinTime` time DEFAULT NULL COMMENT 'Confirmed courier call-in time',
  `deliveryAgent_productcode` varchar(10) DEFAULT NULL COMMENT 'A code that identifies which shipment service was used',
  `deliveryAgent_flightCodePersonId` int(10) unsigned DEFAULT NULL COMMENT 'The person who created the AWB (for auditing)',
  `extra` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JSON column for facility-specific or hard-to-define attributes' CHECK (json_valid(`extra`)),
  `externalShippingIdToSynchrotron` int(11) unsigned DEFAULT NULL COMMENT 'ID for shipping to synchrotron in external application',
  `source` varchar(50) DEFAULT current_user(),
  PRIMARY KEY (`shippingId`),
  KEY `laboratoryId` (`laboratoryId`),
  KEY `Shipping_FKIndex1` (`proposalId`),
  KEY `Shipping_FKIndex2` (`sendingLabContactId`),
  KEY `Shipping_FKIndex3` (`returnLabContactId`),
  KEY `Shipping_FKIndexCreationDate` (`creationDate`),
  KEY `Shipping_FKIndexName` (`shippingName`),
  KEY `Shipping_FKIndexStatus` (`shippingStatus`),
  KEY `Shipping_ibfk_4` (`deliveryAgent_flightCodePersonId`),
  CONSTRAINT `Shipping_ibfk_1` FOREIGN KEY (`proposalId`) REFERENCES `Proposal` (`proposalId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Shipping_ibfk_2` FOREIGN KEY (`sendingLabContactId`) REFERENCES `LabContact` (`labContactId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Shipping_ibfk_3` FOREIGN KEY (`returnLabContactId`) REFERENCES `LabContact` (`labContactId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Shipping_ibfk_4` FOREIGN KEY (`deliveryAgent_flightCodePersonId`) REFERENCES `Person` (`personId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11154 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Shipping`
--

LOCK TABLES `Shipping` WRITE;
/*!40000 ALTER TABLE `Shipping` DISABLE KEYS */;
INSERT INTO `Shipping` VALUES
(474,141666,'cm-0001 1 processing',NULL,NULL,NULL,NULL,NULL,'processing',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(477,141666,'cm-0001 2 processing',NULL,NULL,NULL,NULL,NULL,'processing',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(480,141666,'cm-0001 3 processing',NULL,NULL,NULL,NULL,NULL,'processing',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(6988,37027,'Default Shipping:cm14451-1',NULL,NULL,NULL,NULL,NULL,'processing',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(7227,37027,'cm14451-2_Shipment1',NULL,NULL,NULL,NULL,NULL,'processing','2016-02-10 13:03:07',NULL,0,'2016-02-10 13:03:07',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(7231,37027,'VMXi Simulator Test shipment',NULL,NULL,NULL,NULL,NULL,'opened',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(7241,141666,'Shipment 01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2023-08-21 08:16:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(7242,141666,'Shipment 01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2023-08-21 08:16:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(7243,141666,'Shipment 01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2023-08-21 08:16:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%'),
(7266,1000024,'Shipment 02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root@%');
/*!40000 ALTER TABLE `Shipping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ShippingHasSession`
--

DROP TABLE IF EXISTS `ShippingHasSession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ShippingHasSession` (
  `shippingId` int(10) unsigned NOT NULL,
  `sessionId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`shippingId`,`sessionId`),
  KEY `ShippingHasSession_FKIndex2` (`sessionId`),
  CONSTRAINT `ShippingHasSession_ibfk_1` FOREIGN KEY (`shippingId`) REFERENCES `Shipping` (`shippingId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ShippingHasSession_ibfk_2` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShippingHasSession`
--

LOCK TABLES `ShippingHasSession` WRITE;
/*!40000 ALTER TABLE `ShippingHasSession` DISABLE KEYS */;
INSERT INTO `ShippingHasSession` VALUES
(474,339525),
(477,339528),
(480,339531),
(6988,55167),
(7227,55168);
/*!40000 ALTER TABLE `ShippingHasSession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sleeve`
--

DROP TABLE IF EXISTS `Sleeve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sleeve` (
  `sleeveId` tinyint(3) unsigned NOT NULL COMMENT 'The unique sleeve id 1...255 which also identifies its home location in the freezer',
  `location` tinyint(3) unsigned DEFAULT NULL COMMENT 'NULL == freezer, 1...255 for local storage locations',
  `lastMovedToFreezer` timestamp NOT NULL DEFAULT current_timestamp(),
  `lastMovedFromFreezer` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`sleeveId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='Registry of ice-filled sleeves used to cool plates whilst on the goniometer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sleeve`
--

LOCK TABLES `Sleeve` WRITE;
/*!40000 ALTER TABLE `Sleeve` DISABLE KEYS */;
/*!40000 ALTER TABLE `Sleeve` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SpaceGroup`
--

DROP TABLE IF EXISTS `SpaceGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SpaceGroup` (
  `spaceGroupId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
  `spaceGroupNumber` int(10) unsigned DEFAULT NULL COMMENT 'ccp4 number pr IUCR',
  `spaceGroupShortName` varchar(45) DEFAULT NULL COMMENT 'short name without blank',
  `spaceGroupName` varchar(45) DEFAULT NULL COMMENT 'verbose name',
  `bravaisLattice` varchar(45) DEFAULT NULL COMMENT 'short name',
  `bravaisLatticeName` varchar(45) DEFAULT NULL COMMENT 'verbose name',
  `pointGroup` varchar(45) DEFAULT NULL COMMENT 'point group',
  `geometryClassnameId` int(11) unsigned DEFAULT NULL,
  `MX_used` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 if used in the crystal form',
  PRIMARY KEY (`spaceGroupId`),
  KEY `geometryClassnameId` (`geometryClassnameId`),
  KEY `SpaceGroup_FKShortName` (`spaceGroupShortName`),
  CONSTRAINT `SpaceGroup_ibfk_1` FOREIGN KEY (`geometryClassnameId`) REFERENCES `GeometryClassname` (`geometryClassnameId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=231 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SpaceGroup`
--

LOCK TABLES `SpaceGroup` WRITE;
/*!40000 ALTER TABLE `SpaceGroup` DISABLE KEYS */;
INSERT INTO `SpaceGroup` VALUES
(1,1,'P1','P 1','aP',NULL,NULL,NULL,1),
(2,2,'P-1','P-1',NULL,NULL,NULL,NULL,1),
(3,3,'P2','P 12 1','mP',NULL,NULL,NULL,1),
(4,4,'P21','P 121 1','mP',NULL,NULL,NULL,1),
(5,5,'C2','C 12 1','mC,mI',NULL,NULL,NULL,1),
(6,6,'P1m1','P 1m 1',NULL,NULL,NULL,NULL,0),
(7,7,'P1c1','P 1c 1',NULL,NULL,NULL,NULL,0),
(8,8,'C1m1','C 1m 1',NULL,NULL,NULL,NULL,0),
(9,9,'C1c1','C 1c 1',NULL,NULL,NULL,NULL,0),
(10,10,'P12/m1','P 12/m 1',NULL,NULL,NULL,NULL,0),
(11,11,'P121/m1','P 121/m 1',NULL,NULL,NULL,NULL,0),
(12,12,'C12/m1','C 12/m 1',NULL,NULL,NULL,NULL,0),
(13,13,'P12/c1','P 12/c 1',NULL,NULL,NULL,NULL,0),
(14,14,'P121/c1','P 121/c 1',NULL,NULL,NULL,NULL,0),
(15,15,'C12/c1','C 12/c 1',NULL,NULL,NULL,NULL,0),
(16,16,'P222','P 22 2','oP',NULL,NULL,NULL,1),
(17,17,'P2221','P 22 21','oP',NULL,NULL,NULL,1),
(18,18,'P21212','P21 21 2','oP',NULL,NULL,NULL,1),
(19,19,'P212121','P21 21 21','oP',NULL,NULL,NULL,1),
(20,20,'C2221','C 22 21','oC',NULL,NULL,NULL,1),
(21,21,'C222','C 22 2','oC',NULL,NULL,NULL,1),
(22,22,'F222','F 22 2','oF',NULL,NULL,NULL,1),
(23,23,'I222','I 22 2','oI',NULL,NULL,NULL,1),
(24,24,'I212121','I21 21 21','oI',NULL,NULL,NULL,1),
(25,25,'Pmm2','P mm 2',NULL,NULL,NULL,NULL,0),
(26,26,'Pmc21','P mc 21',NULL,NULL,NULL,NULL,0),
(27,27,'Pcc2','P cc 2',NULL,NULL,NULL,NULL,0),
(28,28,'Pma2','P ma 2',NULL,NULL,NULL,NULL,0),
(29,29,'Pca21','P ca 21',NULL,NULL,NULL,NULL,0),
(30,30,'Pnc2','P nc 2',NULL,NULL,NULL,NULL,0),
(31,31,'Pmn21','P mn 21',NULL,NULL,NULL,NULL,0),
(32,32,'Pba2','P ba 2',NULL,NULL,NULL,NULL,0),
(33,33,'Pna21','P na 21',NULL,NULL,NULL,NULL,0),
(34,34,'Pnn2','P nn 2',NULL,NULL,NULL,NULL,0),
(35,35,'Cmm2','C mm 2',NULL,NULL,NULL,NULL,0),
(36,36,'Cmc21','C mc 21',NULL,NULL,NULL,NULL,0),
(37,37,'Ccc2','C cc 2',NULL,NULL,NULL,NULL,0),
(38,38,'Amm2','A mm 2',NULL,NULL,NULL,NULL,0),
(39,39,'Abm2','A bm 2',NULL,NULL,NULL,NULL,0),
(40,40,'Ama2','A ma 2',NULL,NULL,NULL,NULL,0),
(41,41,'Aba2','A ba 2',NULL,NULL,NULL,NULL,0),
(42,42,'Fmm2','F mm 2',NULL,NULL,NULL,NULL,0),
(43,43,'Fdd2','F dd 2',NULL,NULL,NULL,NULL,0),
(44,44,'Imm2','I mm 2',NULL,NULL,NULL,NULL,0),
(45,45,'Iba2','I ba 2',NULL,NULL,NULL,NULL,0),
(46,46,'Ima2','I ma 2',NULL,NULL,NULL,NULL,0),
(47,47,'Pmmm','P mm m',NULL,NULL,NULL,NULL,0),
(48,48,'Pnnn','P nn n',NULL,NULL,NULL,NULL,0),
(49,49,'Pccm','P cc m',NULL,NULL,NULL,NULL,0),
(50,50,'Pban','P ba n',NULL,NULL,NULL,NULL,0),
(51,51,'Pmma1','P mm a1',NULL,NULL,NULL,NULL,0),
(52,52,'Pnna1','P nn a1',NULL,NULL,NULL,NULL,0),
(53,53,'Pmna1','P mn a1',NULL,NULL,NULL,NULL,0),
(54,54,'Pcca1','P cc a1',NULL,NULL,NULL,NULL,0),
(55,55,'Pbam1','P ba m1',NULL,NULL,NULL,NULL,0),
(56,56,'Pccn1','P cc n1',NULL,NULL,NULL,NULL,0),
(57,57,'Pbcm1','P bc m1',NULL,NULL,NULL,NULL,0),
(58,58,'Pnnm1','P nn m1',NULL,NULL,NULL,NULL,0),
(59,59,'Pmmn1','P mm n1',NULL,NULL,NULL,NULL,0),
(60,60,'Pbcn1','P bc n1',NULL,NULL,NULL,NULL,0),
(61,61,'Pbca1','P bc a1',NULL,NULL,NULL,NULL,0),
(62,62,'Pnma1','P nm a1',NULL,NULL,NULL,NULL,0),
(63,63,'Cmcm1','C mc m1',NULL,NULL,NULL,NULL,0),
(64,64,'Cmca1','C mc a1',NULL,NULL,NULL,NULL,0),
(65,65,'Cmmm','C mm m',NULL,NULL,NULL,NULL,0),
(66,66,'Cccm','C cc m',NULL,NULL,NULL,NULL,0),
(67,67,'Cmma','C mm a',NULL,NULL,NULL,NULL,0),
(68,68,'Ccca','C cc a',NULL,NULL,NULL,NULL,0),
(69,69,'Fmmm','F mm m',NULL,NULL,NULL,NULL,0),
(70,70,'Fddd','F dd d',NULL,NULL,NULL,NULL,0),
(71,71,'Immm','I mm m',NULL,NULL,NULL,NULL,0),
(72,72,'Ibam','I ba m',NULL,NULL,NULL,NULL,0),
(73,73,'Ibca1','I b c a1',NULL,NULL,NULL,NULL,0),
(74,74,'Imma1','I mm a1',NULL,NULL,NULL,NULL,0),
(75,75,'P4','P4','tP',NULL,NULL,NULL,1),
(76,76,'P41','P41','tP',NULL,NULL,NULL,1),
(77,77,'P42','P42','tP',NULL,NULL,NULL,1),
(78,78,'P43','P43','tP',NULL,NULL,NULL,1),
(79,79,'I4','I4','tI',NULL,NULL,NULL,1),
(80,80,'I41','I41','tI',NULL,NULL,NULL,1),
(81,81,'P-4','P-4',NULL,NULL,NULL,NULL,0),
(82,82,'I-4','I-4',NULL,NULL,NULL,NULL,0),
(83,83,'P4/m','P4/m',NULL,NULL,NULL,NULL,0),
(84,84,'P42/m','P42/m',NULL,NULL,NULL,NULL,0),
(85,85,'P4/n','P4/n',NULL,NULL,NULL,NULL,0),
(86,86,'P42/n','P42/n',NULL,NULL,NULL,NULL,0),
(87,87,'I4/m','I4/m',NULL,NULL,NULL,NULL,0),
(88,88,'I41/a','I41/a',NULL,NULL,NULL,NULL,0),
(89,89,'P422','P 42 2','tP',NULL,NULL,NULL,1),
(90,90,'P4212','P 421 2','tP',NULL,NULL,NULL,1),
(91,91,'P4122','P41 2 2','tP',NULL,NULL,NULL,1),
(92,92,'P41212','P41 21 2','tP',NULL,NULL,NULL,1),
(93,93,'P4222','P42 2 2','tP',NULL,NULL,NULL,1),
(94,94,'P42212','P42 21 2','tP',NULL,NULL,NULL,1),
(95,95,'P4322','P43 2 2','tP',NULL,NULL,NULL,1),
(96,96,'P43212','P43 21 2','tP',NULL,NULL,NULL,1),
(97,97,'I422','I 42 2','tI',NULL,NULL,NULL,1),
(98,98,'I4122','I41 2 2','tI',NULL,NULL,NULL,1),
(99,99,'P4mm','P 4m m',NULL,NULL,NULL,NULL,0),
(100,100,'P4bm','P4 b m',NULL,NULL,NULL,NULL,0),
(101,101,'P42cm','P42 c m',NULL,NULL,NULL,NULL,0),
(102,102,'P42nm','P42 n m',NULL,NULL,NULL,NULL,0),
(103,103,'P4cc','P4 c c',NULL,NULL,NULL,NULL,0),
(104,104,'P4nc','P4 n c',NULL,NULL,NULL,NULL,0),
(105,105,'P42mc','P42 m c',NULL,NULL,NULL,NULL,0),
(106,106,'P42bc','P42 b c',NULL,NULL,NULL,NULL,0),
(107,107,'I4mm','I4 m m',NULL,NULL,NULL,NULL,0),
(108,108,'I4cm','I4 c m',NULL,NULL,NULL,NULL,0),
(109,109,'I41md','I41 m d',NULL,NULL,NULL,NULL,0),
(110,110,'I41cd','I41 c d',NULL,NULL,NULL,NULL,0),
(111,111,'P-42m','P-4 2 m',NULL,NULL,NULL,NULL,0),
(112,112,'P-42c','P-4 2 c',NULL,NULL,NULL,NULL,0),
(113,113,'P-421m','P-4 21 m',NULL,NULL,NULL,NULL,0),
(114,114,'P-421c','P-4 21 c',NULL,NULL,NULL,NULL,0),
(115,115,'P-4m2','P-4 m 2',NULL,NULL,NULL,NULL,0),
(116,116,'P-4c2','P-4 c 2',NULL,NULL,NULL,NULL,0),
(117,117,'P-4b2','P-4 b 2',NULL,NULL,NULL,NULL,0),
(118,118,'P-4n2','P-4 n 2',NULL,NULL,NULL,NULL,0),
(119,119,'I-4m2','I-4 m 2',NULL,NULL,NULL,NULL,0),
(120,120,'I-4c2','I-4 c 2',NULL,NULL,NULL,NULL,0),
(121,121,'I-42m','I-4 2 m',NULL,NULL,NULL,NULL,0),
(122,122,'I-42d','I-4 2 d',NULL,NULL,NULL,NULL,0),
(123,123,'P4/mmm','P4/m m m',NULL,NULL,NULL,NULL,0),
(124,124,'P4/mcc','P4/m c c',NULL,NULL,NULL,NULL,0),
(125,125,'P4/nbm','P4/n b m',NULL,NULL,NULL,NULL,0),
(126,126,'P4/nnc','P4/n n c',NULL,NULL,NULL,NULL,0),
(127,127,'P4/mbm1','P4/m b m1',NULL,NULL,NULL,NULL,0),
(128,128,'P4/mnc1','P4/m n c1',NULL,NULL,NULL,NULL,0),
(129,129,'P4/nmm1','P4/n m m1',NULL,NULL,NULL,NULL,0),
(130,130,'P4/ncc1','P4/n c c1',NULL,NULL,NULL,NULL,0),
(131,131,'P42/mmc','P42/m m c',NULL,NULL,NULL,NULL,0),
(132,132,'P42/mcm','P42/m c m',NULL,NULL,NULL,NULL,0),
(133,133,'P42/nbc','P42/n b c',NULL,NULL,NULL,NULL,0),
(134,134,'P42/nnm','P42/n n m',NULL,NULL,NULL,NULL,0),
(135,135,'P42/mbc','P42/m b c',NULL,NULL,NULL,NULL,0),
(136,136,'P42/mnm','P42/m n m',NULL,NULL,NULL,NULL,0),
(137,137,'P42/nmc','P42/n m c',NULL,NULL,NULL,NULL,0),
(138,138,'P42/ncm','P42/n c m',NULL,NULL,NULL,NULL,0),
(139,139,'I4/mmm','I4/m m m',NULL,NULL,NULL,NULL,0),
(140,140,'I4/mcm','I4/m c m',NULL,NULL,NULL,NULL,0),
(141,141,'I41/amd','I41/a m d',NULL,NULL,NULL,NULL,0),
(142,142,'I41/acd','I41/a c d',NULL,NULL,NULL,NULL,0),
(143,143,'P3','P3','hP',NULL,NULL,NULL,1),
(144,144,'P31','P31','hP',NULL,NULL,NULL,1),
(145,145,'P32','P32','hP',NULL,NULL,NULL,1),
(146,146,'R3','H3','hR',NULL,NULL,NULL,1),
(147,147,'P-3','P-3',NULL,NULL,NULL,NULL,0),
(148,148,'H-3','H-3',NULL,NULL,NULL,NULL,0),
(149,149,'P312','P3 1 2','hP',NULL,NULL,NULL,1),
(150,150,'P321','P3 2 1','hP',NULL,NULL,NULL,1),
(151,151,'P3112','P31 1 2','hP',NULL,NULL,NULL,1),
(152,152,'P3121','P31 2 1','hP',NULL,NULL,NULL,1),
(153,153,'P3212','P32 1 2','hP',NULL,NULL,NULL,1),
(154,154,'P3221','P32 2 1','hP',NULL,NULL,NULL,1),
(155,155,'R32','H3 2','hR',NULL,NULL,NULL,1),
(156,156,'P3m1','P3 m 1',NULL,NULL,NULL,NULL,0),
(157,157,'P31m','P3 1 m',NULL,NULL,NULL,NULL,0),
(158,158,'P3c1','P3 c 1',NULL,NULL,NULL,NULL,0),
(159,159,'P31c','P3 1 c',NULL,NULL,NULL,NULL,0),
(160,160,'H3m','H3 m',NULL,NULL,NULL,NULL,0),
(161,161,'H3c','H3 c',NULL,NULL,NULL,NULL,0),
(162,162,'P-31m','P-3 1 m',NULL,NULL,NULL,NULL,0),
(163,163,'P-31c','P-3 1 c',NULL,NULL,NULL,NULL,0),
(164,164,'P-3m1','P-3 m 1',NULL,NULL,NULL,NULL,0),
(165,165,'P-3c1','P-3 c 1',NULL,NULL,NULL,NULL,0),
(166,166,'H-3m','H-3 m',NULL,NULL,NULL,NULL,0),
(167,167,'H-3c','H-3 c',NULL,NULL,NULL,NULL,0),
(168,168,'P6','P6','hP',NULL,NULL,NULL,1),
(169,169,'P61','P61','hP',NULL,NULL,NULL,1),
(170,170,'P65','P65','hP',NULL,NULL,NULL,1),
(171,171,'P62','P62','hP',NULL,NULL,NULL,1),
(172,172,'P64','P64','hP',NULL,NULL,NULL,1),
(173,173,'P63','P63','hP',NULL,NULL,NULL,1),
(174,174,'P-6','P-6',NULL,NULL,NULL,NULL,0),
(175,175,'P6/m','P6/m',NULL,NULL,NULL,NULL,0),
(176,176,'P63/m','P63/m',NULL,NULL,NULL,NULL,0),
(177,177,'P622','P6 2 2','hP',NULL,NULL,NULL,1),
(178,178,'P6122','P61 2 2','hP',NULL,NULL,NULL,1),
(179,179,'P6522','P65 2 2','hP',NULL,NULL,NULL,1),
(180,180,'P6222','P62 2 2','hP',NULL,NULL,NULL,1),
(181,181,'P6422','P64 2 2','hP',NULL,NULL,NULL,1),
(182,182,'P6322','P63 2 2','hP',NULL,NULL,NULL,1),
(183,183,'P6mm','P6 m m',NULL,NULL,NULL,NULL,0),
(184,184,'P6cc','P6 c c',NULL,NULL,NULL,NULL,0),
(185,185,'P63cm','P63 c m',NULL,NULL,NULL,NULL,0),
(186,186,'P63mc','P63 m c',NULL,NULL,NULL,NULL,0),
(187,187,'P-6m2','P-6 m 2',NULL,NULL,NULL,NULL,0),
(188,188,'P-6c2','P-6 c 2',NULL,NULL,NULL,NULL,0),
(189,189,'P-62m','P-6 2 m',NULL,NULL,NULL,NULL,0),
(190,190,'P-62c','P-6 2 c',NULL,NULL,NULL,NULL,0),
(191,191,'P6/mmm','P6/m m m',NULL,NULL,NULL,NULL,0),
(192,192,'P6/mcc','P6/m c c',NULL,NULL,NULL,NULL,0),
(193,193,'P63/mcm','P63/m c m',NULL,NULL,NULL,NULL,0),
(194,194,'P63/mmc','P63/m m c',NULL,NULL,NULL,NULL,0),
(195,195,'P23','P2 3','cP',NULL,NULL,NULL,1),
(196,196,'F23','F2 3','cF',NULL,NULL,NULL,1),
(197,197,'I23','I2 3','cI',NULL,NULL,NULL,1),
(198,198,'P213','P21 3','cP',NULL,NULL,NULL,1),
(199,199,'I213','I21 3','cI',NULL,NULL,NULL,1),
(200,200,'Pm-3','Pm -3',NULL,NULL,NULL,NULL,0),
(201,201,'Pn-3','Pn -3',NULL,NULL,NULL,NULL,0),
(202,202,'Fm-3','Fm -3',NULL,NULL,NULL,NULL,0),
(203,203,'Fd-3','Fd -3',NULL,NULL,NULL,NULL,0),
(204,204,'Im-3','Im -3',NULL,NULL,NULL,NULL,0),
(205,205,'Pa-31','Pa -31',NULL,NULL,NULL,NULL,0),
(206,206,'Ia-31','Ia -31',NULL,NULL,NULL,NULL,0),
(207,207,'P432','P4 3 2','cP',NULL,NULL,NULL,1),
(208,208,'P4232','P42 3 2','cP',NULL,NULL,NULL,1),
(209,209,'F432','F4 3 2','cF',NULL,NULL,NULL,1),
(210,210,'F4132','F41 3 2','cF',NULL,NULL,NULL,1),
(211,211,'I432','I4 3 2','cI',NULL,NULL,NULL,1),
(212,212,'P4332','P43 3 2','cP',NULL,NULL,NULL,1),
(213,213,'P4132','P41 3 2','cP',NULL,NULL,NULL,1),
(214,214,'I4132','I41 3 2','cI',NULL,NULL,NULL,1),
(215,215,'P-43m','P-4 3 m',NULL,NULL,NULL,NULL,0),
(216,216,'F-43m','F-4 3 m',NULL,NULL,NULL,NULL,0),
(217,217,'I-43m','I-4 3 m',NULL,NULL,NULL,NULL,0),
(218,218,'P-43n','P-4 3 n',NULL,NULL,NULL,NULL,0),
(219,219,'F-43c','F-4 3 c',NULL,NULL,NULL,NULL,0),
(220,220,'I-43d','I-4 3 d',NULL,NULL,NULL,NULL,0),
(221,221,'Pm-3m','Pm -3 m',NULL,NULL,NULL,NULL,0),
(222,222,'Pn-3n','Pn -3 n',NULL,NULL,NULL,NULL,0),
(223,223,'Pm-3n1','Pm -3 n1',NULL,NULL,NULL,NULL,0),
(224,224,'Pn-3m1','Pn -3 m1',NULL,NULL,NULL,NULL,0),
(225,225,'Fm-3m','Fm -3 m',NULL,NULL,NULL,NULL,0),
(226,226,'Fm-3c','Fm -3 c',NULL,NULL,NULL,NULL,0),
(227,227,'Fd-3m1','Fd -3 m1',NULL,NULL,NULL,NULL,0),
(228,228,'Fd-3c1','Fd -3 c1',NULL,NULL,NULL,NULL,0),
(229,229,'Im-3m','Im -3 m',NULL,NULL,NULL,NULL,0),
(230,230,'Ia-3d1','Ia -3 d1',NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `SpaceGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SubstructureDetermination`
--

DROP TABLE IF EXISTS `SubstructureDetermination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `SubstructureDetermination` (
  `substructureDeterminationId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key (auto-incremented)',
  `phasingAnalysisId` int(11) unsigned NOT NULL COMMENT 'Related phasing analysis item',
  `phasingProgramRunId` int(11) unsigned NOT NULL COMMENT 'Related program item',
  `spaceGroupId` int(10) unsigned DEFAULT NULL COMMENT 'Related spaceGroup',
  `method` enum('SAD','MAD','SIR','SIRAS','MR','MIR','MIRAS','RIP','RIPAS') DEFAULT NULL COMMENT 'phasing method',
  `lowRes` double DEFAULT NULL,
  `highRes` double DEFAULT NULL,
  `recordTimeStamp` datetime DEFAULT NULL COMMENT 'Creation or last update date/time',
  PRIMARY KEY (`substructureDeterminationId`),
  KEY `SubstructureDetermination_FKIndex1` (`phasingAnalysisId`),
  KEY `SubstructureDetermination_FKIndex2` (`phasingProgramRunId`),
  KEY `SubstructureDetermination_FKIndex3` (`spaceGroupId`),
  CONSTRAINT `SubstructureDetermination_phasingAnalysisfk_1` FOREIGN KEY (`phasingAnalysisId`) REFERENCES `PhasingAnalysis` (`phasingAnalysisId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `SubstructureDetermination_phasingProgramRunfk_1` FOREIGN KEY (`phasingProgramRunId`) REFERENCES `PhasingProgramRun` (`phasingProgramRunId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `SubstructureDetermination_spaceGroupfk_1` FOREIGN KEY (`spaceGroupId`) REFERENCES `SpaceGroup` (`spaceGroupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubstructureDetermination`
--

LOCK TABLES `SubstructureDetermination` WRITE;
/*!40000 ALTER TABLE `SubstructureDetermination` DISABLE KEYS */;
/*!40000 ALTER TABLE `SubstructureDetermination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TiltImageAlignment`
--

DROP TABLE IF EXISTS `TiltImageAlignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TiltImageAlignment` (
  `movieId` int(11) unsigned NOT NULL COMMENT 'FK to Movie table',
  `tomogramId` int(11) unsigned NOT NULL COMMENT 'FK to Tomogram table; tuple (movieID, tomogramID) is unique',
  `defocusU` float DEFAULT NULL COMMENT 'unit: Angstroms',
  `defocusV` float DEFAULT NULL COMMENT 'unit: Angstroms',
  `psdFile` varchar(255) DEFAULT NULL,
  `resolution` float DEFAULT NULL COMMENT 'unit: Angstroms',
  `fitQuality` float DEFAULT NULL,
  `refinedMagnification` float DEFAULT NULL COMMENT 'unitless',
  `refinedTiltAngle` float DEFAULT NULL COMMENT 'units: degrees',
  `refinedTiltAxis` float DEFAULT NULL COMMENT 'units: degrees',
  `residualError` float DEFAULT NULL COMMENT 'Residual error, unit: nm',
  PRIMARY KEY (`movieId`,`tomogramId`),
  KEY `TiltImageAlignment_fk_tomogramId` (`tomogramId`),
  CONSTRAINT `TiltImageAlignment_fk_movieId` FOREIGN KEY (`movieId`) REFERENCES `Movie` (`movieId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `TiltImageAlignment_fk_tomogramId` FOREIGN KEY (`tomogramId`) REFERENCES `Tomogram` (`tomogramId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='For storing per-movie analysis results (reconstruction)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TiltImageAlignment`
--

LOCK TABLES `TiltImageAlignment` WRITE;
/*!40000 ALTER TABLE `TiltImageAlignment` DISABLE KEYS */;
INSERT INTO `TiltImageAlignment` VALUES
(1,1,NULL,NULL,NULL,NULL,NULL,NULL,16,5,NULL),
(2,1,NULL,NULL,NULL,NULL,NULL,NULL,17,5,NULL),
(3,1,NULL,NULL,NULL,NULL,NULL,NULL,18,5,NULL),
(4,1,NULL,NULL,NULL,NULL,NULL,NULL,19,5,NULL),
(5,2,NULL,NULL,NULL,NULL,NULL,NULL,16,5,NULL),
(6,2,NULL,NULL,NULL,NULL,NULL,NULL,17,5,NULL),
(7,2,NULL,NULL,NULL,NULL,NULL,NULL,18,5,NULL),
(8,2,NULL,NULL,NULL,NULL,NULL,NULL,19,5,NULL),
(11,8,NULL,NULL,NULL,NULL,NULL,NULL,19,5,NULL),
(12,8,NULL,NULL,NULL,NULL,NULL,NULL,19,5,NULL),
(13,8,NULL,NULL,NULL,NULL,NULL,NULL,19,5,NULL),
(14,5,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL);
/*!40000 ALTER TABLE `TiltImageAlignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tomogram`
--

DROP TABLE IF EXISTS `Tomogram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tomogram` (
  `tomogramId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionId` int(11) unsigned DEFAULT NULL COMMENT 'FK to DataCollection table',
  `autoProcProgramId` int(10) unsigned DEFAULT NULL COMMENT 'FK, gives processing times/status and software information',
  `volumeFile` varchar(255) DEFAULT NULL COMMENT '.mrc file representing the reconstructed tomogram volume',
  `stackFile` varchar(255) DEFAULT NULL COMMENT '.mrc file containing the motion corrected images ordered by angle used as input for the reconstruction',
  `sizeX` int(11) unsigned DEFAULT NULL COMMENT 'unit: pixels',
  `sizeY` int(11) unsigned DEFAULT NULL COMMENT 'unit: pixels',
  `sizeZ` int(11) unsigned DEFAULT NULL COMMENT 'unit: pixels',
  `pixelSpacing` float DEFAULT NULL COMMENT 'Angstrom/pixel conversion factor',
  `residualErrorMean` float DEFAULT NULL COMMENT 'Alignment error, unit: nm',
  `residualErrorSD` float DEFAULT NULL COMMENT 'Standard deviation of the alignment error, unit: nm',
  `xAxisCorrection` float DEFAULT NULL COMMENT 'X axis angle (etomo), unit: degrees',
  `tiltAngleOffset` float DEFAULT NULL COMMENT 'tilt Axis offset (etomo), unit: degrees',
  `zShift` float DEFAULT NULL COMMENT 'shift to center volumen in Z (etomo)',
  `fileDirectory` varchar(255) DEFAULT NULL COMMENT 'Directory path for files referenced by this table',
  `centralSliceImage` varchar(255) DEFAULT NULL COMMENT 'Tomogram central slice file',
  `tomogramMovie` varchar(255) DEFAULT NULL COMMENT 'Movie traversing the tomogram across an axis',
  `xyShiftPlot` varchar(255) DEFAULT NULL COMMENT 'XY shift plot file',
  `projXY` varchar(255) DEFAULT NULL COMMENT 'XY projection file',
  `projXZ` varchar(255) DEFAULT NULL COMMENT 'XZ projection file',
  `recordTimeStamp` datetime DEFAULT current_timestamp() COMMENT 'Creation or last update date/time',
  `globalAlignmentQuality` float DEFAULT NULL COMMENT 'Quality of fit metric for the alignment of the tilt series corresponding to this tomogram',
  `gridSquareId` int(11) unsigned DEFAULT NULL COMMENT 'FK, references medium mag map in GridSquare',
  `pixelLocationX` int(11) DEFAULT NULL COMMENT 'pixel location of tomogram centre on search map image (x)',
  `pixelLocationY` int(11) DEFAULT NULL COMMENT 'pixel location of tomogram centre on search map image (y)',
  PRIMARY KEY (`tomogramId`),
  KEY `Tomogram_fk_dataCollectionId` (`dataCollectionId`),
  KEY `Tomogram_fk_autoProcProgramId` (`autoProcProgramId`),
  KEY `Tomogram_fk_gridSquareId` (`gridSquareId`),
  CONSTRAINT `Tomogram_fk_autoProcProgramId` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Tomogram_fk_dataCollectionId` FOREIGN KEY (`dataCollectionId`) REFERENCES `DataCollection` (`dataCollectionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Tomogram_fk_gridSquareId` FOREIGN KEY (`gridSquareId`) REFERENCES `GridSquare` (`gridSquareId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='For storing per-sample, per-position data analysis results (reconstruction)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tomogram`
--

LOCK TABLES `Tomogram` WRITE;
/*!40000 ALTER TABLE `Tomogram` DISABLE KEYS */;
INSERT INTO `Tomogram` VALUES
(1,6017406,56986676,'aligned_file_fri_aretomo.mrc','/dls/m02/data/align_output/Position_1_9_stack_reprocess1.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test_thumbnail.png','test_movie.png','test.png','test.png','test.png','2023-01-19 14:15:44',1.1,NULL,NULL,NULL),
(2,6017408,56986678,'aligned_file_fri_aretomo.mrc','/dls/m02/data/align_output/Position_1_9_stack.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test.png','test.png','test.png','test.png','test.png','2023-01-19 14:15:44',NULL,NULL,NULL,NULL),
(3,6017409,56986678,'aligned_file_fri_aretomo.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test.png','test.png','test.png','test.png','test.png','2023-01-19 14:15:44',NULL,NULL,NULL,NULL),
(4,6017411,56986679,'aligned_file_fri_aretomo.mrc','/dls/m02/data/align_output/Position_1_9_stack.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test.png','test.png','test.png','test.png','test.png','2023-01-19 14:15:44',NULL,NULL,NULL,NULL),
(5,6017411,56986800,'aligned_file_fri_aretomo.mrc','/dls/m02/data/align_output/Position_1_9_stack.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test.png','test.png','test.png','test.png','test.png','2023-01-19 14:15:44',NULL,NULL,NULL,NULL),
(6,6017408,56986676,'aligned_file_fri_aretomo.mrc','/dls/m02/data/align_output/Position_1_9_stack.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test.png','test.png','test.png','test.png','test.png','2023-01-19 14:15:44',NULL,NULL,NULL,NULL),
(7,6017408,56986676,'aligned_file_fri_aretomo.mrc','/dls/m02/data/align_output/Position_1_9_stack.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test.png','test.png','test.png','test.png','test.png','2023-01-19 14:15:44',NULL,NULL,NULL,NULL),
(8,6017413,56986801,'aligned_file_fri_aretomo.mrc','/dls/m02/data/align_output/Position_1_9_stack.mrc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'/dls','test.png','test.png','test.png','test.png','test.png','2023-01-19 14:15:44',1.2,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Tomogram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserGroup`
--

DROP TABLE IF EXISTS `UserGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserGroup` (
  `userGroupId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(31) NOT NULL,
  PRIMARY KEY (`userGroupId`),
  UNIQUE KEY `UserGroup_idx1` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserGroup`
--

LOCK TABLES `UserGroup` WRITE;
/*!40000 ALTER TABLE `UserGroup` DISABLE KEYS */;
INSERT INTO `UserGroup` VALUES
(39,'autocollect'),
(17,'bag_stats'),
(20,'bl_stats'),
(45,'detector_admin'),
(8,'developers'),
(9,'ehc'),
(6,'em_admin'),
(10,'fault_admin'),
(50,'goods_handling'),
(53,'imaging_admin'),
(59,'mm_admin'),
(2,'mx_admin'),
(14,'pdb_stats'),
(4,'powder_admin'),
(47,'prop_admin'),
(3,'saxs_admin'),
(28,'ship_manage'),
(12,'sm_admin'),
(56,'spectroscopy_admin'),
(1,'super_admin'),
(24,'temp_mx_admin'),
(5,'tomo_admin'),
(11,'vmxi'),
(34,'xpdf_admin');
/*!40000 ALTER TABLE `UserGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserGroup_has_LDAPSearchParameters`
--

DROP TABLE IF EXISTS `UserGroup_has_LDAPSearchParameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserGroup_has_LDAPSearchParameters` (
  `userGroupId` int(11) unsigned NOT NULL,
  `ldapSearchParametersId` int(11) unsigned NOT NULL,
  `name` varchar(200) NOT NULL COMMENT 'Name of the object we search for',
  PRIMARY KEY (`userGroupId`,`ldapSearchParametersId`,`name`),
  KEY `UserGroup_has_LDAPSearchParameters_fk2` (`ldapSearchParametersId`),
  CONSTRAINT `UserGroup_has_LDAPSearchParameters_fk1` FOREIGN KEY (`userGroupId`) REFERENCES `UserGroup` (`userGroupId`),
  CONSTRAINT `UserGroup_has_LDAPSearchParameters_fk2` FOREIGN KEY (`ldapSearchParametersId`) REFERENCES `LDAPSearchParameters` (`ldapSearchParametersId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Gives the LDAP search parameters needed to find a set of usergroup members';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserGroup_has_LDAPSearchParameters`
--

LOCK TABLES `UserGroup_has_LDAPSearchParameters` WRITE;
/*!40000 ALTER TABLE `UserGroup_has_LDAPSearchParameters` DISABLE KEYS */;
INSERT INTO `UserGroup_has_LDAPSearchParameters` VALUES
(1,1,'dls_foo'),
(17,2,'dls_bar');
/*!40000 ALTER TABLE `UserGroup_has_LDAPSearchParameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserGroup_has_Permission`
--

DROP TABLE IF EXISTS `UserGroup_has_Permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserGroup_has_Permission` (
  `userGroupId` int(11) unsigned NOT NULL,
  `permissionId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`userGroupId`,`permissionId`),
  KEY `UserGroup_has_Permission_fk2` (`permissionId`),
  CONSTRAINT `UserGroup_has_Permission_fk1` FOREIGN KEY (`userGroupId`) REFERENCES `UserGroup` (`userGroupId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `UserGroup_has_Permission_fk2` FOREIGN KEY (`permissionId`) REFERENCES `Permission` (`permissionId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserGroup_has_Permission`
--

LOCK TABLES `UserGroup_has_Permission` WRITE;
/*!40000 ALTER TABLE `UserGroup_has_Permission` DISABLE KEYS */;
INSERT INTO `UserGroup_has_Permission` VALUES
(1,1),
(1,7),
(1,8),
(1,9),
(1,10),
(1,11),
(1,18),
(1,20),
(1,23),
(1,49),
(2,1),
(2,6),
(2,23),
(2,80),
(3,7),
(3,23),
(4,20),
(5,10),
(6,8),
(6,23),
(8,1),
(8,2),
(8,4),
(8,6),
(8,7),
(8,8),
(8,9),
(8,10),
(8,11),
(8,18),
(8,20),
(8,23),
(8,26),
(8,29),
(8,37),
(8,49),
(9,1),
(9,6),
(10,12),
(10,77),
(11,13),
(11,15),
(11,16),
(11,17),
(11,32),
(11,43),
(11,55),
(11,58),
(11,64),
(12,18),
(14,1),
(17,26),
(20,29),
(24,1),
(28,23),
(28,37),
(34,49),
(39,69);
/*!40000 ALTER TABLE `UserGroup_has_Permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserGroup_has_Person`
--

DROP TABLE IF EXISTS `UserGroup_has_Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserGroup_has_Person` (
  `userGroupId` int(11) unsigned NOT NULL,
  `personId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`userGroupId`,`personId`),
  KEY `userGroup_has_Person_fk2` (`personId`),
  CONSTRAINT `userGroup_has_Person_fk1` FOREIGN KEY (`userGroupId`) REFERENCES `UserGroup` (`userGroupId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userGroup_has_Person_fk2` FOREIGN KEY (`personId`) REFERENCES `Person` (`personId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserGroup_has_Person`
--

LOCK TABLES `UserGroup_has_Person` WRITE;
/*!40000 ALTER TABLE `UserGroup_has_Person` DISABLE KEYS */;
INSERT INTO `UserGroup_has_Person` VALUES
(1,17000),
(1,18549),
(1,46270),
(2,16000),
(6,18660);
/*!40000 ALTER TABLE `UserGroup_has_Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `XFEFluorescenceComposite`
--

DROP TABLE IF EXISTS `XFEFluorescenceComposite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `XFEFluorescenceComposite` (
  `xfeFluorescenceCompositeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `r` int(10) unsigned NOT NULL COMMENT 'Red layer',
  `g` int(10) unsigned NOT NULL COMMENT 'Green layer',
  `b` int(10) unsigned NOT NULL COMMENT 'Blue layer',
  `rOpacity` float NOT NULL DEFAULT 1 COMMENT 'Red layer opacity',
  `bOpacity` float NOT NULL DEFAULT 1 COMMENT 'Red layer opacity',
  `gOpacity` float NOT NULL DEFAULT 1 COMMENT 'Red layer opacity',
  `opacity` float NOT NULL DEFAULT 1 COMMENT 'Total map opacity',
  PRIMARY KEY (`xfeFluorescenceCompositeId`),
  KEY `XFEFluorescenceComposite_ibfk1` (`r`),
  KEY `XFEFluorescenceComposite_ibfk2` (`g`),
  KEY `XFEFluorescenceComposite_ibfk3` (`b`),
  CONSTRAINT `XFEFluorescenceComposite_ibfk1` FOREIGN KEY (`r`) REFERENCES `XRFFluorescenceMapping` (`xrfFluorescenceMappingId`),
  CONSTRAINT `XFEFluorescenceComposite_ibfk2` FOREIGN KEY (`g`) REFERENCES `XRFFluorescenceMapping` (`xrfFluorescenceMappingId`),
  CONSTRAINT `XFEFluorescenceComposite_ibfk3` FOREIGN KEY (`b`) REFERENCES `XRFFluorescenceMapping` (`xrfFluorescenceMappingId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='A composite XRF map composed of three XRFFluorescenceMapping entries creating r, g, b layers';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `XFEFluorescenceComposite`
--

LOCK TABLES `XFEFluorescenceComposite` WRITE;
/*!40000 ALTER TABLE `XFEFluorescenceComposite` DISABLE KEYS */;
/*!40000 ALTER TABLE `XFEFluorescenceComposite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `XFEFluorescenceSpectrum`
--

DROP TABLE IF EXISTS `XFEFluorescenceSpectrum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `XFEFluorescenceSpectrum` (
  `xfeFluorescenceSpectrumId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sessionId` int(10) unsigned NOT NULL,
  `blSampleId` int(10) unsigned DEFAULT NULL,
  `jpegScanFileFullPath` varchar(255) DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `exposureTime` float DEFAULT NULL,
  `axisPosition` float DEFAULT NULL,
  `beamTransmission` float DEFAULT NULL,
  `annotatedPymcaXfeSpectrum` varchar(255) DEFAULT NULL,
  `fittedDataFileFullPath` varchar(255) DEFAULT NULL,
  `scanFileFullPath` varchar(255) DEFAULT NULL,
  `energy` float DEFAULT NULL,
  `beamSizeVertical` float DEFAULT NULL,
  `beamSizeHorizontal` float DEFAULT NULL,
  `crystalClass` varchar(20) DEFAULT NULL,
  `comments` varchar(1024) DEFAULT NULL,
  `blSubSampleId` int(11) unsigned DEFAULT NULL,
  `flux` double DEFAULT NULL COMMENT 'flux measured before the xrfSpectra',
  `flux_end` double DEFAULT NULL COMMENT 'flux measured after the xrfSpectra',
  `workingDirectory` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`xfeFluorescenceSpectrumId`),
  KEY `XFEFluorescnceSpectrum_FKIndex1` (`blSampleId`),
  KEY `XFEFluorescnceSpectrum_FKIndex2` (`sessionId`),
  KEY `XFE_ibfk_3` (`blSubSampleId`),
  CONSTRAINT `XFE_ibfk_1` FOREIGN KEY (`sessionId`) REFERENCES `BLSession` (`sessionId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `XFE_ibfk_2` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `XFE_ibfk_3` FOREIGN KEY (`blSubSampleId`) REFERENCES `BLSubSample` (`blSubSampleId`)
) ENGINE=InnoDB AUTO_INCREMENT=2414 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `XFEFluorescenceSpectrum`
--

LOCK TABLES `XFEFluorescenceSpectrum` WRITE;
/*!40000 ALTER TABLE `XFEFluorescenceSpectrum` DISABLE KEYS */;
INSERT INTO `XFEFluorescenceSpectrum` VALUES
(1766,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160112_14_49_14.png','2016-01-12 14:49:14','2016-01-12 14:50:05','/dls/i03/data/2016/cm14451-1/20160112_14_49_14.mca',3,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160112_14_49_14.html',NULL,'/dls/i03/data/2016/cm14451-1/20160112_14_49_14.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1779,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_15_53_23.png','2016-01-13 15:53:23','2016-01-13 15:54:53','/dls/i03/data/2016/cm14451-1/20160113_15_53_23.mca',3,NULL,1.6,'/dls/i03/data/2016/cm14451-1/20160113_15_53_23.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_15_53_23.dat',12700,20,20,NULL,NULL,NULL,NULL,NULL,NULL),
(1780,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_50_27.png','2016-01-13 16:50:27','2016-01-13 16:51:27','/dls/i03/data/2016/cm14451-1/20160113_16_50_27.mca',3,NULL,25.6,'/dls/i03/data/2016/cm14451-1/20160113_16_50_27.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_50_27.dat',12700,20,20,NULL,NULL,NULL,NULL,NULL,NULL),
(1781,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_51_54.png','2016-01-13 16:51:54','2016-01-13 16:52:29','/dls/i03/data/2016/cm14451-1/20160113_16_51_54.mca',1,NULL,100,'/dls/i03/data/2016/cm14451-1/20160113_16_51_54.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_51_54.dat',12700,20,20,NULL,NULL,NULL,NULL,NULL,NULL),
(1782,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_55_14.png','2016-01-13 16:55:14','2016-01-13 16:55:24','/dls/i03/data/2016/cm14451-1/20160113_16_55_14.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_16_55_14.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_55_14.dat',12700,20,20,NULL,NULL,NULL,NULL,NULL,NULL),
(1783,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_57_18.png','2016-01-13 16:57:18','2016-01-13 16:57:28','/dls/i03/data/2016/cm14451-1/20160113_16_57_18.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_16_57_18.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_57_18.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1784,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_58_02.png','2016-01-13 16:58:02','2016-01-13 16:58:13','/dls/i03/data/2016/cm14451-1/20160113_16_58_02.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_16_58_02.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_58_02.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1785,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_59_00.png','2016-01-13 16:59:00','2016-01-13 16:59:12','/dls/i03/data/2016/cm14451-1/20160113_16_59_00.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_16_59_00.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_59_00.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1786,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_59_53.png','2016-01-13 16:59:53','2016-01-13 17:00:04','/dls/i03/data/2016/cm14451-1/20160113_16_59_53.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_16_59_53.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_16_59_53.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1787,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_01_34.png','2016-01-13 17:01:34','2016-01-13 17:01:49','/dls/i03/data/2016/cm14451-1/20160113_17_01_34.mca',1,NULL,30.0212,'/dls/i03/data/2016/cm14451-1/20160113_17_01_34.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_01_34.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1788,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_11_40.png','2016-01-13 17:11:40','2016-01-13 17:12:54','/dls/i03/data/2016/cm14451-1/20160113_17_11_40.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_11_40.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_11_40.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1789,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_13_25.png','2016-01-13 17:13:25','2016-01-13 17:13:36','/dls/i03/data/2016/cm14451-1/20160113_17_13_25.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_13_25.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_13_25.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1790,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_14_01.png','2016-01-13 17:14:01','2016-01-13 17:14:13','/dls/i03/data/2016/cm14451-1/20160113_17_14_01.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_14_01.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_14_01.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1791,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_15_13.png','2016-01-13 17:15:13','2016-01-13 17:15:26','/dls/i03/data/2016/cm14451-1/20160113_17_15_13.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_15_13.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_15_13.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1792,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_20_59.png','2016-01-13 17:20:59','2016-01-13 17:21:10','/dls/i03/data/2016/cm14451-1/20160113_17_20_59.mca',1,NULL,4.99011,'/dls/i03/data/2016/cm14451-1/20160113_17_20_59.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_20_59.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1793,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_21_26.png','2016-01-13 17:21:26','2016-01-13 17:21:38','/dls/i03/data/2016/cm14451-1/20160113_17_21_26.mca',1,NULL,4.99011,'/dls/i03/data/2016/cm14451-1/20160113_17_21_26.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_21_26.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1794,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_24_57.png','2016-01-13 17:24:57','2016-01-13 17:25:11','/dls/i03/data/2016/cm14451-1/20160113_17_24_57.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_24_57.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_24_57.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1795,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_25_21.png','2016-01-13 17:25:21','2016-01-13 17:25:32','/dls/i03/data/2016/cm14451-1/20160113_17_25_21.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_25_21.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_25_21.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1796,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_25_48.png','2016-01-13 17:25:48','2016-01-13 17:26:00','/dls/i03/data/2016/cm14451-1/20160113_17_25_48.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_25_48.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_25_48.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1797,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_26_44.png','2016-01-13 17:26:44','2016-01-13 17:26:57','/dls/i03/data/2016/cm14451-1/20160113_17_26_44.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_26_44.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_26_44.dat',12700,20,20,NULL,NULL,NULL,NULL,NULL,NULL),
(1798,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_27_19.png','2016-01-13 17:27:19','2016-01-13 17:27:32','/dls/i03/data/2016/cm14451-1/20160113_17_27_19.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_27_19.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_27_19.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1799,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_28_10.png','2016-01-13 17:28:10','2016-01-13 17:28:22','/dls/i03/data/2016/cm14451-1/20160113_17_28_10.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_28_10.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_28_10.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1800,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_29_49.png','2016-01-13 17:29:49','2016-01-13 17:30:01','/dls/i03/data/2016/cm14451-1/20160113_17_29_49.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_29_49.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_29_49.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1801,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_55_15.png','2016-01-13 17:55:15','2016-01-13 17:56:11','/dls/i03/data/2016/cm14451-1/20160113_17_55_15.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_55_15.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_55_15.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1802,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_57_11.png','2016-01-13 17:57:11','2016-01-13 17:57:22','/dls/i03/data/2016/cm14451-1/20160113_17_57_11.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_57_11.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_57_11.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1803,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_57_48.png','2016-01-13 17:57:48','2016-01-13 17:58:00','/dls/i03/data/2016/cm14451-1/20160113_17_57_48.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_57_48.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_57_48.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1804,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_58_55.png','2016-01-13 17:58:55','2016-01-13 17:59:08','/dls/i03/data/2016/cm14451-1/20160113_17_58_55.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_17_58_55.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_17_58_55.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1805,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_05_35.png','2016-01-13 18:05:35','2016-01-13 18:05:47','/dls/i03/data/2016/cm14451-1/20160113_18_05_35.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_05_35.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_05_35.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1806,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_06_50.png','2016-01-13 18:06:50','2016-01-13 18:07:02','/dls/i03/data/2016/cm14451-1/20160113_18_06_50.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_06_50.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_06_50.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1807,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_07_44.png','2016-01-13 18:07:44','2016-01-13 18:07:56','/dls/i03/data/2016/cm14451-1/20160113_18_07_44.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_07_44.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_07_44.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1808,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_08_38.png','2016-01-13 18:08:38','2016-01-13 18:08:50','/dls/i03/data/2016/cm14451-1/20160113_18_08_38.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_08_38.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_08_38.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1809,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_09_26.png','2016-01-13 18:09:26','2016-01-13 18:09:38','/dls/i03/data/2016/cm14451-1/20160113_18_09_26.mca',1,NULL,4.0011,'/dls/i03/data/2016/cm14451-1/20160113_18_09_26.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_09_26.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1810,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_10_25.png','2016-01-13 18:10:25','2016-01-13 18:10:38','/dls/i03/data/2016/cm14451-1/20160113_18_10_25.mca',1,NULL,4.0011,'/dls/i03/data/2016/cm14451-1/20160113_18_10_25.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_10_25.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1811,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_10_51.png','2016-01-13 18:10:51','2016-01-13 18:11:04','/dls/i03/data/2016/cm14451-1/20160113_18_10_51.mca',1,NULL,4.0011,'/dls/i03/data/2016/cm14451-1/20160113_18_10_51.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_10_51.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1812,55167,374695,'/dls/i03/data/2016/cm14451-1/20160113_18_11_20.png','2016-01-13 18:11:20','2016-01-13 18:11:32','/dls/i03/data/2016/cm14451-1/20160113_18_11_20.mca',1,NULL,4.0011,'/dls/i03/data/2016/cm14451-1/20160113_18_11_20.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_11_20.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1813,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_14_57.png','2016-01-13 18:14:57','2016-01-13 18:15:09','/dls/i03/data/2016/cm14451-1/20160113_18_14_57.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_14_57.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_14_57.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1814,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_15_50.png','2016-01-13 18:15:50','2016-01-13 18:16:02','/dls/i03/data/2016/cm14451-1/20160113_18_15_50.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_15_50.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_15_50.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1815,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_16_20.png','2016-01-13 18:16:20','2016-01-13 18:16:31','/dls/i03/data/2016/cm14451-1/20160113_18_16_20.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_16_20.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_16_20.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1816,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_16_56.png','2016-01-13 18:16:56','2016-01-13 18:17:08','/dls/i03/data/2016/cm14451-1/20160113_18_16_56.mca',1,NULL,1.59925,'/dls/i03/data/2016/cm14451-1/20160113_18_16_56.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_16_56.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1817,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_17_56.png','2016-01-13 18:17:56','2016-01-13 18:18:29','/dls/i03/data/2016/cm14451-1/20160113_18_17_56.mca',1,NULL,12.8,'/dls/i03/data/2016/cm14451-1/20160113_18_17_56.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_17_56.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1818,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_20_49.png','2016-01-13 18:20:49','2016-01-13 18:21:22','/dls/i03/data/2016/cm14451-1/20160113_18_20_49.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160113_18_20_49.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_20_49.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1819,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_21_46.png','2016-01-13 18:21:46','2016-01-13 18:21:57','/dls/i03/data/2016/cm14451-1/20160113_18_21_46.mca',1,NULL,12.8138,'/dls/i03/data/2016/cm14451-1/20160113_18_21_46.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_21_46.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1820,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_22_33.png','2016-01-13 18:22:33','2016-01-13 18:22:45','/dls/i03/data/2016/cm14451-1/20160113_18_22_33.mca',1,NULL,12.8138,'/dls/i03/data/2016/cm14451-1/20160113_18_22_33.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_22_33.dat',12700,20,50,NULL,'good spectrum',NULL,NULL,NULL,NULL),
(1821,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_23_52.png','2016-01-13 18:23:52','2016-01-13 18:24:05','/dls/i03/data/2016/cm14451-1/20160113_18_23_52.mca',1,NULL,12.8138,'/dls/i03/data/2016/cm14451-1/20160113_18_23_52.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_23_52.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1822,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_39_34.png','2016-01-13 18:39:34','2016-01-13 18:40:11','/dls/i03/data/2016/cm14451-1/20160113_18_39_34.mca',1,NULL,100,'/dls/i03/data/2016/cm14451-1/20160113_18_39_34.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_39_34.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1823,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_40_53.png','2016-01-13 18:40:53','2016-01-13 18:41:26','/dls/i03/data/2016/cm14451-1/20160113_18_40_53.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160113_18_40_53.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_40_53.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1824,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_41_43.png','2016-01-13 18:41:43','2016-01-13 18:42:16','/dls/i03/data/2016/cm14451-1/20160113_18_41_43.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160113_18_41_43.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_18_41_43.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1825,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_20_04.png','2016-01-13 19:20:04','2016-01-13 19:20:37','/dls/i03/data/2016/cm14451-1/20160113_19_20_04.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160113_19_20_04.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_20_04.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1826,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_21_10.png','2016-01-13 19:21:10','2016-01-13 19:21:43','/dls/i03/data/2016/cm14451-1/20160113_19_21_10.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160113_19_21_10.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_21_10.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1827,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_22_01.png','2016-01-13 19:22:01','2016-01-13 19:22:34','/dls/i03/data/2016/cm14451-1/20160113_19_22_01.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160113_19_22_01.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_22_01.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1828,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_23_10.png','2016-01-13 19:23:10','2016-01-13 19:23:45','/dls/i03/data/2016/cm14451-1/20160113_19_23_10.mca',1,NULL,12.8,'/dls/i03/data/2016/cm14451-1/20160113_19_23_10.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_23_10.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1829,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_49_01.png','2016-01-13 19:49:01','2016-01-13 19:50:38','/dls/i03/data/2016/cm14451-1/20160113_19_49_01.mca',1,NULL,12.8,'/dls/i03/data/2016/cm14451-1/20160113_19_49_01.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_19_49_01.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1830,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_20_12_35.png','2016-01-13 20:12:35','2016-01-13 20:13:35','/dls/i03/data/2016/cm14451-1/20160113_20_12_35.mca',1,NULL,0.1,'/dls/i03/data/2016/cm14451-1/20160113_20_12_35.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_20_12_35.dat',14000,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1831,55167,NULL,'/dls/i03/data/2016/cm14451-1/20160113_20_17_07.png','2016-01-13 20:17:07','2016-01-13 20:19:49','/dls/i03/data/2016/cm14451-1/20160113_20_17_07.mca',1,NULL,3.2,'/dls/i03/data/2016/cm14451-1/20160113_20_17_07.html',NULL,'/dls/i03/data/2016/cm14451-1/20160113_20_17_07.dat',14000,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1832,55167,374695,'/dls/i03/data/2016/cm14451-1/20160114_11_16_25.png','2016-01-14 11:16:25','2016-01-14 11:17:32','/dls/i03/data/2016/cm14451-1/20160114_11_16_25.mca',1,NULL,1.6,'/dls/i03/data/2016/cm14451-1/20160114_11_16_25.html',NULL,'/dls/i03/data/2016/cm14451-1/20160114_11_16_25.dat',12673,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1833,55167,374695,'/dls/i03/data/2016/cm14451-1/20160114_11_20_14.png','2016-01-14 11:20:14','2016-01-14 11:20:46','/dls/i03/data/2016/cm14451-1/20160114_11_20_14.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160114_11_20_14.html',NULL,'/dls/i03/data/2016/cm14451-1/20160114_11_20_14.dat',12673,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(1834,55167,374695,'/dls/i03/data/2016/cm14451-1/20160114_11_23_23.png','2016-01-14 11:23:23','2016-01-14 11:23:56','/dls/i03/data/2016/cm14451-1/20160114_11_23_23.mca',1,NULL,6.4,'/dls/i03/data/2016/cm14451-1/20160114_11_23_23.html',NULL,'/dls/i03/data/2016/cm14451-1/20160114_11_23_23.dat',14000,20,50,NULL,'null _FLAG_',NULL,NULL,NULL,NULL),
(1984,55168,NULL,'/dls/i03/data/2016/cm14451-2/20160330_14_34_12.png','2016-03-30 14:34:12','2016-03-30 14:34:25','/dls/i03/data/2016/cm14451-2/20160330_14_34_12.mca',1,NULL,19.9988,'/dls/i03/data/2016/cm14451-2/20160330_14_34_12.html',NULL,'/dls/i03/data/2016/cm14451-2/20160330_14_34_12.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1987,55168,NULL,'/dls/i03/data/2016/cm14451-2/20160331_10_13_31.png','2016-03-31 10:13:31','2016-03-31 10:13:44','/dls/i03/data/2016/cm14451-2/20160331_10_13_31.mca',1,NULL,20.0048,'/dls/i03/data/2016/cm14451-2/20160331_10_13_31.html',NULL,'/dls/i03/data/2016/cm14451-2/20160331_10_13_31.dat',12700,20,80,NULL,NULL,NULL,NULL,NULL,NULL),
(1990,55168,NULL,'/dls/i03/data/2016/cm14451-2/20160405_16_40_33.png','2016-04-05 16:40:33','2016-04-05 16:42:09','/dls/i03/data/2016/cm14451-2/20160405_16_40_33.mca',3,NULL,12.8,'/dls/i03/data/2016/cm14451-2/20160405_16_40_33.html',NULL,'/dls/i03/data/2016/cm14451-2/20160405_16_40_33.dat',14000,20,20,NULL,NULL,NULL,NULL,NULL,NULL),
(2002,55168,NULL,'/dls/i03/data/2016/cm14451-2/20160406_16_29_44.png','2016-04-06 16:29:44','2016-04-06 16:30:27','/dls/i03/data/2016/cm14451-2/20160406_16_29_44.mca',2,NULL,12.8,'/dls/i03/data/2016/cm14451-2/20160406_16_29_44.html',NULL,'/dls/i03/data/2016/cm14451-2/20160406_16_29_44.dat',12700,20,50,NULL,NULL,NULL,NULL,NULL,NULL),
(2005,55168,NULL,'/dls/i03/data/2009/in1246-1/jpegs/bs/bs_MS_1_001.jpeg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `XFEFluorescenceSpectrum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `XRFFluorescenceMapping`
--

DROP TABLE IF EXISTS `XRFFluorescenceMapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `XRFFluorescenceMapping` (
  `xrfFluorescenceMappingId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `xrfFluorescenceMappingROIId` int(11) unsigned NOT NULL,
  `gridInfoId` int(11) unsigned NOT NULL,
  `dataFormat` varchar(15) NOT NULL COMMENT 'Description of format and any compression, i.e. json+gzip for gzipped json',
  `data` longblob NOT NULL COMMENT 'The actual data',
  `points` int(11) unsigned DEFAULT NULL COMMENT 'The number of points available, for realtime feedback',
  `opacity` float NOT NULL DEFAULT 1 COMMENT 'Display opacity',
  `colourMap` varchar(20) DEFAULT NULL COMMENT 'Colour map for displaying the data',
  `min` int(3) DEFAULT NULL COMMENT 'Min value in the data for histogramming',
  `max` int(3) DEFAULT NULL COMMENT 'Max value in the data for histogramming',
  `autoProcProgramId` int(10) unsigned DEFAULT NULL COMMENT 'Related autoproc programid',
  PRIMARY KEY (`xrfFluorescenceMappingId`),
  KEY `XRFFluorescenceMapping_ibfk1` (`xrfFluorescenceMappingROIId`),
  KEY `XRFFluorescenceMapping_ibfk2` (`gridInfoId`),
  KEY `XRFFluorescenceMapping_ibfk3` (`autoProcProgramId`),
  CONSTRAINT `XRFFluorescenceMapping_ibfk1` FOREIGN KEY (`xrfFluorescenceMappingROIId`) REFERENCES `XRFFluorescenceMappingROI` (`xrfFluorescenceMappingROIId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `XRFFluorescenceMapping_ibfk2` FOREIGN KEY (`gridInfoId`) REFERENCES `GridInfo` (`gridInfoId`),
  CONSTRAINT `XRFFluorescenceMapping_ibfk3` FOREIGN KEY (`autoProcProgramId`) REFERENCES `AutoProcProgram` (`autoProcProgramId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci COMMENT='An XRF map generated from an XRF Mapping ROI based on data from a gridscan of a sample';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `XRFFluorescenceMapping`
--

LOCK TABLES `XRFFluorescenceMapping` WRITE;
/*!40000 ALTER TABLE `XRFFluorescenceMapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `XRFFluorescenceMapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `XRFFluorescenceMappingROI`
--

DROP TABLE IF EXISTS `XRFFluorescenceMappingROI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `XRFFluorescenceMappingROI` (
  `xrfFluorescenceMappingROIId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `startEnergy` float NOT NULL,
  `endEnergy` float NOT NULL,
  `element` varchar(2) DEFAULT NULL,
  `edge` varchar(15) DEFAULT NULL COMMENT 'Edge type i.e. Ka1, could be a custom edge in case of overlap Ka1-noCa',
  `r` tinyint(3) unsigned DEFAULT NULL COMMENT 'R colour component',
  `g` tinyint(3) unsigned DEFAULT NULL COMMENT 'G colour component',
  `b` tinyint(3) unsigned DEFAULT NULL COMMENT 'B colour component',
  `blSampleId` int(10) unsigned DEFAULT NULL COMMENT 'ROIs can be created within the context of a sample',
  `scalar` varchar(50) DEFAULT NULL COMMENT 'For ROIs that are not an element, i.e. could be a scan counter instead',
  PRIMARY KEY (`xrfFluorescenceMappingROIId`),
  KEY `XRFFluorescenceMappingROI_FKblSampleId` (`blSampleId`),
  CONSTRAINT `XRFFluorescenceMappingROI_FKblSampleId` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `XRFFluorescenceMappingROI`
--

LOCK TABLES `XRFFluorescenceMappingROI` WRITE;
/*!40000 ALTER TABLE `XRFFluorescenceMappingROI` DISABLE KEYS */;
/*!40000 ALTER TABLE `XRFFluorescenceMappingROI` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `XrayCentring`
--

DROP TABLE IF EXISTS `XrayCentring`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `XrayCentring` (
  `xrayCentringId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dataCollectionGroupId` int(11) NOT NULL COMMENT 'references DataCollectionGroup table',
  `status` enum('success','failed','pending') DEFAULT NULL,
  `xrayCentringType` enum('2d','3d') DEFAULT NULL,
  PRIMARY KEY (`xrayCentringId`),
  KEY `dataCollectionGroupId` (`dataCollectionGroupId`),
  CONSTRAINT `XrayCentring_ibfk_1` FOREIGN KEY (`dataCollectionGroupId`) REFERENCES `DataCollectionGroup` (`dataCollectionGroupId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Xray Centring analysis associated with one or more grid scans.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `XrayCentring`
--

LOCK TABLES `XrayCentring` WRITE;
/*!40000 ALTER TABLE `XrayCentring` DISABLE KEYS */;
/*!40000 ALTER TABLE `XrayCentring` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `XrayCentringResult`
--

DROP TABLE IF EXISTS `XrayCentringResult`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `XrayCentringResult` (
  `xrayCentringResultId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gridInfoId` int(11) unsigned NOT NULL,
  `method` varchar(15) DEFAULT NULL COMMENT 'Type of X-ray centering calculation',
  `status` enum('success','failure','pending') NOT NULL DEFAULT 'pending',
  `x` float DEFAULT NULL COMMENT 'position in number of boxes in direction of the fast scan within GridInfo grid',
  `y` float DEFAULT NULL COMMENT 'position in number of boxes in direction of the slow scan within GridInfo grid',
  `blSampleId` int(11) unsigned DEFAULT NULL COMMENT 'The BLSample attributed for this x-ray centring result, i.e. the actual sample even for multi-pins',
  PRIMARY KEY (`xrayCentringResultId`),
  KEY `XrayCenteringResult_ibfk_1` (`gridInfoId`),
  KEY `XrayCentringResult_fk_blSampleId` (`blSampleId`),
  CONSTRAINT `XrayCentringResult_fk_blSampleId` FOREIGN KEY (`blSampleId`) REFERENCES `BLSample` (`blSampleId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `XrayCentringResult_ibfk_1` FOREIGN KEY (`gridInfoId`) REFERENCES `GridInfo` (`gridInfoId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `XrayCentringResult`
--

LOCK TABLES `XrayCentringResult` WRITE;
/*!40000 ALTER TABLE `XrayCentringResult` DISABLE KEYS */;
/*!40000 ALTER TABLE `XrayCentringResult` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `v_run`
--

DROP TABLE IF EXISTS `v_run`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `v_run` (
  `runId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `run` varchar(7) NOT NULL DEFAULT '',
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  PRIMARY KEY (`runId`),
  KEY `v_run_idx1` (`startDate`,`endDate`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `v_run`
--

LOCK TABLES `v_run` WRITE;
/*!40000 ALTER TABLE `v_run` DISABLE KEYS */;
INSERT INTO `v_run` VALUES
(1,'2008-01','2007-12-17 09:00:00','2008-02-09 08:59:59'),
(2,'2008-02','2008-02-09 09:00:00','2008-03-14 08:59:59'),
(3,'2008-03','2008-03-14 09:00:00','2008-04-28 08:59:59'),
(4,'2008-04','2008-04-28 09:00:00','2008-05-30 08:59:59'),
(5,'2008-05','2008-05-30 09:00:00','2008-07-12 08:59:59'),
(6,'2008-06','2008-07-12 09:00:00','2008-08-15 08:59:59'),
(7,'2008-07','2008-08-15 09:00:00','2008-09-27 08:59:59'),
(8,'2008-08','2008-09-27 09:00:00','2008-10-31 08:59:59'),
(9,'2008-09','2008-10-31 09:00:00','2008-12-19 08:59:59'),
(10,'2009-01','2008-12-19 09:00:00','2009-02-09 08:59:59'),
(11,'2009-02','2009-02-09 09:00:00','2009-03-13 08:59:59'),
(12,'2009-03','2009-03-13 09:00:00','2009-04-25 08:59:59'),
(13,'2009-04','2009-04-25 09:00:00','2009-05-29 08:59:59'),
(14,'2009-05','2009-05-29 09:00:00','2009-07-18 08:59:59'),
(15,'2009-06','2009-07-18 09:00:00','2009-08-14 08:59:59'),
(16,'2009-07','2009-08-14 09:00:00','2009-09-29 08:59:59'),
(17,'2009-08','2009-09-29 09:00:00','2009-10-30 08:59:59'),
(18,'2009-09','2009-10-30 09:00:00','2009-12-18 08:59:59'),
(19,'2010-01','2009-12-18 09:00:00','2010-02-08 08:59:59'),
(20,'2010-02','2010-02-08 09:00:00','2010-03-15 08:59:59'),
(21,'2010-03','2010-03-15 09:00:00','2010-06-01 08:59:59'),
(22,'2010-04','2010-06-01 09:00:00','2010-08-13 08:59:59'),
(23,'2010-05','2010-08-13 09:00:00','2010-11-01 08:59:59'),
(24,'2010-06','2010-11-01 09:00:00','2010-12-23 08:59:59'),
(25,'2011-01','2010-12-23 09:00:00','2011-03-04 08:59:59'),
(26,'2011-02','2011-03-04 09:00:00','2011-06-03 08:59:59'),
(27,'2011-03','2011-06-03 09:00:00','2011-08-12 08:59:59'),
(28,'2011-04','2011-08-12 09:00:00','2011-11-07 08:59:59'),
(29,'2011-05','2011-11-07 09:00:00','2011-12-22 08:59:59'),
(30,'2012-01','2011-12-22 09:00:00','2012-03-26 08:59:59'),
(31,'2012-02','2012-03-26 09:00:00','2012-06-01 08:59:59'),
(32,'2012-03','2012-06-01 09:00:00','2012-08-17 08:59:59'),
(33,'2012-04','2012-08-17 09:00:00','2012-11-02 08:59:59'),
(34,'2012-05','2012-11-02 09:00:00','2012-12-21 08:59:59'),
(35,'2013-01','2012-12-21 09:00:00','2013-03-22 08:59:59'),
(36,'2013-02','2013-03-22 09:00:00','2013-05-31 08:59:59'),
(37,'2013-03','2013-05-31 09:00:00','2013-08-16 08:59:59'),
(38,'2013-04','2013-08-16 09:00:00','2013-11-01 08:59:59'),
(39,'2013-05','2013-11-01 09:00:00','2013-12-20 08:59:59'),
(40,'2014-01','2013-12-20 09:00:00','2014-03-14 08:59:59'),
(41,'2014-02','2014-03-14 09:00:00','2014-05-30 08:59:59'),
(42,'2014-03','2014-05-30 09:00:00','2014-08-15 08:59:59'),
(43,'2014-04','2014-08-15 09:00:00','2014-10-24 08:59:59'),
(44,'2014-05','2014-10-24 09:00:00','2014-12-19 08:59:59'),
(45,'2015-01','2014-12-19 09:00:00','2015-03-13 08:59:59'),
(46,'2015-02','2015-03-13 09:00:00','2015-05-29 08:59:59'),
(47,'2015-03','2015-05-29 09:00:00','2015-08-14 08:59:59'),
(48,'2015-04','2015-08-14 09:00:00','2015-10-23 08:59:59'),
(49,'2015-05','2015-10-23 09:00:00','2015-12-18 08:59:59'),
(50,'2016-01','2015-12-18 09:00:00','2016-03-11 08:59:59'),
(51,'2016-02','2016-03-11 09:00:00','2016-05-20 08:59:59'),
(52,'2016-03','2016-05-20 09:00:00','2016-08-12 08:59:59'),
(53,'2016-04','2016-08-12 09:00:00','2016-10-07 08:59:59'),
(54,'2016-05','2016-10-07 09:00:00','2016-12-20 08:59:59'),
(55,'2017-01','2016-12-20 09:00:00','2017-03-17 08:59:59'),
(56,'2017-02','2017-03-17 09:00:00','2017-05-26 08:59:59'),
(57,'2017-03','2017-05-26 09:00:00','2017-08-11 08:59:59'),
(58,'2017-04','2017-08-11 09:00:00','2017-10-27 08:59:59'),
(59,'2017-05','2017-10-27 09:00:00','2017-12-19 08:59:59'),
(60,'2018-01','2017-12-19 09:00:00','2018-03-16 08:59:59'),
(61,'2018-02','2018-03-16 09:00:00','2018-05-24 08:59:59'),
(62,'2018-03','2018-05-24 09:00:00','2018-08-10 08:59:59'),
(63,'2018-04','2018-08-10 09:00:00','2018-10-26 08:59:59'),
(64,'2018-05','2018-10-26 09:00:00','2018-12-18 08:59:59'),
(65,'2019-01','2018-12-18 09:00:00','2019-03-08 08:59:59'),
(66,'2019-02','2019-03-08 09:00:00','2019-05-23 08:59:59'),
(67,'2019-03','2019-05-23 09:00:00','2019-08-09 08:59:59'),
(68,'2019-04','2019-08-09 09:00:00','2019-10-25 08:59:59'),
(69,'2019-05','2019-10-25 09:00:00','2019-12-17 08:59:59'),
(70,'2020-01','2019-12-17 09:00:00','2020-03-06 08:59:59'),
(71,'2020-02','2020-03-06 09:00:00','2020-05-22 08:59:59'),
(72,'2020-03','2020-05-22 09:00:00','2020-08-14 08:59:59');
/*!40000 ALTER TABLE `v_run` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zc_ZocaloBuffer`
--

DROP TABLE IF EXISTS `zc_ZocaloBuffer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `zc_ZocaloBuffer` (
  `AutoProcProgramID` int(10) unsigned NOT NULL COMMENT 'Reference to an existing AutoProcProgram',
  `UUID` int(10) unsigned NOT NULL COMMENT 'AutoProcProgram-specific unique identifier',
  `Reference` int(10) unsigned DEFAULT NULL COMMENT 'Context-dependent reference to primary key IDs in other ISPyB tables',
  PRIMARY KEY (`AutoProcProgramID`,`UUID`),
  CONSTRAINT `AutoProcProgram_fk_AutoProcProgramId` FOREIGN KEY (`AutoProcProgramID`) REFERENCES `AutoProcProgram` (`autoProcProgramId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zc_ZocaloBuffer`
--

LOCK TABLES `zc_ZocaloBuffer` WRITE;
/*!40000 ALTER TABLE `zc_ZocaloBuffer` DISABLE KEYS */;
/*!40000 ALTER TABLE `zc_ZocaloBuffer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ispyb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-09 10:50:48
