SELECT 
ID
, [NAME]
, NETWORKALIAS
, NETWORKDOMAIN
, [SID]
, IDENTITYPROVIDER
, COMPANY
, [ENABLE]
FROM USERINFO
WHERE NETWORKALIAS LIKE @Email