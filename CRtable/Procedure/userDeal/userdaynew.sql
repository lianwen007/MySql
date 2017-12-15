BEGIN/*
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
	ifnull(sta2.usergrade, 'teacher') AS gradename,
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
);*/
END
