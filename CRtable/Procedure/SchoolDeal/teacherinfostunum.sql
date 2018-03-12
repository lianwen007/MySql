
BEGIN
	DELETE
FROM
	teacher_info_stunum
WHERE
	datetime = adddate(date(sysdate()) ,- 1) + 0;

INSERT INTO teacher_info_stunum (
	teacherid,
	teachername,
	schoolid,
	schoolname,
	classid,
	classname,
	studentnum,
	datetime
)(
	SELECT
		stab1.teacherId,
		stab1.teacherName,
		stab1.schoolid,
		a4.sSchoolName,
		stab1.clazzId,
		stab1.`name`,
		count(DISTINCT stab1.userId) AS stunum,
		adddate(date(sysdate()) ,- 1) + 0 AS datetime
	FROM
		(
			SELECT DISTINCT
				sta1.teacherId,
				sta1.teacherName,
				sta1.schoolid,
				sta1.clazzId,
				sta1.`name`,
				sta2.userId
			FROM
				(
					SELECT
						a1.schoolid,
						a1.clazzId,
						a2.`name`,
						a1.teacherId,
						a1.teacherName
					FROM
						xh_webmanage.XHSchool_ClazzTeachers a1
					JOIN xh_webmanage.XHSchool_Clazzes a2 ON a1.clazzId = a2.id
					AND a2.clazzType = '0'
					WHERE
						a1.departed = '0'
				) sta1
			LEFT JOIN (
				SELECT
					a4.schoolId,
					a4.userId,
					a4.groupId
				FROM
					(
						SELECT
							a3.schoolId,
							a3.userId,
							a3.groupId,
							a2.`name`
						FROM
							xh_webmanage.XHSchool_ClazzMembers a3
						LEFT JOIN xh_webmanage.XHSchool_Clazzes a2 ON a3.groupId = a2.id
						AND a2.clazzType = '0'
						WHERE
							a3.departed = '0'
					) a4
				WHERE
					a4.`name` IS NOT NULL
			) sta2 ON sta1.clazzId = sta2.groupId
			AND sta1.schoolid = sta2.schoolId
		) stab1
	LEFT JOIN xh_webmanage.XHSchool_Info a4 ON stab1.schoolid = a4.iSchoolId
	GROUP BY
		stab1.teacherId,
		stab1.teacherName,
		stab1.schoolid,
		a4.sSchoolName,
		stab1.clazzId,
		stab1.`name`,
		adddate(date(sysdate()) ,- 1) + 0
);


END
