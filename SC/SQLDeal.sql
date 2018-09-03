-- dwd_duowei_apps
SELECT id as id
 ,collect_id as person_id
 ,app_name as name
 ,version_name as version
 ,null as type
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,package_name as package_name
 ,version_code as version_code
 ,valid_flag as valid_flag
 ,app_type as app_type
 ,app_size as app_size
 ,install_time as install_time
 ,install_path as install_path
 ,data_flag as data_flag
 ,'I' dwd_op_type
 ,null as dwd_server_date
 ,null as dwd_sync_date
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_app_info a;

-- dwd_duowei_bluetooth_access
SELECT id as id
 ,collect_id as person_id
 ,relationship_bt_dev_name as name
 ,null as bluetooth_type_dm
 ,null as alias
 ,relationship_bt_mac as mac
 ,null as longitude
 ,null as latitude
 ,null as altitide
 ,null as scantime
 ,conn_time as connecttime
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as bluetooth_type_name
 ,null as dwd_server_date
 ,null as dwd_sync_date
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_conn_bluetooth a; 
 
 
-- dwd_duowei_bluetooth_his
SELECT id as id
 ,collect_id as person_id
 ,relationship_bt_mac as friend_bluetooth_mac
 ,file_name as mime_name
 ,file_path as mime_path
 ,file_type as mime_type_dm
 ,conn_time as start_time
 ,find_time as end_time
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case FILE_TYPE when 1 then '文本' when 2 then '图片' when 3 then '语音' when 4 then '视频' when 5 then '文件' when 9 then '其他' end mime_type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_conn_bluetooth a;
   
-- dwd_duowei_calendar
select a.id as id 
 ,a.collect_id as person_id
 ,a.title as event 
 ,a.event_place as place 
 ,a.content 
 ,a.start_time
 ,a.end_time
 ,null as createtime
 ,null as latest_mod_time
 ,a.del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,a.app_type
 ,a.notice_rule
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_calendar a
   
-- dwd_duowei_ecom_account
select id as id
 ,collect_id as tradingid
 ,account as accountname
 ,null as displayname
 ,null as password
 ,app_type as app_id_dm
 ,null as lastlogin
 ,deal_flag as deal_status_dm
 ,DESCRIPTION as relafulldesc
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as area
 ,null as city_code_dm
 ,null as fixed_phone
 ,null as msisdn 
 ,null as email_account
 ,null as certificate_type_dm
 ,null as certificate_no
 ,'9' as sexcode
 ,null as age
 ,null as postal_address
 ,null as postal_code
 ,null as occupation_name
 ,null as blood_type_dm 
 ,null as name
 ,null as sign_name
 ,null as personal_desc
 ,null as reg_city
 ,null as graduateschool
 ,null as zodiac 
 ,null as constallation
 ,null as birthday 
 ,null as app_mac 
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as app_id_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,null as blood_type_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_ecom_deal a ;
 
 
-- dwd_duowei_ecom_goodsrecord
select id as id
 ,collect_id as account_id
 ,null as goodsrecordtype_id
 ,save_folder as goodssource_dm
 ,goods_id as goodscode
 ,goods_name as goodsname
 ,goods_url as goodsurl
 ,null as goodscount
 ,goods_price as money
 ,sall_count as buycount
 ,description as extract_desc
 ,create_time as recordtime
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,shop_id as shop_id
 ,shop_name as shop_name
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case SAVE_FOLDER when 1 then '收藏夹' when 2 then '购物车' when 3 then '已购买' when 4 then '普通浏览' when 99 then '其他' end as goodssource_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_ecom_goods a ;
 
-- dwd_duowei_ecom_searchrecord
select id as id
 ,collect_id as account_id
 ,keyword as keyword
 ,search_time as searchtime
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_ecom_search a ;
 
-- dwd_duowei_ecom_shop
select id as id
 ,account as account_id
 ,shop_id as shop_id
 ,shop_name as shop_name
 ,creater_account as friend_id
 ,creater_account as friend_account
 ,creater_nickname as friend_nickname
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,collect_id as collect_id
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_ecom_shops a ;

-- dwd_duowei_ecom_tradingrecord
select id as id
 ,account as account_id
 ,collect_id as tradingid
 ,null as tradingname
 ,friend_account as partnerid
 ,friend_nickname as partnername
 ,case direction when 1 then 2 when 2 then 1 when 0 then 0 end as tradingtype_dm
 ,null as tradingnum
 ,null as goodsname
 ,price as tradingsum
 ,deal_time as tradingtime
 ,null as rec_name
 ,null as rec_phone
 ,null as rec_addr
 ,deal_flag as deal_status_dm
 ,DESCRIPTION as relafulldesc
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,account as account
 ,friend_account as friend_account
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case direction when 1 then '支出' when 2 then '收入' when 0 then '未知' end as tradingtype_name
 ,case deal_flag when 0 then '未知' when 1 then '交易未开始' when 2 then '交易中' when 3 then '交易完成' when 4 then '交易关闭' when 9 then '其他' end as deal_status_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_ecom_deal a ;
 
