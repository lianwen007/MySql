-- MYSQL CREATE TABLE
CREATE TABLE `king_common_count_daily` (
  `student_id` bigint(20) DEFAULT NULL,
  `student_name` varchar(10) DEFAULT NULL,
  `school_id` bigint(20) DEFAULT NULL,
  `school_name` varchar(50) DEFAULT NULL,
  `class_id` bigint(20) DEFAULT NULL,
  `class_name` varchar(30) DEFAULT NULL,
  `book_id` varchar(30) DEFAULT NULL,
  `book_name` varchar(50) DEFAULT NULL,
  `subject_id` int(20) DEFAULT NULL,
  `hp` int(20) DEFAULT NULL,
  `credit` int(20) DEFAULT NULL,
  `total_integral` int(20) DEFAULT NULL,
  `game_integral` int(20) DEFAULT NULL,
  `homework_num` int(20) DEFAULT NULL,
  `self_work_num` int(20) DEFAULT NULL,
  `old_topic_num` int(20) DEFAULT NULL,
  `topic_num` int(20) DEFAULT NULL,
  `qst_right_num` int(20) DEFAULT NULL,
  `qst_right_rate` float DEFAULT NULL,
  `time_cost` int(20) DEFAULT NULL,
  `date_time` varchar(10) DEFAULT NULL,
  `src_file_day` varchar(10) DEFAULT NULL,
  KEY `index_school_id` (`school_id`) USING BTREE,
  KEY `index_class_id` (`class_id`) USING BTREE,
  KEY `index_book_id` (`book_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- HIVE CREATE TABLE
CREATE TABLE rptdata.final_king_common_count_daily(
  student_id bigint,
  student_name string,
  school_id bigint,
  school_name string,
  class_id bigint,
  class_name string,
  book_id string,
  book_name string,
  subject_id int,
  hp int,
  credit int,
  total_integral int,
  game_integral int,
  homework_num int,
  self_work_num int,
  old_topic_num int,
  topic_num int,
  qst_right_num int,
  qst_right_rate float,
  time_cost int,
  date_time string)
PARTITIONED BY (src_file_day string)  
STORED AS PARQUET;

sqoop export --connect 'jdbc:mysql://172.16.10.26:3306/xh_elasticsearch?useUnicode=true&characterEncoding=utf-8' --username xhelas --password Ma0Zy6P0 --table king_common_count_daily --hcatalog-database rptdata --hcatalog-table final_king_common_count_daily --hive-partition-key src_file_day --hive-partition-value 20180703


SET hive.exec.dynamic.partition.mode=nonstrict; 
INSERT OVERWRITE TABLE rptdata.final_king_common_count_daily partition(src_file_day)
SELECT
sta1.student_id,
sta3.student_name,
sta3.school_id,
sta3.school_name,
sta3.class_id,
sta3.class_name,
sta1.book_id,
sta1.book_name,
sta1.subject_id,
sta3.hp,
sta3.credit,
sta2.total_integral,
sta1.game_integral,
sta1.sumhomework,
sta1.sumselfwork,
sta1.old_numtopic,
sta1.numtopic,
sta1.sumright,
CASE WHEN sta1.book_type in(1,3) THEN sta1.sumright/sta1.numtopic
WHEN sta1.book_type in(2,5) THEN sta1.engrightrate END AS rightlv,
sta1.sumtime,
sta1.date_time,
from_unixtime(unix_timestamp(),'yyyyMMdd') src_file_day
FROM
(SELECT
a3.student_id,
a3.book_id,
a3.book_name,
a3.sub_id AS subject_id,
FROM_UNIXTIME(int(a3.create_time/1000),'yyyyMMdd') AS date_time,
SUM(a3.integral) AS game_integral,
SUM(IF(a3.ishome_work = 0,1,0)) AS sumhomework,
SUM(IF(a3.ishome_work != 0,1,0)) AS sumselfwork,
CASE WHEN a3.book_type in(2,5) THEN COUNT(a3.ishome_work)*1
 WHEN a3.book_type in(1,3) THEN SUM(a3.qst_count)
 END AS old_numtopic,
CASE WHEN a3.book_type in(2,5) THEN COUNT(a3.ishome_work)*1
 WHEN a3.book_type in(1,3) THEN SUM(a3.qst_count) - SUM(IF(a3.judge_count>0,IF(a3.judge_count>10,10,a3.judge_count),0))
 END AS numtopic,
CASE WHEN a3.book_type in(2,5) THEN SUM(a3.fail_count)
 WHEN a3.book_type in(1,3) THEN SUM(a3.question_right)
 END AS sumright,
SUM(a3.accuracy)AS engrightrate,
SUM(a3.time_consuming) AS sumtime,
a3.book_type
FROM(
SELECT a33.*,
a44.book_name,a44.book_type,a44.subject_id sub_id
FROM
rptdata.fact_king_game_detail a33 
LEFT JOIN rptdata.fact_king_book_library_detail a44 ON a33.book_id=a44.book_id
WHERE a33.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,+'yyyyMMdd')
AND a44.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
)AS a3
GROUP BY
a3.student_id,
a3.book_id,
a3.sub_id,
a3.book_name,
FROM_UNIXTIME(int(a3.create_time/1000),'yyyyMMdd'),a3.book_type
) sta1 
LEFT JOIN (
SELECT a6.student_id,a6.book_id,
 SUM(a6.integral) AS total_integral
FROM rptdata.fact_king_game_detail a6
WHERE a6.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
GROUP BY a6.student_id,a6.book_id
)sta2 ON sta1.student_id = sta2.student_id AND sta1.book_id=sta2.book_id
LEFT JOIN (
SELECT a7.student_id,a7.student_name,a7.hp,a7.credit,
  a7.school_id,a7.school_name,a7.class_id,a7.class_name
FROM rptdata.fact_king_student_detail a7 
WHERE a7.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
) sta3 ON sta1.student_id = sta3.student_id;

