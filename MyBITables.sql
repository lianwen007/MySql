#1114-update user_package_log 加入应用和userid字段提取
#1107-update 'teacher'字段转化为中文'教师'
#1106-update user_alive_count/package 增加用户总数。增加user_num_all表处理。
#1101-update user_day_new 优化。增加table月处理，月度分表



SET GLOBAL event_scheduler = 1;

DELIMITER //
DROP PROCEDURE IF EXISTS userpackagelog//
CREATE PROCEDURE userpackagelog() 
BEGIN
set @asql=concat(
"
INSERT INTO user_package_log(userid,packagename,createtime,datetime)(
SELECT
sta.userid,
sta.packagename,
sta.createtime,
sta.datetime
FROM (
SELECT 
case 
when (message LIKE '%users/%') then substr(message,INSTR(message,'users')+6,5)
when (message LIKE '%works/%studentid%')then substr(message,INSTR(message,'studentid')+10,5)
when (message LIKE '%works/%teacherid%')then substr(message,INSTR(message,'teacherid')+10,5)
when (message LIKE '%t/userStatistical%help%')then substr(message,INSTR(message,'userStatistical')+16,5)
when (message LIKE '%userId=%')then substr(message,INSTR(message,'userId')+7,5)
when (message LIKE '%v_/%/message%')then substr(request,INSTR(request,'message')-6,5)
when (message LIKE '%/praised/comment/%')then substr(request,INSTR(request,'praised/comment')-6,5)
when (message LIKE '%interfaces%')then substr(message,INSTR(message,'UserId=')+7,5)
when (message LIKE '%osc.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%oet.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%wcc.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%gw01.yunzuoye.net%')then substr(message,-5,5)
else 0 end as userid,
case 
when local_addr='ztp.yunzuoye.net' then 'pingtai3'
when local_addr='cloudwk.yunzuoye.net' then 'yunzuoye3'
when local_addr='read.yunzuoye.net' then 'read'
when local_addr='gw01.yunzuoye.net' then 'guwen'
when local_addr='wcc.yunzuoye.net' then 'yuwen'
when local_addr='oet.yunzuoye.net' then 'kouyu'
when local_addr='osc.yunzuoye.net' then 'xiaowai'
when local_addr='isc.yunzuoye.net' then 'xiaonei'
when local_addr='response.yunzuoye.net' then 'xiangying'
when (request LIKE '%interfaces%homework_new%') then 'yunzuoye2'
when (request LIKE '%interfaces_stw_mathematics%') then 'shuxuestw'
when (request LIKE '%interfaces_yystw%') then 'yystw'
when (request LIKE '%interfaces_stw_science%') then 'kexuestw'
else 0 end as packagename,
request,
UNIX_TIMESTAMP(substr(message,1,19))+28800 as createtime,
from_unixtime(UNIX_TIMESTAMP(substr(message,1,19))+28800,'%Y-%m-%d') as datetime
FROM user_package",DATE_FORMAT(adddate(date(sysdate()) ,-1),'%Y%m%d')
," WHERE local_addr IN ('ztp.yunzuoye.net','cloudwk.yunzuoye.net','read.yunzuoye.net','gw01.yunzuoye.net','wcc.yunzuoye.net','oet.yunzuoye.net','osc.yunzuoye.net','isc.yunzuoye.net','response.yunzuoye.net') 
OR request LIKE '%interfaces%'
) sta
WHERE sta.userid RLIKE '^[1-9]' AND  sta.userid RLIKE '[0-9]$'
)
"
);
prepare stm from @asql;
EXECUTE stm;
end//

DELIMITER //
DROP EVENT IF EXISTS userpackagelog_event//
CREATE EVENT userpackagelog_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-10-24 06:00:00'
ON COMPLETION PRESERVE
DO CALL userpackagelog()//



