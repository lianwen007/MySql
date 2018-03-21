INSERT INTO product_stw_kpicount 
SELECT a3.teacherid,a3.teachername,a3.classid,a3.classname,a3.schoolid,a3.studentnum,NVL(stab1.subjectid,0),
NVL(stab1.zilnum,0),NVL(stab1.counthw,0),NVL(stab1.countgame,0),NVL(stab1.finrate,0),NVL(stab1.taskrate,0),NVL(stab1.datetime,0),
from_unixtime(unix_timestamp()-60*60*24*0,'yyyyMMdd') AS uptime
FROM teacher_info_stunum a3
LEFT JOIN
(SELECT sta1.teacherid,sta1.subjectid,sta3.zilnum,sta1.counthw,sta1.countgame,
sta2.allfin AS taskrate,sta2.finsum AS finrate,sta1.datetime FROM
(SELECT a1.teacherid,a3.subjectid,a1.datetime,
count(a1.homeworkid) AS counthw,SUM(a1.gamecount) AS countgame
FROM(SELECT DISTINCT teacherid,bookid,homeworkid,gamecount,
FROM_UNIXTIME(int(createtime/1000),'yyyyMMdd') AS datetime
FROM product_stw_kpibase ) a1
LEFT JOIN product_stw_subject a3 ON a1.bookid=a3.bookid
GROUP BY a1.teacherid,a3.subjectid,a1.datetime)sta1
LEFT JOIN
(SELECT a2.teacherid,a3.subjectid,
FROM_UNIXTIME(int(a2.createtime/1000),'yyyyMMdd') AS datetime,
SUM(IF(a2.isfinish=1,1,0))AS finsum,COUNT(a2.isfinish) AS allfin,
SUM(a2.finishcount)AS gamefin, SUM(a2.gamecount)AS gamesum
FROM product_stw_kpibase a2 
LEFT JOIN product_stw_subject a3 ON a2.bookid=a3.bookid
GROUP BY FROM_UNIXTIME(int(a2.createtime/1000),'yyyyMMdd'),
a2.teacherid,a3.subjectid)sta2 
ON sta1.teacherid=sta2.teacherid AND sta1.subjectid=sta2.subjectid
AND sta1.datetime=sta2.datetime 
LEFT JOIN(
SELECT a3.teacherid,sta4.subjectid,sum(sta4.zlnum)AS zilnum,sta4.datetime
FROM teacher_student_info a3
LEFT JOIN
(SELECT a1.userid,a2.subjectid,count(DISTINCT a1.id)AS zlnum,
from_unixtime(a1.createtime,'yyyyMMdd') AS datetime
FROM product_stw_base a1
LEFT JOIN product_stw_subject a2
ON a1.bookid=a2.bookid
WHERE a1.ishomework='1' AND
a1.udatetime>=from_unixtime(unix_timestamp()-60*60*24*0,'yyyyMMdd')
GROUP BY a1.userid,a2.subjectid,from_unixtime(a1.createtime,'yyyyMMdd'))sta4
ON sta4.userid=a3.userid WHERE sta4.subjectid IS NOT NULL 
AND a3.datetime>=from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
GROUP BY a3.teacherid,sta4.subjectid,sta4.datetime) sta3 
ON sta1.teacherid=sta3.teacherid AND sta1.subjectid=sta3.subjectid AND sta1.datetime=sta3.datetime
)stab1 ON stab1.teacherid=a3.teacherid
WHERE a3.datetime>=from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