-- dwd_duowei_email
select id as id 
 ,account as account_id
 ,from_address as mail_from
 ,to_address as mail_to
 ,cc_address as cc
 ,bcc_address as bcc
 ,subject as subject
 ,content
 ,null as bodypath
 ,send_time as senddate
 ,save_folder as mail_save_folder_dm
 ,read_flag as isread
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,app_type as app_type
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,collect_id
 ,case save_folder when 1 then '收件箱' when 2 then '发件箱' when 3 then '草稿箱' when 4 then '垃圾箱' when 5 then '回收站' when 9 then '其他' end as mail_save_folder_name
 ,'I' as dwd_op_type,null as dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') as dwd_batch,'02' as dwd_source
 from kn_mf_email_content a; 
 
-- duowei_email_account
select a.id as id
 ,a.collect_id as person_id
 ,null as appname
 ,a.app_type as app_id_dm
 ,a.account as address
 ,null as displayname
 ,null as password
 ,null as sign 
 ,a.del_flag
 ,null as remark
 ,a.take_time as client_date
 ,a.upload_time as server_date
 ,null as sync_date
 ,null as install_time
 ,a.country as area
 ,null as city_code_dm
 ,a.telephone as fixed_phone
 ,a.mobile as msisdn
 ,null as certificate_type_dm
 ,null as certificate_no
 ,a.sex as sexcode
 ,a.age
 ,a.address as postal_address
 ,null as postal_code
 ,a.occupation as occupation_name
 ,a.blood_type as blood_type_dm
 ,a.real_name as name
 ,a.signature as sign_name
 ,a.personal_desc
 ,a.city as reg_city
 ,a.school as graduateschool
 ,null as zodiac
 ,a.constellation 
 ,a.birthday 
 ,null as app_mac
 ,a.data_flag
 ,a.valid_flag
 ,null as app_id_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_email_contact a
 
 
-- duowei_email_attachment
select a.id as id
 ,b.email_id
 ,a.file_name 
 ,a.file_path
 ,a.del_flag
 ,null as remark
 ,a.take_time as client_date
 ,a.upload_time as server_date
 ,null as sync_date
 ,a.data_flag
 ,a.valid_flag
 ,'I' as dwd_op_type
 ,null as dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') as dwd_batch
 ,'02' as dwd_source
 from kn_mf_email_attachment a 
 left join kn_mf_email_content b 
 on a.sequence = b.sequence
 
-- dwd_duowei_email_contact
select id as id
 ,account as account_id
 ,friend_account as address
 ,null as groupname
 ,friend_nickname as displayname
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as area
 ,null as city_code_dm
 ,telephone as fixed_phone
 ,mobile as msisdn
 ,null as certificate_type_dm
 ,null as certificate_no
 ,sex as sexcode
 ,age as age
 ,address as postal_address
 ,null as postal_code
 ,occupation as occupation_name
 ,blood_type as blood_type_dm
 ,real_name as name
 ,signature as sign_name
 ,personal_desc as personal_desc
 ,city as reg_city
 ,school as graduateschool
 ,null as zodiac
 ,constellation as constallation
 ,birthday as birthday
 ,app_type as app_type
 ,friend_remark as friend_remark
 ,face_id as face_id
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as city_code_name
 ,null as certificate_type_name
 ,collect_id as collect_id
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_email_contact a ;

-- dwd_duowei_email_search
select id as id
 ,collect_id as account_id
 ,'' as account
 ,search_time as createtime
 ,keyword as keyword
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,app_type as app_type
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_email_search a ;

 
--dwd_duowei_gps
select id as id 
 ,collect_id as person_id
 ,longitude
 ,latitude
 ,null as angle
 ,place_address as address
 ,login_time as connecttime
 ,null as source
 ,del_flag 
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,app_type as app_type
 ,place_name as place_name
 ,gps_type as gps_type
 ,data_flag
 ,valid_flag
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_gps_position a 
 
 
-- dwd_duowei_im_contact
select id as id
 ,collect_id as profile_id
 ,app_type as account_type_dm
 ,collect_id as account_id
 ,account as account
 ,friend_account as friend_id
 ,friend_account as friend_account
 ,friend_nickname as friend_nickname
 ,friend_group as friend_group
 ,friend_remark as friend_remark
 ,face_id as photo
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as area
 ,null as city_code_dm
 ,telephone as fixed_phone
 ,mobile as msisdn
 ,email as email_account
 ,null as certificate_type_dm
 ,null as certificate_no
 ,sex as sexcode
 ,age as age
 ,address as postal_address
 ,null as postal_code
 ,occupation as occupation_name
 ,blood_type as blood_type_dm
 ,real_name as name
 ,signature as sign_name
 ,personal_desc as personal_desc
 ,city as reg_city
 ,school as graduateschool
 ,null as zodiac
 ,constellation as constallation
 ,birthday as birthday
 ,friend_type as friend_type
 ,face_id as face_id
 ,country as country
 ,company as company
 ,hometown as hometown
 ,mood as mood
 ,hobbies as hobbies
 ,homepage as homepage
 ,last_login_time as last_login_time
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_im_friend a ;