DELIMITER //
DROP PROCEDURE IF EXISTS useraliveday//
CREATE PROCEDURE useraliveday() 
BEGIN
delete from user_alive_day where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO user_alive_day(userid,packagename,schoolid,schoolname,gradename,datetime)(
SELECT
	st.userId,
	st.packagename,
	st.schoolId,
	st.schoolName,
	st.gradename,
	st.datetime
FROM
(SELECT
	sta1.userId,
	sta1.packagename,
	ifnull(ifnull(sta2.schoolId,sta3.schoolId),0) AS schoolId,
	ifnull(ifnull(sta2.sSchoolName,sta3.sSchoolName),0) AS schoolName,
	ifnull(sta2.usergrade,'教师') AS gradename,
	sta1.datetime
FROM(
	SELECT DISTINCT
		a1.userId,
		a1.packagename,
		a1.datetime
	FROM
		user_package_log a1
WHERE a1.datetime=adddate(date(sysdate()) ,-1)
	) sta1
LEFT JOIN (SELECT DISTINCT
		a2.userId,
		a2.groupId,
		a2.schoolId,
		a5.sSchoolName,
		a3.`name` AS usergrade
	FROM
		xh_webmanage.XHSchool_ClazzMembers a2
LEFT JOIN xh_webmanage.XHSchool_Clazzes a3 ON a2.groupId = a3.id
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a2.schoolId
		) sta2 ON sta1.userId = sta2.userId
LEFT JOIN (SELECT DISTINCT
		a4.UserId,
		a4.schoolId,
		a5.sSchoolName
	FROM
		xh_webmanage.XHSchool_Teachers a4
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a4.schoolId
		) sta3 ON sta1.userId = sta3.userId) st
);
end//

DELIMITER //
DROP EVENT IF EXISTS useraliveday_event//
CREATE EVENT useraliveday_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-10-24 06:05:00'
ON COMPLETION PRESERVE
DO CALL useraliveday()//


DELIMITER //
DROP PROCEDURE IF EXISTS userpackagecount//
CREATE PROCEDURE userpackagecount() 
BEGIN
delete from user_package_count where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO user_package_count(schoolid,schoolname,gradename,packagename,stunum,daystunum,weekstunum,monthstunum,teanum,dayteanum,weekteanum,monthteanum,datetime)(
SELECT
	st1.schoolid,
	st1.schoolname,
	st1.gradename,
	st1.packagename,
	st5.stunum,
	stdayapp.daystunum,
	stweekapp.weekstunum,
	stmonthapp.monthstunum,
	st5.alluser - st5.stunum,
	stdayapp.alluser - stdayapp.daystunum AS dayteanum,
	stweekapp.alluser - stweekapp.weekstunum AS weekteanum,
	stmonthapp.alluser - stmonthapp.monthstunum AS monthteanum,
	adddate(date(sysdate()) ,-1) as datetime

FROM(SELECT DISTINCT
	a1.schoolid,
	a1.schoolname,
	a1.gradename,
	a1.packagename
	FROM
	user_alive_day a1
	WHERE a1.schoolid!='0'
	and UNIX_TIMESTAMP(a1.datetime)>=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-30))	
	) st1
LEFT JOIN (SELECT
		a2.schoolid,
		a2.schoolname,
		a2.gradename,
		a2.packagename,
		count(DISTINCT a2.userid) AS alluser, 
		ifnull(CASE WHEN (a2.gradename != '教师') THEN count(DISTINCT a2.userid)
		END,0) AS daystunum
	FROM
		user_alive_day a2
	WHERE a2.datetime=adddate(date(sysdate()) ,-1)
	GROUP BY
		a2.schoolid,
		a2.schoolname,
		a2.gradename,
		a2.packagename
) stdayapp ON st1.schoolid = stdayapp.schoolid
AND st1.packagename = stdayapp.packagename
AND st1.gradename = stdayapp.gradename
LEFT JOIN (SELECT
		a3.schoolid,
		a3.schoolname,
		a3.gradename,
		a3.packagename,
		count(DISTINCT a3.userid) AS alluser, 
		ifnull(CASE WHEN (a3.gradename != '教师') THEN count(DISTINCT a3.userid) 
		END,0) AS weekstunum
	FROM
		user_alive_day a3
	where UNIX_TIMESTAMP(a3.datetime)>=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-7))
	GROUP BY
		a3.schoolid,
		a3.schoolname,
		a3.gradename,
		a3.packagename
) stweekapp ON st1.schoolid = stweekapp.schoolid
AND st1.packagename = stweekapp.packagename
AND st1.gradename = stweekapp.gradename
LEFT JOIN (SELECT
		a4.schoolid,
		a4.schoolname,
		a4.gradename,
		a4.packagename,
		count(DISTINCT a4.userId) AS alluser, 
		ifnull(CASE WHEN (a4.gradename != '教师') THEN count(DISTINCT a4.userid)
		END,0) AS monthstunum
	FROM
		user_alive_day a4
	where UNIX_TIMESTAMP(a4.datetime)>=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-30))
	GROUP BY
		a4.schoolid,
		a4.schoolname,
		a4.gradename,
		a4.packagename
) stmonthapp ON st1.schoolid = stmonthapp.schoolid
AND st1.packagename = stmonthapp.packagename
AND st1.gradename = stmonthapp.gradename
LEFT JOIN(
	SELECT
			a6.schoolId,
			a6.schoolName,
			a6.gradename,
			count(DISTINCT a6.userId) AS alluser,
			ifnull(
				CASE
				WHEN (a6.gradename != '教师') THEN
					count(DISTINCT a6.userId)
				END,
				0
			) AS stunum
		FROM
			user_num_all a6
		WHERE	
			UNIX_TIMESTAMP(a6.datetime) = UNIX_TIMESTAMP(
				adddate(date(sysdate()) ,- 1))

		GROUP BY
			a6.schoolId,
			a6.schoolName,
			a6.gradename) st5 ON st1.schoolId = st5.schoolId
	AND st1.gradename = st5.gradename
);
END//

