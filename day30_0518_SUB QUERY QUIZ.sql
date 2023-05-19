--���� 1.
---EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� ( AVG(�÷�) ���)
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary)
                     FROM employees);
                     
---EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���
SELECT COUNT(*)
FROM employees
WHERE salary > (SELECT AVG(salary)
                     FROM employees);
                     
---EMPLOYEES ���̺��� job_id�� IT_PFOG�� ������� ��ձ޿����� ���� ������� �����͸� ����ϼ���
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary)
                     FROM employees
                     WHERE job_id = 'IT_PROG');
                     
--���� 2.
---DEPARTMENTS���̺��� manager_id�� 100�� ����� department_id��
--EMPLOYEES���̺��� department_id�� ��ġ�ϴ� ��� ����� ������ �˻��ϼ���.
SELECT * 
FROM employees
WHERE department_id = (SELECT department_id
                           FROM departments
                           WHERE manager_id = 100);

--���� 3.
---EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� ����ϼ���
SELECT * 
FROM employees
WHERE manager_id > ANY (SELECT manager_id
                        FROM employees
                        WHERE first_name = 'Pat');

---EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.
SELECT * FROM employees WHERE first_name = 'James';

SELECT * 
FROM employees
WHERE manager_id = 120 OR manager_id = 121;

SELECT * 
FROM employees
WHERE manager_id IN (SELECT manager_id
                     FROM employees
                     WHERE first_name = 'James');

--���� 4.
---EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� �� ��ȣ, �̸��� ����ϼ���
SELECT * 
FROM (SELECT first_name,
             ROWNUM  AS rn
      FROM(SELECT * 
           FROM employees
           ORDER BY first_name DESC))
WHERE rn >= 41 AND rn <=50;

--���� 5.
---EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� �� ��ȣ, ���id, �̸�, ��ȣ,
--�Ի����� ����ϼ���.
-- ��� 1
SELECT * 
FROM (SELECT first_name,
             ROWNUM  AS rn,
             employee_id,
             hire_date
      FROM(SELECT * 
           FROM employees
           ORDER BY hire_date))
WHERE rn >= 31 AND rn <= 40;
-- ��� 2
SELECT *
FROM(SELECT E.*,
           ROWNUM rn
     FROM (SELECT employee_id,
                  first_name || ' ' || last_name AS name,
                  phone_number,
                  hire_date
            FROM employees
            ORDER BY hire_date) E
            )
WHERE rn BETWEEN 31 AND 40;

--���� 6.
--employees���̺� departments���̺��� left �����ϼ���
--����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
--����) �������̵� ���� �������� ����
SELECT e.employee_id,
       CONCAT(e.first_name, e.last_name),
       d.department_id,
       d.department_name
FROM employees e
LEFT JOIN departments d
ON d.department_id = e.department_id
ORDER BY e.employee_id;

--���� 7.
--���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
-- ��� 1
SELECT CONCAT(e.first_name, e.last_name) AS �̸�,
       e.employee_id AS �������̵�,
      (SELECT department_name
       FROM departments d
       WHERE d.department_id = e.department_id) AS �μ����̵�,
       (SELECT department_id
       FROM departments d
       WHERE d.department_id = e.department_id) AS �μ���
FROM employees e
ORDER BY e.employee_id;
-- ���2
SELECT employee_id,
       first_name || ' ' || last_name AS NAME,
       department_id,
       (SELECT department_name
        FROM departments d
        WHERE d.department_id = e.department_id) AS department_nam
FROM employees e
ORDER BY employee_id;
        

--���� 8.
--departments���̺� locations���̺��� left �����ϼ���
--����) �μ����̵�, �μ��̸�, �Ŵ������̵�, �����̼Ǿ��̵�, ��Ʈ��_��巹��, ����Ʈ �ڵ�, ��Ƽ �� ����մϴ�
--����) �μ����̵� ���� �������� ����
SELECT d.*,
       l.location_id,
       street_address,
       postal_code,
       city
FROM departments d
LEFT JOIN LOCATIONS l
ON d.location_id = l.location_id
ORDER BY department_id;

--���� 9.
--���� 8�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT d.*,
      (SELECT street_address
       FROM locations l
       WHERE d.location_id = l.location_id) AS �ּ�,
       (SELECT postal_code
       FROM locations l
       WHERE d.location_id = l.location_id) AS �����ȣ,
       (SELECT city
       FROM locations l
       WHERE d.location_id = l.location_id) AS ����
FROM departments d
ORDER BY d.department_id;