-- dwd_duowei_im_gmember
select id as id
 ,collect_id as profile_id
 ,app_type as account_type_dm
 ,group_account as groupnum
 ,group_name as groupname
 ,member_account as friend_id
 ,member_account as friend_account
 ,member_nickname as friend_nickname
 ,member_remark as friend_remark
 ,null as area
 ,null as city_code_dm
 ,telephone as fixed_phone
 ,mobile as msisdn
 ,email as email_account
 ,null as certificate_type_dm
 ,null as certificate_no
 ,sex as sexcode
 ,age as age
 ,address as postal_address
 ,null as postal_code
 ,occupation as occupation_name
 ,blood_type as blood_type_dm
 ,real_name as name
 ,signature as sign_name
 ,personal_desc as personal_desc
 ,city as reg_city
 ,school as graduateschool
 ,null as zodiac
 ,constellation as constallation
 ,birthday as birthday
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,account as account
 ,country as country
 ,company as company
 ,hometown as hometown
 ,mood as mood
 ,hobbies as hobbies
 ,homepage as homepage
 ,last_login_time as last_login_time
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_member a ;

-- dwd_duowei_im_group
select id as id
 ,collect_id as profile_id
 ,app_type as account_type_dm
 ,group_account as groupnum
 ,group_name as groupname
 ,creater_account as friend_id
 ,creater_account as friend_account
 ,creater_nickname as group_owner_nickname
 ,member_count as members
 ,max_member_count as group_max_member_cout
 ,description as intro
 ,announcement as bulletin
 ,group_name as displayname
 ,open_flag as isdiscusse
 ,del_flag as del_flag
 ,group_remark as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,account as account
 ,group_type as group_type
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group a ;

-- dwd_duowei_im_message
select id as id
 ,collect_id as profile_id
 ,app_type as account_type_dm
 ,null as msgid
 ,2 as type_dm
 ,collect_id as account_id
 ,account as account
 ,null as nickname
 ,GROUP_ACCOUNT as otherid
 ,GROUP_NAME as group_name
 ,content as message
 ,SENDER_ACCOUNT as senderid
 ,SENDER_NICKNAME as sendername
 ,send_time as createtime
 ,null as orderindex
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,msg_type as filetype
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,'群组' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_msg a;
 union all
 select id as id
 ,collect_id as profile_id
 ,app_type as account_type_dm
 ,null as msgid
 ,1 as type_dm
 ,collect_id as account_id
 ,account as account
 ,null as nickname
 ,null as otherid
 ,null as group_name
 ,content as message
 ,friend_account as senderid
 ,friend_nickname as sendername
 ,send_time as createtime
 ,null as orderindex
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,msg_type as filetype
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,'好友' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_im_friend_msg a
  union all       
 select id as id
 ,collect_id as profile_id
 ,app_type as account_type_dm
 ,null as msgid
 ,1 as type_dm
 ,collect_id as account_id
 ,account as account
 ,null as nickname
 ,null as otherid
 ,null as group_name
 ,content as message
 ,friend_account as senderid
 ,friend_nickname as sendername
 ,send_time as createtime
 ,null as orderindex
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,msg_type as filetype
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,'好友' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_dr_im_friend_msg a;
 
 
-- dwd_duowei_im_profile

select a.id as id
 ,a.collect_id as person_id
 ,a.app_type as account_id_dm
 ,a.account as account_id
 ,a.account as account
 ,null as nickname
 ,null as password
 ,null as remark
 ,a.take_time as client_date
 ,a.upload_time as server_date
 ,null as sync_date
 ,null as install_time
 ,a.country as area
 ,null as city_code_dm
 ,a.telephone as fixed_phone
 ,a.mobile as msisdn
 ,null as email_account
 ,null as certificate_type_dm
 ,null as certificate_no
 ,a.sex as sexcode
 ,a.address as postal_address
 ,null as postal_code
 ,a.occupation as occupation_name
 ,a.blood_type as blood_type_dm
 ,a.real_name as name
 ,a.signature as sign_name
 ,a.personal_desc
 ,a.city as reg_city
 ,a.school as graduateschool
 ,null as zodiac
 ,a.constellation 
 ,a.birthday 
 ,null as app_mac
 ,a.data_flag
 ,a.valid_flag
 ,null as account_type_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_im_friend a
 where a.app_type not in (11001,11002)

