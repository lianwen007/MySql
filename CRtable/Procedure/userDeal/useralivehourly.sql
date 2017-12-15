BEGIN
delete from user_alive_day_hourly where datetime = adddate(date(sysdate()) ,-1);	
INSERT INTO user_alive_day_hourly (hourly, usernum, datetime)(
	SELECT
		from_unixtime(createtime, '%H') AS hourly,
		count(DISTINCT userid) usernum,
		adddate(date(sysdate()),- 1) as datetime
	FROM
		user_package_log a1
	WHERE
		a1.datetime=adddate(date(sysdate()),- 1)
	GROUP BY
		from_unixtime(createtime, '%H')
);
delete from user_alive_day_hourly_date where datetime = adddate(date(sysdate()) ,-1);	
INSERT INTO user_alive_day_hourly_date (datetime)(
SELECT 
adddate(date(sysdate()) ,- 1) AS datetime
);
END
