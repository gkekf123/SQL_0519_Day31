
----- INSERT, UPDATE, DELETE -> COMMIT : ���� �ݿ� ó�� -----

-- INSERT --
DESC departments;

-- ��ü�� ����
INSERT INTO departments VALUES(300, 'DEV', NULL, 1700);

-- ������ ����, �������� �⺻��
INSERT INTO departments(department_id, department_name) VALUES(310, 'SYSTEM');
SELECT * FROM departments;

-- �ǵ�����
ROLLBACK;

-- �纻 ���̺�
CREATE TABLE EMPS AS ( SELECT * FROm employees WHERE 1 = 2);
SELECT * FROM emps;

-- employees ���̺��� �ش� �׸� ���� / ��ü �÷��� ����
INSERT INTO emps (SELECT * FROM employees WHERE job_id = 'IT_PROG');

-- �������� �μ�Ʈ
INSERT INTO emps (employee_id, last_name, email, hire_date, job_id)
    VALUES(200, 
           (SELECT last_name FROM employees WHERE employee_id = '200'),
           (SELECT email FROM employees WHERE employee_id = '200'),
        SYSDATE,
        'TEST'
           );
           
----------------------------------------------------------------------------

-- UPDATE --
SELECT  * FROM emps;

-- EX 1 : �⺻ UPDATE
UPDATE emps
SET hire_date = SYSDATE, 
    last_name = 'HONG',
    salary = salary + 1000
WHERE employee_id = 103;

-- EX 2 : ����
UPDATE emps
SET commission_pct = 0.1
WHERE job_id IN ('IT_PROG', 'SA_MAN');

-- EX 3 : ���� ����
-- employee_id = 200�� �޿��� 103���� �����ϰ� ����
UPDATE emps
SET salary = (SELECT salary
               FROM employees
               WHERE employee_id = 103)
WHERE employee_id = 200;

-- EX 4 : 3���� �÷��� ����
UPDATE emps
SET(job_id, salary, commission_pct) = (SELECT job_id, 
                                              salary, 
                                              commission_pct 
                                       FROM emps 
                                       WHERE employee_id = 103)
WHERE employee_id = 200;

COMMIT;

----------------------------------------------------------------------------

-- DELETE --
-- ���̺� ���� + ������ ����
CREATE TABLE depts AS (SELECT * 
                       FROM departments
                       WHERE 1 = 1)
;
-- EX 1 : ������ ���� �� PK�� �̿�
DELETE FROM emps
WHERE employee_id = 200;

DELETE FROM emps
WHERE salary >= 4000;

ROLLBACK;

SELECT * FROM emps;

-- EX 2 : 
DELETE FROM emps
WHERE department_id = (SELECT department_id
                       FROM departments
                       WHERE department_name = 'IT')
;
SELECT * FROM emps;

-- employees�� 60�� �μ��� ����ϰ� �ֱ� ������ ���� �Ұ�
DELETE FROM departments WHERE department_id = 60;

----------------------------------------------------------------------------

-- MERGE : �� ���̺��� ���ؼ� �����Ͱ� ������ UPDATE, ���ٸ� INSERT
SELECT * FROM emps;

MERGE INTO emps e1
USING(SELECT * FROM employees WHERE job_id IN ('IT_PROG', 'SA_MAN')) e2
ON(e1.employee_id = e2.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        e1.salary = e2.salary,
        e1.hire_date = e2.hire_date,
        e1.commission_pct = e2.commission_pct
WHEN NOT MATCHED THEN
    INSERT VALUES
    (e2.employee_id,
     e2.first_name,
     e2.last_name,
     e2.email,
     e2.phone_number,
     e2.hire_date,
     e2.job_id,
     e2.salary,
     e2.commission_pct,
     e2.manager_id,
     e2.department_id
    )
;

-- MERGE 3
SELECT * FROM emps;

MERGE INTO emps e
USING DUAL
ON(e.employee_id = 103)
WHEN MATCHED THEN
    UPDATE SET e.last_name = 'DEMO'
WHEN NOT MATCHED THEN
    INSERT(e.employee_id,
           e.last_name,
           e.email,
           e.hire_date,
           e.job_id)
    VALUES('1000', 'DEMO', 'DEMO', SYSDATE, 'DEMO')
;
DELETE FROM emps
WHERE employee_id = 103;
SELECT * FROM emps;

