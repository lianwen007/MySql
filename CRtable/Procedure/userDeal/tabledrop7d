BEGIN
set @asql=concat(
"drop table if exists user_package",DATE_FORMAT(adddate(date(sysdate()) ,-1),'%Y%m%d')
);
prepare stm from @asql;
EXECUTE stm;
END
