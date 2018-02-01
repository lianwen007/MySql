#HiveQL

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
sta1.hp,
sta1.credit,
sta1.sumscore - IF(sta2.sumscore is NULL,0,sta2.sumscore) AS countscore,
sta1.sumhomework - IF(sta2.sumhomework is NULL,0,sta2.sumhomework) AS numhomework,
sta1.sumselfwork - IF(sta2.sumselfwork is NULL,0,sta2.sumselfwork) AS numselfwork,
sta1.numtopic - IF(sta2.numtopic is NULL,0,sta2.numtopic) AS topicnum,
sta1.sumright - IF(sta2.sumright is NULL,0,sta2.sumright) AS countright,
(sta1.sumright - IF(sta2.sumright is NULL,0,sta2.sumright))/(sta1.numtopic - IF(sta2.numtopic is 

NULL,0,sta2.numtopic)) AS rightlv,
sta1.sumtime - IF(sta2.sumtime is NULL,0,sta2.sumtime) AS counttime,
from_unixtime(unix_timestamp()-60*60*24*1,'yyyy-MM-dd') AS datetime
FROM
(SELECT
a1.userid,
a1.username,
a1.schoolid,
a1.schoolname,
a1.classname,
a1.classid,
a1.hp,
a1.credit,
a1.bookname,
a1.bookid,
a1.sumscore,
a1.sumhomework,
a1.sumselfwork,
a1.numtopic,
a1.sumright,
a1.sumtime
FROM product_stw_log a1
WHERE 
a1.datetime = from_unixtime(unix_timestamp()-60*60*24*1,'yyyy-MM-dd')
)sta1
LEFT JOIN
(SELECT
a2.userid,
a2.bookid,
a2.sumscore,
a2.sumhomework,
a2.sumselfwork,
a2.numtopic,
a2.sumright,
a2.sumtime
FROM product_stw_log a2
WHERE 
a2.datetime = from_unixtime(unix_timestamp()-60*60*24*2,'yyyy-MM-dd')
)sta2 ON sta1.userid = sta2.userid and sta1.bookid = sta2.bookid;
