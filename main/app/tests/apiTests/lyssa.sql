/*
 Navicat Premium Data Transfer

 Source Server         : MySQL Development
 Source Server Type    : MySQL
 Source Server Version : 50610
 Source Host           : localhost
 Source Database       : lyssa

 Target Server Type    : MySQL
 Target Server Version : 50610
 File Encoding         : utf-8

 Date: 05/06/2013 15:43:44 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `clients`
-- ----------------------------
DROP TABLE IF EXISTS `clients`;
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

-- ----------------------------
--  Records of `clients`
-- ----------------------------
BEGIN;
INSERT INTO `clients` VALUES ('44cc27a5-af8b-412f-855a-57c8205d86f5', '1', 'ClientA', 'clienta', 'asd', 'asdf', 'asdfas', 'asdfasdf', 'sdf', 'asdf', 'asdfas', 'sfd', '2013-04-10 22:14:54', '2013-04-10 22:14:58', null), ('05817084-bc15-4dee-90a1-2e0735a242e1', '2', 'ClientB', 'clientb', 'kdfkd', 'dsk', 'aksdfg', 'asdf', 'asdf', 'sdaf', 'sadf', 'sdf', '2013-04-10 22:15:23', '2013-04-10 22:15:25', null), ('c4602593-f460-41f8-bb42-a0f0afe021d6', '3', 'ClientC', 'clientc', 'kasdfui', 'asdf', 'asdfg', 'afsdg', 'adsfg', 'asdfga', 'asdgf', 'asdfg', '2013-04-10 22:35:18', '2013-04-10 22:35:21', null);
COMMIT;

-- ----------------------------
--  Table structure for `dictionaries`
-- ----------------------------
DROP TABLE IF EXISTS `dictionaries`;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
--  Records of `dictionaries`
-- ----------------------------
BEGIN;
INSERT INTO `dictionaries` VALUES ('42901aba-c28a-43a9-8080-6f9d383a3644', '1', 'Buildings', '44cc27a5-af8b-412f-855a-57c8205d86f5', '2013-04-13 19:44:22', '2013-04-13 19:44:24', null, '1'), ('3b5c6c5b-ca10-4c96-a9e3-82cfa15e258c', '2', 'Apples', '44cc27a5-af8b-412f-855a-57c8205d86f5', '2013-04-13 19:44:54', '2013-04-13 19:44:57', null, '1'), ('7335505b-6a74-43c0-ae03-675c632806c1', '3', 'Actors', '05817084-bc15-4dee-90a1-2e0735a242e1', '2013-04-13 19:45:23', '2013-04-13 19:45:25', null, '2'), ('b95e0927-1c0c-4b88-8869-31b7b3dfd634', '4', 'Building123', '44cc27a5-af8b-412f-855a-57c8205d86f5', '2013-05-06 18:49:23', '2013-05-06 18:49:23', null, '1');
COMMIT;

-- ----------------------------
--  Table structure for `dictionaryItems`
-- ----------------------------
DROP TABLE IF EXISTS `dictionaryItems`;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
--  Records of `dictionaryItems`
-- ----------------------------
BEGIN;
INSERT INTO `dictionaryItems` VALUES ('ad755cb6-c1e3-4dd8-b73a-abe51652a55d', '1', 'Sears Tower', '44cc27a5-af8b-412f-855a-57c8205d86f5', '42901aba-c28a-43a9-8080-6f9d383a3644', '2013-04-13 19:46:11', '2013-04-13 19:46:13', null, '1', '1'), ('2d5c970f-a25a-41ec-bd9b-3abdd1bdbd2c', '2', 'World Trade Center', '44cc27a5-af8b-412f-855a-57c8205d86f5', '42901aba-c28a-43a9-8080-6f9d383a3644', '2013-04-13 19:46:48', '2013-05-02 10:56:33', null, '1', '1'), ('064225fe-372f-4a0f-bf84-28e8e38a12db', '3', 'Eiffel Tower', '44cc27a5-af8b-412f-855a-57c8205d86f5', '42901aba-c28a-43a9-8080-6f9d383a3644', '2013-04-13 19:47:24', '2013-05-02 23:40:08', null, '1', '1'), ('7db098a0-dc47-47c0-99a3-cad4a35ff80b', '4', 'Macintosh', '05817084-bc15-4dee-90a1-2e0735a242e1', '7335505b-6a74-43c0-ae03-675c632806c1', '2013-04-13 19:48:02', '2013-04-13 19:48:07', null, '2', '3'), ('b97e02e4-bad8-4891-be85-9cb8c49526ec', '5', 'New Item', '44cc27a5-af8b-412f-855a-57c8205d86f5', '3b5c6c5b-ca10-4c96-a9e3-82cfa15e258c', '2013-05-03 00:17:36', '2013-05-03 00:17:36', null, '1', '2'), ('c92ca0b6-7053-4dd3-97b1-ff9ad4ab179a', '6', 'late item', '44cc27a5-af8b-412f-855a-57c8205d86f5', '3b5c6c5b-ca10-4c96-a9e3-82cfa15e258c', '2013-05-03 00:18:15', '2013-05-03 00:18:15', null, '1', '2'), ('393a85dd-2e10-4178-ba68-313a231b7f32', '7', 'application', '44cc27a5-af8b-412f-855a-57c8205d86f5', '3b5c6c5b-ca10-4c96-a9e3-82cfa15e258c', '2013-05-03 00:20:18', '2013-05-03 00:20:18', null, '1', '2'), ('b8281c77-1cb9-49d2-9144-f9d1c2b38e7a', '8', 'dfasdfasdfasdf', '44cc27a5-af8b-412f-855a-57c8205d86f5', '3b5c6c5b-ca10-4c96-a9e3-82cfa15e258c', '2013-05-03 00:21:46', '2013-05-03 00:21:46', null, '1', '2');
COMMIT;

-- ----------------------------
--  Table structure for `employees`
-- ----------------------------
DROP TABLE IF EXISTS `employees`;
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

-- ----------------------------
--  Records of `employees`
-- ----------------------------
BEGIN;
INSERT INTO `employees` VALUES ('45b7c719-2049-4a44-ad9c-09e858afc48b', '1', 'casey', 'Peter', 'Griffin', 'dfs', 'asd', 'casey', '$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK', 'clientSuperAdmin', '44cc27a5-af8b-412f-855a-57c8205d86f5', '2013-04-10 22:17:43', '2013-04-10 22:17:45', null, '1'), ('04ad5b05-c9a5-430f-8d5c-8483d5d904e4', '2', 'erici', 'divis', 'dids', 'did', 'dfi', 'sdf', '$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK', 'superAdmin', '44cc27a5-af8b-412f-855a-57c8205d86f5', '2013-04-10 22:18:16', '2013-04-10 22:18:17', null, '1'), ('f755b54f-e918-4fcb-9024-2b48370df4a1', '3', 'IDixs', 'kddi', 'kdid', 'dksdfo', 'dfsgksdgol', 'sdgl', '$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK', 'clientAdmin', '05817084-bc15-4dee-90a1-2e0735a242e1', '2013-04-10 22:18:52', '2013-04-10 22:18:54', null, '2'), ('0054d814-6d36-4573-bbfc-a2b6644266cc', '4', 'Marc', 'Xis', 'kdi', 'kdigf', 'lsdfsd', 'sdfgsgd', '$2a$12$i5clYosAvZGPQTYvbYwYx.4GITiLev7.xYA0ZpFZV7Upziw1rRVBK', 'clientDelegate', '05817084-bc15-4dee-90a1-2e0735a242e1', '2013-04-10 22:19:26', '2013-04-10 22:19:28', null, '2');
COMMIT;

-- ----------------------------
--  Table structure for `events`
-- ----------------------------
DROP TABLE IF EXISTS `events`;
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

-- ----------------------------
--  Table structure for `fields`
-- ----------------------------
DROP TABLE IF EXISTS `fields`;
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

-- ----------------------------
--  Table structure for `groups`
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ordinal` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_bin NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
--  Records of `groups`
-- ----------------------------
BEGIN;
INSERT INTO `groups` VALUES ('25a9f290-8d82-4efd-8caa-d991feede182', '1', 'groupA', '0', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', 'edf9847e-9c18-46b8-a673-1d266a73cab4', '2013-05-01 12:21:31', '2013-05-01 12:21:31', null, '1', '1'), ('3290bed5-23c7-4293-ba46-12d382ef57f6', '2', 'groupB', '1', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', 'edf9847e-9c18-46b8-a673-1d266a73cab4', '2013-05-01 12:21:44', '2013-05-01 12:21:44', null, '1', '1'), ('2b45f0bf-7140-489d-b537-1804015a51e2', '3', 'TEST GROUP NAME', '0', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', 'ff38de1d-3af2-426c-b490-cba0ea9b0468', '2013-05-01 12:24:55', '2013-05-02 12:51:30', null, '1', '16'), ('dae0a2e5-d50e-4e77-8f87-23f409c0ad36', '4', 'super wild name', '1', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', 'ff38de1d-3af2-426c-b490-cba0ea9b0468', '2013-05-01 12:25:02', '2013-05-02 11:30:28', null, '1', '16'), ('2201bf5e-3051-4ab0-9941-030615608a0b', '5', 'as', '2', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', 'ff38de1d-3af2-426c-b490-cba0ea9b0468', '2013-05-01 12:25:08', '2013-05-02 12:45:23', null, '1', '16'), ('f3c9bcd9-5f7c-411a-bcb4-1dcad30f3581', '6', 'Group Name Change', '3', 0x4465736372697074696f6e, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 21:09:55', '2013-05-02 22:34:05', '2013-05-02 22:34:05', '1', '17'), ('0f890de6-1c69-4f3c-b421-dc42275cfe38', '7', 'Exercise Finish', '0', 0x6e65772064657363, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 22:00:46', '2013-05-06 18:29:25', null, '1', '17'), ('02704a23-039b-4c5b-911c-724f3509036f', '8', 'some wild new group', '0', 0x6465736372697074696f6e, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 22:07:56', '2013-05-02 22:33:17', '2013-05-02 22:33:17', '1', '17'), ('f70c7968-14ba-4a00-91a0-d662367ef534', '9', 'new non deleted group', '1', 0x746573742074696d65, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 22:23:33', '2013-05-02 22:34:01', '2013-05-02 22:34:01', '1', '17'), ('fede092e-3df6-4451-bec6-8b2a57b1cb71', '10', 'test group', '0', 0x746573742067726f7570, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 22:33:36', '2013-05-02 22:33:59', '2013-05-02 22:33:59', '1', '17'), ('4e7540b5-a45f-4cd4-a08f-d691d871b33e', '11', 'Exercise Setup', '2', 0x4e65772047726f75702031, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 22:36:46', '2013-05-06 18:29:25', null, '1', '17'), ('a6ff6af6-cc9c-451b-b9f4-2fa81548c77f', '12', 'exercise group yeah', '2', 0x6e65772067726f757073, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:04:10', '2013-05-02 23:07:58', '2013-05-02 23:07:58', '1', '17'), ('b9c5e64b-8cc2-471e-a5b0-3a570b0b59b5', '13', 'temp test', '0', 0x6173646669646964, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:07:32', '2013-05-02 23:07:36', '2013-05-02 23:07:36', '1', '17'), ('ad02067c-ae90-406d-8340-1d7a6a9b1a14', '14', 'newest group 1', '0', 0x696469646964, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:08:09', '2013-05-02 23:09:59', '2013-05-02 23:09:48', '1', '17'), ('990a5c82-de3a-48af-aa5a-1c67a5b7a72d', '15', 'newest group 2', '1', 0x74657374, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:09:42', '2013-05-02 23:10:28', '2013-05-02 23:10:28', '1', '17'), ('8ac0474b-a8e9-426b-8ef6-c6e2e54ef9c7', '16', 'jjjj', '2', 0x616461736461736474, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:14:44', '2013-05-04 20:13:07', '2013-05-04 20:13:07', '1', '17'), ('3a3163d7-08d7-4306-a01b-2061ddf59f3c', '17', 'new group', '0', 0x64696469646964, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:16:20', '2013-05-02 23:17:17', '2013-05-02 23:17:17', '1', '17'), ('5fc76bc4-fc25-4931-a061-9e3e9652cca5', '18', 'new group jab', '0', 0x6469646964, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:30:52', '2013-05-02 23:30:58', '2013-05-02 23:30:58', '1', '17'), ('c6a3489e-3ad4-43f5-9771-fe0f081023fb', '19', 'new wild group', '0', 0x746573742067726f7570, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:34:58', '2013-05-02 23:35:07', '2013-05-02 23:35:07', '1', '17'), ('4d35c41a-8d48-4ad5-809d-a3e4aae8c324', '20', 'didid', '0', 0x6b64696469646964, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-02 23:38:40', '2013-05-02 23:38:53', '2013-05-02 23:38:53', '1', '17'), ('1ce9ab66-43a4-4916-8fd7-ce099c24880c', '21', 'test hg', '2', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-04 20:12:44', '2013-05-04 21:20:03', '2013-05-04 21:20:03', '1', '17'), ('1aa67332-eee6-424f-8075-7cc8162238f0', '22', 'newish group', '0', 0x74656d706c61746573, '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-04 21:20:33', '2013-05-04 21:20:44', '2013-05-04 21:20:44', '1', '17'), ('be192f40-61cf-47da-9d7f-1b1ee8e6b1b4', '23', 'gdsdf', '0', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', '7ed7142a-1d14-487e-8cce-339b4948b132', '2013-05-04 21:20:55', '2013-05-04 21:20:58', '2013-05-04 21:20:58', '1', '19'), ('180aa700-58f8-441d-8c42-91c856c1d729', '24', 'sdfasadf', '1', 0x617364676661736761736467, '44cc27a5-af8b-412f-855a-57c8205d86f5', '7ed7142a-1d14-487e-8cce-339b4948b132', '2013-05-04 21:21:03', '2013-05-04 21:21:13', '2013-05-04 21:21:13', '1', '19'), ('743da2b5-2b50-444c-820b-1b025488c41a', '25', 'asdfasdf', '1', 0x736164666173646661736466, '44cc27a5-af8b-412f-855a-57c8205d86f5', '7ed7142a-1d14-487e-8cce-339b4948b132', '2013-05-04 21:21:09', '2013-05-04 21:21:26', '2013-05-04 21:21:26', '1', '19'), ('fc7c32e1-3415-4ee8-b561-0256693d4c46', '26', 'Group A1', '0', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', '7ed7142a-1d14-487e-8cce-339b4948b132', '2013-05-04 21:21:20', '2013-05-06 19:05:45', null, '1', '19'), ('f92a0b84-a708-4ce4-affa-212e8eecd263', '27', 'Third New Group', '1', '', '44cc27a5-af8b-412f-855a-57c8205d86f5', '46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '2013-05-06 18:29:20', '2013-05-06 18:29:25', null, '1', '17');
COMMIT;

-- ----------------------------
--  Table structure for `revisions`
-- ----------------------------
DROP TABLE IF EXISTS `revisions`;
CREATE TABLE `revisions` (
  `uid` varchar(255) COLLATE utf8_bin NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `changeSummary` text COLLATE utf8_bin,
  `scope` text COLLATE utf8_bin,
  `finalized` tinyint(3) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
--  Records of `revisions`
-- ----------------------------
BEGIN;
INSERT INTO `revisions` VALUES ('edf9847e-9c18-46b8-a673-1d266a73cab4', '1', 0x546869732069732061206368616e67652073756d6d617279, 0x5468697320697320612073636f7065, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', 'ccb2a09e-7bc8-448d-ab9c-2011004a72c6', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-13 19:50:42', '2013-04-13 19:50:44', null, '1', '1', '1'), ('dad1065c-91cf-4796-8f8b-74edfc06f2db', '2', 0x5765206d616b65206c6f7473206f66206368616e676573, null, '0', '05817084-bc15-4dee-90a1-2e0735a242e1', '9e5a299b-eea3-46c6-a021-1fa404522e00', 'f755b54f-e918-4fcb-9024-2b48370df4a1', '2013-04-13 19:51:49', '2013-04-13 19:51:51', null, '2', '3', '2'), ('6a5e020c-c504-4913-be9f-830bf1482443', '3', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:09', '2013-04-30 22:54:09', null, '1', '1', '10'), ('a2f93e6f-ac99-452d-8575-3b0d9429f6e6', '4', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:39', '2013-04-30 22:54:39', null, '1', '1', '10'), ('ed07dafd-5fde-4270-962c-07ab1404a25f', '5', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:41', '2013-04-30 22:54:41', null, '1', '1', '10'), ('c4cbd9d6-4115-43e2-bb9d-3d65733b9271', '6', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:42', '2013-04-30 22:54:42', null, '1', '1', '10'), ('77947437-7883-4f32-ba83-2f6e3c9451d0', '7', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:44', '2013-04-30 22:54:44', null, '1', '1', '10'), ('36069bbb-29e4-4f82-b55d-a00debdb9598', '8', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:45', '2013-04-30 22:54:45', null, '1', '1', '10'), ('90576d19-f827-404d-9e96-832ab3957740', '9', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:45', '2013-04-30 22:54:45', null, '1', '1', '10'), ('a55f3471-aea5-4d7c-9b75-ef2ae4d529c6', '10', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:46', '2013-04-30 22:54:46', null, '1', '1', '10'), ('8f03e5ce-c316-4746-a3e4-8a318714d088', '11', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:46', '2013-04-30 22:54:46', null, '1', '1', '10'), ('c0d183a6-6a67-438e-a6c5-61581096e97f', '12', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:47', '2013-04-30 22:54:47', null, '1', '1', '10'), ('0be0f422-d6fe-4486-9d4d-f0665da54ab4', '13', 0x74657874, 0x74657374, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-30 22:54:47', '2013-04-30 22:54:47', null, '1', '1', '10'), ('6dd88156-6e44-4ca6-94b8-6cbd60c9291e', '14', 0x7265717569726564, 0x7265717569726564, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '64ead8a3-8a59-4278-a3b2-12592723133a', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-01 12:24:07', '2013-05-01 12:24:07', null, '1', '1', '11'), ('82b7490e-4293-4c6e-8b07-a3928d7737ee', '15', 0x7265717569726564, 0x7265717569726564, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '64ead8a3-8a59-4278-a3b2-12592723133a', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-01 12:24:12', '2013-05-01 12:24:12', null, '1', '1', '11'), ('ff38de1d-3af2-426c-b490-cba0ea9b0468', '16', 0x7265717569726564, 0x7265717569726564, '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '64ead8a3-8a59-4278-a3b2-12592723133a', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-01 12:24:12', '2013-05-01 12:24:12', null, '1', '1', '11'), ('46c7d9fa-a7bd-436c-bb5e-59ab055b43c1', '17', '', '', '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '6867c1c5-2c75-465e-b735-88f50caaee85', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 21:09:15', '2013-05-02 21:09:15', null, '1', '1', '16'), ('d4b52155-7eb7-45e2-985d-6f97cfe64aac', '18', '', '', '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', '607af04b-e3b4-444c-a7f3-4ad4830d3ec3', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 23:31:17', '2013-05-02 23:31:17', null, '1', '1', '17'), ('7ed7142a-1d14-487e-8cce-339b4948b132', '19', '', '', '0', '44cc27a5-af8b-412f-855a-57c8205d86f5', 'c151b58d-1457-4259-ad09-546d9e37d295', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-04 18:35:52', '2013-05-04 18:35:52', null, '1', '1', '18');
COMMIT;

-- ----------------------------
--  Table structure for `submissionFields`
-- ----------------------------
DROP TABLE IF EXISTS `submissionFields`;
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

-- ----------------------------
--  Table structure for `submissionGroups`
-- ----------------------------
DROP TABLE IF EXISTS `submissionGroups`;
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

-- ----------------------------
--  Table structure for `submissions`
-- ----------------------------
DROP TABLE IF EXISTS `submissions`;
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

-- ----------------------------
--  Table structure for `templates`
-- ----------------------------
DROP TABLE IF EXISTS `templates`;
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
--  Records of `templates`
-- ----------------------------
BEGIN;
INSERT INTO `templates` VALUES ('ccb2a09e-7bc8-448d-ab9c-2011004a72c6', '1', 'thisischanged123', 'mini', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-10 22:20:50', '2013-04-16 08:09:53', '2013-04-16 08:09:53', '1', '1'), ('9e5a299b-eea3-46c6-a021-1fa404522e00', '2', 'dupertemplate', 'mini', '05817084-bc15-4dee-90a1-2e0735a242e1', '0054d814-6d36-4573-bbfc-a2b6644266cc', '2013-04-10 22:22:13', '2013-04-16 08:09:53', '2013-04-16 08:09:53', '2', '4'), ('ee58b0a0-248e-4c88-b4de-5d9f7e6db937', '3', 'dogsandcats', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 01:41:33', '2013-04-16 08:10:31', '2013-04-16 08:10:31', '1', '1'), ('c6268022-fdc2-465d-98c3-8c6195fb9aa9', '4', 'mangolians', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '04ad5b05-c9a5-430f-8d5c-8483d5d904e4', '2013-04-16 01:41:33', '2013-05-02 09:43:39', '2013-05-02 09:43:39', '1', '2'), ('67ecce1e-5dfc-4bbf-92a5-4200a803086f', '5', 'newdogsandcats', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 07:16:33', '2013-05-01 11:46:29', '2013-05-01 11:46:29', '1', '1'), ('806007f1-ef91-4d01-894c-79919f068660', '6', 'newdogsandcats', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 07:49:23', '2013-05-01 11:46:31', '2013-05-01 11:46:31', '1', '1'), ('a6c85807-106b-4c64-8e65-acfa11586c49', '7', 'newdogsandcats', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 07:56:26', '2013-05-01 11:46:32', '2013-05-01 11:46:32', '1', '1'), ('110757b7-ea2d-4d3d-9b5c-5ae06f87ef73', '8', 'newdogsandcats', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 07:58:39', '2013-05-01 11:46:25', '2013-05-01 11:46:25', '1', '1'), ('f2244262-51d3-4486-8e25-26017fe5ab20', '9', 'newdogsandcats', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 07:59:30', '2013-05-01 11:27:37', '2013-05-01 11:27:37', '1', '1'), ('1b9b632c-2c8f-4272-9f4c-775ea5d8c2f3', '10', 'clientadmincreated', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 07:59:56', '2013-05-02 22:08:46', '2013-05-02 22:08:46', '1', '1'), ('64ead8a3-8a59-4278-a3b2-12592723133a', '11', 'clientadmincreated', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-04-16 08:00:22', '2013-05-02 22:08:49', '2013-05-02 22:08:49', '1', '1'), ('f2a741aa-f085-4090-ad29-9b5efddf96bb', '12', 'delta timer', 'mini', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 09:51:16', '2013-05-02 22:08:43', '2013-05-02 22:08:43', '1', '1'), ('815e5cdd-2040-4ff1-a449-3fb977ad3b46', '13', 'full expercise', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 09:51:30', '2013-05-02 22:08:33', '2013-05-02 22:08:33', '1', '1'), ('68e88088-786b-4923-badf-c60a4f671112', '14', 'Mini Exercise', 'mini', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 09:52:49', '2013-05-02 22:08:36', '2013-05-02 22:08:36', '1', '1'), ('4e192acc-a7d6-4f5a-b519-9ac7b2c4737b', '15', 'Test Template', 'mini', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 21:08:23', '2013-05-02 22:08:39', '2013-05-02 22:08:39', '1', '1'), ('6867c1c5-2c75-465e-b735-88f50caaee85', '16', 'TEST TEMPLATE 1', 'mini', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 21:09:15', '2013-05-06 19:10:09', null, '1', '1'), ('607af04b-e3b4-444c-a7f3-4ad4830d3ec3', '17', 'wonderful new template', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-02 23:31:17', '2013-05-02 23:31:25', '2013-05-02 23:31:25', '1', '1'), ('c151b58d-1457-4259-ad09-546d9e37d295', '18', 'template test', 'full', '44cc27a5-af8b-412f-855a-57c8205d86f5', '45b7c719-2049-4a44-ad9c-09e858afc48b', '2013-05-04 18:35:52', '2013-05-04 18:35:52', null, '1', '1');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
