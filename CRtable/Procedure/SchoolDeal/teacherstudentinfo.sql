
BEGIN
	#Routine body goes here...
	DELETE
FROM
	teacher_student_info
WHERE
	datetime = adddate(date(sysdate()) ,- 1) + 0;

INSERT INTO teacher_student_info (
	teacherid,
	teachername,
	schoolid,
	classid,
	classname,
	userid,
	datetime
)(
	SELECT DISTINCT
		sta1.teacherId,
		sta1.teacherName,
		sta1.schoolid,
		sta1.clazzId,
		sta1.`name`,
		sta2.userId,
		adddate(date(sysdate()) ,- 1) + 0 AS datetime
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
);


END
