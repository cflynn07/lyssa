-- MySQL dump 10.13  Distrib 5.6.10, for osx10.6 (i386)
--
-- Host: localhost    Database: lyssa
-- ------------------------------------------------------
-- Server version	5.6.10

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `identifier` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `address3` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `stateProvince` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  UNIQUE KEY `indentifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES ('44cc27a5-af8b-412f-855a-57c8205d86f5',1,'ClientA','clienta','asd','asdf','asdfas','asdfasdf','sdf','asdf','asdfas','sfd','2013-04-10 22:14:54','2013-04-10 22:14:58',NULL),('05817084-bc15-4dee-90a1-2e0735a242e1',2,'ClientB','clientb','kdfkd','dsk','aksdfg','asdf','asdf','sdaf','sadf','sdf','2013-04-10 22:15:23','2013-04-10 22:15:25',NULL),('c4602593-f460-41f8-bb42-a0f0afe021d6',3,'ClientC','clientc','kasdfui','asdf','asdfg','afsdg','adsfg','asdfga','asdgf','asdfg','2013-04-10 22:35:18','2013-04-10 22:35:21',NULL);
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictionaries`
--

DROP TABLE IF EXISTS `dictionaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dictionaries` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_dictionaries_clients1` (`clientId`),
  KEY `fk_dictionaries_clients2` (`clientUid`),
  CONSTRAINT `fk_dictionaries_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dictionaries_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictionaries`
--

LOCK TABLES `dictionaries` WRITE;
/*!40000 ALTER TABLE `dictionaries` DISABLE KEYS */;
INSERT INTO `dictionaries` VALUES ('42901aba-c28a-43a9-8080-6f9d383a3644',1,'Buildings','44cc27a5-af8b-412f-855a-57c8205d86f5','2013-04-13 19:44:22','2013-04-13 19:44:24',NULL,1),('3b5c6c5b-ca10-4c96-a9e3-82cfa15e258c',2,'Apples','44cc27a5-af8b-412f-855a-57c8205d86f5','2013-04-13 19:44:54','2013-04-13 19:44:57',NULL,1),('7335505b-6a74-43c0-ae03-675c632806c1',3,'Actors','05817084-bc15-4dee-90a1-2e0735a242e1','2013-04-13 19:45:23','2013-04-13 19:45:25',NULL,2);
/*!40000 ALTER TABLE `dictionaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictionaryItems`
--

DROP TABLE IF EXISTS `dictionaryItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dictionaryItems` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `dictionaryUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `dictionaryId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_dictionaryItems_dictionaries1` (`dictionaryId`),
  KEY `fk_dictionaryItems_clients1` (`clientId`),
  KEY `fk_dictionaryItems_dictionaries2` (`dictionaryUid`),
  KEY `fk_dictionaryItems_clients2` (`clientUid`),
  CONSTRAINT `fk_dictionaryItems_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dictionaryItems_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dictionaryItems_dictionaries1` FOREIGN KEY (`dictionaryId`) REFERENCES `dictionaries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dictionaryItems_dictionaries2` FOREIGN KEY (`dictionaryUid`) REFERENCES `dictionaries` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictionaryItems`
--

LOCK TABLES `dictionaryItems` WRITE;
/*!40000 ALTER TABLE `dictionaryItems` DISABLE KEYS */;
INSERT INTO `dictionaryItems` VALUES ('ad755cb6-c1e3-4dd8-b73a-abe51652a55d',1,'Sears Tower','44cc27a5-af8b-412f-855a-57c8205d86f5','42901aba-c28a-43a9-8080-6f9d383a3644','2013-04-13 19:46:11','2013-04-13 19:46:13',NULL,1,1),('2d5c970f-a25a-41ec-bd9b-3abdd1bdbd2c',2,'World Trade Center','44cc27a5-af8b-412f-855a-57c8205d86f5','42901aba-c28a-43a9-8080-6f9d383a3644','2013-04-13 19:46:48','2013-04-13 19:46:51',NULL,1,1),('064225fe-372f-4a0f-bf84-28e8e38a12db',3,'Eiffel Tower','44cc27a5-af8b-412f-855a-57c8205d86f5','42901aba-c28a-43a9-8080-6f9d383a3644','2013-04-13 19:47:24','2013-04-13 19:47:28',NULL,1,1),('7db098a0-dc47-47c0-99a3-cad4a35ff80b',4,'Macintosh','05817084-bc15-4dee-90a1-2e0735a242e1','7335505b-6a74-43c0-ae03-675c632806c1','2013-04-13 19:48:02','2013-04-13 19:48:07',NULL,2,3);
/*!40000 ALTER TABLE `dictionaryItems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employees` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `firstName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `lastName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `type` enum('superAdmin','clientSuperAdmin','clientAdmin','clientDelegate','clientAuditor') COLLATE utf8_bin DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`),
  KEY `clientId` (`clientId`),
  KEY `clientUid` (`clientUid`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES ('45b7c719-2049-4a44-ad9c-09e858afc48b',1,'casey','Peter','Griffin','dfs','asd','casey','$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK','clientSuperAdmin','44cc27a5-af8b-412f-855a-57c8205d86f5','2013-04-10 22:17:43','2013-04-10 22:17:45',NULL,1),('04ad5b05-c9a5-430f-8d5c-8483d5d904e4',2,'erici','divis','dids','did','dfi','sdf','$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK','superAdmin','44cc27a5-af8b-412f-855a-57c8205d86f5','2013-04-10 22:18:16','2013-04-10 22:18:17',NULL,1),('f755b54f-e918-4fcb-9024-2b48370df4a1',3,'IDixs','kddi','kdid','dksdfo','dfsgksdgol','sdgl','$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK','clientAdmin','05817084-bc15-4dee-90a1-2e0735a242e1','2013-04-10 22:18:52','2013-04-10 22:18:54',NULL,2),('0054d814-6d36-4573-bbfc-a2b6644266cc',4,'Marc','Xis','kdi','kdigf','lsdfsd','sdfgsgd','$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK','clientDelegate','05817084-bc15-4dee-90a1-2e0735a242e1','2013-04-10 22:19:26','2013-04-10 22:19:28',NULL,2);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `dateTime` datetime DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `employeeUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `employeeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_events_employees1` (`employeeId`),
  KEY `fk_events_clients1` (`clientId`),
  KEY `fk_events_employees2` (`employeeUid`),
  KEY `fk_events_clients2` (`clientUid`),
  CONSTRAINT `fk_events_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_events_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_events_employees1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_events_employees2` FOREIGN KEY (`employeeUid`) REFERENCES `employees` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fields` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `type` enum('openResponse','selectIndividual','selectMultiple','yesNo','slider') COLLATE utf8_bin DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `groupUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `groupId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_fields_groups1` (`groupId`),
  KEY `fk_fields_clients1` (`clientId`),
  KEY `fk_fields_groups2` (`groupUid`),
  KEY `fk_fields_clients2` (`clientUid`),
  CONSTRAINT `fk_fields_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fields_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fields_groups1` FOREIGN KEY (`groupId`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fields_groups2` FOREIGN KEY (`groupUid`) REFERENCES `groups` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ordinal` int(11) DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `revisionUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `revisionId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_groups_revisions1` (`revisionId`),
  KEY `fk_groups_clients1` (`clientId`),
  KEY `fk_groups_revisions2` (`revisionUid`),
  KEY `fk_groups_clients2` (`clientUid`),
  CONSTRAINT `fk_groups_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_groups_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_groups_revisions1` FOREIGN KEY (`revisionId`) REFERENCES `revisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_groups_revisions2` FOREIGN KEY (`revisionUid`) REFERENCES `revisions` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `revisions`
--

DROP TABLE IF EXISTS `revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `revisions` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `changeSummary` text COLLATE utf8_bin,
  `scope` text COLLATE utf8_bin,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `templateUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `employeeUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `employeeId` int(11) DEFAULT NULL,
  `templateId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_revisions_templates1` (`templateId`),
  KEY `fk_revisions_employees1` (`employeeId`),
  KEY `fk_revisions_employees2` (`employeeUid`),
  KEY `fk_revisions_templates2` (`templateUid`),
  KEY `fk_revisions_clients1` (`clientId`),
  KEY `fk_revisions_clients2` (`clientUid`),
  CONSTRAINT `fk_revisions_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_revisions_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_revisions_employees1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_revisions_employees2` FOREIGN KEY (`employeeUid`) REFERENCES `employees` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_revisions_templates1` FOREIGN KEY (`templateId`) REFERENCES `templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_revisions_templates2` FOREIGN KEY (`templateUid`) REFERENCES `templates` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revisions`
--

LOCK TABLES `revisions` WRITE;
/*!40000 ALTER TABLE `revisions` DISABLE KEYS */;
INSERT INTO `revisions` VALUES ('edf9847e-9c18-46b8-a673-1d266a73cab4',1,'This is a change summary','This is a scope','44cc27a5-af8b-412f-855a-57c8205d86f5','ccb2a09e-7bc8-448d-ab9c-2011004a72c6','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-13 19:50:42','2013-04-13 19:50:44',NULL,1,1,1),('dad1065c-91cf-4796-8f8b-74edfc06f2db',2,'We make lots of changes',NULL,'05817084-bc15-4dee-90a1-2e0735a242e1','9e5a299b-eea3-46c6-a021-1fa404522e00','f755b54f-e918-4fcb-9024-2b48370df4a1','2013-04-13 19:51:49','2013-04-13 19:51:51',NULL,2,3,2);
/*!40000 ALTER TABLE `revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissionFields`
--

DROP TABLE IF EXISTS `submissionFields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submissionFields` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `submissionGroupUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `submissionGroupId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_submissionFields_submissionGroups1` (`submissionGroupId`),
  KEY `fk_submissionFields_clients1` (`clientId`),
  KEY `fk_submissionFields_submissionGroups2` (`submissionGroupUid`),
  KEY `fk_submissionFields_clients2` (`clientUid`),
  CONSTRAINT `fk_submissionFields_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissionFields_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissionFields_submissionGroups1` FOREIGN KEY (`submissionGroupId`) REFERENCES `submissionGroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissionFields_submissionGroups2` FOREIGN KEY (`submissionGroupUid`) REFERENCES `submissionGroups` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissionFields`
--

LOCK TABLES `submissionFields` WRITE;
/*!40000 ALTER TABLE `submissionFields` DISABLE KEYS */;
/*!40000 ALTER TABLE `submissionFields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissionGroups`
--

DROP TABLE IF EXISTS `submissionGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submissionGroups` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `submissionUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `submissionId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_submissionGroups_submissions1` (`submissionId`),
  KEY `fk_submissionGroups_submissions2` (`clientId`),
  KEY `fk_submissionGroups_submissions3` (`submissionUid`),
  KEY `fk_submissionGroups_clients1` (`clientUid`),
  CONSTRAINT `fk_submissionGroups_clients1` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissionGroups_submissions1` FOREIGN KEY (`submissionId`) REFERENCES `submissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissionGroups_submissions2` FOREIGN KEY (`clientId`) REFERENCES `submissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissionGroups_submissions3` FOREIGN KEY (`submissionUid`) REFERENCES `submissions` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissionGroups`
--

LOCK TABLES `submissionGroups` WRITE;
/*!40000 ALTER TABLE `submissionGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `submissionGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submissions` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `eventUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `employeeUid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `employeeId` int(11) DEFAULT NULL,
  `eventId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `fk_submissions_events1` (`eventId`),
  KEY `fk_submissions_employees1` (`employeeId`),
  KEY `fk_submissions_clients1` (`clientId`),
  KEY `fk_submissions_employees2` (`employeeUid`),
  KEY `fk_submissions_events2` (`eventUid`),
  KEY `fk_submissions_clients2` (`clientUid`),
  CONSTRAINT `fk_submissions_clients1` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissions_clients2` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissions_employees1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissions_employees2` FOREIGN KEY (`employeeUid`) REFERENCES `employees` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissions_events1` FOREIGN KEY (`eventId`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submissions_events2` FOREIGN KEY (`eventUid`) REFERENCES `events` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissions`
--

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templates`
--

DROP TABLE IF EXISTS `templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `templates` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `type` enum('full','mini') COLLATE utf8_bin DEFAULT NULL,
  `clientUid` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `employeeUid` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `clientId` int(11) NOT NULL,
  `employeeId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  KEY `employeeId` (`employeeId`),
  KEY `clientId` (`clientId`),
  KEY `employeeUid` (`employeeUid`),
  KEY `clientUid` (`clientUid`),
  CONSTRAINT `templates_ibfk_1` FOREIGN KEY (`employeeId`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `templates_ibfk_2` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `templates_ibfk_3` FOREIGN KEY (`employeeUid`) REFERENCES `employees` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `templates_ibfk_4` FOREIGN KEY (`clientUid`) REFERENCES `clients` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templates`
--

LOCK TABLES `templates` WRITE;
/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT INTO `templates` VALUES ('ccb2a09e-7bc8-448d-ab9c-2011004a72c6',1,'thisischanged123','mini','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-10 22:20:50','2013-04-16 08:09:53','2013-04-16 08:09:53',1,1),('9e5a299b-eea3-46c6-a021-1fa404522e00',2,'dupertemplate','mini','05817084-bc15-4dee-90a1-2e0735a242e1','0054d814-6d36-4573-bbfc-a2b6644266cc','2013-04-10 22:22:13','2013-04-16 08:09:53','2013-04-16 08:09:53',2,4),('ee58b0a0-248e-4c88-b4de-5d9f7e6db937',3,'dogsandcats','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 01:41:33','2013-04-16 08:10:31','2013-04-16 08:10:31',1,1),('c6268022-fdc2-465d-98c3-8c6195fb9aa9',4,'mangolians','full','44cc27a5-af8b-412f-855a-57c8205d86f5','04ad5b05-c9a5-430f-8d5c-8483d5d904e4','2013-04-16 01:41:33','2013-04-16 01:41:33',NULL,1,2),('67ecce1e-5dfc-4bbf-92a5-4200a803086f',5,'newdogsandcats','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 07:16:33','2013-04-16 07:16:33',NULL,1,1),('806007f1-ef91-4d01-894c-79919f068660',6,'newdogsandcats','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 07:49:23','2013-04-16 07:49:23',NULL,1,1),('a6c85807-106b-4c64-8e65-acfa11586c49',7,'newdogsandcats','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 07:56:26','2013-04-16 07:56:26',NULL,1,1),('110757b7-ea2d-4d3d-9b5c-5ae06f87ef73',8,'newdogsandcats','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 07:58:39','2013-04-16 07:58:39',NULL,1,1),('f2244262-51d3-4486-8e25-26017fe5ab20',9,'newdogsandcats','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 07:59:30','2013-04-16 07:59:30',NULL,1,1),('1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3',10,'clientadmincreated','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 07:59:56','2013-04-16 07:59:56',NULL,1,1),('64ead8a3-8a59-4278-a3b2-12592723133a',11,'clientadmincreated','full','44cc27a5-af8b-412f-855a-57c8205d86f5','45b7c719-2049-4a44-ad9c-09e858afc48b','2013-04-16 08:00:22','2013-04-16 08:00:22',NULL,1,1);
/*!40000 ALTER TABLE `templates` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-04-20  7:52:42
