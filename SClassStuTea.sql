SELECT
	#跨班级用户，包含教师学生
	sta1.userid,
	sta3.sUserName,
	sta1.schoolid,
	sta1.schoolname,
	sta2.gradename,
	sta4.departed
FROM
	(
		SELECT
			a.userid,
			a.schoolid,
			a.schoolname,
			a.gradename,
			count(DISTINCT a.gradename) AS grnum
		FROM
			school_grade_user a
		WHERE
			a.datetime = ADDDATE(date(sysdate()) ,-1)
		GROUP BY
			a.userid,
			a.schoolid,
			a.schoolname
		HAVING
			count(DISTINCT a.gradename) > 1
	) sta1
LEFT JOIN (
	SELECT
		b.userid,
		b.schoolid,
		b.schoolname,
		b.gradename
	FROM
		school_grade_user b
	WHERE
		b.datetime = ADDDATE(date(sysdate()) ,-1)
) sta2 ON sta1.userid = sta2.userid
AND sta1.schoolid = sta2.schoolid
LEFT JOIN (
	SELECT
		c.iUserId,
		c.sUserName
	FROM
		xh_webmanage.xhsys_user c
) sta3 ON sta1.userid = sta3.iUserId
LEFT JOIN (
	SELECT
		d.userId,
		d.departed
	FROM
		xh_webmanage.xhschool_clazzmembers d
) sta4 ON sta1.userid = sta4.userId
