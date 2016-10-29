--
-- Derive the IBM i operating system level and then 
-- determine the level of currency of PTF Groups
-- 
With iLevel(iVersion, iRelease) AS
(
select OS_VERSION, OS_RELEASE from sysibmadm.env_sys_info
)
SELECT P.*
FROM iLevel, systools.group_ptf_currency P
WHERE ptf_group_release = 
'R' CONCAT iVersion CONCAT iRelease concat '0'
ORDER BY ptf_group_level_available -
ptf_group_level_installed DESC;
