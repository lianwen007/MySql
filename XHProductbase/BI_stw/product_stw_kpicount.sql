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
tab1.schoolname,tab1.subjectid, tab1.datetime,tab3.studentnum
