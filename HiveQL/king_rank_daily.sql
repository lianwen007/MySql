CREATE TABLE rptdata.fact_king_rank_daily(
  id string,
  school_id string,
  book_id string,
  subject_id string,
  class_id string,
  class_name string,
  student_id string,
  student_name string,
  intgral string,
  qst_count string,
  qst_right string,
  qst_right_tate string,
  class_rank string,
  class_compare string,
  school_rank string,
  school_compare string,
  is_weekly string
  )  
PARTITIONED BY (date_time string)  
STORED AS PARQUET;
  
  
SET hive.exec.dynamic.partition.mode=nonstrict; 
insert overwrite table rptdata.fact_king_rank_daily partition(date_time)
SELECT row_number() over() as row_id,st0.*
FROM(
-- onweek records
SELECT -- row_number() over() as row_id,
stab1.school_id,stab1.book_id,stab1.subject_id,stab1.class_id,stab1.class_name,
stab1.student_id,stab1.student_name,stab1.integral,stab1.qst_num,0 qst_right,0 qst_right_rate,
stab1.class_rank,int(stab1.class_rank - NVL(stab2.class_rank,stab1.class_rank)) class_compare,
stab1.school_rank,int(stab1.school_rank - NVL(stab2.school_rank,stab1.school_rank)) school_compare,
1 is_weekly,stab1.date_time
FROM 
(SELECT 
sta1.school_id,sta1.book_id,sta1.subject_id,sta1.class_id,sta1.class_name,
sta1.student_id,sta1.student_name,sta1.integral,sta1.qst_num,0 qst_right,0 qst_right_rate,
row_number() over(partition by sta1.class_id,sta1.book_id 
order by sta1.integral desc) class_rank,
row_number() over(partition by sta1.school_id,sta1.book_id 
order by sta1.integral desc) school_rank,
from_unixtime(unix_timestamp(),'yyyyMMdd') date_time
FROM(
SELECT a1.student_id,a3.student_name,a1.class_id,a3.class_name,a3.school_id,
a1.book_id,a2.subject_id,a2.book_type,
  SUM(a1.integral) integral,   
CASE WHEN a2.book_type IN (1,3) THEN COUNT(a1.game_id)*10
    WHEN a2.book_type IN (2,5) THEN COUNT(a1.game_id)
    END AS qst_num
FROM rptdata.fact_king_game_detail a1 
JOIN rptdata.fact_king_book_library_detail a2 ON a1.book_id = a2.book_id
LEFT JOIN (
SELECT DISTINCT ta3.student_id,ta3.student_name,
ta3.class_name,ta3.school_id
FROM rptdata.fact_king_student_detail ta3
) a3 
ON a1.student_id = a3.student_id
WHERE a1.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a2.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a1.create_time>=(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-1)*86400*7))*1000
AND a1.create_time<(unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-0)*86400*7))*1000
GROUP BY a1.student_id,a3.student_name,a1.class_id,a3.class_name,a3.school_id,
a1.book_id,a2.subject_id,a2.book_type
  ) sta1
)stab1
LEFT JOIN 
(SELECT 
a5.student_id,a5.book_id,a5.class_rank,a5.school_rank
FROM
  rptdata.fact_king_rank_last_week a5
WHERE a5.date_time = FROM_UNIXTIME((unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+
          ((weekofyear(from_unixtime(unix_timestamp(),'yyyy-MM-dd'))-1)*86400*7)),'yyyyMMdd')
)stab2
ON stab1.student_id = stab2.student_id AND stab1.book_id = stab2.book_id

UNION ALL 
-- historic records
SELECT -- row_number() over() as row_id,
stab1.school_id,stab1.book_id,stab1.subject_id,stab1.class_id,stab1.class_name,
stab1.student_id,stab1.student_name,stab1.integral,stab1.qst_num,0 qst_right,0 qst_right_rate,
stab1.class_rank,0 class_compare,
stab1.school_rank,0 school_compare,
0 is_weekly,stab1.date_time
FROM 
(SELECT 
sta1.school_id,sta1.book_id,sta1.subject_id,sta1.class_id,sta1.class_name,
sta1.student_id,sta1.student_name,sta1.integral,sta1.qst_num,0 qst_right,0 qst_right_rate,
row_number() over(partition by sta1.class_id,sta1.book_id 
order by sta1.integral desc) class_rank,
row_number() over(partition by sta1.school_id,sta1.book_id 
order by sta1.integral desc) school_rank, 
from_unixtime(unix_timestamp(),'yyyyMMdd') date_time
FROM(
SELECT a1.student_id,a3.student_name,a1.class_id,a3.class_name,a3.school_id,
a1.book_id,a2.subject_id,a2.book_type,
  SUM(a1.integral) integral,   
CASE WHEN a2.book_type IN (1,3) THEN COUNT(a1.game_id)*10
    WHEN a2.book_type IN (2,5) THEN COUNT(a1.game_id)
    END AS qst_num
FROM rptdata.fact_king_game_detail a1 
JOIN rptdata.fact_king_book_library_detail a2 ON a1.book_id = a2.book_id
LEFT JOIN (
SELECT DISTINCT ta3.student_id,ta3.student_name,
ta3.class_name,ta3.school_id
FROM rptdata.fact_king_student_detail ta3
) a3 
ON a1.student_id = a3.student_id
WHERE a1.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
AND a2.src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
GROUP BY a1.student_id,a3.student_name,a1.class_id,a3.class_name,a3.school_id,
a1.book_id,a2.subject_id,a2.book_type
  ) sta1
)stab1
)st0;
