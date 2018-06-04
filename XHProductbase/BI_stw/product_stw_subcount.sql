BEGIN
TRUNCATE TABLE product_stw_subcount;
INSERT INTO  product_stw_subcount(
SELECT
	sta1.userid,
	sta1.username,
	sta1.subjectid,
	sta1.schoolid,
	sta1.classid,
	sta1.classname,
	sum(sta1.numhomework) + sum(sta1.numselfwork) AS oldtopicnum,
  CASE WHEN sta1.subjectid = '3' 
  THEN SUM(sta1.rightlv)/(sum(sta1.numhomework)+sum(sta1.numselfwork))
  ELSE sum(sta1.topicnum) END AS alltopicnum,
	sum(countright) AS numright,
	sta1.datetime
FROM
	(
		SELECT
			a1.userid,
			a1.username,
			a2.subjectid,
			a1.schoolid,
			a1.classid,
			a1.classname,
			a1.numhomework,
			a1.numselfwork,
			a1.topicnum,
			a1.countright,
			a1.datetime,
      a1.rightlv
		FROM
			product_stw_daycount a1
		LEFT JOIN product_stw_subject a2 ON a1.bookid = a2.bookid
	) AS sta1
GROUP BY
	sta1.userid,
	sta1.subjectid,
	sta1.datetime,
	sta1.username,
	sta1.schoolid,
	sta1.classid,
	sta1.classname
);
TRUNCATE TABLE product_qst_count;
INSERT INTO product_qst_count(
SELECT sta1.userid,sta1.username,sta1.classid,sta1.classname,sta1.schoolid,
  sta1.subjectid,
 CASE WHEN sta1.subjectid IN (2,4)THEN SUM(sta1.qstnum)*10 
      WHEN sta1.subjectid IN (3)THEN SUM(sta1.qstnum)
 END AS numqst,
 CASE WHEN sta1.subjectid IN (2,4) 
       THEN (SUM(sta1.countright)*100/SUM(sta1.qstnum))/10
      WHEN sta1.subjectid IN (3) THEN SUM(sta1.rightlv)/SUM(sta1.qstnum)
  END AS rightrate,
  'stw' AS app_name,
  sta1.datetime
FROM(
SELECT a1.userid,a1.bookid,a1.username,a1.classid,a1.classname,a1.schoolid,
  a1.numhomework+a1.numselfwork AS qstnum,
  a1.countright,a1.rightlv,a2.subjectid,a1.datetime
FROM product_stw_daycount a1
LEFT JOIN product_stw_subject a2
ON a1.bookid = a2.bookid) sta1
GROUP BY sta1.userid,sta1.subjectid,sta1.datetime);
END
