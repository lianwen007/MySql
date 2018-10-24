SELECT t1.rider_id
,t2.rider_name
,t1.rule_id   --'规则ID'
,t1.rule_name   --'规则名称'
,t2.sex   
,t2.age   
,t2.rider_type  --'骑士类型 0：骑手 5：骑士'
,t2.rider_level  --'骑士level；0：Lv1；5：Lv2；10：Lv3；15：Lv4；20：Lv5'
,t2.rider_status  --'状态'
,t2.city_id as rider_city_id  --'骑手城市ID'
,coalesce(t2.city_name,'0') as rider_city_name
,t2.region_id  --'所属区域ID'
,t2.regist_city_id  --'注册城市'
,t2.online_times  --'当日在线时长,单为：秒'
,t2.total_points  --'总积分'
,t1.city_id   --'订单城市ID'
,coalesce(t4.city_name,'0') as city_name
,t1.source_name
,t1.create_time
--工单相关
,COALESCE(t1.workorder_id ,'0') as workorder_id 
,COALESCE(t3.platform_shop_id,0) as platform_shop_id
,COALESCE(t3.platform_shop_name,'0') as platform_shop_name   --'渠道'
,COALESCE(t3.classify,0)as classify   --'一级分类'
,COALESCE(t3.classify_name,'0')as classify_name   --'一级分类名称'
,COALESCE(t3.subclassify,0)as subclassify   --'二级分类'
,COALESCE(t3.subclassify_name,'0')as subclassify_name   --'二级分类名称'
,COALESCE(t3.item_code,0)as item_code   --'事项编码'
,COALESCE(t3.item_name,'0')as item_name   --'事项名称'
,COALESCE(t3.wdesc,'0')as wdesc   --'工单描述'
,COALESCE(t3.result,'0')as result   --'结果(1成立，0不成立)'
,COALESCE(t3.result_content,'0')as result_content    --'结果回复文案'
,COALESCE(t3.create_source,0)as create_source    --'创建来源 10-APP 20-客服 30-渠道'
--,COALESCE(t3.create_time,cast(0 as timestamp))as w_create_time   --'工单创建时间'
,COALESCE(t3.accept_time,cast(0 as timestamp))as accept_time   --'受理时间'
,COALESCE(t3.require_time,cast(0 as timestamp))as require_time    --'要求时间'
,COALESCE(t3.resolved_time,cast(0 as timestamp))as resolved_time    --'解决时间'
,COALESCE(t3.action_type,0)as action_type   --'处理方式, 99-未处理，0-无，10-扣款，20-还款'
,COALESCE(t3.action_value,'0')as action_value   --'处理值'
,COALESCE(t3.action_result,0)as action_result   --'处理结果（10成功，20出错，30超时）'
--订单相关
,COALESCE(t3.service_id,'0')as order_id   --'工单关联订单ID'
,COALESCE(t3.shop_id,0)as shop_id    --'订单商家ID'
,COALESCE(t3.shop_name,'0')as shop_name   --'订单商家名称'
,COALESCE(t3.status,'0')as order_status   --'订单状态'
,COALESCE(t3.place_time,cast(0 as timestamp))as place_time    --'订单下单时间'
,COALESCE(t3.arrive_time,cast(0 as timestamp))as arrive_time    --'订单骑手到店时间'
,COALESCE(t3.leave_time,cast(0 as timestamp))as leave_time   --'订单骑手离店时间'
,COALESCE(t3.finish_time,cast(0 as timestamp))as finish_time    --'订单完结时间'
,case when t3.resolved_time is NULL then 'unfinish' else '20181021' end as pt
FROM 
  (
    SELECT s1.rider_id
    ,s1.rule_id   --'规则ID'
    ,s1.rule_name   --'规则名称'
    ,s1.city_id   --'订单城市ID'
    ,case when s1.source_type=1 then '工单'
      when s1.source_type=2 then '风控'
      else '0' end as source_name  --"违规事件来源" 
    ,s1.create_time
    ,s1.source_event_id as workorder_id 
    ,'0' as pt
    FROM 
      ods.rider_court_punish_event s1   --违规事件表
    WHERE s1.pt='20181021'

    union all

    SELECT s2.source_id as rider_id
    ,case when s2.item_code='10236' then 28
      when s2.item_code in('030902','030801') then 72
      else 0 end as rule_id
    ,case when s2.item_code='10236' then '拍摄票据不规范'
      when s2.item_code in('030902','030801') then '恶意申诉'
      else 0 end as rule_name
    ,s2.city_id
    ,'风控' as source_name
    ,s2.create_time
    ,s2.id as workorder_id
    ,'0' as pt
    FROM ods.workorderdb_workorder s2   --工单表
    WHERE s2.pt='20181021'
    AND s2.item_code IN ('030902','030801','10236')
  )t1
  LEFT JOIN (
    SELECT tb1.*  
    ,tb2.shop.shop_id as shop_id    --'订单商家ID'
    ,tb2.shop.shop_name as shop_name   --'订单商家名称'
    ,tb2.status as order_status   --'订单状态'
    ,tb2.place_time as place_time    --'订单下单时间'
    ,tb2.arrive_time as arrive_time    --'订单骑手到店时间'
    ,tb2.leave_time as leave_time   --'订单骑手离店时间'
    ,tb2.finish_time as finish_time    --'订单完结时间' 
    ,tb4.platform_shop_name
    FROM da.dwb_workorder_base_df tb1
    LEFT JOIN (
      SELECT * FROM da.dws_order_base_di where pt='20181021') tb2  ON tb1.service_id=tb2.order_id
    LEFT JOIN (
      SELECT * FROM da.dim_platform_shop_df WHERE pt='20181021') tb4 ON tb1.platform_shop_id = tb4.platform_shop_id
    WHERE tb1.pt='20181021'    
    ) t3 ON t1.workorder_id=t3.workorder_id
LEFT JOIN (
    SELECT tb3.*,tb4.city_name FROM da.dwb_rider_df tb3
    LEFT JOIN (
      SELECT * FROM da.dim_city_df WHERE pt='20181021') tb4 ON tb3.city_id = tb4.city_id
    WHERE tb3.pt='20181021'
    ) t2 ON t1.rider_id=t2.rider_id
LEFT JOIN (
    SELECT * FROM da.dim_city_df WHERE pt='20181021') t4 ON t1.city_id = t4.city_id

