BEGIN
delete from device_user_sevendays_nologin where datetime = adddate(date(sysdate()) ,-1);
INSERT INTO device_user_sevendays_nologin(userid,username,logonname,schoolname,gradename,
devicenumber,model,loginnum,applognum,datetime)(
SELECT 
sta1.userid,
sta2.username,
sta2.logonname,
sta2.schoolname,
sta2.gradename,
sta1.devicenumber,
sta2.model,
sta1.loginnum,
sta1.applognum,
adddate(date(sysdate()) ,-1) AS datetime
FROM(
SELECT
a1.userid,
a1.devicenumber,
sum(a1.islogin)as loginnum,
sum(a1.isapplog)as applognum
FROM device_user_login_log a1
WHERE 
UNIX_TIMESTAMP(a1.datetime)<=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-1))

AND UNIX_TIMESTAMP(a1.datetime)>=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-7))

GROUP BY a1.userid,a1.devicenumber)sta1
LEFT JOIN(
SELECT DISTINCT
a2.userid,
a2.devicenumber,
a2.username,
a2.logonname,
a2.schoolname,
a2.gradename,
a2.model
FROM device_user_login_log a2
WHERE 
UNIX_TIMESTAMP(a2.datetime)<=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-1))

AND UNIX_TIMESTAMP(a2.datetime)>=UNIX_TIMESTAMP(adddate(date(sysdate()) ,-7))

)sta2 on sta1.userid=sta2.userid and
sta1.devicenumber=sta2.devicenumber
#WHERE sta1.loginnum='0' AND sta1.applognum='0'
);
END