--���� 10.
--locations���̺� countries ���̺��� left �����ϼ���
--����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
--����) country_name���� �������� ����
SELECT location_id,
       street_address,
       city,
       c.country_id,
       c.country_name
FROM locations l
LEFT JOIN countries c
ON l.country_id = c.country_id
ORDER BY country_name;

--���� 11.
--���� 10�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT l.location_id,
       l.street_address,
       l.city,
       l.country_id,
        (SELECT country_name
        FROM countries c
        WHERE l.country_id = c.country_id) AS country_name
FROM locations l
ORDER BY country_name;

--���ΰ� ��������
--���� 12.
--employees���̺�, departments���̺��� left���� hire_date�� �������� �������� 1-10��° �����͸� ����մϴ�
--����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, ��ȭ��ȣ, �Ի���, �μ����̵�, �μ��̸� �� ����մϴ�.
--����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� Ʋ������ �ȵ˴ϴ�.

SELECT ROWNUM rn,
       a.*
FROM(SELECT e.employee_id,
            e.first_name || ' ' || last_name,
            e.phone_number,
            e.hire_date,
            e.department_id,
            d.department_name
     FROM employees e
     LEFT JOIN departments d
     ON e.department_id = d.department_id
     ORDER BY hire_date) AS a
WHERE ROWNUM BETWEEN 1 AND 10;

--���� 13.
----EMPLOYEES �� DEPARTMENTS ���̺��� JOB_ID�� SA_MAN ����� ������ LAST_NAME, JOB_ID,
--DEPARTMENT_ID,DEPARTMENT_NAME�� ����ϼ���
-- ���1
SELECT e.last_name,
       e.job_id,
       e.department_id,
       (SELECT department_name
        FROM departments d
        WHERE e.department_id = d.department_id)
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
WHERE job_id = 'SA_MAN';
-- ���2 : ����
SELECT e.last_name,
       e.job_id,
       e.department_id,
       d.department_name
FROM (SELECT * 
      FROM employees
      WHERE job_id = 'SA_MAN') e
JOIN departments d
ON e.department_id = d.department_id;

--���� 14
----DEPARTMENT���̺��� �� �μ��� ID, NAME, MANAGER_ID�� �μ��� ���� �ο����� ����ϼ���.
----�ο��� ���� �������� �����ϼ���.
----����� ���� �μ��� ������� ���� �ʽ��ϴ�
-- ���1
SELECT
    d.department_id,
    d.department_name,
    d.manager_id,
    (SELECT COUNT(*)
     FROM employees e
     WHERE e.department_id = d.department_id) AS PERSON_COUNT
FROM departments d
WHERE d.department_id IN (SELECT DISTINCT department_id
                           FROM employees)
ORDER BY PERSON_COUNT DESC;
-- ���2 : ����
SELECT *
FROM (SELECT department_id,
             COUNT(*)
      FROM employees
      GROUP BY department_id) e
;
-- �ݴ��
SELECT d.department_id,
       d.department_name,
       d.manager_id,
       e.total
FROM departments d
JOIN(SELECT department_id, -- �ζ��κ�
             COUNT(*) AS total
      FROM employees 
      GROUP BY department_id) e
ON d.department_id = e.department_id
ORDER BY total
;

--���� 15
----�μ��� ���� ���� ���ο�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���
----�μ��� ����� ������ 0���� ����ϼ���
SELECT d.*,
       NVL(e.salary, 0) AS salary,
       l.street_address,
       l.postal_code
FROM departments d
LEFT JOIN (SELECT department_id,
                  TRUNC(AVG(salary)) AS salary
                  FROM employees
                  GROUP BY department_id) e
ON d.department_id = e.department_id
LEFT JOIN locations l
ON l.location_id = d.location_id
;

--���� 16
---���� 15����� ���� DEPARTMENT_ID�������� �������� �����ؼ� ROWNUM�� �ٿ� 1-10������ ������
--����ϼ���
SELECT * 
FROM(SELECT ROWNUM rn,
            x.*
     FROM(SELECT d.*,
                 NVL(e.salary, 0) AS salary,
                 l.street_address,
                 l.postal_code
          FROM departments d
          LEFT JOIN (SELECT department_id,
                            TRUNC(AVG(salary)) AS salary
                     FROM employees
                     GROUP BY department_id) e
          ON d.department_id = e.department_id
          LEFT JOIN locations l
          ON l.location_id = d.location_id
          ORDER BY d.department_id DESC) x
)
WHERE rn > 10 AND rn <= 20
--WHERE ROWNUM BETWEEN 1 AND 10
;