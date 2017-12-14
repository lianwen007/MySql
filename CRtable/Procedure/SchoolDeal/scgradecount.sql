BEGIN

delete from school_grade_count where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO school_grade_count (schoolid,schoolname,areaname0,areaname1,areaname2,gradeclass,gradenum,teanum,stunum,datetime)(
SELECT
		st1.schoolid,
		st1.schoolname,
		st1.areaname0,
		st1.areaname1,
		st1.areaname2,
		CASE
		WHEN st1.gradeclass='7' THEN '7年级'
		WHEN st1.gradeclass='8' THEN '8年级'
		WHEN st1.gradeclass='9' THEN '9年级'
		ELSE st1.gradeclass END AS gradeclazz,
		st2.gradenum,
		st3.teanum,
		st2.stunum,
		adddate(date(sysdate()) ,- 1) AS datetime
	FROM
		(
			SELECT DISTINCT
			a1.schoolid,
			a1.schoolname,
			a5.areaname0,
			a5.areaname1,
			a5.areaname2,
			a1.gradeclass
			#count(DISTINCT a1.gradename) AS gradenum
		FROM
			school_grade_user a1
		LEFT JOIN
			(SELECT DISTINCT 
				a4.schoolid,
				a4.areaname0,
				a4.areaname1,
				a4.areaname2	
				FROM school_area_name a4
			) a5
		ON a1.schoolid=a5.schoolid
		WHERE #a1.gradeclass RLIKE '^[1-9]'
		a1.datetime = adddate(date(sysdate()) ,- 1)
		AND
		a1.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
	
		) st1
	LEFT JOIN (
		SELECT
			a2.schoolid,
			a2.schoolname,
			a2.gradeclass,
			count( a2.userid) AS stunum,
			count(DISTINCT a2.gradename) AS gradenum
		FROM
			school_grade_user a2
		WHERE
			a2.gradename != '教师'
		AND a2.datetime = adddate(date(sysdate()) ,- 1)
		AND a2.schoolid NOT in ('0','900090009','3563','3618','4160','3614')
		GROUP BY
			a2.schoolid,
			a2.schoolname,
			a2.gradeclass
	) st2 ON st1.schoolid = st2.schoolid
	AND st1.gradeclass = st2.gradeclass
	LEFT JOIN (
		SELECT
				a3.schoolid,
				a3.schoolname,
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
				a3.schoolid,
				a3.schoolname,
				a3.gradeclass
	) st3 ON st1.schoolid = st3.schoolid
	AND st1.gradeclass = st3.gradeclass

);

END
