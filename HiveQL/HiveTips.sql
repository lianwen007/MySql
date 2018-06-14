# 取自然周时间
select unix_timestamp(substr(from_unixtime(unix_timestamp()),1,4),'yyyy')+ 
                    # substr截取时间中的年份，自动转为当年1月1日0时的UNIX时间戳
    ((weekofyear(from_unixtime(unix_timestamp()-60*60*24*0,'yyyy-MM-dd'))-1)*86400*7)
                    # 再加上本年当前时间对应的周，已过的总秒数，成为完整的时间戳
                    
                    
# 排行，无重复名次, 可多维度排名
SELECT dense_rank() over(partition by sta1.class_id,sta1.book_id order by sta1.integral desc)
