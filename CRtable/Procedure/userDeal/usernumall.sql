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
			a0.iSchoolId NOT in ('0','900090009','3563','3618','4160')
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
		a4.teacherId,
		a4.schoolId,
		a5.sSchoolName
	FROM
		xh_webmanage.XHSchool_ClazzTeachers a4
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a4.schoolId
		) sta3 ON sta1.iUserId = sta3.teacherId) st
WHERE st.schoolId!='0'
);
end