-- dwd_duowei_im_search
select id as id
 ,collect_id as person_id
 ,app_type as account_type_dm
 ,account as account_id
 ,account as account
 ,search_time as createtime
 ,keyword as keyword
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_search a; 

-- dwd_duowei_map_navigation
select id as id
 ,collect_id as person_id
 ,collect_id as account_id
 ,collect_id as account
 ,start_place_address as startaddr
 ,start_latitude as startlat
 ,start_longitude as startlon
 ,start_above_sealevel as startalt
 ,null as startcitycode
 ,start_time as starttime
 ,end_place_address as endaddr
 ,end_latitude as endlat
 ,end_longitude as endlon
 ,end_above_sealevel as endalt
 ,null as endcitycode
 ,end_time as endtime
 ,null as navitime
 ,null as positypeid_dm
 ,app_type as app_id_dm
 ,flight_num as flightid
 ,price as purchase_price
 ,null as aircom
 ,null as order_num
 ,del_flag as del_flag
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,start_place_address as start_place_name
 ,end_place_address as end_place_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_gps_route a ;

-- dwd_duowei_map_position
select id as id
 ,collect_id as person_id
 ,collect_id as account_id
 ,collect_id as account
 ,latitude as latitude
 ,longitude as longitude
 ,above_sealevel as altitide
 ,place_address as address
 ,login_time as gpstime
 ,login_time as login_time
 ,app_type as app_id_dm
 ,gps_type as gps_type
 ,place_address as address
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,del_flag
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_gps_position a ;
 
 
-- dwd_duowei_map_search
select id as id
 ,collect_id as profile_id
 ,collect_id as account_id
 ,'' as account
 ,search_time as createtime
 ,keyword as keyword
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_gps_search a ;


-- dwd_duowei_map_user
select id as id
 ,collect_id as person_id
 ,app_type as app_id_dm
 ,collect_id as account_id
 ,collect_id as account
 ,null as regis_nickname
 ,null as password
 ,null as install_time
 ,null as area
 ,place_name as city_code_dm
 ,null as fixed_phone
 ,null as msisdn 
 ,null as email_account
 ,null as certificate_type_dm
 ,null as certificate_no
 ,'9' as sexcode
 ,null as age
 ,null as postal_address
 ,null as postal_code
 ,null as occupation_name
 ,null as blood_type_dm 
 ,null as name
 ,null as sign_name
 ,null as personal_desc
 ,null as reg_city
 ,null as graduateschool
 ,null as zodiac 
 ,null as constallation
 ,null as birthday 
 ,null as app_mac
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag 
 ,null as app_id_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,null as blood_type_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_gps_position a ;
 
 
-- dwd_duowei_memo
SELECT id as id
 ,collect_id as person_id
 ,title as title
 ,event_place as place
 ,content as content
 ,start_time as starttime
 ,end_time as endtime
 ,start_time as createdate
 ,end_time as updatedate
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,valid_flag as valid_flag
 ,data_flag as data_flag
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_calendar a;

-- dwd_duowei_person
select     a.collect_id as id
 ,null as pno
 ,max(a.o_name) as name
 ,null as pinyin
 ,null as alias
 ,'9' as sexcode
 ,max(a.o_identify_type) as certificate_type_dm
 ,max(a.o_identify_num) as certificate_no
 ,max(b.mobile) as phonenum
 ,max(b.other_mobile) as phonenum1
 ,null as phonenum2
 ,null as phonenum3
 ,max(b.iccid) as iccid
 ,max(b.imsi) as imsi
 ,max(b.imei) as imei
 ,max(b.wifi_mac) as mac_wifi
 ,max(b.bluetooth_mac) as mac_bt
 ,max(b.model) as phonetype
 ,null as security_software_org_dm
 ,max(manufacturer_code) as manufacturer
 ,null as characteristic_desc
 ,max(b.os) as phoneosver
 ,null as org
 ,max(a.o_hometown) as address
 ,null as persontype
 ,max(a.wsba_case_id) as caseno
 ,max(a.case_type) as case_type_dm
 ,null as case_name
 ,null as casedesc
 ,max(a.description) as remark
 ,max(a.policestation_code) as dept_dm
 ,max(a.police_id) as user_dm
 ,max(a.police_name) as user_name
 ,max(a.policestation_area) as area_code
 ,null as data_level
 ,null as longitude
 ,null as latitude
 ,max(a.device_id) as device_id
 ,null as device_name
 ,max(a.take_time) as client_date
 ,max(a.upload_time) as server_date
 ,null as sync_date
 ,null as incharge_wa_department_dm
 ,max(b.brand) as brand
 ,max(b.serial_id) as serial_id
 ,null as handset_type
 ,max(b.center_number) as center_number
 ,null as case_belong
 ,max(a.collect_id) as collect_id
 ,max(a.data_flag) as data_flag
 ,max(a.valid_flag) as valid_flag
 ,null as resource_ip
 ,null as resource_path
 ,null as certificate_type_name
 ,null as security_software_org_name
 ,max(a.policestation_addr) as dept_name
 ,null as incharge_wa_department_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_base_info a
 LEFT JOIN KN_MF_DEVICE_INFO b ON a.COLLECT_ID = b.COLLECT_ID AND b.DATA_FLAG = '0'
 group by a.collect_id;
 
