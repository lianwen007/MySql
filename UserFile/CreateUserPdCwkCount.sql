create table xhelktest.user_product_cloudwk_count
(userid bigint,
 username string,
 subject int,
 schoolid int,
 gradename string,
 avgselfscore float,
 sumselfscore float,
 avgscore float,
 sumscore float,
 avgtime float,
 sumtime float,
 numzuoye int,
 numzuoti int,
 listentimes int,
 numwrong int,
 numsubmit int,
 rightlv float,
 clrightlv float,
 clavgscore float,
 clavgtime float,
 sturank int,
 rankfenbu float,
 datetime string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;
