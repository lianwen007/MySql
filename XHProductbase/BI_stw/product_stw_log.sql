#HiveQL

INSERT INTO xh_basecount.product_stw_log

SELECT
a1.userid,
a1.username,
a1.schoolid,
a1.schoolname,
a1.classname,
a1.classid,
a1.bookname,
a1.bookid,
a1.hp,
a1.credit,
SUM(a1.newintegral) AS sumscore,
SUM(IF(a1.ishomework = 0,1,0)) AS sumhomework,
SUM(IF(a1.ishomework != 0,1,0)) AS sumselfwork,
COUNT(a1.ishomework)*10 AS numtopic,
SUM(a1.rightnum) AS sumright,
SUM(a1.rightnum)/(COUNT(a1.ishomework)*10) AS rightlv,
SUM(a1.timecost) AS sumtime,
from_unixtime(unix_timestamp()-60*60*24*1,'yyyy-MM-dd') AS `datetime`
FROM
product_stw_base a1
WHERE
a1.udatetime > unix_timestamp(from_unixtime(unix_timestamp()-60*60*24*1,'yyyy-MM-dd 00:00:00'))
GROUP BY
a1.userid,
a1.username,
a1.schoolid,
a1.schoolname,
a1.classname,
a1.classid,
a1.hp,
a1.credit,
a1.bookname,
a1.bookid;