-- dwd_duowei_phone_calllog
select id as id
 ,collect_id as person_id
 ,o_mobile as msisdn
 ,relationship_phone as phonenum
 ,relationship_name as relationship_name
 ,to_timestamp(CASE SEND_TIME WHEN '0' THEN NULL ELSE SEND_TIME END,'YYYY')::timestamp(0)without time zone as calltime
 ,to_timestamp(CASE SEND_TIME WHEN '0' THEN NULL ELSE SEND_TIME END,'YYYY')::timestamp(0)without time zone + (duration || ' sec')::interval as end_time
 ,duration as duration
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,case DIRECTION when 1 then '1' when 2 then '1' when 0 then '9' when 99 then '9' end as status_dm
 ,data_source as datasource_dm
 ,null as physeq
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as privacyconfig_dm
 ,attribution as attribution
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case DIRECTION when 1 then '接通' when 2 then '接通' when 0 then '其他' when 99 then '其他' end as status_name
 ,case DIRECTION when 1 then '拨打' when 2 then '接听' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,case DATA_SOURCE when 1 then '手机' when 2 then 'SIM卡' when 3 then '文件' end as datasource_name
 ,null as privacyconfig_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_dr_calls a
 union all
 select id as id
 ,collect_id as person_id
 ,o_mobile as msisdn
 ,relationship_phone as phonenum
 ,relationship_name as relationship_name
 ,send_time as calltime
 ,send_time::timestamp + (duration || ' sec')::interval as end_time
 ,duration as duration
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,case DIRECTION when 1 then '1' when 2 then '1' when 0 then '9' when 99 then '9' end as status_dm
 ,data_source as datasource_dm
 ,null as physeq
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as privacyconfig_dm
 ,attribution as attribution
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case DIRECTION when 1 then '接通' when 2 then '接通' when 0 then '其他' when 99 then '其他' end as status_name
 ,case DIRECTION when 1 then '拨打' when 2 then '接听' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,case DATA_SOURCE when 1 then '手机' when 2 then 'SIM卡' when 3 then '文件' end as datasource_name
 ,null as privacyconfig_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_calls a;
       
-- dwd_duowei_phone_contact
select id as id
 ,collect_id as person_id
 ,contact_name as name
 ,contact_name as pinyin
 ,contact_name as name_initial
 ,phone_value_type_dm as phone_value_type_dm
 ,null as phone_number_type
 ,contact_value as phonenum
 ,data_source as datasource_dm
 ,null as physeq
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as privacyconfig_dm
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,phone_value_type_mc as phone_value_type_name
 ,case data_source when 1 then '手机' when 2 then 'SIM卡' when 3 then '文件' end as datasource_name
 ,null as privacyconfig_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_contact a
 left join (select b.value phone_value_type_dm,cast(b.value as INTEGER) phone_value_type_int,b.description phone_value_type_mc from ids_element a,ids_element_value b
 where a.id = b.element_id and b.element_id = 8) c
 on a.property = c.phone_value_type_int
 union all
 select id as id
 ,collect_id as person_id
 ,contact_name as name
 ,contact_name as pinyin
 ,contact_name as name_initial
 ,phone_value_type_dm as phone_value_type_dm
 ,null as phone_number_type
 ,contact_value as phonenum
 ,data_source as datasource_dm
 ,null as physeq
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as privacyconfig_dm
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,phone_value_type_mc as phone_value_type_name
 ,case data_source when 1 then '手机' when 2 then 'SIM卡' when 3 then '文件' end as datasource_name
 ,null as privacyconfig_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_dr_contact a
 left join (select b.value phone_value_type_dm,cast(b.value as INTEGER) phone_value_type_int,b.description phone_value_type_mc from ids_element a,ids_element_value b
 where a.id = b.element_id and b.element_id = 8) c
 on a.property = c.phone_value_type_int;
  
-- dwd_duowei_phone_mms
select id as id
 ,collect_id as person_id
 ,o_mobile as msisdn
 ,relationship_phone as phonenum
 ,relationship_name as relationship_name
 ,content as content
 ,file_path as mainfile
 ,send_time as smstime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,read_flag as isread_dm
 ,save_folder as mail_save_folder_dm
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_source as data_source
 ,attribution as attribution
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,case read_flag when 0 then '未读' when 1 then '已读' when 9 then '其他' end as isread_name
 ,case save_folder when 1 then '收件箱' when 2 then '发件箱' when 3 then '草稿箱' when 4 then '垃圾箱'else '其他' end as mail_save_folder_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_multimedia_sms a
 left join (SELECT distinct b.VALUE mail_save_folder_dm,CAST (b. VALUE AS INTEGER) mail_save_folder_int,b.description mail_save_folder_name
 FROM ids_element A,ids_element_value b WHERE A.ID = b.element_id AND a.id=22) c
 on a.save_folder = c.mail_save_folder_int;

