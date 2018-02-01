create table product_stw_base(
username string,
userid bigint,
classname string,
classid int,
schoolname string,
schoolid bigint,
hp int,
credit int,
bookname string,
bookid string,
newintegral float,
ishomework int,
rightnum int,
timecost int,
udatetime bigint)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;


create table product_stw_log(
userid bigint,
username string,
schoolid bigint,
schoolname string,
classname string,
classid int,
bookname string,
bookid string,
hp int,
credit int,
sumscore float,
sumhomework int,
sumselfwork int,
numtopic int,
sumright int,
rightlv float,
sumtime int,
datetime string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;


create table product_stw_daycount(
userid bigint,
username string,
schoolid bigint,
schoolname string,
classname string,
classid int,
bookname string,
bookid string,
hp int,
credit int,
countscore float,
numhomework int,
numselfwork int,
topicnum int,
countright int,
rightlv float,
counttime int,
datetime string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;