DELIMITER //
DROP EVENT IF EXISTS userpackagecount_event//
CREATE EVENT userpackagecount_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-10-24 06:25:00'
ON COMPLETION PRESERVE
DO CALL userpackagecount()//


DELIMITER //
DROP PROCEDURE IF EXISTS useralivecount//
CREATE PROCEDURE useralivecount() 
BEGIN
delete from user_alive_count where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO user_alive_count(schoolid,schoolname,gradename,daynewuser,stunum,daystunum,weekstunum,monthstunum,teanum,dayteanum,weekteanum,monthteanum,datetime)(

	SELECT
		st1.schoolId,
		st1.schoolName,
		st1.gradename,
		stdaynew.daynewuser,
		st5.stunum,
		stdayuser.daystunum,
		stweekuser.weekstunum,
		stmonthuser.monthstunum,
		st5.alluser - st5.stunum AS teanum,
		stdayuser.dayalluser - stdayuser.daystunum AS dayteanum,
		stweekuser.weekalluser - stweekuser.weekstunum AS weekteanum,
		stmonthuser.monthalluser - stmonthuser.monthstunum AS monthteanum,
		adddate(date(sysdate()) ,-1) as datetime
		FROM(SELECT DISTINCT
		a5.schoolid,
		a5.schoolname,
		a5.gradename
	FROM
		user_alive_day a5
	WHERE
		a5.schoolid != '0' 
	and UNIX_TIMESTAMP(a5.datetime)>=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-30))
		) st1
	LEFT JOIN (
		SELECT
		a1.schoolid,
		a1.schoolname,
		a1.gradename,
		count(DISTINCT a1.userid) AS daynewuser
	FROM
		user_day_new a1
	WHERE
		UNIX_TIMESTAMP(a1.datetime) = UNIX_TIMESTAMP(adddate(date(sysdate()) ,- 1))
	GROUP BY
		a1.schoolid,
		a1.schoolname,
		a1.gradename
	) stdaynew ON st1.schoolid = stdaynew.schoolid
	AND st1.gradename = stdaynew.gradename
	LEFT JOIN (
	SELECT
		a2.schoolid,
		a2.schoolname,
		a2.gradename,
		count(DISTINCT a2.userId) AS dayalluser,
		ifnull(CASE WHEN (a2.gradename != '教师') THEN count(DISTINCT a2.userid)
		END,0) AS daystunum
	FROM
		user_alive_day a2
	WHERE	
		UNIX_TIMESTAMP(a2.datetime) = UNIX_TIMESTAMP(adddate(date(sysdate()) ,- 1))
	GROUP BY
		a2.schoolid,
		a2.schoolname,
		a2.gradename
	) stdayuser ON st1.schoolid = stdayuser.schoolid
	AND st1.gradename = stdayuser.gradename
	LEFT JOIN (
		SELECT
			a3.schoolid,
			a3.schoolname,
			a3.gradename,
			count(DISTINCT a3.userId) AS weekalluser,
			ifnull(
				CASE
				WHEN (a3.gradename != '教师') THEN
					count(DISTINCT a3.userId)
				END,
				0
			) AS weekstunum
		FROM
			user_alive_day a3
		WHERE
			UNIX_TIMESTAMP(a3.datetime) >= UNIX_TIMESTAMP(
				adddate(date(sysdate()) ,- 7)
			)
		AND
			UNIX_TIMESTAMP(a3.datetime) < UNIX_TIMESTAMP(
				date(sysdate())
			)
		GROUP BY
			a3.schoolid,
			a3.schoolname,
			a3.gradename
	) stweekuser ON st1.schoolId = stweekuser.schoolId
	AND st1.gradename = stweekuser.gradename
	LEFT JOIN (
		SELECT
			a4.schoolid,
			a4.schoolname,
			a4.gradename,
			count(DISTINCT a4.userId) AS monthalluser,
			ifnull(
				CASE
				WHEN (a4.gradename != '教师') THEN
					count(DISTINCT a4.userId)
				END,
				0
			) AS monthstunum
		FROM
			user_alive_day a4
		WHERE
			UNIX_TIMESTAMP(a4.datetime) >= UNIX_TIMESTAMP(
				adddate(date(sysdate()) ,- 30)
			)
		AND
			UNIX_TIMESTAMP(a4.datetime) < UNIX_TIMESTAMP(
				date(sysdate())
			)
		GROUP BY
			a4.schoolid,
			a4.schoolname,
			a4.gradename
	) stmonthuser ON st1.schoolid = stmonthuser.schoolid
	AND st1.gradename = stmonthuser.gradename
