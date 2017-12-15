BEGIN
delete from user_package_count where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO user_package_count(schoolid,schoolname,gradename,packagename,stunum,daystunum,weekstunum,monthstunum,teanum,dayteanum,weekteanum,monthteanum,datetime)(
SELECT
	st1.schoolid,
	st1.schoolname,
	st1.gradename,
	st1.packagename,
	st1.stunum,
	stdayapp.daystunum,
	stweekapp.weekstunum,
	stmonthapp.monthstunum,
	st1.teanum,
	stdayapp.alluser - stdayapp.daystunum AS dayteanum,
	stweekapp.alluser - stweekapp.weekstunum AS weekteanum,
	stmonthapp.alluser - stmonthapp.monthstunum AS monthteanum,
	adddate(date(sysdate()) ,-1) as datetime

FROM(SELECT
		sta1.schoolid,
		sta1.schoolname,
		sta4.packagename,
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
		SELECT
				a3.schoolid,
				a3.gradename,
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
				a3.schoolid,a3.gradename
	) sta3 ON sta1.schoolid = sta3.schoolid
AND sta1.gradename = sta3.gradename
LEFT JOIN(
SELECT DISTINCT
a4.schoolid,
	a4.schoolname,
	a4.gradename,
	a4.packagename
	FROM
	user_alive_day a4
	WHERE a4.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
	and UNIX_TIMESTAMP(a4.datetime)>=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-30))	
)sta4 ON sta1.schoolid = sta4.schoolid
AND sta1.gradename = sta4.gradename) st1
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
	AND a2.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
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
	AND a3.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
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
	AND a4.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
	GROUP BY
		a4.schoolid,
		a4.schoolname,
		a4.gradename,
		a4.packagename
) stmonthapp ON st1.schoolid = stmonthapp.schoolid
AND st1.packagename = stmonthapp.packagename
AND st1.gradename = stmonthapp.gradename
);

END
