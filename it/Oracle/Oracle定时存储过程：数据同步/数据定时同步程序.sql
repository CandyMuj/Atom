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

-- ����ִ�мƻ�
declare
  job number;
BEGIN
  DBMS_JOB.SUBMIT(JOB       => job,  -- �Զ����ɵ�����id
                  WHAT      => 'towercrnop.datatimingsync;',  -- Ҫִ�д˴洢����,����sql���
                  NEXT_DATE => sysdate, -- ����ִ��ʱ��,����ִ��
                  INTERVAL  => 'sysdate + 5/(24 * 60 * 60)');  -- ִ������
  COMMIT;
  -- ����ִ�мƻ�
  DBMS_JOB.RUN(job);
end;



-- �鿴���������� 
select job,what,next_date,next_sec,failures,broken,interval from all_jobs; 

-- �޸ļ��ʱ�䣺
begin dbms_job.interval(job,interval);commit; end;

-- ֹͣjob��
begin dbms_job.broken(106,true,sysdate);commit; end;

-- ����job
begin dbms_job.broken(106,false,sysdate);commit; end;

-- ɾ��job
begin dbms_job.remove(105);commit;end;
