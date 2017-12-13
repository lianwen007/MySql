BEGIN
delete from device_user_login_log where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO device_user_login_log (userid,username,logonname,louid,schoolid,schoolname,gradename,
devicenumber,model,lodate,islogin,isapplog,datetime)(
SELECT
	sta1.iUserId,
	sta4.sUserName,
	sta4.sLogonName,
	sta2.lo_uid,
	ifnull(sta4.ischoolId,0) AS schoolId,
	ifnull(sta4.sSchoolName,0) AS schoolName,
	CASE
	WHEN sta4.iUserType='4' THEN '教师'
	WHEN sta4.iUserType='1' THEN sta4.usergrade
	ELSE '0' END AS gradename,
	sta1.sDeviceNumber,
	sta1.sModel,
	sta2.lodate,
	IF (sta2.lodate != 'NULL', 1, 0) islogin,
	IF (sta3.datetime != 'NULL', 1, 0) isapplog,
 	adddate(date(sysdate()) ,- 1) AS datetime
FROM
	(
		SELECT
			a1.iUserId,
			a1.sDeviceNumber,
			a1.sModel
		FROM
			xh_webmanage.XHSys_AccountDeviceLocked a1
		WHERE
			sModel LIKE '%5100%'
	) sta1
LEFT JOIN (
	SELECT DISTINCT
		a2.lo_us_id,
		a2.lo_uid,
		substr(a2.lo_date, 1, 10) AS lodate
	FROM
		xh_product.login_log a2
	WHERE
		substr(lo_date, 1, 10) = adddate(date(sysdate()) ,- 1)
) sta2 ON sta1.IuserId = sta2.lo_us_id
LEFT JOIN (
	SELECT DISTINCT
		a3.userid,
		a3.datetime
	FROM
		xh_elasticsearch.user_alive_day a3
	WHERE
		a3.datetime = adddate(date(sysdate()) ,- 1)
) sta3 ON sta1.iUserId = sta3.userid
left JOIN (SELECT DISTINCT
		a4.iUserId,
		a4.sUserName,
		a4.sLogonName,
		a4.iUserType,
		a4.iSchoolId,
		a5.sSchoolName,
		a4.sAdClsName AS usergrade
	FROM
		xh_webmanage.XHSys_User a4
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a4.iSchoolId
		) sta4 ON sta1.iUserId = sta4.iUserId 
);

END
