insert into user_product_cloudwk_count1(
userid,
username,
subject,
schoolid,
gradename,
avgselfscore,
sumselfscore,
avgscore,
sumscore,
avgtime,
sumtime,
numzuoye,
numzuoti,
listentimes,
numwrong,
numsubmit,
rightlv,
clrightlv,
clavgscore,
clavgtime,
sturank,
rankfenbu,
datetime)
SELECT
 sta1.userid,
 sta1.username,
 sta1.subject,
 sta1.schoolid,
 sta1.gradename,
 sta1.avgselfscore,
 sta1.sumselfscore,
 sta1.subavgscore,
 sta1.sumscore,
 sta1.avgtime,
 sta1.sumtime,
 sta1.numzuoye,
 sta1.numzuoti,
 sta1.listentimes,
 sta1.numwrong,
 sta1.numsubmit,
 sta1.rightlv,
 sta2.clrightlv,
 sta2.clavgscore,
 sta2.clavgtime,
 sta1.sturank,
 --sta1.sturank/sta3.stunum as rankfenbu,
 percent_rank()over(partition by sta1.schoolid,sta1.gradename,sta1.subject order by sta1.subavgscore desc) as renkfenbu,
 from_unixtime(unix_timestamp()-60*60*24*1,'yyyy-MM-dd') AS `datetime`
FROM
 (
  SELECT
   a2.userid,
   a2.username,
   a1.subject,
   a2.schoolid,
   a2.gradename,
   count(a1.workid) AS numzuoye,
   sum(a1.topicnum) AS numzuoti,
   AVG(a1.selfscore) AS avgselfscore,
   sum(a1.selfscore) AS sumselfscore,
   AVG(if(a1.score=0,a1.selfscore,a1.score)) AS subavgscore,
   sum(a1.score) AS sumscore,
   AVG(a1.costtime) AS avgtime,
   sum(a1.costtime) AS sumtime,
   sum(a1.listentimes) AS listentimes,
   sum(a1.wrongnum) AS numwrong,
   sum(IF(a1.schedule > 2, 1, 0)) AS numsubmit,
   sum(a1.rightnum) / sum(a1.topicnum) AS rightlv,
   rank()over(partition by a2.schoolid,a2.gradename,a1.subject order by AVG(if(a1.score=0,a1.selfscore,a1.score)) desc) AS sturank
  FROM school_grade_user a2 
  left JOIN user_product_cloudwk a1 ON a1.userid = cast(a2.userid as bigint)
  WHERE a1.schedule > 2 and a1.datetime='2018-01-10'
  GROUP BY
   a2.userid,
   a2.username,
   a1.subject,
   a2.schoolid,
   a2.gradename
 ) sta1
LEFT JOIN (
 SELECT
  sa2.schoolid,
  sa2.subject,
  sa2.gradename,
  avg(sa2.numright / sa2.numzuoti) AS clrightlv,
  avg(sa2.avgscore) AS clavgscore,
  avg(sa2.avgtime) AS clavgtime
 FROM
  (
   SELECT
    a4.userid,
    a4.subject,
    a3.schoolid,
    a3.gradename,
    sum(a4.rightnum) AS numright,
    sum(a4.topicnum) AS numzuoti,
    AVG(a4.score) AS avgscore,
    AVG(a4.costtime) AS avgtime
   FROM
    user_product_cloudwk a4
   JOIN school_grade_user a3 ON a4.userid = cast(a3.userid as bigint)
   WHERE a4.schedule > 2 and a4.datetime='2018-01-10'
   GROUP BY
    a4.userid,
    a4.subject,
    a3.schoolid,
    a3.gradename
  ) sa2
 GROUP BY
  sa2.schoolid,
  sa2.subject,
  sa2.gradename
) sta2 ON sta1.schoolid = sta2.schoolid
AND sta1.gradename = sta2.gradename
AND sta1.subject = sta2.subject
  left join (
  select
  a5.schoolid,
  a5.gradename,
  count(distinct a5.userid) as stunum
  from school_grade_user a5
  group by 
  a5.schoolid,
  a5.gradename
  ) sta3 on sta1.schoolid=sta3.schoolid and sta1.gradename=sta3.gradename
