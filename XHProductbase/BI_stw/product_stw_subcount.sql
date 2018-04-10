BEGIN
INSERT INTO  product_stw_subcount(
SELECT sta1.userid,sta1.username,sta1.subjectid,
sta1.schoolid,sta1.classid,sta1.classname,
sum(sta1.numhomework)+sum(sta1.numselfwork) AS oldtopicnum,
sum(sta1.topicnum)AS alltopicnum,sum(countright)AS numright,sta1.datetime FROM(
SELECT a1.userid,a1.username,a2.subjectid,a1.schoolid,a1.classid,
a1.classname,a1.numhomework,a1.numselfwork,a1.topicnum,a1.countright,a1.datetime
FROM product_stw_daycount a1 
LEFT JOIN product_stw_subject a2
ON a1.bookid=a2.bookid)AS sta1
GROUP BY sta1.userid,sta1.subjectid,sta1.datetime,sta1.username,
sta1.schoolid,sta1.classid,sta1.classname
);
END
