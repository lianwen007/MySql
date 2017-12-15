BEGIN
set @rename_table=concat(
"RENAME TABLE user_package_log to 
user_package_log_",DATE_FORMAT(adddate(date(sysdate()) ,-1),'%Y%m')
);
set @create_table= CONCAT(
'create table user_package_log(`id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` varchar(255) NOT NULL,
  `packagename` varchar(255) DEFAULT NULL,
  `createtime` varchar(255) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;');
prepare remt from @rename_table;
EXECUTE remt;
prepare crmt from @create_table;
EXECUTE crmt;
END
