-- DBA_objects��all_objects
-- all_triggers��user_triggers
--���д�����
Select object_name From user_objects Where object_type='TRIGGER';
SELECT owner,trigger_name,trigger_type,status FROM all_triggers;
--���д洢����
Select object_name From user_objects Where object_type='PROCEDURE';
select * from user_procedures
--������ͼ
Select object_name From user_objects Where object_type='VIEW';
--���б�
Select object_name From user_objects Where object_type='TABLE';

-- ��ѯ���ֶκ�ע�Ͷ���� �ο���https://blog.csdn.net/yali1990515/article/details/75084471
select 
      ut.COLUMN_NAME,--�ֶ�����
      uc.comments,--�ֶ�ע��
      ut.DATA_TYPE,--�ֵ�����
      ut.DATA_LENGTH,--�ֵ䳤��
      ut.NULLABLE--�Ƿ�Ϊ��
from user_tab_columns  ut
inner JOIN user_col_comments uc
on ut.TABLE_NAME  = uc.table_name and ut.COLUMN_NAME = uc.column_name
where ut.Table_Name='RC_METADATA' 
order by ut.column_name