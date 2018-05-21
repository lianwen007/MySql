CREATE TABLE `active_user_num_daily` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `school_id` varchar(20) CHARACTER SET latin1 DEFAULT NULL COMMENT '学校标识',
  `school_name` varchar(200) CHARACTER SET latin1 DEFAULT NULL COMMENT '学校名称',
  `grade_id` varchar(10) CHARACTER SET latin1 DEFAULT NULL COMMENT '年级标识',
  `grade_name` varchar(100) CHARACTER SET latin1 DEFAULT NULL COMMENT '年级名称',
  `class_id` varchar(10) CHARACTER SET latin1 DEFAULT NULL COMMENT '班级标识',
  `class_name` varchar(100) CHARACTER SET latin1 DEFAULT NULL COMMENT '班级名称',
  `day_stu_num` bigint(20) DEFAULT '0' COMMENT '学生日活跃数',
  `total_stu_num` bigint(20) DEFAULT '0' COMMENT '学生总人数',
  `day_tea_num` bigint(20) DEFAULT '0' COMMENT '教师日活跃数',
  `tea_num` bigint(20) DEFAULT '0' COMMENT '教师总人数',
  `class_stu_rate` int(3) DEFAULT '0' COMMENT '班级学生活跃指数',
  `class_tea_rate` int(3) DEFAULT '0' COMMENT '班级教师活跃指数',
  `date_time` varchar(8) CHARACTER SET latin1 NOT NULL COMMENT '统计日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



SELECT altab1.schoolId,altab2.sSchoolName,altab1.gradeid,altab1.gradeid,
altab1.classid,altab1.classname,
altab1.day_stu_num,altab1.stu_num,altab1.day_tea_num,altab1.tea_num,
(altab1.day_stu_num/altab1.stu_num)*100 AS stu_rate,
(altab1.day_tea_num/altab1.tea_num)*100 AS tea_rate,
adddate(date(sysdate()) ,- 0)+0
FROM
(SELECT tab1.schoolId,tab1.gradeid,tab1.classid,tab1.classname,tab1.split_id,
CASE WHEN tab1.split_id = '1' THEN SUM(tab1.islive) END AS day_tea_num,
CASE WHEN tab1.split_id = '1' THEN COUNT(DISTINCT tab1.userid) END AS tea_num,
CASE WHEN tab1.split_id = '2' THEN SUM(tab1.islive) END AS day_stu_num,
CASE WHEN tab1.split_id = '2' THEN COUNT(DISTINCT tab1.userid) END AS stu_num
FROM
(SELECT sta1.schoolId,sta1.classid,sta1.classname,sta1.userid,IFNULL(sta2.is_alive,0) islive,
sta1.gradeid,sta1.enrollYear,sta1.split_id
FROM
(SELECT a1.schoolId,a1.clazzId classid,a2.`name` classname,a1.teacherId userid,a2.grade,a2.enrollYear,
CASE WHEN a2.grade = '21' AND a2.enrollYear = '2017' THEN '7'
  WHEN a2.grade = '21' AND a2.enrollYear = '2016' THEN '8'
  WHEN a2.grade = '21' AND a2.enrollYear = '2015' THEN '9'
  WHEN a2.grade = '31' AND a2.enrollYear = '2017' THEN '10'
  WHEN a2.grade = '31' AND a2.enrollYear = '2016' THEN '11'
  WHEN a2.grade = '31' AND a2.enrollYear = '2015' THEN '12'
END AS gradeid,1 AS split_id
FROM xh_webmanage.XHSchool_ClazzTeachers a1
LEFT JOIN xh_webmanage.XHSchool_Clazzes a2
ON a1.clazzId = a2.id
WHERE a1.departed = '0'
AND a2.clazzType = '0'
UNION ALL
SELECT a3.schoolId,a3.groupId classid,a2.`name` classname,a3.userId userid,a2.grade,a2.enrollYear,
CASE WHEN a2.grade = '21' AND a2.enrollYear = '2017' THEN '7'
  WHEN a2.grade = '21' AND a2.enrollYear = '2016' THEN '8'
  WHEN a2.grade = '21' AND a2.enrollYear = '2015' THEN '9'
  WHEN a2.grade = '31' AND a2.enrollYear = '2017' THEN '10'
  WHEN a2.grade = '31' AND a2.enrollYear = '2016' THEN '11'
  WHEN a2.grade = '31' AND a2.enrollYear = '2015' THEN '12'
END AS gradeid,2 AS split_id
FROM xh_webmanage.XHSchool_ClazzMembers a3
LEFT JOIN xh_webmanage.XHSchool_Clazzes a2
ON a3.groupId = a2.id
WHERE a3.departed = '0') sta1 
LEFT JOIN
(SELECT DISTINCT a4.userid,1 AS is_alive
FROM xh_elasticsearch.user_alive_day a4
WHERE a4.datetime = adddate(date(sysdate()) ,- 1)
) sta2 ON sta1.userid = sta2.userid
) tab1 GROUP BY tab1.schoolId,tab1.gradeid,tab1.classid,tab1.classname,tab1.split_id

UNION ALL
SELECT sta3.schoolId,sta3.gradeid,0 classid,'teacher' classname,1 split_id,
SUM(sta3.is_alive) day_tea_num,
count(DISTINCT sta3.userid) tea_num,0 day_stu_num,0 stu_num
FROM 
(SELECT DISTINCT a1.schoolId,a1.teacherId userid,
sta2.is_alive,a2.grade,a2.enrollYear,
CASE WHEN a2.grade = '21' AND a2.enrollYear = '2017' THEN '7'
  WHEN a2.grade = '21' AND a2.enrollYear = '2016' THEN '8'
  WHEN a2.grade = '21' AND a2.enrollYear = '2015' THEN '9'
  WHEN a2.grade = '31' AND a2.enrollYear = '2017' THEN '10'
  WHEN a2.grade = '31' AND a2.enrollYear = '2016' THEN '11'
  WHEN a2.grade = '31' AND a2.enrollYear = '2015' THEN '12'
END AS gradeid,1 AS split_id
FROM xh_webmanage.XHSchool_ClazzTeachers a1
LEFT JOIN xh_webmanage.XHSchool_Clazzes a2
ON a1.clazzId = a2.id
LEFT JOIN
(SELECT DISTINCT a4.userid,1 AS is_alive
FROM xh_elasticsearch.user_alive_day a4
WHERE a4.datetime = adddate(date(sysdate()) ,- 1)
) sta2 ON a1.teacherId = sta2.userid
WHERE a1.departed = '0'
AND a2.clazzType = '0') sta3
GROUP BY sta3.schoolId,sta3.gradeid

UNION ALL
SELECT sta4.schoolId,0 gradeid,0 classid,'teacher' classname,1 split_id,
SUM(sta4.is_alive) day_tea_num,
count(DISTINCT sta4.userid) tea_num,0 day_stu_num,0 stu_num
FROM 
(SELECT DISTINCT a1.schoolId,a1.teacherId userid,
sta2.is_alive
FROM xh_webmanage.XHSchool_ClazzTeachers a1
LEFT JOIN
(SELECT DISTINCT a4.userid,1 AS is_alive
FROM xh_elasticsearch.user_alive_day a4
WHERE a4.datetime = adddate(date(sysdate()) ,- 1)
) sta2 ON a1.teacherId = sta2.userid
WHERE a1.departed = '0') sta4
GROUP BY sta4.schoolId ) altab1
LEFT JOIN 
(SELECT a9.iSchoolId,a9.sSchoolName
FROM xh_webmanage.XHSchool_Info a9) altab2 
ON altab1.schoolId = altab2.iSchoolId
