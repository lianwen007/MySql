create table user_file_product(
userid bigint,
username string,
schoolid bigint,
schoolname string,
gradename string,
scorestatus int,
scorechn float,
rankchn float,
scoremath float,
rankmath float,
scoreeng float,
rankeng float,
scoresci float,
ranksci float,
avgstatus int,
topstatus int,
topnumber float,
finalstatus int,
datetime bigint)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;