-- dwd_duowei_phone_sms
select id as id
 ,collect_id as person_id
 ,o_mobile as msisdn
 ,relationship_phone as phonenum
 ,relationship_name as relationship_name
 ,content as content
 ,send_time as smstime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,read_flag as isread_dm
 ,save_folder as mail_save_folder_dm
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_source as datasource_dm
 ,case data_source when 1 then '手机' when 2 then 'SIM卡' end as datasource_name
 ,attribution as attribution
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,case read_flag when 0 then '未读' when 1 then '已读' when 9 then '其他' end as isread_name
 ,case save_folder when 1 then '收件箱' when 2 then '发件箱' when 3 then '草稿箱' when 4 then '垃圾箱'else '其他' end as mail_save_folder_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_sms a
 left join (select distinct b.value mail_save_folder_dm,cast(b.value as INTEGER) mail_save_folder_int,b.description mail_save_folder_mc from ids_element a,ids_element_value b
 where a.id = b.element_id and b.element_id = 17) c
 on a.save_folder = c.mail_save_folder_int
 union all
 select id as id
 ,collect_id as person_id
 ,o_mobile as msisdn
 ,relationship_phone as phonenum
 ,relationship_name as relationship_name
 ,content as content
 ,send_time as smstime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,read_flag as isread_dm
 ,save_folder as mail_save_folder_dm
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_source as datasource_dm
 ,case data_source when 1 then '手机' when 2 then 'SIM卡' end as datasource_name
 ,attribution as attribution
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,case read_flag when 0 then '未读' when 1 then '已读' when 9 then '其他' end as isread_name
 ,case save_folder when 1 then '收件箱' when 2 then '发件箱' when 3 then '草稿箱' when 4 then '垃圾箱'else '其他' end as mail_save_folder_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_dr_sms a
 left join (select distinct b.value mail_save_folder_dm,cast(b.value as INTEGER) mail_save_folder_int,b.description mail_save_folder_mc from ids_element a,ids_element_value b
 where a.id = b.element_id and b.element_id = 17) c
 on a.save_folder = c.mail_save_folder_int;

-- dwd_duowei_qq_contact
select id as id
 ,collect_id as profile_id
 ,account as account_id
 ,friend_group as subgroupnum
 ,friend_account as qq
 ,friend_nickname as nickname
 ,friend_remark as alias
 ,face_id as photo
 ,signature
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as area
 ,null as city_code_dm
 ,telephone as fixed_phone
 ,mobile as msisdn
 ,sex as sexcode
 ,age as age
 ,address as postal_address
 ,null as postal_code
 ,occupation as occupation_name
 ,blood_type as blood_type_dm
 ,real_name as name
 ,personal_desc as personal_desc
 ,city as reg_city
 ,school as graduateschool
 ,null as zodiac
 ,constellation as constallation
 ,birthday as birthday
 ,mood as signature
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_friend_qq a ;

-- dwd_duowei_qq_gmember
select id as id
 ,collect_id as profile_id
 ,account 
 ,group_account as groupnum
 ,group_name as groupname
 ,member_account as qq
 ,member_nickname as nickname
 ,member_remark as alias
 ,face_id as photo
 ,del_flag
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,telephone as fixed_phone
 ,mobile as msisdn
 ,email as email_account
 ,sex as sexcode
 ,age as age
 ,address as postal_address
 ,null as postal_code
 ,occupation as occupation_name
 ,blood_type as blood_type_dm
 ,real_name as name
 ,signature as sign_name
 ,personal_desc as personal_desc
 ,city as reg_city
 ,school as graduateschool
 ,null as zodiac
 ,constellation as constallation
 ,birthday as birthday
 ,data_flag as data_flag 
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_member_qq a ;
 
-- dwd_duowei_qq_group
select id as id
 ,collect_id as profile_id
 ,group_account as groupnum
 ,group_name as groupname
 ,creater_account as admin_qq
 ,creater_nickname as admin_nickname
 ,member_count as group_member_count
 ,max_member_count as group_max_member_cout
 ,group_type as isdiscusse
 ,description as abstruct
 ,announcement as notice
 ,del_flag as del_flag
 ,group_remark as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,account as account
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_qq a ;
 
