-- ��ѯ�û���صĶ���
1.�鿴�����û���
select * from dba_users;  
select * from all_users;  
select * from user_users; 

2.�鿴�û����ɫϵͳȨ��(ֱ�Ӹ�ֵ���û����ɫ��ϵͳȨ��)��
select * from dba_sys_privs;  
select * from user_sys_privs; 

3.�鿴��ɫ(ֻ�ܲ鿴��½�û�ӵ�еĽ�ɫ)��������Ȩ��
sql>select * from role_sys_privs; 

4.�鿴�û�����Ȩ�ޣ�
select * from dba_tab_privs;  
select * from all_tab_privs;  
select * from user_tab_privs; 

5.�鿴���н�ɫ��
select * from dba_roles; 

6.�鿴�û����ɫ��ӵ�еĽ�ɫ��
select * from dba_role_privs;  
select * from user_role_privs; 

7.�鿴��Щ�û���sysdba��sysoperϵͳȨ��(��ѯʱ��Ҫ��ӦȨ��)
select * from V$PWFILE_USERS  


-- ��ѯ���еı�ռ�����
select tablespace_name from dba_tablespaces;

-- �鿴��־�洢ռ�����
select * from V$FLASH_RECOVERY_AREA_USAGE; 