LEFT JOIN(
	SELECT
			a6.schoolId,
			a6.schoolName,
			a6.gradename,
			count(DISTINCT a6.userId) AS alluser,
			ifnull(
				CASE
				WHEN (a6.gradename != '教师') THEN
					count(DISTINCT a6.userId)
				END,
				0
			) AS stunum
		FROM
			user_num_all a6
		WHERE	
			UNIX_TIMESTAMP(a6.datetime) = UNIX_TIMESTAMP(
				adddate(date(sysdate()) ,- 1))
		GROUP BY
			a6.schoolId,
			a6.schoolName,
			a6.gradename) st5 ON st1.schoolId = st5.schoolId
	AND st1.gradename = st5.gradename
)
);
end//

DELIMITER //
DROP EVENT IF EXISTS useralivecount_event//
CREATE EVENT useralivecount_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-10-24 06:20:00'
ON COMPLETION PRESERVE
DO CALL useralivecount()//


DELIMITER //
DROP PROCEDURE IF EXISTS userdaynew//
CREATE PROCEDURE userdaynew() 
BEGIN
delete from user_day_new where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO user_day_new(userid,packagename,schoolid,schoolname,gradename,datetime)(
SELECT
	st.userid,
	st.packagename,
	st.schoolid,
	st.schoolname,
	st.gradename,
	st.datetime
FROM
(
SELECT
	sta1.userid,
	sta1.packagename,
	ifnull(ifnull(sta2.schoolId,sta3.schoolId),0) AS schoolid,
	ifnull(ifnull(sta2.sSchoolName,sta3.sSchoolName),0) AS schoolname,
	ifnull(sta2.usergrade, '教师') AS gradename,
	sta1.datetime
FROM(
	SELECT 	
	a1.userid,
	a1.packagename,
	a1.datetime
	FROM
(
	SELECT DISTINCT		
	a2.userid,
	a2.packagename,
	a2.datetime
FROM
	user_package_log a2 
	WHERE a2.datetime = adddate(date(sysdate()) ,- 1)
)a1 left JOIN
(	
select DISTINCT a8.userid 
	from user_package_log a8 
WHERE a8.datetime NOT LIKE adddate(date(sysdate()),-1)
)sta8
	on a1.userid = sta8.userid
	WHERE sta8.userid IS NULL
	) sta1
LEFT JOIN (
	SELECT DISTINCT
		a2.userId,
		a2.groupId,
		a2.schoolId,
		a5.sSchoolName,
		a3.`name` as usergrade
	FROM
		xh_webmanage.XHSchool_ClazzMembers a2
	LEFT JOIN xh_webmanage.XHSchool_Clazzes a3 ON a2.groupId = a3.id
	LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a2.schoolId
) sta2 ON sta1.userId = sta2.userId
LEFT JOIN (
	SELECT DISTINCT
		a4.UserId,
		a4.schoolId,
		a5.sSchoolName
	FROM
		xh_webmanage.XHSchool_Teachers a4
	LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a4.schoolId
) sta3 ON sta1.userId = sta3.userId ) st
);
end//

DELIMITER //
DROP EVENT IF EXISTS userdaynew_event//
CREATE EVENT userdaynew_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-10-24 06:10:00'
ON COMPLETION PRESERVE
DO CALL userdaynew()//