-- dwd_duowei_qq_message
select id as id
 ,collect_id as profile_id
 ,null as msgid
 ,2 as type_dm
 ,account as account
 ,GROUP_ACCOUNT as otherid
 ,GROUP_NAME as group_name
 ,content as message
 ,SENDER_ACCOUNT as senderid
 ,SENDER_NICKNAME as sendername
 ,send_time as createtime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,msg_type as filetype
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'群组' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_msg_qq a
 union all 
 select id as id
 ,collect_id as profile_id
 ,null as msgid
 ,1 as type_dm
 ,account as account
 ,null as otherid
 ,null as group_name
 ,content as message
 ,friend_account as senderid
 ,friend_nickname as sendername
 ,send_time as createtime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,msg_type as filetype
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'好友' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_friend_msg_qq a
 union all 
select id as id
 ,collect_id as profile_id
 ,null as msgid
 ,1 as type_dm
 ,account as account
 ,null as otherid
 ,null as group_name
 ,content as message
 ,friend_account as senderid
 ,friend_nickname as sendername
 ,send_time as createtime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,msg_type as filetype
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'好友' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_dr_im_friend_msg_qq a;
 

-- dwd_duowei_qq_profile

select a.id as id
 ,a.collect_id as person_id
 ,a.account as account
 ,null as nickname
 ,null as password
 ,a.face_id as photo
 ,null as type
 ,null as version
 ,a.last_login_time as lastlogin
 ,a.del_flag as del_flag
 ,null as remark
 ,a.take_time as client_date
 ,a.upload_time as server_date
 ,null as sync_date
 ,null as install_time
 ,a.country as area
 ,null as city_code_dm
 ,a.telephone as fixed_phone
 ,a.mobile as msisdn
 ,null as email_account
 ,null as certificate_type_dm
 ,null as certificate_no
 ,a.sex as sexcode
 ,a.age as age
 ,a.address as postal_address
 ,null as postal_code
 ,a.occupation as occupation_name
 ,a.blood_type as blood_type_dm
 ,a.real_name as name
 ,a.signature as sign_name
 ,a.personal_desc
 ,a.city as reg_city
 ,a.school as graduateschool
 ,null as zodiac
 ,a.constellation 
 ,a.birthday 
 ,null as app_mac
 ,a.data_flag
 ,a.valid_flag
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_qq_friend a
 where a.app_type in (11001)
 
 
-- dwd_duowei_qq_subgroup
select id as id
 ,collect_id as person_id
 ,group_account as groupnum
 ,group_name as groupname
 ,del_flag as del_flag
 ,group_remark as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type
 ,null dwd_vmd5
 ,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch
 ,'02' dwd_source
 from kn_mf_qq_group a ;
 

-- dwd_duowei_web_cookie
select id as id
 ,collect_id as person_id
 ,o_mobile as msisdn
 ,relationship_phone as phonenum
 ,relationship_name as relationship_name
 ,content as content
 ,file_path as mainfile
 ,send_time as smstime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,read_flag as isread_dm
 ,mail_save_folder_dm as mail_save_folder_dm
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_source as data_source
 ,attribution as attribution
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_browser_cookies a ;
 
-- dwd_duowei_web_favorite
select id as id
 ,collect_id as person_id
 ,access_name as title
 ,access_url as url
 ,create_time as createtime
 ,app_type as browse_type_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_browser_favorite a ;
 
-- dwd_duowei_web_history
select id as id
 ,collect_id as person_id
 ,title as title
 ,access_url as url
 ,access_time as visittime
 ,access_count as visitcount
 ,app_type as browse_type_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_browser_history a ;
 
-- dwd_duowei_web_keyword
select id as id
 ,collect_id as person_id
 ,keyword as keyword
 ,search_url as url
 ,search_time as searchtime
 ,app_type as browse_type_dm
 ,del_flag as del_flag
 ,title as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as browse_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_browser_search a ;
 
-- dwd_duowei_web_userinfo
select id as id
 ,collect_id as person_id
 ,app_type as browse_type_dm
 ,access_url as url
 ,login_name as account
 ,login_pwd as password
 ,null as app_mac
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as browse_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_browser_website_pwd a ;
 
-- dwd_duowei_weibo_message
select id as id
 ,collect_id as profile_id
 ,null as type
 ,sender_account as issuer
 ,sender_nickname as issuernick
 ,account as issuerid
 ,msg_type as message_type_dm
 ,null as portraitpath
 ,topic as weibo_topic
 ,content as issuecontent
 ,null as issueimagepath
 ,null as mblog_id
 ,null as relevant_mblog_id
 ,null as idroot_mblog_id
 ,null as root
 ,null as rootnick
 ,null as rootid
 ,null as rootcontent
 ,null as rootimagepath
 ,null as forwardcount
 ,null as commentcount
 ,null as likecount
 ,null as issuetime
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,app_type as app_type
 ,account as account
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case msg_type when 0 then '未知' when 1 then '原创' when 2 then '转发' when 3 then '评论点赞' when 9 then '其他' end as message_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_weibo_blog a ;
 
