DROP TABLE IF EXISTS rptdata.fact_king_game_detail;
CREATE TABLE rptdata.fact_king_game_detail(
  game_id string,
  student_id string,
  book_id string,
  integral string,
  new_integral string,
  accuracy string,
  fail_count string,
  question_right string,
  question_type string,
  judge_count string,
  class_id string,
  isHome_work string,
  homework_id string,
  subject_id string,
  time_consuming string,
  word_count string,
  qst_count string,
  create_time string
  )  
PARTITIONED BY (src_file_day string)  
STORED AS PARQUET;


SET hive.exec.dynamic.partition.mode=nonstrict; 
insert overwrite table rptdata.fact_king_game_detail partition(src_file_day)
select 
`b`.*,
size(func.json_array(b1.questionList)),
`c`.`createTime`,
from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd') as src_file_day
from `ods`.`king_0000_game_info_ex` `a` 
lateral view json_tuple(`a`.`json`,'_id','studentId','bookId','integral','newIntegral','accuracy','failCount','questionRight',
'questionType','penddingLevelIntegral','classId','isHomeWork','homeWorkId','subjectId','timeConsuming','wordsMasterCount') `b` 
as `_id`,`studentId`,`bookId`,`integral`,`newIntegral`,`accuracy`,`failCount`,`questionRight`,
`questionType`,`judgeCount`,`classId`,`isHomeWork`,`homeWorkId`,`subjectId`,`timeConsuming`,`wordsMasterCount`
lateral view json_tuple(`a`.`json`,'createTime','questionList') b1 as createTime,`questionList`
lateral view json_tuple(`b1`.`createTime`,'$numberLong') `c` as `createTime`
where src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd');