DELIMITER //
DROP PROCEDURE IF EXISTS useralivehuorly//
CREATE PROCEDURE useralivehuorly() 
BEGIN
delete from user_alive_day_hourly where datetime = adddate(date(sysdate()) ,-1);	
INSERT INTO user_alive_day_hourly (hourly, usernum, datetime)(
	SELECT
		from_unixtime(createtime, '%H') AS hourly,
		count(DISTINCT userid) usernum,
		adddate(date(sysdate()),- 1) as datetime
	FROM
		user_package_log a1
	WHERE
		a1.datetime=adddate(date(sysdate()),- 1)
	GROUP BY
		from_unixtime(createtime, '%H')
);
delete from user_alive_day_hourly_date where datetime = adddate(date(sysdate()) ,-1);	
INSERT INTO user_alive_day_hourly_date (datetime)(
SELECT 
adddate(date(sysdate()) ,- 1) AS datetime
);
end//

DELIMITER //
DROP EVENT IF EXISTS useralivehuorly_event//
CREATE EVENT useralivehuorly_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-10-24 06:15:00'
ON COMPLETION PRESERVE
DO CALL useralivehuorly()//

DELIMITER //
DROP PROCEDURE IF EXISTS tabledrop7d//
CREATE PROCEDURE tabledrop7d() 
BEGIN
set @asql=concat(
"drop table if exists user_package",DATE_FORMAT(adddate(date(sysdate()) ,-8),'%Y%m%d')
);
prepare stm from @asql;
EXECUTE stm;
end//


DELIMITER //
DROP EVENT IF EXISTS tabledrop7d_event//
CREATE EVENT tabledrop7d_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-10-28 06:30:00'
ON COMPLETION PRESERVE
DO CALL tabledrop7d()//



DELIMITER //
DROP PROCEDURE IF EXISTS tablemonthdeal//
CREATE PROCEDURE tablemonthdeal() 
BEGIN
set @rename_table=concat(
"RENAME TABLE user_package_log to user_package_log_",DATE_FORMAT(adddate(date(sysdate()) ,-1),'%Y%m')
);
set @create_table= CONCAT('create table user_package_log(`id` int(11) NOT NULL AUTO_INCREMENT,
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
end//

DELIMITER //
DROP EVENT IF EXISTS tablemonthdeal_event//
CREATE EVENT tablemonthdeal_event
ON SCHEDULE EVERY 1 MONTH STARTS '2017-11-01 23:30:00'
ON COMPLETION PRESERVE
DO CALL tablemonthdeal()//


DELIMITER //
DROP PROCEDURE IF EXISTS usernumall//
CREATE PROCEDURE usernumall() 
BEGIN
delete from user_num_all where datetime = adddate(date(sysdate()) ,-1);	
INSERT INTO user_num_all(userid,schoolid,schoolname,gradename,datetime)(
SELECT
	st.iUserId,
	st.schoolId,
	st.schoolName,
	st.gradename,
	st.datetime
FROM
(SELECT
	sta1.iUserId,
	ifnull(ifnull(sta2.schoolId,sta3.schoolId),0) AS schoolId,
	ifnull(ifnull(sta2.sSchoolName,sta3.sSchoolName),0) AS schoolName,
	ifnull(sta2.usergrade,'教师') AS gradename,
	adddate(date(sysdate()) ,- 1) AS datetime
FROM(
	SELECT DISTINCT
			a0.iUserId
		FROM
			xh_webmanage.XHSys_User a0
		WHERE
			a0.iUserType in ('1','4')
		AND
			a0.iSchoolId NOT in ('0','900090009')
	) sta1
LEFT JOIN (SELECT DISTINCT
		a2.userId,
		a2.groupId,
		a2.schoolId,
		a5.sSchoolName,
		a3.`name` AS usergrade
	FROM
		xh_webmanage.XHSchool_ClazzMembers a2
LEFT JOIN xh_webmanage.XHSchool_Clazzes a3 ON a2.groupId = a3.id
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a2.schoolId
		) sta2 ON sta1.iUserId = sta2.userId
LEFT JOIN (SELECT DISTINCT
		a4.UserId,
		a4.schoolId,
		a5.sSchoolName
	FROM
		xh_webmanage.XHSchool_Teachers a4
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a4.schoolId
		) sta3 ON sta1.iUserId = sta3.userId) st
WHERE st.schoolId!='0'
);
end//

DELIMITER //
DROP EVENT IF EXISTS usernumall_event//
CREATE EVENT usernumall_event
ON SCHEDULE EVERY 24 HOUR STARTS '2017-11-07 03:30:00'
ON COMPLETION PRESERVE
DO CALL usernumall()//
