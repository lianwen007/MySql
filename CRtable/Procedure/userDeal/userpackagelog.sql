#20180122 加入古文 gw01.yunzuoye.net
#20171226 加入刷题王3 king.yunzuoye.net

BEGIN
set @asql=concat(
"
INSERT INTO user_package_log(userid,packagename,createtime,datetime)(
SELECT
sta.userid,
sta.packagename,
sta.createtime,
sta.datetime
FROM (
SELECT 
case 
when (message LIKE '%users/%') then substr(message,INSTR(message,'users')+6,5)
when (message LIKE '%works/%studentid%')then substr(message,INSTR(message,'studentid')+10,5)
when (message LIKE '%works/%teacherid%')then substr(message,INSTR(message,'teacherid')+10,5)
when (message LIKE '%t/userStatistical%help%')then substr(message,INSTR(message,'userStatistical')+16,5)
when (message LIKE '%userId=%')then substr(message,INSTR(message,'userId')+7,5)
when (message LIKE '%v_/%/message%')then substr(request,INSTR(request,'message')-6,5)
when (message LIKE '%/praised/comment/%')then substr(request,INSTR(request,'praised/comment')-6,5)
when (message LIKE '%interfaces%')then substr(message,INSTR(message,'UserId=')+7,5)
when (message LIKE '%osc.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%oet.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%wcc.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%isc.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%king.yunzuoye.net%')then substr(message,-5,5)
when (message LIKE '%gw01.yunzuoye.net%')then substr(message,-5,5)
else 0 end as userid,
case 
when local_addr='ztp.yunzuoye.net' then 'pingtai3'
when local_addr='cloudwk.yunzuoye.net' then 'yunzuoye3'
when local_addr='king.yunzuoye.net' then 'shuatiwang3'
when local_addr='read.yunzuoye.net' then 'read'
when local_addr='response.yunzuoye.net' then 'xiangying'
when local_addr='osc.yunzuoye.net' then 'xiaowai'
when local_addr='oet.yunzuoye.net' then 'kouyu'
when local_addr='wcc.yunzuoye.net' then 'yuwen'
when local_addr='isc.yunzuoye.net' then 'xiaonei'
when local_addr='gw01.yunzuoye.net' then 'guwen'
when (message LIKE '%interfaces%homework_new%') then 'yunzuoye2'
when (message LIKE '%interfaces_stw_mathematics%') then 'shuxuestw'
when (message LIKE '%interfaces_yystw%') then 'yystw'
when (message LIKE '%interfaces_stw_science%') then 'kexuestw'
end as packagename,
UNIX_TIMESTAMP(substr(message,1,19))+28800 as createtime,
from_unixtime(UNIX_TIMESTAMP(substr(message,1,19))+28800,'%Y-%m-%d') as datetime
FROM user_package",DATE_FORMAT(adddate(date(sysdate()) ,-1),'%Y%m%d')
," WHERE local_addr 
IN ('ztp.yunzuoye.net','cloudwk.yunzuoye.net',
'read.yunzuoye.net','response.yunzuoye.net'
,'osc.yunzuoye.net','oet.yunzuoye.net','wcc.yunzuoye.net'
,'isc.yunzuoye.net','king.yunzuoye.net','gw01.yunzuoye.net') or message LIKE '%interfaces%'
) sta
WHERE sta.userid RLIKE '^[1-9]' AND  sta.userid RLIKE '[0-9]$'
)
"
);
prepare stm from @asql;
EXECUTE stm;
END
