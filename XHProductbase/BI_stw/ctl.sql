load data local inpath '/root/xhproduct/stwinfo/' into table product_stw_base;
truncate table product_stw_kpibase;
load data local inpath '/root/xhproduct/stwinfo_kpi/' into table product_stw_kpibase;
truncate table product_stw_subject;
load data local inpath '/root/xhproduct/stwinfo_sub/' into table product_stw_subject;
truncate table product_stw_entype;
load data local inpath '/root/xhproduct/stwinfo_english/' into table product_stw_entype;
truncate table product_stw_daycount;
INSERT INTO product_stw_daycount
SELECT
sta1.userid,
sta1.username,
sta1.schoolid,
sta1.schoolname,
sta1.classname,
sta1.classid,
sta1.bookname,
sta1.bookid,
sta4.hp,
sta4.credit,
sta6.newintegral,
sta2.sumhomework,
sta2.sumselfwork,
sta2.numtopic,
sta2.sumright,
CASE WHEN sta2.subtype = 1 THEN sta2.sumright/sta2.numtopic
WHEN sta2.subtype = 2 THEN sta2.engrightrate END AS rightlv,
sta2.sumtime,
sta1.datetime
FROM
(SELECT DISTINCT 
a1.userid,
a1.username,
a1.schoolname,
a1.schoolid,
a1.classname,
a1.classid,
a1.bookname,
a1.bookid,
FROM_UNIXTIME(a1.createtime,'yyyy-MM-dd') AS datetime
FROM
product_stw_base a1
WHERE a1.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
)sta1
LEFT JOIN(SELECT
a3.userid,
a3.bookid,
FROM_UNIXTIME(a3.createtime,'yyyy-MM-dd') AS datetime,
SUM(IF(a3.ishomework = 0,1,0)) AS sumhomework,
SUM(IF(a3.ishomework != 0,1,0)) AS sumselfwork,
CASE WHEN a3.subtype = 2 THEN COUNT(a3.ishomework)*10
WHEN a3.subtype = 1 THEN (COUNT(a3.ishomework)*10 - SUM(IF(a3.judgecount>0,a3.judgecount,0))) 
END AS numtopic,
SUM(a3.rightnum) AS sumright,
SUM(a3.judgecount)AS engrightrate,
SUM(a3.timecost) AS sumtime,
a3.subtype
FROM(SELECT a33.*,a44.subtype FROM
product_stw_base a33 LEFT JOIN product_stw_subject a44 ON a33.bookid=a44.bookid
WHERE a33.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
)AS a3
GROUP BY
a3.userid,
a3.bookid,
FROM_UNIXTIME(a3.createtime,'yyyy-MM-dd'),a3.subtype
) sta2 on sta2.userid=sta1.userid and sta2.bookid=sta1.bookid
and sta2.datetime = sta1.datetime
LEFT JOIN(
SELECT DISTINCT
a4.userid,
a4.hp,
a4.credit
FROM product_stw_base a4
JOIN (select userid,max(updatetime)as maxtime 
FROM product_stw_base
WHERE udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd') 
GROUP BY userid) a5
on a4.userid=a5.userid and a4.updatetime=a5.maxtime
WHERE a4.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
)sta4 ON sta1.userid=sta4.userid
LEFT JOIN (
SELECT  DISTINCT a6.userid,
a6.bookid,a6.newintegral
FROM product_stw_base a6
JOIN (select userid,bookid,max(updatetime)as maxtime 
FROM product_stw_base 
WHERE udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd') GROUP BY userid,bookid) a7
on a6.userid=a7.userid and a6.bookid=a7.bookid and a6.updatetime=a7.maxtime
WHERE a6.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
)sta6 ON sta1.userid = sta6.userid AND sta1.bookid=sta6.bookid;

TRUNCATE TABLE product_stw_kpicount;
INSERT INTO product_stw_kpicount
SELECT tab1.teacherid,tab1.teachername,tab1.classid,tab1.classname,tab3.studentnum,tab1.schoolid,
tab1.schoolname,tab1.subjectid,SUM(tab1.ziliancishu)AS zilcishu,SUM(tab1.buzhicishu)AS buzcishu,
SUM(tab1.buzhifenshu)AS buzfenshu,SUM(tab1.shangjiaofenshu)AS shangjfenshu,tab1.datetime,
FROM_UNIXTIME(UNIX_TIMESTAMP()-24*60*60*0,'yyyyMMdd') AS uptime
FROM
(SELECT sta2.teacherid,sta3.teachername,sta2.classid,sta3.classname,
sta3.schoolid,sta3.schoolname,sta2.subjectid,0 AS ziliancishu,
sta2.buzhicishu,sta2.shangjiaofenshu,sta2.buzhifenshu,sta2.datetime
FROM 
(SELECT st1.teacherid,st1.classid,st1.subjectid,
FROM_UNIXTIME(int(st1.createtime/1000),'yyyyMMdd') AS datetime,
COUNT(DISTINCT st1.homeworkid) AS buzhicishu,
SUM(st1.isfinish)AS shangjiaofenshu, COUNT(st1.isfinish)AS buzhifenshu
FROM(SELECT a1.userid,a1.createtime,a1.homeworkid,a1.teacherid,
a1.isfinish,a1.bookid,a2.classid,a3.subjectid
FROM product_stw_kpibase a1 LEFT JOIN teacher_student_info a2 
ON a2.userid=a1.userid AND a1.teacherid=a2.teacherid
LEFT JOIN product_stw_subject a3 ON a3.bookid=a1.bookid)AS st1
WHERE st1.classid IS NOT NULL
GROUP BY st1.teacherid,st1.classid,st1.subjectid,
FROM_UNIXTIME(int(st1.createtime/1000),'yyyyMMdd'))sta2
LEFT JOIN teacher_info_stunum sta3 
ON sta3.teacherid=sta2.teacherid AND sta3.classid=sta2.classid
WHERE sta3.datetime>=from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd')
UNION ALL
SELECT sta3.teacherid,sta3.teachername,sta4.classid,sta3.classname,
sta3.schoolid,sta3.schoolname,sta4.subjectid,sta4.ziliancishu,
0 AS buzhicishu,0 AS shangjiaofenshu,0 AS buzhifenshu,sta4.datetime
FROM 
(SELECT sta1.classid,sta1.subjectid,
FROM_UNIXTIME(sta1.createtime,'yyyyMMdd') AS datetime,
COUNT(DISTINCT sta1.id) AS ziliancishu
FROM(SELECT a4.userid,a4.createtime,a4.id,
a4.bookid,a2.classid,a3.subjectid
FROM product_stw_base a4 LEFT JOIN teacher_student_info a2 
ON a2.userid=a4.userid LEFT JOIN product_stw_subject a3 
ON a3.bookid=a4.bookid WHERE a4.ishomework=1 )AS sta1
WHERE sta1.classid IS NOT NULL
GROUP BY sta1.classid,sta1.subjectid,
FROM_UNIXTIME(sta1.createtime,'yyyyMMdd'))sta4
LEFT JOIN teacher_info_stunum sta3 
ON sta3.classid=sta4.classid
WHERE sta3.datetime>=from_unixtime(unix_timestamp()-60*60*24*1,'yyyyMMdd'))tab1
LEFT JOIN teacher_info_stunum tab3 ON tab1.classid=tab3.classid AND tab1.teacherid=tab3.teacherid
GROUP BY tab1.teacherid,tab1.teachername,tab1.classid,tab1.classname,tab1.schoolid,
tab1.schoolname,tab1.subjectid, tab1.datetime,tab3.studentnum;

TRUNCATE TABLE product_stw_encount;
INSERT INTO product_stw_encount
SELECT stab1.userid,s2.username,s2.schoolid,s2.classid,s2.classname,
NVL(stab2.pubcount,0)AS gamecount,
NVL(stab2.fincount,0)AS fincount,
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
SUM(NVL(stab1.avgrate,0))AS rateavg,
stab1.datetime
FROM(
SELECT sta7.userid,sta7.datetime,sta7.entype,sta7.ishomework,
SUM(sta7.judgecount)AS avgrate,
CASE WHEN sta7.ishomework = '1' THEN 
COUNT(sta7.ishomework) END AS selfnum,
CASE WHEN sta7.ishomework = '0' THEN 
SUM(IF(sta7.judgecount = '100',1,0)) END AS homewkfull,
CASE WHEN sta7.ishomework = '1' THEN 
SUM(IF(sta7.judgecount = '100',1,0)) END AS fullself,
CASE WHEN sta7.entype = '9' THEN
AVG(sta7.judgecount) END AS listenrate,
CASE WHEN sta7.entype = '7' THEN
AVG(sta7.judgecount) END AS readrate,
CASE WHEN sta7.entype = '14' THEN
AVG(sta7.judgecount) END AS blankrate,
CASE WHEN sta7.entype = '9' THEN
SUM(IF(sta7.judgecount='100',1,0)) END AS listenfull,
CASE WHEN sta7.entype = '7' THEN
SUM(IF(sta7.judgecount='100',1,0)) END AS readfull,
CASE WHEN sta7.entype = '14' THEN
SUM(IF(sta7.judgecount='100',1,0)) END AS blankfull,
CASE WHEN sta7.entype = '9' THEN
COUNT(sta7.ishomework) END AS listennum,
CASE WHEN sta7.entype = '7' THEN
COUNT(sta7.ishomework) END AS readnum,
CASE WHEN sta7.entype = '14' THEN
COUNT(sta7.ishomework) END AS blanknum
FROM(SELECT a7.userid,a7.judgecount,a7.ishomework,a8.entype,a9.subjectid,
FROM_UNIXTIME(a7.createtime,'yyyy-MM-dd') AS datetime
FROM product_stw_base a7 
LEFT JOIN product_stw_entype a8
ON a7.id = a8.id 
JOIN product_stw_subject a9
ON a7.bookid = a9.bookid
AND a7.udatetime>unix_timestamp(from_unixtime(unix_timestamp(),'yyyy-MM-dd'),'yyyy-MM-dd')
AND a9.subjectid = '3') sta7
GROUP BY sta7.userid,sta7.datetime,sta7.entype,sta7.ishomework
) stab1 LEFT JOIN
(SELECT a4.userid,sum(a4.gamecount)AS pubcount,
sum(a4.finishcount)AS fincount,
FROM_UNIXTIME(int(a4.createtime/1000),'yyyy-MM-dd') AS datetime
FROM product_stw_kpibase a4 JOIN product_stw_subject a3
ON a3.bookid = a4.bookid and a3.subjectid = '3'
GROUP BY a4.userid,a4.bookid,FROM_UNIXTIME(int(a4.createtime/1000),'yyyy-MM-dd')
) stab2 ON stab1.userid = stab2.userid and stab1.datetime = stab2.datetime
LEFT JOIN
(SELECT DISTINCT sa2.userid,sa2.username,sa2.schoolid,sa2.classid,sa2.classname
FROM teacher_student_info sa2 
)s2 ON stab1.userid=s2.userid
GROUP BY stab1.userid,s2.username,NVL(stab2.fincount,0),
s2.schoolid,s2.classid,NVL(stab2.pubcount,0),
s2.classname,stab1.datetime;
