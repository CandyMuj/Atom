--1����ѯ��ռ�ʹ�����
select a.tablespace_name ��ռ�����,
       total "�ܿռ䣨M��",
       free "ʣ��ռ䣨M��",
       total - free as "��ʹ�ÿռ䣨M��",
       substr(free / total * 100, 1, 5) as ʣ�����,
       substr((total - free) / total * 100, 1, 5) as ��ʹ����
  from (select tablespace_name, sum(bytes) / 1024 / 1024 as total
          from dba_data_files
         group by tablespace_name) a,
       (select tablespace_name, sum(bytes) / 1024 / 1024 as free
          from dba_free_space
         group by tablespace_name) b
 where a.tablespace_name = b.tablespace_name
 order by a.total desc;

--2����ѯ��ռ�������ļ���ţ�
select * from dba_data_files c where c.tablespace_name = '��ռ�ȫ��';

--3.  ��������ļ�����ռ䣺��file_name���������+1��
alter tablespace ��ռ�ȫ�� add datafile '�����ļ�����·��������' size 10G autoextend off;
    
--���磺
alter tablespace METADB_V2 add datafile '/Data/app/oracle/oradata/sctower/metadb_v2_03.dbf' size 10G autoextend off;