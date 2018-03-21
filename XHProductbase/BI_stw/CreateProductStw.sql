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
id string,
createtime bigint,
updatetime bigint,
judgecount int,
newintegral float,
ishomework int,
rightnum int,
timecost int,
udatetime bigint)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;


create table product_stw_kpibase(
homeworkid string,
createtime bigint,
userid int,
teacherid int,
bookid string,
gamecount int,
finishcount int,
isfinish int,
updatetime bigint)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;


create table product_stw_subject(
bookid string,
bookname string,
subjectid int,
subtype int,
updatetime bigint)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;


create table product_stw_base_day(
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
id string,
newintegral float,
ishomework int,
rightnum int,
timecost int,
datetime string,
datauptime string)
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
datetime string,
datauptime string)
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



create table product_stw_kpicount(
teacherid bigint,
teachername string,
classid int,
classname string,
schoolid bigint,
studentnum bigint,
subjectid int,
zilnum int,
counthw int,
countgame int,
finrate float,
taskrate float,
datetime bigint,
uptime bigint)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;
