load data local inpath '/root/xhproduct/stwinfo/' into table xh_basecount.product_stw_base;
truncate table xh_basecount.product_stw_daycount;
INSERT INTO xh_basecount.product_stw_daycount

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
sta2.sumright/sta2.numtopic AS rightlv,
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
xh_basecount.product_stw_base a1
WHERE a1.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
)sta1
LEFT JOIN(
SELECT
a3.userid,
a3.bookid,
FROM_UNIXTIME(a3.createtime,'yyyy-MM-dd') AS datetime,
SUM(IF(a3.ishomework = 0,1,0)) AS sumhomework,
SUM(IF(a3.ishomework != 0,1,0)) AS sumselfwork,
COUNT(a3.ishomework)*10 AS numtopic,
SUM(if(a3.rightnum>10,10,a3.rightnum)) AS sumright,
SUM(a3.timecost) AS sumtime
FROM
xh_basecount.product_stw_base a3
WHERE a3.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
GROUP BY
a3.userid,
a3.bookid,
FROM_UNIXTIME(a3.createtime,'yyyy-MM-dd')
) sta2 on sta2.userid=sta1.userid and sta2.bookid=sta1.bookid
and sta2.datetime = sta1.datetime
LEFT JOIN(
SELECT DISTINCT
a4.userid,
a4.hp,
a4.credit
FROM xh_basecount.product_stw_base a4
JOIN (select userid,max(updatetime)as maxtime 
FROM xh_basecount.product_stw_base
WHERE udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd') 
GROUP BY userid) a5
on a4.userid=a5.userid and a4.updatetime=a5.maxtime
WHERE a4.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
)sta4 ON sta1.userid=sta4.userid
LEFT JOIN (
SELECT  DISTINCT a6.userid,
a6.bookid,a6.newintegral
FROM xh_basecount.product_stw_base a6
JOIN (select userid,bookid,max(updatetime)as maxtime 
FROM xh_basecount.product_stw_base 
WHERE udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd') GROUP BY userid,bookid) a7
on a6.userid=a7.userid and a6.bookid=a7.bookid and a6.updatetime=a7.maxtime
WHERE a6.udatetime >= unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'),'yyyy-MM-dd')
)sta6 ON sta1.userid = sta6.userid AND sta1.bookid=sta6.bookid;
truncate table tmptables.product_stw_daycount_lastday;
insert into tmptables.product_stw_daycount_lastday
select * from xh_basecount.product_stw_daycount;
