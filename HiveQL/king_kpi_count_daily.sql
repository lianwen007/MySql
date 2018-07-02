-- MYSQL CREATE TABLE
CREATE TABLE `king_kpi_count_daily` (
  `teacher_id` bigint(20) DEFAULT NULL,
  `teacher_name` varchar(20) DEFAULT NULL,
  `class_id` bigint(20) DEFAULT NULL,
  `class_name` varchar(20) DEFAULT NULL,
  `student_num` int(11) DEFAULT NULL,
  `school_id` bigint(20) DEFAULT NULL,
  `school_name` varchar(50) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `self_prac_times` int(11) DEFAULT NULL,
  `task_times` int(11) DEFAULT NULL,
  `task_num` int(11) DEFAULT NULL,
  `upload_num` int(11) DEFAULT NULL,
  `date_time` int(20) DEFAULT NULL,
  `src_file_day` int(20) DEFAULT NULL,
  KEY `index_school_id` (`school_id`) USING BTREE,
  KEY `index_class_id` (`class_id`) USING BTREE,
  KEY `index_subject_id` (`subject_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- HIVE CREATE TABLE
CREATE TABLE rptdata.fact_king_kpi_count_daily(
teacher_id            bigint,
teacher_name          string,
class_id              int,
class_name            string,
student_num           bigint,
school_id             bigint,
school_name           string,
subject_id            int,
self_prac_times       int,
task_times            int,
task_num              int,
upload_num            int,
date_time             bigint)
PARTITIONED BY (src_file_day string)  
STORED AS PARQUET;

sqoop export --connect 'jdbc:mysql://172.16.10.26:3306/xh_elasticsearch?useUnicode=true&characterEncoding=utf-8' --username xhelas --password Ma0Zy6P0 --table king_kpi_count_daily --hcatalog-database rptdata --hcatalog-table fact_king_kpi_count_daily --hive-partition-key src_file_day --hive-partition-value 20180702


SET hive.exec.dynamic.partition.mode=nonstrict; 
INSERT OVERWRITE TABLE rptdata.fact_king_kpi_count_daily partition(src_file_day)
SELECT tab1.teacher_id,tab3.teachername,
tab1.class_id,tab3.classname,
tab3.studentnum,tab3.schoolid,
tab3.schoolname,tab1.subject_id,
SUM(tab1.ziliancishu)AS self_times,
SUM(tab1.buzhicishu)AS task_times,
SUM(tab1.buzhifenshu)AS task_num,
SUM(tab1.shangjiaofenshu)AS upload_num,
tab1.date_time,
FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*0,'yyyyMMdd') AS src_file_day
FROM
(
SELECT sta2.teacher_id,sta2.class_id,sta2.subject_id,0 AS ziliancishu,
sta2.buzhicishu,sta2.shangjiaofenshu,sta2.buzhifenshu,sta2.date_time
FROM 
(
SELECT st1.teacher_id,st1.class_id,st1.subject_id,
FROM_UNIXTIME(int(st1.create_time/1000),'yyyyMMdd') AS date_time,
COUNT(DISTINCT st1.homework_id) AS buzhicishu,
INT(SUM(st1.is_finish))AS shangjiaofenshu, COUNT(st1.is_finish)AS buzhifenshu
FROM(
SELECT a1.student_id,a1.create_time,a1.homework_id,a1.teacher_id,
  a1.is_finish,a1.book_id,a2.class_id,a3.subject_id
FROM 
 rptdata.fact_king_homework_detail a1 
LEFT JOIN 
 rptdata.fact_king_student_detail a2 
 ON a2.student_id=a1.student_id
LEFT JOIN 
 rptdata.fact_king_book_library_detail a3 
 ON a3.book_id=a1.book_id
WHERE a1.src_file_day = FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*1,'yyyyMMdd')
 AND a2.src_file_day = FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*1,'yyyyMMdd')
 AND a3.src_file_day = FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*1,'yyyyMMdd')
)AS st1
--WHERE st1.class_id IS NOT NULL
GROUP BY st1.teacher_id,st1.class_id,st1.subject_id,
FROM_UNIXTIME(int(st1.create_time/1000),'yyyyMMdd')
)sta2
UNION ALL
SELECT sta3.teacherid teacher_id,sta4.class_id,sta4.subject_id,sta4.ziliancishu,
0 AS buzhicishu,0 AS shangjiaofenshu,0 AS buzhifenshu,sta4.date_time
FROM 
(
SELECT sta1.class_id,sta1.subject_id,
FROM_UNIXTIME(INT(sta1.create_time/1000),'yyyyMMdd') AS date_time,
COUNT(DISTINCT sta1.game_id) AS ziliancishu
FROM(
SELECT a4.student_id,a4.create_time,a4.game_id,
a4.book_id,a2.class_id,a3.subject_id
FROM rptdata.fact_king_game_detail a4
LEFT JOIN 
 rptdata.fact_king_student_detail a2 
 ON a2.student_id=a4.student_id
LEFT JOIN 
rptdata.fact_king_book_library_detail a3
ON a3.book_id=a4.book_id
WHERE a4.ishome_work=1
AND a4.src_file_day = FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*1,'yyyyMMdd')
 AND a2.src_file_day = FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*1,'yyyyMMdd')
 AND a3.src_file_day = FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*1,'yyyyMMdd')
)AS sta1
--WHERE sta1.class_id IS NOT NULL
GROUP BY sta1.class_id,sta1.subject_id,
FROM_UNIXTIME(INT(sta1.create_time/1000),'yyyyMMdd')
)sta4
LEFT JOIN rptdata.fact_teacher_info_stunum sta3 
ON sta3.classid=sta4.class_id
WHERE sta3.datetime = FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*1,'yyyyMMdd')
) tab1
LEFT JOIN rptdata.fact_teacher_info_stunum tab3 
ON tab1.class_id=tab3.classid AND tab1.teacher_id=tab3.teacherid
GROUP BY tab1.teacher_id,tab3.teachername,tab1.class_id,tab3.classname,tab3.schoolid,
tab3.schoolname,tab1.subject_id, tab1.date_time,tab3.studentnum;
