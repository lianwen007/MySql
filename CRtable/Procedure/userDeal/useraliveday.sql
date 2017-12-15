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
		WHERE a2.departed='0'
		) sta2 ON sta1.userId = sta2.userId
LEFT JOIN (SELECT DISTINCT
		a4.teacherId,
		a4.schoolId,
		a3.sSchoolName
	FROM
		xh_webmanage.XHSchool_ClazzTeachers a4
LEFT JOIN xh_webmanage.XHSchool_Info a3 ON a3.iSchoolId = a4.schoolId
		WHERE a4.departed='0'
		) sta3 ON sta1.userId = sta3.teacherId) st 
WHERE st.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
);
END
