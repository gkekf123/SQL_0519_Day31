----- ���� ���� -----
-- SELECT���� SELECT �������� ���� ���� :  ��Į�� ��������
-- SELECT���� FROM �������� ���� ���� : �ζ��κ�
-- SELECT���� WHERE �������� ���� : ��������
-- ���������� �ݵ�� () �ȿ� ���µ�
------------------------------------------------------------
-- ������ �������� : ������ �Ǵ� ���� 1���� ��������
SELECT first_name,
       salary
FROM employees
WHERE salary > (SELECT salary
                FROM employees
                WHERE first_name = 'Nancy');
                
-- employee_id�� 103���� ����� ������ ����
SELECT job_id FROM employees WHERE employee_id = 103;

SELECT * 
FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE employee_id = 103);

-- ������ �� -> ������ �̾�� �Ѵ�, �÷����� 1������ �Ѵ�.
-- ERROR
SELECT * 
FROM employees
WHERE job_id = (SELECT * 
                FROM employees
                WHERE employee_id = 103);
--------------------------------------------------------------------
-- ���� �� �������� : ���� ��������� IN, ANY, ALL�� ���ؾ� �Ѵ�
SELECT salary FROm employees WHERE first_name = 'David';

-- IN : ������ ���� ã�� : 4800, 9500, 6800
SELECT * 
FROM employees
WHERE salary IN (SELECT salary
                    FROM employees
                    WHERE first_name = 'David');
                    
-- ANY : �ּҰ� ���� ŭ, �ִ밪 ���� ���� -- �޿��� 4800���� ū �����
-- > ANY : 4800���� ū �����
-- < ANY : 9500���� ���� �����
SELECT * 
FROM employees
WHERE salary > ANY (SELECT salary
                    FROM employees
                    WHERE first_name = 'David');
                    
-- ALL : �ִ밪 ���� ŭ, �ּҰ� ���� ����--
-- > ALL : 9500 ���� ū ���
-- < ALL : 4800 ���� ���� ���
SELECT * 
FROM employees
WHERE salary < ALL (SELECT salary
                    FROM employees
                    WHERE first_name = 'David');
                    
-- ��������
-- ������ IT_PROG�� ������� �ּҰ� ���� ū �޿��� �޴� �����
SELECT * FROM employees WHERE job_id = 'IT_PROG';

SELECT *
FROM employees
WHERE salary > ANY (SELECT salary
                    FROM employees
                    WHERE job_id = 'IT_PROG');
--------------------------------------------------------------------
-- ��Į�� ��������
-- JOIN�� Ư�� ���̺��� 1�÷��� ������ �� �� �����ϴ�
SELECT first_name,
       email,
       (SELECT department_name 
        FROM departments d 
        WHERE d.department_id = e.department_id)
FROM employees e
ORDER BY first_name;

-- LEFT JOIN : �� / �Ʒ� ��� ����
SELECT first_name,
       email,
       department_name
FROM employees e
LEFT JOIN departments d 
ON d.department_id = e.department_id
ORDER BY first_name;

-- �� �μ��� �Ŵ��� �̸��� ���
-- ��Į��
SELECT D.*,
       (SELECT first_name
        FROM employees e
        WHERE e.employee_id = d.manager_id)
FROM departments d;

-- JOIN
SELECT d.*,
       e.first_name
FROM departments d
LEFT JOIN employees e
ON d.manager_id = e.employee_id;

-- ��Į�� ������ ���� �� ����
SELECT * FROM jobs;
SELECT * FROM departments;
SELECT * FROM employees;

SELECT e.first_name,
       e.job_id,
       (SELECT job_title
        FROM jobs j
        WHERE j.job_id = e.job_id) AS job_title,
       (SELECT department_name
        FROM departments d
        WHERE d.department_id = e.department_id) AS department_name
FROM employees e;

-- �� �μ��� ��� ��, �μ����� ���
SELECT department_id, COUNT(*) FROM employees GROUP BY department_id;

SELECT d.*,
       NVL((SELECT COUNT(*)
        FROM employees e
        WHERE e.department_id = d.department_id
        GROUP BY department_id), 0) AS �����
FROM departments d;
--------------------------------------------------------------------
-- Inline View : �� ������ �������� �����
-- ��¥�� ���̺� ����
SELECT * 
FROM (SELECT *
      FROM (SELECT *
            FROM employees)
);

-- ROWNUM�� ��ȸ �� �����̱� ������, ORDER�� ���� ���Ǹ� ROWNUM ���̴� ����
SELECT first_name,
       salary,
       ROWNUM
        FROM (SELECT *
              FROM employees
              ORDER BY salary DESC);

-- ���� 2
SELECT ROWNUM,
       A.*
FROM (SELECT first_name,
             salary
      FROM employees
      ORDER BY salary DESC) A;

-- ROWNUM�� ������ 1��°���� ��ȸ �����ϱ� ���� 1 AND 10�� ����
SELECT first_name,
       salary,
       ROWNUM
        FROM (SELECT *
              FROM employees
              ORDER BY salary DESC)
        WHERE ROWNUM BETWEEN 11 AND 20;

-- �ذ��� : �ζ��κ信�� RONUM�� rn���� �÷�ȭ
SELECT *
FROM (SELECT first_name,
             salary,
             ROWNUM AS rn
      FROM (SELECT *
            FROM employees
            ORDER BY salary DESC))
WHERE rn >= 51 AND rn <= 60;

-- �ζ��� ���� ����
SELECT TO_CHAR(REGDATE, 'YY-MM-DD') AS REGDATE ,
       NAME
FROM (SELECT 'ȫ�浿' AS NAME, 
             SYSDATE AS REGDATE 
      FROM DUAL
      UNION ALL
      SELECT '�̼���', 
             SYSDATE 
      FROM DUAL);
      
-- �ζ��� ���� ����
-- �μ��� �����
SELECT * 
FROM departments d
LEFT JOIN(SELECT department_id,
                 COUNT(*)
          FROM employees
          GROUP BY department_id) E 
ON d.department_id = e.department_id;
      
-- �ζ��� ���� ����2 : 
-- �μ��� �����
SELECT d.*,
       e.total
FROM departments d
LEFT JOIN(SELECT department_id,
                 COUNT(*) AS total
          FROM employees
          GROUP BY department_id) E 
ON d.department_id = e.department_id;

-- ������(��Һ�) || ������(IN, ANY, ALL)
-- ��Į�� ���� : LEFT JOIN�� ���� ����, 1���� �÷��� ������ ��
-- �ζ��κ� : FROM ���� ��¥ ���̺