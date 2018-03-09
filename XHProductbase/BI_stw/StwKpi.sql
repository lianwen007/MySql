SELECT a3.teacherid,a3.teachername,a3.classid,a3.classname,a3.schoolid,a3.studentnum,
CASE WHEN stab1.subjectid='1' THEN '语文'
WHEN stab1.subjectid='2' THEN '数学'
WHEN stab1.subjectid='3' THEN '英语'
WHEN stab1.subjectid='4' THEN '科学'
END AS subname,
NVL(stab1.zilnum,0),stab1.counthw,stab1.countgame,stab1.finrate,stab1.taskrate,stab1.datetime
FROM xh_elasticsearch.teacher_info_stunum a3
LEFT JOIN
(SELECT sta1.teacherid,sta1.subjectid,sta3.zilnum,sta1.counthw,sta1.countgame,
sta2.finsum/sta2.allfin AS finrate,sta2.gamefin/sta2.gamesum AS taskrate,sta1.datetime FROM
(SELECT a1.teacherid,a3.subjectid,a1.datetime,
count(a1.homeworkid) AS counthw,SUM(a1.gamecount) AS countgame
FROM(SELECT DISTINCT teacherid,bookid,homeworkid,gamecount,
FROM_UNIXTIME(int(createtime/1000),'yyyyMMdd') AS datetime
FROM xh_basecount.product_stw_kpibase ) a1
LEFT JOIN xh_basecount.product_stw_subject a3 ON a1.bookid=a3.bookid
GROUP BY a1.teacherid,a3.subjectid,a1.datetime)sta1
LEFT JOIN
(SELECT a2.teacherid,a3.subjectid,
FROM_UNIXTIME(int(a2.createtime/1000),'yyyyMMdd') AS datetime,
SUM(IF(a2.isfinish=1,1,0)) AS finsum,COUNT(a2.isfinish) AS allfin,
SUM(a2.finishcount)AS gamefin, SUM(a2.gamecount)AS gamesum
FROM xh_basecount.product_stw_kpibase a2 
LEFT JOIN xh_basecount.product_stw_subject a3 ON a2.bookid=a3.bookid
GROUP BY FROM_UNIXTIME(int(a2.createtime/1000),'yyyyMMdd'),
a2.teacherid,a3.subjectid)sta2 
ON sta1.teacherid=sta2.teacherid AND sta1.subjectid=sta2.subjectid
AND sta1.datetime=sta2.datetime 
LEFT JOIN(
SELECT a3.teacherid,sta4.subjectid,sum(sta4.zlnum)AS zilnum,sta4.datetime
FROM xh_elasticsearch.teacher_student_info a3
LEFT JOIN
(SELECT a1.userid,a2.subjectid,count(DISTINCT a1.id)AS zlnum,
from_unixtime(a1.createtime,'yyyyMMdd') AS datetime
FROM xh_basecount.product_stw_base a1
LEFT JOIN xh_basecount.product_stw_subject a2
ON a1.bookid=a2.bookid
WHERE a1.ishomework='1' AND
a1.udatetime>=unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyyMMdd'),'yyyyMMdd')
GROUP BY a1.userid,a2.subjectid,from_unixtime(a1.createtime,'yyyyMMdd'))sta4
ON sta4.userid=a3.userid WHERE sta4.subjectid IS NOT NULL 
AND a3.datetime>=from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
GROUP BY a3.teacherid,sta4.subjectid,sta4.datetime) sta3 
ON sta1.teacherid=sta3.teacherid AND sta1.subjectid=sta3.subjectid AND sta1.datetime=sta3.datetime
)stab1 ON a3.teacherid=stab1.teacherid
WHERE a3.datetime>=from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
