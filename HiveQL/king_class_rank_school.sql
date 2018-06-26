-- Hive table
CREATE TABLE rptdata.fact_king_class_rank_school(
  id bigint,
  school_id bigint,
  book_id string,
  subject_id bigint,
  class_id bigint,
  class_name string,
  intgral int,
  qst_count int,
  qst_right_rate string
  )  
PARTITIONED BY (date_time string)  
STORED AS PARQUET;

-- MYSQL Table
CREATE TABLE `king_class_rank_school` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `school_id` bigint(20) NOT NULL COMMENT '学校标识',
  `book_id` varchar(30) NOT NULL COMMENT '书本标识',
  `subject_id` bigint(10) NOT NULL COMMENT '科目标识',
  `class_id` bigint(10) NOT NULL COMMENT '班级标识',
  `class_name` varchar(100) NOT NULL COMMENT '班级名称',
  `intgral` int(10) NOT NULL DEFAULT '0' COMMENT '积分',
  `qst_count` int(10) NOT NULL DEFAULT '0' COMMENT '做题量',
  `qst_right_rate` varchar(10) NOT NULL DEFAULT '0.00' COMMENT '正确率',
  `date_time` varchar(8) NOT NULL COMMENT '统计日期',
  PRIMARY KEY (`id`),
  KEY `index_school_id` (`school_id`),
  KEY `index_book_id` (`book_id`),
  KEY `index_class_id` (`class_id`),
  KEY `index_date_time` (`date_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


SET hive.exec.dynamic.partition.mode=nonstrict; 
insert overwrite table rptdata.fact_king_class_rank_school partition(date_time)
SELECT
row_number() over() as row_id, sta1.* 
FROM( SELECT 
a1.school_id,
a1.book_id,
a2.subject_id,
a1.class_id,
a1.class_name,
AVG(a1.intgral)AS intgral,
AVG(a1.qst_count)AS qst_count,
AVG(a1.qst_right_rate)AS qst_right_rate,
a1.date_time
FROM rptdata.fact_king_rank_daily a1
LEFT JOIN rptdata.fact_king_book_library_detail a2
ON a1.book_id = a2.book_id 
WHERE a1.is_weekly = '1'
AND a1.date_time = from_unixtime(unix_timestamp(),'yyyyMMdd')
GROUP BY 
a1.school_id,
a1.book_id,
a2.subject_id,
a1.class_id,
a1.class_name,
a1.date_time
)sta1;