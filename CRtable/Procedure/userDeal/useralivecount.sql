#20180131-增加packagename非空判定


BEGIN
delete from user_alive_count where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO user_alive_count(schoolid,schoolname,gradename,daynewuser,stunum,daystunum,weekstunum,monthstunum,teanum,dayteanum,weekteanum,monthteanum,datetime)(

SELECT
		st1.schoolId,
		st1.schoolName,
		st1.gradename,
		stdaynew.daynewuser,
		st1.stunum,
		stdayuser.daystunum,
		stweekuser.weekstunum,
		stmonthuser.monthstunum,
		st1.teanum,
		stdayuser.dayalluser - stdayuser.daystunum AS dayteanum,
		stweekuser.weekalluser - stweekuser.weekstunum AS weekteanum,
		stmonthuser.monthalluser - stmonthuser.monthstunum AS monthteanum,
		adddate(date(sysdate()) ,-1) as datetime
		FROM(

SELECT
		sta1.schoolid,
		sta1.schoolname,
		sta1.gradename,
		sta3.teanum,
		sta2.stunum,
		adddate(date(sysdate()) ,- 1) AS datetime
	FROM
		(
			SELECT DISTINCT
			a1.schoolid,
			a1.schoolname,
			a1.gradename
		FROM
			school_grade_user a1
		WHERE 
		a1.datetime = adddate(date(sysdate()) ,- 1)
		AND
		a1.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
	
		) sta1
	LEFT JOIN (
		SELECT 
			a2.schoolid,
			a2.gradename,
			count(a2.userid) AS stunum
		FROM
			school_grade_user a2
		WHERE
			a2.gradename != '教师'
		AND a2.datetime = adddate(date(sysdate()) ,- 1)
		AND a2.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
		GROUP BY
			a2.schoolid,
			a2.gradename
	) sta2 ON sta1.schoolid = sta2.schoolid
AND sta1.gradename=sta2.gradename
	LEFT JOIN (
		SELECT a5.schoolid,a5.gradename,sum(a5.teanum)AS teanum 
			FROM(
				SELECT
				a3.schoolid,
				a3.gradename,
				a3.gradeclass,
				count(DISTINCT a3.userid) AS teanum
			FROM
				school_grade_user a3
			WHERE
				a3.gradename = '教师'
			AND 
			a3.datetime = adddate(date(sysdate()) ,- 1)
			AND
			a3.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
			GROUP BY
				a3.schoolid,a3.gradename,a3.gradeclass
		)a5 
GROUP BY a5.schoolid,a5.gradename) sta3 ON sta1.schoolid = sta3.schoolid
AND sta1.gradename = sta3.gradename
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
	AND
		a2.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
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
		AND 
			a3.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
		AND a3.packagename IS NOT NULL
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
		AND 
			a4.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
		AND a4.packagename IS NOT NULL
		GROUP BY
			a4.schoolid,
			a4.schoolname,
			a4.gradename
	) stmonthuser ON st1.schoolid = stmonthuser.schoolid
	AND st1.gradename = stmonthuser.gradename
);
END
