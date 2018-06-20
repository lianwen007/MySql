CREATE TABLE `fact_king_english_count_daily`(
  `student_id` bigint, 
  `student_name` string, 
  `school_id` bigint, 
  `class_id` int, 
  `class_name` string, 
  `task_count` int, 
  `finish_count` int, 
  `home_full` int, 
  `self_count` int, 
  `self_full` int, 
  `listen_full` int, 
  `read_full` int, 
  `blank_full` int, 
  `listen_rate` int, 
  `read_rate` int, 
  `blank_rate` int, 
  `listen_num` int, 
  `read_num` int, 
  `blank_num` int, 
  `rate_avg` float, 
  `date_time` string)
PARTITIONED BY (src_file_day string)  
STORED AS PARQUET;


SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE rptdata.fact_king_english_count_daily partition(src_file_day)
SELECT stab1.student_id,s2.student_name,s2.school_id,s2.class_id,s2.class_name,
NVL(stab2.totalcount,0)AS task_count,
NVL(stab2.fincount,0)AS finish_count,
SUM(NVL(stab1.homewkfull,0))AS homefull,
SUM(NVL(stab1.selfnum,0))AS selfcount,
SUM(NVL(stab1.fullself,0))AS selffull,
SUM(NVL(stab1.listenfull,0))AS listenfull,
SUM(NVL(stab1.readfull,0))AS readfull,
SUM(NVL(stab1.blankfull,0))AS blankfull,
NVL(AVG(stab1.listenrate),0)AS ratelisten,
NVL(AVG(stab1.readrate),0)AS rateread,
NVL(AVG(stab1.blankrate),0)AS rateblank,
SUM(NVL(stab1.listennum,0))AS numlisten,
SUM(NVL(stab1.readnum,0))AS numread,
SUM(NVL(stab1.blanknum,0))AS numblank,
AVG(NVL(stab1.avgrate,0))AS rateavg,
stab1.date_time,
from_unixtime(unix_timestamp(),'yyyyMMdd') AS src_file_day
FROM(
SELECT sta7.student_id,sta7.date_time,sta7.question_type,sta7.ishome_work,
sta7.game_count,
sta7.finish_count,
INT(AVG(sta7.accuracy)) AS avgrate,
CASE WHEN sta7.ishome_work = '1' THEN 
COUNT(sta7.ishome_work) END AS selfnum,
CASE WHEN sta7.ishome_work = '0' THEN 
SUM(IF(sta7.accuracy = '100',1,0)) END AS homewkfull,
CASE WHEN sta7.ishome_work = '1' THEN 
SUM(IF(sta7.accuracy = '100',1,0)) END AS fullself,
CASE WHEN sta7.question_type = '9' THEN
INT(AVG(sta7.accuracy)) END AS listenrate,
CASE WHEN sta7.question_type = '7' THEN
INT(AVG(sta7.accuracy)) END AS readrate,
CASE WHEN sta7.question_type IN('701','401') THEN
INT(AVG(sta7.accuracy)) END AS blankrate,
CASE WHEN sta7.question_type = '9' THEN
SUM(IF(sta7.accuracy='100',1,0)) END AS listenfull,
CASE WHEN sta7.question_type = '7' THEN
SUM(IF(sta7.accuracy='100',1,0)) END AS readfull,
CASE WHEN sta7.question_type IN('701','401') THEN
SUM(IF(sta7.accuracy='100',1,0)) END AS blankfull,
CASE WHEN sta7.question_type = '9' THEN
COUNT(sta7.ishome_work) END AS listennum,
CASE WHEN sta7.question_type = '7' THEN
COUNT(sta7.ishome_work) END AS readnum,
CASE WHEN sta7.question_type IN('701','401') THEN
COUNT(sta7.ishome_work) END AS blanknum
FROM(
SELECT a7.student_id,a7.accuracy,a7.ishome_work,a7.question_type,
a9.subject_id,a8.game_count,a8.finish_count,
FROM_UNIXTIME(INT(a8.create_time/1000),'yyyy-MM-dd') AS date_time
FROM rptdata.fact_king_game_detail a7 
JOIN rptdata.fact_king_book_library_detail a9
ON a7.book_id = a9.book_id
LEFT JOIN 
  rptdata.fact_king_homework_detail a8
  ON a7.homework_id = a8.id
WHERE a7.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a9.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a8.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a9.subject_id = '3'
) sta7
GROUP BY sta7.student_id,sta7.date_time,sta7.question_type,sta7.ishome_work,
sta7.game_count,
sta7.finish_count
) stab1
LEFT JOIN
(SELECT DISTINCT sa2.student_id,sa2.student_name,sa2.school_id,sa2.class_id,sa2.class_name
FROM rptdata.fact_king_student_detail sa2 
WHERE sa2.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
)s2 ON stab1.student_id=s2.student_id
LEFT JOIN
(
SELECT a4.student_id,SUM(a4.game_count)AS totalcount,
SUM(a4.finish_count)AS fincount,
FROM_UNIXTIME(int(a4.create_time/1000),'yyyy-MM-dd') AS date_time
FROM rptdata.fact_king_homework_detail a4 
JOIN rptdata.fact_king_book_library_detail a3
ON a3.book_id = a4.book_id 
WHERE 
  a3.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a4.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a3.subject_id = '3'
GROUP BY a4.student_id,FROM_UNIXTIME(int(a4.create_time/1000),'yyyy-MM-dd')
) stab2 
ON stab1.student_id = stab2.student_id and stab1.date_time = stab2.date_time
GROUP BY stab1.student_id,s2.student_name,NVL(stab2.fincount,0),
s2.school_id,s2.class_id,NVL(stab2.totalcount,0),
s2.class_name,stab1.date_time;
