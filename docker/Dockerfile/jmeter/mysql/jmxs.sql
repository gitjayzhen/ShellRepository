create database test;
use test;
CREATE TABLE jmxs (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(50) NOT NULL DEFAULT '',
  file varchar(50) NOT NULL DEFAULT '',
  status varchar(50) NOT NULL DEFAULT '',
  ip varchar(50) DEFAULT NULL,
  user varchar(50) DEFAULT NULL,
  pw varchar(50) DEFAULT NULL,
  process varchar(50) DEFAULT NULL,
  duration int(11) DEFAULT NULL,
  isactive int(11) NOT NULL,
  createtime datetime NOT NULL,
  changetime datetime NOT NULL,
  jmeterip varchar(50) DEFAULT NULL,
  pid int(11) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;