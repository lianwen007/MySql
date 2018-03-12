BEGIN
	#Routine body goes here...
INSERT ignore INTO xhschool_info(iSchoolId,
sSchoolName,
bDelete,
tCreateDate,
iCreateUserId,
tLastModifyDate,
iLastModifyUserId,
iStatus,
bWelfare,
iStage,
sCode,
sAbbr,
iType,
iApprovalStatus,
oContacts,
sImages,
sOrganizationCode,
sTags,
iRunLevel,
sProvinceName,
sCityName,
sCountyName,
sDetailedAddress,
tSchoolDate,
iMainRunUserId,
sRunUserId)
(
SELECT * from xh_webmanage.XHSchool_Info where ischoolid>4848 and ischoolid <10000
);

END
