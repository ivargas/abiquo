-- DELETE THE OBSOLETE PUBLIC IP TABLE --
DROP TABLE IF EXISTS `kinton`.`publicip`;

--
-- STATEFUL REFRACTOR TABLES MIGRATION
--

-- 
-- Definition of table `kinton`.`tier`.
--
DROP TABLE IF EXISTS `kinton`.`tier`;
CREATE TABLE `kinton`.`tier` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(40) NOT NULL,
    `description` varchar(255) NOT NULL,
    `idDataCenter` int(10) unsigned NOT NULL,
    `isEnabled` tinyint(1) unsigned NOT NULL default '1',
    `version_c` integer NOT NULL DEFAULT 1,
     PRIMARY KEY  (`id`),
     CONSTRAINT `tier_FK_1` FOREIGN KEY (`idDataCenter`) REFERENCES `datacenter` (`idDataCenter`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

INSERT INTO `kinton`.`tier` (name, description, idDataCenter, isEnabled)
SELECT "Default tier 1" , "Description of default tier 1", idDataCenter, 1
FROM datacenter;

INSERT INTO `kinton`.`tier` (name, description, idDataCenter, isEnabled)
SELECT "Default tier 2" , "Description of default tier 2", idDataCenter, 1
FROM datacenter;

INSERT INTO `kinton`.`tier` (name, description, idDataCenter, isEnabled)
SELECT "Default tier 3" , "Description of default tier 3", idDataCenter, 1
FROM datacenter;

INSERT INTO `kinton`.`tier` (name, description, idDataCenter, isEnabled)
SELECT "Default tier 4" , "Description of default tier 4", idDataCenter, 1
FROM datacenter;

--
-- Definition of table `kinton`.`cabin`
--

DROP TABLE IF EXISTS `kinton`.`storage_device`;
CREATE TABLE `kinton`.`storage_device` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `idDataCenter` int(10) unsigned NOT NULL,
  `management_ip` varchar(256) NOT NULL,
  `management_port` int(5) unsigned NOT NULL DEFAULT '0',
  `iscsi_ip` varchar(256) NOT NULL,
  `iscsi_port` int(5) unsigned NOT NULL DEFAULT '0',
  `storage_technology` varchar(256) DEFAULT NULL,
  `version_c` integer NOT NULL DEFAULT 1,
  PRIMARY KEY  (`id`),
  CONSTRAINT `cabinet_FK_1` FOREIGN KEY (`idDataCenter`) REFERENCES `datacenter` (`idDataCenter`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Update `storage_device` table with previous `storage_pool` table
INSERT INTO `kinton`.`storage_device` (name, idDataCenter, management_ip, management_port, iscsi_ip, iscsi_port, storage_technology)
SELECT CONCAT('cabin_', s.name) , 
       r.idDatacenter,substring_index(substring_index(s.url_management,':',2),'//',-1), 
       substring_index(substring_index(s.url_management,':',-1),'/',1), 
       s.host_ip, 
       s.host_port, 
       s.storage_technology 
FROM `storage_pool` s, `remote_service` r 
WHERE s.idRemoteService = r.idRemoteService;

-- REESTRUCTURE THE STORAGE_POOL TABLE
ALTER TABLE `kinton`.`storage_pool` ADD COLUMN `idStorageDevice` int(10) unsigned NOT NULL;
ALTER TABLE `kinton`.`storage_pool` ADD COLUMN `idTier` int(10) unsigned NOT NULL;
ALTER TABLE `kinton`.`storage_pool` ADD COLUMN `isEnabled` tinyint(1) unsigned NOT NULL default '1';
ALTER TABLE `kinton`.`storage_pool` ADD COLUMN `totalSizeInMb` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE `kinton`.`storage_pool` ADD COLUMN `usedSizeInMb` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE `kinton`.`storage_pool` ADD COLUMN `availableSizeInMb` BIGINT(20) UNSIGNED NOT NULL DEFAULT 0;

/*!40000 ALTER TABLE `storage_pool` DISABLE KEYS */;
UPDATE `storage_pool` s, `remote_service` r, `storage_device` c
SET s.idStorageDevice = c.id, s.idTier = 1, s.isEnabled = 1
WHERE r.idRemoteService = s.idRemoteService 
  AND r.idDatacenter = r.idDatacenter;
/*!40000 ALTER TABLE `storage_pool` ENABLE KEYS */;

ALTER TABLE `kinton`.`storage_pool` ADD CONSTRAINT `storage_pool_FK1` FOREIGN KEY (`idStorageDevice`) REFERENCES `kinton`.`storage_device` (`id`) ON DELETE CASCADE;
ALTER TABLE `kinton`.`storage_pool` ADD CONSTRAINT `storage_pool_FK2` FOREIGN KEY (`idTier`) REFERENCES `kinton`.`tier` (`id`) ON DELETE RESTRICT;
ALTER TABLE `kinton`.`storage_pool` DROP FOREIGN KEY `idRemoteServiceFK_1`;
ALTER TABLE `kinton`.`storage_pool` DROP KEY `idRemoteServiceFK_1`;
ALTER TABLE `kinton`.`storage_pool` DROP COLUMN `idRemoteService`;
ALTER TABLE `kinton`.`storage_pool` DROP COLUMN `url_management`;
ALTER TABLE `kinton`.`storage_pool` DROP COLUMN `host_ip`;
ALTER TABLE `kinton`.`storage_pool` DROP COLUMN `host_port`;
ALTER TABLE `kinton`.`storage_pool` DROP COLUMN `storage_technology`;

--
-- System properties
--

/*!40000 ALTER TABLE `kinton`.`system_properties` DISABLE KEYS */;
LOCK TABLES `kinton`.`system_properties` WRITE;
INSERT INTO `kinton`.`system_properties` (`name`, `value`, `description`) VALUES
 ("client.main.enterpriseLogoURL","http://www.abiquo.com","URL displayed when the header enterprise logo is clicked");
UNLOCK TABLES;
/*!40000 ALTER TABLE `kinton`.`system_properties` ENABLE KEYS */;

--
-- Stateful
--

/*!40000 ALTER TABLE `kinton`.`node_virtual_image_stateful_conversions` DISABLE KEYS */;
LOCK TABLES `kinton`.`node_virtual_image_stateful_conversions` WRITE;
ALTER TABLE `kinton`.`node_virtual_image_stateful_conversions` ADD COLUMN `idTier` int(10) unsigned NOT NULL;
ALTER TABLE `kinton`.`node_virtual_image_stateful_conversions` ADD CONSTRAINT `idTier_FK4` FOREIGN KEY (`idTier`) REFERENCES `tier` (`id`);
UNLOCK TABLES;
/*!40000 ALTER TABLE `kinton`.`node_virtual_image_stateful_conversions` ENABLE KEYS */;
