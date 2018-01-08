INSERT INTO user_file_product(
userid,
username,
schoolid,
schoolname,
gradename,
scorestatus,
scorechn,
rankchn,
scoremath,
rankmath,
scoreeng,
rankeng,
scoresci,
ranksci,
avgstatus,
topstatus,
topnumber,
datetime)
SELECT 
sta1.userid,
sta1.username,
sta1.schoolid,
sta1.schoolname,
sta1.gradename,
CASE
WHEN ((1-sta1.graderank/sta1.stunum)>=0.9)THEN 1
WHEN ((1-sta1.graderank/sta1.stunum)>=0.8)THEN 2
WHEN ((1-sta1.graderank/sta1.stunum)>=0.7)THEN 3
WHEN ((1-sta1.graderank/sta1.stunum)>=0.6)THEN 4
ELSE 5 END AS scorestatus,
yuwen.avgscore,
yuwen.rankchn,
shuxue.avgscore,
shuxue.rankmath,
yingyu.avgscore,
yingyu.rankeng,
kexue.avgscore,
kexue.ranksci,
CASE
WHEN ((yuwen.rankchn+shuxue.rankmath+yingyu.rankeng+kexue.ranksci)>=3.2) THEN 1
WHEN ((yuwen.rankchn+shuxue.rankmath+yingyu.rankeng+kexue.ranksci)>=2.4) THEN 2
WHEN ((yuwen.rankchn+shuxue.rankmath+yingyu.rankeng+kexue.ranksci)>=1.6) THEN 3
WHEN ((yuwen.rankchn+shuxue.rankmath+yingyu.rankeng+kexue.ranksci)>=0.8) THEN 4
ELSE 5 END AS avgstatus,
1 AS topstatus,
topnumber,
unix_timestamp(from_unixtime(unix_timestamp(),'yyyy-MM-dd'),'yyyy-MM-dd')AS datetime
FROM
(select
a1.userid,
a1.username,
a1.schoolid,
a5.schoolname,
a1.gradename,
a2.stunum,
avg(a1.avgscore)AS avgallscore,
rank()over(PARTITION by gradename ORDER BY avg(a1.avgscore) DESC) as graderank
FROM user_product_cloudwk_count a1
LEFT JOIN (SELECT aa2.schoolid,aa2.gradename,count(DISTINCT aa2.userid)AS stunum
FROM user_product_cloudwk_count aa2 GROUP BY aa2.schoolid,aa2.gradename)a2 
ON a1.schoolid=a2.schoolid AND a1.gradename=a2.gradename
LEFT JOIN school_grade_user a5 ON a1.schoolid=a5.schoolid
GROUP BY a1.userid,a1.username,a1.schoolid,a5.schoolname,a1.gradename,a2.stunum
)sta1
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as rankchn
from user_product_cloudwk_count a3
WHERE a3.subject=1
)yuwen ON yuwen.userid=sta1.userid
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as rankmath
from user_product_cloudwk_count a3
WHERE a3.subject=2
)shuxue ON shuxue.userid=sta1.userid
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as rankeng
from user_product_cloudwk_count a3
WHERE a3.subject=3
)yingyu ON yingyu.userid=sta1.userid
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as ranksci
from user_product_cloudwk_count a3
WHERE a3.subject=4
)kexue ON kexue.userid=sta1.userid
LEFT JOIN
(SELECT a4.userid,
a4.readnum AS topnumber
FROM user_product_read_count a4)sta2
ON sta1.userid=sta2.userid
