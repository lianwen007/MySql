INSERT INTO xh_userfile.user_file_product(
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
finalstatus,
datetime)
select
stable1.userid,
stable1.username,
stable1.schoolid,
stable1.schoolname,
stable1.gradename,
stable1.scorestatus,
stable1.scorechn,
stable1.rankchn,
stable1.scoremath,
stable1.rankmath,
stable1.scoreeng,
stable1.rankeng,
stable1.scoresci,
stable1.ranksci,
stable1.avgstatus,
stable1.topstatus,
stable1.topnumber,
stable1.finalstatus,
stable1.datetime
from(
select *,
row_number()over(PARTITION by stab1.userid ORDER BY stab1.scorestatus) userselfrank
from (
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
WHEN ((1-sta1.graderank/sta1.stunum)>=0)THEN 5
ELSE 6 END AS scorestatus,
yuwen.avgscore as scorechn,
yuwen.rankchn,
shuxue.avgscore as scoremath,
shuxue.rankmath,
yingyu.avgscore as scoreeng,
yingyu.rankeng,
kexue.avgscore as scoresci,
kexue.ranksci,
CASE
WHEN ((yuwen.rankchn+shuxue.rankmath+yingyu.rankeng+kexue.ranksci)>=3.2) THEN 1
WHEN ((yuwen.rankchn+shuxue.rankmath+yingyu.rankeng+kexue.ranksci)>=2.4) THEN 4
WHEN ((yuwen.rankchn+shuxue.rankmath+yingyu.rankeng+kexue.ranksci)>=1.6) THEN 3
ELSE 2 END AS avgstatus,
CASE
WHEN (yystwcount.rightlv>=80 )THEN 1
WHEN (essaycount.praisenum>=20)THEN 4
WHEN (ilccount.ranklv>=0.75 )THEN 3
WHEN (readcount.readnum>=100)THEN 2
ELSE 5 END AS topstatus,
CASE
WHEN (yystwcount.rightlv>=80 )THEN yystwcount.rightlv
WHEN (essaycount.praisenum>=20 )THEN essaycount.praisenum
WHEN (ilccount.ranklv>=0.75 )THEN ilccount.ranklv
WHEN (readcount.readnum>=100 )THEN readcount.readnum
ELSE 5 END AS topnumber,
case
when ((1-sta1.graderank/sta1.stunum)>=0.8) THEN 1
WHEN ((1-sta1.graderank/sta1.stunum)>=0.6) THEN 2
WHEN ((1-sta1.graderank/sta1.stunum)<=0.2) THEN 3
else FLOOR( 4 + RAND() * (7 - 3))
end as finalstatus,
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
rank()over(PARTITION by a1.schoolid,a1.gradename ORDER BY avg(a1.avgscore) DESC) as graderank
FROM xhelktest.user_product_cloudwk_count a1
LEFT JOIN (SELECT aa2.schoolid,aa2.gradename,count(DISTINCT aa2.userid)AS stunum
FROM xhelktest.user_product_cloudwk_count aa2 GROUP BY aa2.schoolid,aa2.gradename)a2 
ON a1.schoolid=a2.schoolid AND a1.gradename=a2.gradename
LEFT JOIN xhelktest.school_grade_user a5 ON a1.schoolid=cast (a5.schoolid as int)
GROUP BY a1.userid,a1.username,a1.schoolid,a5.schoolname,a1.gradename,a2.stunum
)sta1
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as rankchn
from xhelktest.user_product_cloudwk_count a3
WHERE a3.subject=1
)yuwen ON yuwen.userid=sta1.userid
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as rankmath
from xhelktest.user_product_cloudwk_count a3
WHERE a3.subject=2
)shuxue ON shuxue.userid=sta1.userid
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as rankeng
from xhelktest.user_product_cloudwk_count a3
WHERE a3.subject=3
)yingyu ON yingyu.userid=sta1.userid
LEFT JOIN
(SELECT
a3.userid,
a3.avgscore,
1-a3.rankfenbu as ranksci
from xhelktest.user_product_cloudwk_count a3
WHERE a3.subject=4
)kexue ON kexue.userid=sta1.userid
LEFT JOIN
(SELECT a4.userid,
a4.readnum 
FROM xhelktest.user_product_read_count a4
WHERE a4.readnum>100)readcount
ON sta1.userid=readcount.userid
LEFT JOIN
(SELECT a5.userid,
a5.rightlv
from xh_product.user_yystw_count a5
where a5.rightlv>80) yystwcount
ON sta1.userid=yystwcount.userid
LEFT JOIN
(SELECT a6.userid,
1-a6.scrank/sa6.stunum AS ranklv
FROM xh_product.user_ilc_avgscore_count a6
LEFT JOIN (
SELECT count(DISTINCT a7.userid)AS stunum FROM xh_product.user_ilc_avgscore_count a7)sa6
) ilccount ON sta1.userid=ilccount.userid
LEFT JOIN(
SELECT a7.userid,
a7.praisenum
from xh_product.user_essay_praise_count a7
WHERE a7.praisenum>20
) essaycount ON sta1.userid=essaycount.userid
) stab1 )stable1 where stable1.userselfrank=1