-- dwd_duowei_weibo_pmessage
select id as id
 ,collect_id as profile_id
 ,collect_id as chatid
 ,friend_account as friend_account
 ,account as friend_id
 ,friend_nickname as friend_nickname
 ,null as portraitpath
 ,content as content
 ,send_time as createtime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,app_type as app_type
 ,account as account
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_weibo_msg a ;
 
-- dwd_duowei_weibo_search
select id as id
 ,collect_id as profile_id
 ,collect_id as account_id
 ,collect_id as account
 ,search_time as createtime
 ,keyword as keyword
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_weibo_search a ;
 
-- dwd_duowei_weixin_contact
select id as id
 ,collect_id as profile_id
 ,account as account_id
 ,friend_account as wechatid
 ,friend_nickname as nickname
 ,friend_remark as alias
 ,sex as sexcode 
 ,face_id as photo
 ,email as email
 ,signature
 ,homepage as domain
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,null as area
 ,null as city_code_dm
 ,telephone as fixed_phone
 ,mobile as mobile
 ,age as age
 ,address as postal_address
 ,null as postal_code
 ,occupation as occupation_name
 ,blood_type as blood_type_dm
 ,real_name as name
 ,personal_desc as personal_desc
 ,city as reg_city
 ,school as graduateschool
 ,null as zodiac
 ,constellation as constallation
 ,birthday as birthday
 ,mood as signature
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,null as city_code_name
 ,null as certificate_type_name 
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_friend_weixin a ;
 
-- dwd_duowei_weixin_gmember
select id as id
 ,collect_id as profile_id
 ,account 
 ,group_account as gwechatid
 ,group_name as gwechatname
 ,member_account as wechatid
 ,member_account as friend_account
 ,member_nickname as nickname
 ,member_remark as alias
 ,sex as sexcode
 ,email as email
 ,face_id as photo
 ,signature
 ,homepage as domain
 ,mobile
 ,del_flag
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,telephone as fixed_phone
 ,age as age
 ,address as postal_address
 ,null as postal_code
 ,occupation as occupation_name
 ,blood_type as blood_type_dm
 ,real_name as name
 ,personal_desc as personal_desc
 ,city as reg_city
 ,school as graduateschool
 ,null as zodiac
 ,constellation as constallation
 ,birthday as birthday
 ,data_flag as data_flag 
 ,valid_flag as valid_flag
 ,null as account_type_name
 ,null as city_code_name
 ,null as certificate_type_name
 ,case a.blood_type::int when 0 then '未知' when 1 then 'A型'when 2 then 'B型' when 3 then 'O型' when 4 then 'AB型' when 9 then '其他' end as blood_type_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_member_weixin a ;
 
-- dwd_duowei_weixin_group
select id as id
 ,collect_id as profile_id
 ,group_account as gwechatid
 ,group_name as groupname
 ,creater_account as friend_account
 ,creater_nickname as group_owner_nickname
 ,member_count as group_member_count
 ,max_member_count as group_max_member_cout
 ,description as group_description
 ,announcement as group_notice
 ,del_flag as del_flag
 ,group_remark as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,account as account
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_weixin a ;
 
-- dwd_duowei_weixin_message
select id as id
 ,collect_id as profile_id
 ,null as msgid
 ,2 as type_dm
 ,account as account
 ,GROUP_ACCOUNT as otherid
 ,GROUP_NAME as group_name
 ,content as message
 ,SENDER_ACCOUNT as senderid
 ,SENDER_NICKNAME as sendername
 ,send_time as createtime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'群组' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_group_msg_weixin a
 union all
  select id as id
 ,collect_id as profile_id
 ,null as msgid
 ,1 as type_dm
 ,account as account
 ,null as otherid
 ,null as group_name
 ,content as content
 ,friend_account as senderid
 ,friend_nickname as sendername
 ,send_time as createtime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'好友' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_im_friend_msg_qq a
 union all 
 select id as id
 ,collect_id as profile_id
 ,null as msgid
 ,1 as type_dm
 ,account as account
 ,null as otherid
 ,null as group_name
 ,content as content
 ,friend_account as senderid
 ,friend_nickname as sendername
 ,send_time as createtime
 ,case DIRECTION when 1 then '02' when 2 then '01' when 0 then '99' when 99 then '99' end as local_action_dm
 ,del_flag as del_flag
 ,null as remark
 ,take_time as client_date
 ,upload_time as server_date
 ,null as sync_date
 ,res_path as filepath
 ,data_flag as data_flag
 ,valid_flag as valid_flag
 ,'好友' as type_name
 ,case DIRECTION when 1 then '发送' when 2 then '接收' when 0 then '其他' when 99 then '其他' end as local_action_name
 ,'I' dwd_op_type,null dwd_vmd5,concat(to_char(now(),'YYYY-MM-DD'),'-01') dwd_batch,'02' dwd_source
 from kn_mf_dr_im_friend_msg_qq a;
