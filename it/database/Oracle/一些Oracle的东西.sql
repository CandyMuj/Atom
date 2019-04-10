-- Oracle��������
CREATE SEQUENCE emp_sequence  --������
INCREMENT BY 1		      -- ÿ�μӼ���  
START WITH 1		      -- ��1��ʼ����  
NOMAXVALUE		      -- ���������ֵ  
NOCYCLE			      -- һֱ�ۼӣ���ѭ��  
CACHE 10;

-- �޸�����ÿ�����Ӷ���
ALTER SEQUENCE seq_name INCREMENT BY 1000

--��������
CREATE UNIQUE INDEX rms_portinfo_in ON RMS_PORT_INFO(city_id,zh_label,stateflag,source_ne)
  tablespace RMS_INDX_TABSPACE_1
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
tablespace users pctfree 10 initrans 2 maxtrans 255 storage ( initial 1m next 1m minextents 1 maxextents unlimited )

--����������������
set serveroutput on

--�����洢����
create or replace procedure procedure_name
is
begin
  
end;
/

--���ı������
alter table busi_system_info rename to rms_sys_info;


--��ѯ��ǰ����
select * from user_indexes where table_name='RMS_EQUIPMENT_INFO';   


-- �鿴��ͼ�����ƣ���ѯ�����û�����ͼʹ��ϵͳ��ͼ��all_views)
SQL>select view_name from user_views;
-- �鿴������ͼ��select���
SQL>select view_name,text_length from user_views;
SQL>set long 2000; --˵�������Ը�����ͼ��text_lengthֵ�趨set long �Ĵ�С
SQL>select text from user_views where view_name=upper('&view_name');


--���ע��
comment on table table_name is '';
comment on column table_name.column_name is '';