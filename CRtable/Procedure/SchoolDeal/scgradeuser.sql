BEGIN
delete from school_grade_user where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO school_grade_user(userid,schoolid,schoolname,gradename,teagrade,gradeclass,datetime)(
#1222-增加2018级为7年级
SELECT
	st.iUserId,
	st.schoolId,
	st.schoolName,
	st.gradename,
	st.teagrade,
	CASE
	WHEN ((st.gradeclazz='2017' OR st.gradeclazz='2018') AND st.schoolId != '4652') THEN '7'
	WHEN (st.gradeclazz='2016') THEN '8'
	WHEN (st.gradeclazz='2015') THEN '9'
	ELSE '其他' END AS gradeclass,
	st.datetime
FROM
(SELECT
	sta1.iUserId,
	ifnull(ifnull(sta2.schoolId,sta3.schoolId),0) AS schoolId,
	ifnull(ifnull(sta2.sSchoolName,sta3.sSchoolName),0) AS schoolName,
	ifnull(sta2.usergrade,'教师') AS gradename,
	ifnull(sta3.teagrade,'0')AS teagrade,
	ifnull(sta2.enrollYear,sta3.enrollYear)AS gradeclazz,
	adddate(date(sysdate()) ,- 1) AS datetime
FROM(
	SELECT DISTINCT
			a0.iUserId
		FROM
			xh_webmanage.XHSys_User a0
		WHERE
			a0.iUserType in ('1','4')
		AND
			a0.iSchoolId NOT in ('0','900090009','3563','3618','4160','3614')
	) sta1
LEFT JOIN (SELECT DISTINCT
		a2.userId,
		a2.groupId,
		a2.schoolId,
		a5.sSchoolName,
		a3.enrollYear,
		a3.`name`AS usergrade
	FROM
		xh_webmanage.XHSchool_ClazzMembers a2
LEFT JOIN xh_webmanage.XHSchool_Clazzes a3 ON a2.groupId = a3.id
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a2.schoolId
		WHERE a2.departed='0'
		) sta2 ON sta1.iUserId = sta2.userId
LEFT JOIN (SELECT DISTINCT
		a4.teacherId,
		a4.clazzId,
		a4.schoolId,
		a5.sSchoolName,
		a3.enrollYear,
		a3.`name` AS teagrade
	FROM
		xh_webmanage.XHSchool_ClazzTeachers a4
LEFT JOIN xh_webmanage.XHSchool_Clazzes a3 ON a4.clazzId = a3.id
LEFT JOIN xh_webmanage.XHSchool_Info a5 ON a5.iSchoolId = a4.schoolId
		WHERE a4.departed='0'
		) sta3 ON sta1.iUserId = sta3.teacherId) st
WHERE st.schoolId!='0' AND st.gradename!=''
);

CALL schoolgradecount();

END
