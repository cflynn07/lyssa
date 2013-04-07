mysql = require 'mysql'
client = mysql.createConnection
  host: 'localhost'
  user: 'root'
  password: 'root'
  port: 8889
  database: 'lyssa'

client.connect()

sql = "SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

BEGIN;
INSERT INTO `clients` VALUES ('1', 'Apple', 'apple'), ('2', 'Wellington Mgmt', 'wellington'), ('3', 'Princement', 'prince');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;"

client.query sql, (err, res) ->
  console.log err
  console.log res

