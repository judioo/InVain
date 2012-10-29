-- mysql create database velti;

DROP TABLE IF EXISTS `vote`;
CREATE TABLE `vote` (
  id int(11) unsigned NOT NULL auto_increment,
  vote  timestamp,
  campaign    varchar(100) NOT NULL,
  validity    varchar(6) NOT NULL,
  choice      varchar(100) NOT NULL,
  conn        varchar(100) NOT NULL,
  msisdn      varchar(100) NOT NULL,
  guid        varchar(100) NOT NULL,
  shortcode   varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

GRANT ALL ON velti.* TO velti@'localhost' IDENTIFIED BY 'velti123';
