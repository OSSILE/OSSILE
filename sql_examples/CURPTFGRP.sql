--
-- Derive the IBM i operating system level and then 
-- determine the level of currency of PTF Groups.
-- Requires Admin server to be running
-- 
With iLevel(iVersion, iRelease) AS
(
select OS_VERSION, OS_RELEASE from sysibmadm.env_sys_info
)
SELECT VARCHAR(GRP_CRNCY,25) AS "GRPCUR",
GRP_ID, VARCHAR(GRP_TITLE, 20) AS "NAME",
GRP_LVL, GRP_IBMLVL, GRP_LSTUPD,
GRP_RLS, GRP_SYSSTS
FROM iLevel, systools.group_ptf_currency P
WHERE ptf_group_release =
'R' CONCAT iVersion CONCAT iRelease concat '0'
ORDER BY ptf_group_level_available -
ptf_group_level_installed DESC
