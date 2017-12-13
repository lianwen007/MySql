BEGIN
	#Routine body goes here...
insert ignore 
into school_area_name(schoolid,schoolname,areaname0,areaname1,areaname2,datetime) 
(
SELECT DISTINCT 
a1.iSchoolId,
a1.sSchoolName,
a2.sProvinceName,
a2.sCityName,
a2.sCountyName,
ADDDATE(date(sysdate()) ,-1) as datetime
FROM xh_webmanage.XHSchool_Info a1 
LEFT JOIN xh_webmanage.XHCust_Info a2 
on a1.sSchoolName=a2.sSchoolName OR a1.iSchoolId=a2.iSchoolId
 /*
ON DUPLICATE KEY UPDATE 
areaname0=VALUES(areaname0),
areaname1=VALUES(areaname1),
areaname2=VALUES(areaname2),
datetime=VALUES(datetime)*/
);
END
