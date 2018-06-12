select 
`b`.`studentId` `student_id`,
`b`.`classId` `class_id`,
`b`.`subjectId` `subject_id`,
size(split(regexp_replace(regexp_extract(`b`.`questionlist`,'^\\[(.+)\\]$',1),'\\}\\,\\{', '\\}\\|\\|\\{'),'\\|\\|')) as qst_num,
`b`.`bookId` `book_id`,
`c`.`createTime`,
`a`.`src_file_day`
from `ods`.`king_0000_game_info_ex` `a` 
lateral view json_tuple(`a`.`json`, 'studentId','subjectId', 'questionList','classId','createTime','bookId') `b` as `studentId`,`subjectId`,`questionList`,`classId`,`createTime`,`bookId`
lateral view json_tuple(`b`.`createTime`,'$numberLong') `c` as `createTime`
where src_file_day = from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
order by `c`.`createTime` desc 


select 
`b`.`studentid` `student_id`,
`b`.`classid` `class_id`,
`b`.`subjectid` `subject_id`,
`d`.`questionid` `qst_id`,
`d`.`right` `is_done_flag`,
`d`.`bookid` `book_id`
from `ods`.`king_0000_game_info_ex` `a` 
lateral view json_tuple(`a`.`json`, 'studentId','subjectId', 'questionList','classId','createTime') `b` as `studentId`,`subjectId`,`questionList`,`classId`,`createTime`
lateral view json_tuple(`b`.`createtime`,'$numberLong') `c` as `createTime`
lateral view explode(split(regexp_replace(regexp_extract(`b`.`questionlist`,'^\\[(.+)\\]$',1),'\\}\\,\\{', '\\}\\|\\|\\{'),'\\|\\|')) `ss` as `col` 
lateral view json_tuple(`ss`.`col`,'questionId','right','bookId') `d` as `questionId`,`right`,`bookId`


select transform(m, p, consume, cnt) using 'python xxx.py' as (mid, pid, trans_at, total_cnt) from xxx_table;  

select 
transform(`b`.`questionList`) using 'python resultQst.py' as(qst_result)
from `ods`.`king_0000_game_info_ex` `a` 
lateral view json_tuple(`a`.`json`, 'questionList') `b` as `questionList`
where src_file_day = '20180611'

select 
size(explode(c.qst_real))
from `ods`.`king_0000_game_info_ex` `a` 
lateral view json_tuple(`a`.`json`, 'questionList') `b` as `questionList`
lateral view explode(transform(`b`.`questionList`) using 'python qstReal.py' as (`qst_real`)) `c` as `qst_real`
where src_file_day = '20180611'

select 
`b`.`questionList`
from `ods`.`king_0000_game_info_ex` `a` 
lateral view json_tuple(`a`.`json`, 'questionList') `b` as `questionList`
where src_file_day = '20180611'


select 
*--transform (a.json) using 'python qstReal.py' as (id,ad,bd,cd,dd,fd,ed,gd)
from `ods`.`king_0000_game_info_ex` `a` 
where src_file_day = '20180611'
