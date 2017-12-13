CREATE TABLE `user_package_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` varchar(255) NOT NULL,
  `packagename` varchar(255) DEFAULT NULL,
  `createtime` varchar(255) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `user_alive_day` (
  `id` int(25) NOT NULL AUTO_INCREMENT,
  `userid` varchar(50) NOT NULL,
  `packagename` varchar(255) DEFAULT NULL,
  `schoolid` varchar(50) DEFAULT NULL,
  `schoolname` varchar(255) DEFAULT NULL,
  `gradename` varchar(255) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `user_day_new` (
  `id` int(25) NOT NULL AUTO_INCREMENT,
  `userid` varchar(255) NOT NULL,
  `packagename` varchar(255) DEFAULT NULL,
  `schoolid` varchar(50) DEFAULT NULL,
  `schoolname` varchar(255) DEFAULT NULL,
  `gradename` varchar(255) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `user_alive_count` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `schoolid` varchar(50) DEFAULT NULL,
  `schoolname` varchar(255) DEFAULT NULL,
  `gradename` varchar(255) DEFAULT NULL,
  `daynewuser` varchar(255) DEFAULT NULL,
  `daystunum` varchar(255) DEFAULT NULL,
  `weekstunum` varchar(255) DEFAULT NULL,
  `monthstunum` varchar(255) DEFAULT NULL,
  `dayteanum` varchar(255) DEFAULT NULL,
  `weekteanum` varchar(255) DEFAULT NULL,
  `monthteanum` varchar(255) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `user_package_count` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `schoolid` varchar(50) DEFAULT NULL,
  `schoolname` varchar(255) DEFAULT NULL,
  `gradename` varchar(255) DEFAULT NULL,
  `packagename` varchar(255) DEFAULT NULL,
  `daystunum` varchar(255) DEFAULT NULL,
  `weekstunum` varchar(255) DEFAULT NULL,
  `monthstunum` varchar(255) DEFAULT NULL,
  `dayteanum` varchar(255) DEFAULT NULL,
  `weekteanum` varchar(255) DEFAULT NULL,
  `monthteanum` varchar(255) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `user_alive_day_hourly` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `hourly` varchar(20) DEFAULT NULL,
  `usernum` int(50) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `user_alive_day_hourly_date` (
  `datetime` varchar(20) NOT NULL,
  PRIMARY KEY (`datetime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `package_name_cn` (
  `uid` int(25) NOT NULL AUTO_INCREMENT,
  `packagename` varchar(250) NOT NULL,
  `cnpackname` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `user_num_all` (
  `userid` varchar(255) DEFAULT NULL,
  `schoolid` varchar(255) DEFAULT NULL,
  `schoolname` varchar(255) DEFAULT NULL,
  `gradename` varchar(255) DEFAULT NULL,
  `datetime` varchar(255) DEFAULT NULL
)  ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `school_grade_user` (
  `userid` varchar(200) DEFAULT NULL,
  `schoolid` varchar(200) DEFAULT NULL,
  `schoolname` varchar(200) DEFAULT NULL,
  `gradename` varchar(200) DEFAULT NULL,
  `teagrade` varchar(200) DEFAULT NULL,
  `gradeclass` varchar(200) DEFAULT NULL,
  `datetime` varchar(200) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `school_area_name` (
  `schoolid` int(20) NOT NULL,
  `schoolname` varchar(200) DEFAULT NULL,
  `areaname0` varchar(50) DEFAULT NULL,
  `areaname1` varchar(100) DEFAULT NULL,
  `areaname2` varchar(100) DEFAULT NULL,
  `datetime` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`schoolid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `school_grade_count` (
  `schoolid` varchar(200) DEFAULT NULL,
  `schoolname` varchar(500) DEFAULT NULL,
  `gradeclass` varchar(200) DEFAULT NULL,
  `gradenum` varchar(200) DEFAULT '0',
  `teanum` varchar(200) DEFAULT '0',
  `stunum` varchar(200) DEFAULT '0',
  `datetime` varchar(200) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



CREATE TABLE `device_user_sevendays_nologin` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `userid` int(20) DEFAULT NULL,
  `username` varchar(200) DEFAULT NULL,
  `logonname` varchar(200) DEFAULT NULL,
  `schoolname` varchar(200) DEFAULT NULL,
  `gradename` varchar(200) DEFAULT NULL,
  `devicenumber` varchar(200) DEFAULT NULL,
  `model` varchar(200) DEFAULT NULL,
  `loginnum` int(20) DEFAULT NULL,
  `applognum` int(20) DEFAULT NULL,
  `datetime` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;



CREATE TABLE `device_user_threedays_nologin` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `userid` int(20) DEFAULT NULL,
  `username` varchar(200) DEFAULT NULL,
  `logonname` varchar(200) DEFAULT NULL,
  `schoolname` varchar(200) DEFAULT NULL,
  `gradename` varchar(200) DEFAULT NULL,
  `devicenumber` varchar(200) DEFAULT NULL,
  `model` varchar(200) DEFAULT NULL,
  `loginnum` int(20) DEFAULT NULL,
  `applognum` int(20) DEFAULT NULL,
  `datetime` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;




CREATE TABLE `device_user_login_log` (
  `uid` int(20) NOT NULL AUTO_INCREMENT,
  `userid` int(20) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `logonname` varchar(100) DEFAULT NULL,
  `louid` varchar(200) DEFAULT NULL,
  `schoolid` varchar(20) DEFAULT NULL,
  `schoolname` varchar(250) DEFAULT NULL,
  `gradename` varchar(200) DEFAULT NULL,
  `devicenumber` varchar(200) DEFAULT NULL,
  `model` varchar(200) DEFAULT NULL,
  `lodate` varchar(200) DEFAULT NULL,
  `islogin` varchar(20) DEFAULT NULL,
  `isapplog` varchar(20) DEFAULT NULL,
  `datetime` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
