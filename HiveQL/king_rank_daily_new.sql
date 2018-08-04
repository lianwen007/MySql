-- Hive Create Table
DROP TABLE IF EXISTS rptdata.fact_king_rank_daily;
CREATE TABLE rptdata.fact_king_rank_daily(
  id bigint,
  school_id bigint,
  book_id string,
  subject_id bigint,
  class_id bigint,
  class_name string,
  class_type bigint,
  student_id bigint,
  student_name string,
  intgral int,
  word_count int,
  qst_count int,
  qst_right int,
  qst_right_rate string,
  is_weekly string
  )  
PARTITIONED BY (date_time string)  
STORED AS PARQUET;

-- MYSQL Create Table
CREATE TABLE `king_rank_daily` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `school_id` bigint(20) DEFAULT NULL COMMENT '学校标识',
  `book_id` varchar(30) DEFAULT NULL COMMENT '书本标识',
  `subject_id` bigint(20) DEFAULT NULL COMMENT '科目标识',
  `class_id` bigint(20) DEFAULT NULL COMMENT '班级标识',
  `class_name` varchar(100) DEFAULT NULL COMMENT '班级名称',
  `class_type` bigint(20) DEFAULT NULL COMMENT '培优班(0:否,1:是)',
  `student_id` bigint(20) DEFAULT NULL COMMENT '学生标识',
  `student_name` varchar(100) DEFAULT NULL COMMENT '学生名称',
  `intgral` int(10) DEFAULT NULL COMMENT '积分',
  `word_count` int(10) DEFAULT NULL COMMENT '单词量',
  `qst_count` int(10) DEFAULT NULL COMMENT '做题量',
  `qst_right` int(10) DEFAULT NULL COMMENT '正确题量',
  `qst_right_rate` varchar(10) DEFAULT NULL COMMENT '正确率',
  `is_weekly` varchar(1) NOT NULL COMMENT '周标识(1:历史所有,2:上周,3:本周,4:上上周)',
  `date_time` varchar(8) NOT NULL COMMENT '统计日期',
  KEY `index_school_id_only` (`school_id`),
  KEY `index_book_id_only` (`book_id`),  
  KEY `index_class_id_only` (`class_id`),
  KEY `index_student_id_only` (`student_id`),
  KEY `index_is_weekly_only` (`is_weekly`),
  KEY `index_date_time_only` (`date_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

sqoop export --connect 'jdbc:mysql://172.16.30.54:3306/xh_xueqing?useUnicode=true&characterEncoding=utf-8' --username bigdatauser --password Bigdata@321 --table king_rank_daily --hcatalog-database rptdata --hcatalog-table fact_king_rank_daily --hive-partition-key date_time --hive-partition-value `date +%Y%m%d`;

SET hive.exec.dynamic.partition.mode=nonstrict; 
insert overwrite table rptdata.fact_king_rank_daily partition(date_time)
SELECT row_number() over() as row_id,
st3.school_id,st0.book_id,st0.subject_id,st3.class_id,st3.class_name,st3.class_type,
st0.student_id,st3.student_name,st0.integral,st0.word_num word_count,st0.qst_num,st0.qst_right,
st0.qst_right_rate,st0.is_weekly,
from_unixtime(unix_timestamp(),'yyyyMMdd') date_time
FROM(
-- onweek records
SELECT
sta1.book_id,sta1.subject_id,
sta1.student_id,sta1.integral,sta1.qst_num,INT(sta1.qst_right/100) AS qst_right,
INT(sta1.qst_right*10/sta1.qst_num)/10 AS qst_right_rate, 3 AS is_weekly
FROM(
SELECT a1.student_id,
a1.book_id,a2.subject_id,a2.book_type,
  SUM(a1.integral) integral,SUM(a1.word_count) word_num,
CASE WHEN a2.book_type IN (1,3,4) THEN  SUM(a1.qst_count)
    WHEN a2.book_type IN (2,5) THEN COUNT(a1.game_id)
    END AS qst_num,
CASE WHEN a2.book_type IN (1,3,4) THEN SUM(question_right)*100
    WHEN a2.book_type IN (2,5) THEN SUM(accuracy)
    ELSE 0 
    END AS qst_right
FROM rptdata.fact_king_game_detail a1 
JOIN rptdata.fact_king_book_library_detail a2 ON a1.book_id = a2.book_id
WHERE a1.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a2.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a1.create_time>=(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-1)*86400*7))*1000
AND a1.create_time<(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-0)*86400*7))*1000
GROUP BY a1.student_id,a1.book_id,a2.subject_id,a2.book_type
) sta1

UNION ALL
-- last week records
SELECT
sta1.book_id,sta1.subject_id,
sta1.student_id,sta1.integral,sta1.qst_num,INT(sta1.qst_right/100) AS qst_right,
INT(sta1.qst_right*10/sta1.qst_num)/10 AS qst_right_rate, 2 AS is_weekly
FROM(
SELECT a1.student_id,
a1.book_id,a2.subject_id,a2.book_type,
  SUM(a1.integral) integral,SUM(a1.word_count) word_num,
CASE WHEN a2.book_type IN (1,3,4) THEN  SUM(a1.qst_count)
    WHEN a2.book_type IN (2,5) THEN COUNT(a1.game_id)
    END AS qst_num,
CASE WHEN a2.book_type IN (1,3,4) THEN SUM(question_right)*100
    WHEN a2.book_type IN (2,5) THEN SUM(accuracy)
    ELSE 0 
    END AS qst_right
FROM rptdata.fact_king_game_detail a1 
JOIN rptdata.fact_king_book_library_detail a2 ON a1.book_id = a2.book_id
WHERE a1.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a2.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a1.create_time>=(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-2)*86400*7))*1000
AND a1.create_time<(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-1)*86400*7))*1000
GROUP BY a1.student_id,a1.book_id,a2.subject_id,a2.book_type
) sta1

UNION ALL 
-- before last week records
SELECT 
sta1.book_id,sta1.subject_id,
sta1.student_id,sta1.integral,sta1.qst_num,INT(sta1.qst_right/100) AS qst_right,
INT(sta1.qst_right*10/sta1.qst_num)/10 AS qst_right_rate, 4 AS is_weekly
FROM(
SELECT a1.student_id,
a1.book_id,a2.subject_id,a2.book_type,
  SUM(a1.integral) integral,SUM(a1.word_count) word_num,
CASE WHEN a2.book_type IN (1,3,4) THEN  SUM(a1.qst_count)
    WHEN a2.book_type IN (2,5) THEN COUNT(a1.game_id)
    END AS qst_num,
CASE WHEN a2.book_type IN (1,3,4) THEN SUM(question_right)*100
    WHEN a2.book_type IN (2,5) THEN SUM(accuracy)
    ELSE 0 
    END AS qst_right
FROM rptdata.fact_king_game_detail a1 
JOIN rptdata.fact_king_book_library_detail a2 ON a1.book_id = a2.book_id
WHERE a1.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a2.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a1.create_time>=(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-3)*86400*7))*1000
AND a1.create_time<(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-2)*86400*7))*1000
GROUP BY a1.student_id,a1.book_id,a2.subject_id,a2.book_type
) sta1

UNION ALL 
-- historic records
SELECT 
sta1.book_id,sta1.subject_id,
sta1.student_id,sta1.integral,sta1.qst_num,INT(sta1.qst_right/100) AS qst_right,
INT(sta1.qst_right*10/sta1.qst_num)/10 AS qst_right_rate, 1 AS is_weekly
FROM(
SELECT a1.student_id,
a1.book_id,a2.subject_id,a2.book_type,
  SUM(a1.integral) integral,SUM(a1.word_count) word_num,   
CASE WHEN a2.book_type IN (1,3,4) THEN  SUM(a1.qst_count)
    WHEN a2.book_type IN (2,5) THEN COUNT(a1.game_id)
    END AS qst_num,
CASE WHEN a2.book_type IN (1,3,4) THEN SUM(question_right)*100
    WHEN a2.book_type IN (2,5) THEN SUM(accuracy)
    ELSE 0 
    END AS qst_right
FROM rptdata.fact_king_game_detail a1 
JOIN rptdata.fact_king_book_library_detail a2 ON a1.book_id = a2.book_id
WHERE a1.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a2.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
GROUP BY a1.student_id,a1.book_id,a2.subject_id,a2.book_type
) sta1
)st0
LEFT JOIN (
SELECT DISTINCT ta3.userid AS student_id,
ta3.username AS student_name,
ta3.groupid AS class_id,
ta4.`name` AS class_name,
ta4.clazztype AS class_type,
ta3.schoolid AS school_id
FROM rptdata.xhschool_clazzmembers ta3
JOIN rptdata.xhschool_clazzes ta4
ON ta3.groupid = ta4.id 
AND ta3.departed = 0
) st3 
ON st0.student_id = st3.student_id;
