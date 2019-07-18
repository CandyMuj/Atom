-- ���½����޸�ִ�����ڴ洢��Ϊ���ʽ�ķ�ʽ����Ϊ�޷�ȷ����һ��ִ�е�ʱ�䣬Ҳ�޷�ʵ��ÿ��������ִ�У�ֻ���ǹ涨���������Ե����ڣ���ÿ�켸�㣬ÿ���ܼ�����֮����
-- ������ʱִ�����ñ�
create table timingrun_config(
       job number not null,
       priv_user varchar2(255) not null,
       what varchar2(255) not null,
       exec_cycle varchar2(255) not null,
       broken integer default 0 not null,
       remark varchar2(255)
);
comment on table timingrun_config is '��ʱִ�����ñ�';
comment on column timingrun_config.job is '����ʱΪ�գ���Ӻ���Զ�����';
comment on column timingrun_config.priv_user is '�洢���������û�����������towercrnop��';
comment on column timingrun_config.what is '�洢��������';
comment on column timingrun_config.exec_cycle is 'ִ�����ڱ��ʽ';
comment on column timingrun_config.broken is 'ִ��״̬���Ƿ�ִ�� 0��ֹͣ  1������';
comment on column timingrun_config.remark is '��������';

-- �������Ա�
create table test_ha(
       a date
);

-- �������ݶ�ʱͬ���Ĵ洢����
create or replace procedure towercrnop.datatimingsync
is
begin
  insert into test_ha values(sysdate);
  commit;
end;
/

-- ����һ����������
begin
insert into timingrun_config values(null,'towercrnop','datatimingsync','sysdate + 5/(24 * 60 * 60)',0);
commit;
end;
/

-- �򿪷��� set serveroutput on
-- ���濪ʼд������
-- ����ǰ
create or replace trigger timingrun_config_insert
before insert
on towercrnop.timingrun_config
for each row
declare
  pragma autonomous_transaction; -- ���������� ��������
  job number;
  whata timingrun_config.what%type;
  exec_cyclea timingrun_config.exec_cycle%type;
  brokena timingrun_config.broken%type;
BEGIN
  whata := :new.priv_user||'.'||:new.what||';';
  exec_cyclea := :new.exec_cycle;
  brokena := :new.broken;
  dbms_output.put_line('��ʱִ�д洢�������� ==> '||whata||' ִ������ ==> '||exec_cyclea||' �Ƿ����� ==> '||brokena);
  
  -- ����
  DBMS_JOB.SUBMIT(JOB       => job,  -- �Զ����ɵ�����id
                  WHAT      => whata,  -- Ҫִ�д˴洢����,����sql��� ע�⣺����ķֺŲ�����,���ҿ����ж����������÷ֺŷָ�
                  NEXT_DATE => sysdate, -- ����ִ��ʱ��,����ִ��
                  INTERVAL  => exec_cyclea);  -- ִ������
  COMMIT;
  dbms_output.put_line('job ==> '||job);

  -- ���jobֵ�����ñ�
  :new.job := job;
  
  -- �����ʼΪ1������
  if brokena = 1 then
      DBMS_JOB.RUN(job);
  else -- �������ֹͣ
      begin dbms_job.broken(job,true,sysdate);commit;end;
  end if;
end;
/

-- ���º�
create or replace trigger timingrun_config_update
after update
on towercrnop.timingrun_config
for each row
declare
  pragma autonomous_transaction; -- ���������� ��������
  counts number;
BEGIN
     dbms_output.put_line('job ==> '||:old.job);
     select count(1) into counts from all_jobs where job = :old.job;
     if :old.job is null or counts = 0 then
        raise_application_error(-20011,'jobΪ�ջ�ƻ�������!');
     end if;
     if :old.job <> :new.job or :old.job is null or :new.job is null then
        raise_application_error(-20010,'job�������޸Ļ�Ϊ��!');
     end if;
     -- �޸�ִ�в���
     if (:old.priv_user <> :new.priv_user) or (:old.what <> :new.what) then
       begin dbms_job.what(:old.job, :new.priv_user||'.'||:new.what||';');commit;end;
       dbms_output.put_line('�޸�ִ�в����ɹ� old ==> '||:old.priv_user||'.'||:old.what||'  new ==> '||:new.priv_user||'.'||:new.what);
     end if;
     -- �޸ļ��ʱ��
     if :old.exec_cycle <> :new.exec_cycle then
        begin dbms_job.interval(:old.job, :new.exec_cycle);commit;end;
        dbms_output.put_line('�޸ļ�����ڳɹ� old ==> '||:old.exec_cycle||'  new ==> '||:new.exec_cycle);
     end if;
     -- �޸�ִ��״̬
     if :old.broken <> :new.broken then
        if :new.broken = 1 then -- ����
            begin dbms_job.broken(:old.job, false, sysdate);commit;end;
            dbms_output.put_line('���óɹ�');
        else -- ֹͣ
            begin dbms_job.broken(:old.job, true, sysdate);commit;end;
            dbms_output.put_line('ֹͣ�ɹ�');
        end if;
        dbms_output.put_line('�޸�ִ��״̬�ɹ� old ==> '||:old.broken||'  new ==> '||:new.broken);
     end if;
end;
/

-- ɾ����
create or replace trigger timingrun_config_delete
after delete
on towercrnop.timingrun_config
for each row
declare
  pragma autonomous_transaction; -- ���������� ��������
  counts number;
BEGIN
     dbms_output.put_line('job ==> '||:old.job);
     select count(1) into counts from all_jobs where job = :old.job;
     if :old.job is null or counts = 0 then
        raise_application_error(-20011,'jobΪ�ջ�ƻ�������!');
     else
        -- ֹͣ��ǰ�ƻ�
        begin dbms_job.broken(:old.job, true, sysdate);commit;end;
        dbms_output.put_line('�ƻ�ֹͣ�ɹ�!');
        -- ɾ���ƻ�
        begin dbms_job.remove(:old.job);commit;end;
        dbms_output.put_line('�ƻ�ɾ���ɹ�!');
     end if;
end;
/


-- �·���һЩ�������
-- �򿪷���
set serveroutput on
-- ��ѯ��ǰ���ñ���Ϣ
select * from timingrun_config;
-- ��ѯ��ҵ�����е�������ҵ״̬
select job,what,next_date,next_sec,failures,broken,interval from all_jobs;
-- ��ѯ��������ǰ״̬
select trigger_name, status from user_triggers where trigger_name like 'TIMINGRUN_CONFIG%';
-- �������ñ����д�����
alter table timingrun_config enable all triggers;
-- �������ñ����д�����
alter table timingrun_config disable all triggers;

