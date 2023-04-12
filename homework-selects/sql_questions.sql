-- Write a query to display:

-- 1. the first name, last name, salary, and job grade for all employees.
SELECT first_name, last_name, salary, job_title
FROM employees
         LEFT JOIN jobs USING (job_id);

-- 2. the first and last name, department, city, and state province for each employee.
SELECT first_name, last_name, department_name, city, state_province
FROM employees
         LEFT JOIN departments USING (department_id)
         LEFT JOIN locations USING (location_id);

-- 3. the first name, last name, department number and department name, for all employees for departments 80 or 40.
SELECT first_name, last_name, department_id, department_name
FROM employees
         INNER JOIN departments USING (department_id)
WHERE department_id = 40 OR department_id = 80;

-- 4. those employees who contain a letter z to their first name and also display their last name, department, city, and state province.
SELECT first_name, last_name, department_name, city, state_province
FROM employees
         INNER JOIN departments USING (department_id)
         INNER JOIN locations USING (location_id)
WHERE first_name LIKE '%z%';

-- 5. the first and last name and salary for those employees who earn less than the employee earn whose number is 182.
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
         JOIN employees e2 ON e1.salary < e2.salary AND e2.Employee_id = 182;

-- 6. the first name of all employees including the first name of their manager.
SELECT e.first_name AS EMPLOYEE_NAME, m.first_name AS MANAGER_NAME
FROM employees e
         JOIN employees m ON e.manager_id = m.employee_id;

-- 7. the first name of all employees and the first name of their manager including those who does not working under any manager.
SELECT e.first_name AS EMPLOYEE_NAME, m.first_name AS MANAGER_NAME
FROM employees e
         LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- 8. the details of employees who manage a department.
SELECT *
FROM employees e
         INNER JOIN departments d USING(department_id)
WHERE e.employee_id = d.manager_id;

-- 9. the first name, last name, and department number for those employees who works in the same department as the employee who holds the last name as Taylor.
SELECT e1.first_name, e1.last_name, e1.department_id
FROM employees e1
         JOIN employees e2 ON e1.department_id = e2.department_id AND e2.last_name = 'Taylor';

--10. the department name and number of employees in each of the department.
SELECT  department_name, COUNT(employee_id) AS Number_of_Employees
FROM employees
         INNER JOIN departments USING (department_id)
GROUP BY department_name;

--11. the name of the department, average salary and number of employees working in that department who got commission.
SELECT  department_name, COUNT(employee_id) AS Number_of_Employees, AVG(salary) AS Average_Salary
FROM employees
         INNER JOIN departments USING (department_id)
WHERE commission_pct IS NOT NULL
GROUP BY department_name;

--12. job title and average salary of employees.
SELECT  job_title, AVG(salary) AS Average_Salary
FROM employees
         INNER JOIN jobs USING (job_id)
GROUP BY job_title
ORDER BY Average_Salary ASC;

--13. the country name, city, and number of those departments where at least 2 employees are working.
SELECT  country_name, city, COUNT(department_name) AS Number_of_Departments
FROM employees
         JOIN departments USING (department_id)
         JOIN locations USING (location_id)
         JOIN countries USING (country_id)
GROUP BY country_name, city
HAVING COUNT(department_name) >= 2;

--14. the employee ID, job name, number of days worked in for all those jobs in department 80.
SELECT  employee_id, job_title, end_date - start_date AS Number_of_Days
FROM employees
         JOIN jobs USING (job_id)
         JOIN job_history USING (employee_id)
WHERE job_history.department_id = 80

--15. the name ( first name and last name ) for those employees who gets more salary than the employee whose ID is 163.
SELECT (e1.first_name ||  ' ' || e1.last_name) name
FROM employees e1
         JOIN employees e2 ON e1.salary > e2.salary AND e2.Employee_id = 163;

--16. the employee id, employee name (first name and last name ) for all employees who earn more than the average salary.
SELECT (first_name ||  ' ' || last_name) name, employee_id
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--17. the employee name ( first name and last name ), employee id and salary of all employees who report to Payam.
SELECT (e.first_name ||  ' ' || e.last_name) name, e.employee_id, e.salary
FROM employees e
         JOIN employees m ON e.manager_id = m.employee_id AND m.first_name = 'Payam';

--18. the department number, name ( first name and last name ), job and department name for all employees in the Finance department.
SELECT department_id, (first_name ||  ' ' || last_name) name, job_title, department_name
FROM employees
         INNER JOIN jobs USING(job_id)
         INNER JOIN departments USING(department_id)
WHERE department_name = 'Finance';

--19. all the information of an employee whose id is any of the number 134, 159 and 183.
SELECT *
FROM employees
WHERE employee_id IN (134, 159, 183);

--20. all the information of the employees whose salary is within the range of smallest salary and 2500.
SELECT *
FROM employees
         JOIN jobs USING (job_id)
WHERE salary BETWEEN min_salary AND 2500;

--21. all the information of the employees who does not work in those departments where some employees works whose id within the range 100 and 200.
SELECT *
FROM employees
WHERE employee_id NOT BETWEEN 100 AND 200;

--22. all the information for those employees whose id is any id who earn the second highest salary.
SELECT *
FROM employees
WHERE salary = (SELECT MAX(salary)
                FROM employees
                WHERE salary < (SELECT MAX(salary) FROM employees));

--23. the employee name( first name and last name ) and hiredate for all employees in the same department as Clara. Exclude Clara.
SELECT (e1.first_name ||  ' ' || e1.last_name) name, e1.hire_date
FROM employees e1
         JOIN employees e2 ON e1.department_id = e2.department_id AND e2.first_name = 'Clara' AND e1.first_name <> 'Clara';

--24. the employee number and name( first name and last name ) for all employees who work in a department with any employee whose name contains a T.
SELECT DISTINCT (e1.first_name ||  ' ' || e1.last_name) name, e1.last_name
FROM employees e1
         INNER JOIN employees e2 ON e1.department_id = e2.department_id AND (e2.first_name LIKE '%T%' or e2.last_name LIKE '%T%');

--25. full name(first and last name), job title, starting and ending date of last jobs for those employees with worked without a commission percentage.
SELECT  (emp.first_name ||  ' ' || emp.last_name) name, jb.job_title, jobH.start_date, jobH.end_date
FROM employees emp
         JOIN job_history jobH ON emp.employee_id = jobH.employee_id
         JOIN jobs jb ON emp.job_id = jb.job_id
WHERE emp.commission_pct IS NULL;

--26. the employee number, name( first name and last name ), and salary for all employees who earn more than the average salary and who work in a department with any employee with a J in their name.
SELECT DISTINCT e1.employee_id, (e1.first_name ||  ' ' || e1.last_name) name, e1.salary
FROM employees e1
         INNER JOIN employees e2 ON e1.department_id = e2.department_id
WHERE (e2.first_name LIKE '%J%' OR e2.last_name LIKE '%J%')
  AND e1.salary > (SELECT AVG(salary) from employees);

--27. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN.
SELECT employee_id, (first_name ||  ' ' || last_name) name, job_title
FROM employees e1
         JOIN jobs ON e1.job_id = jobs.job_id
WHERE salary < ANY
      (SELECT salary FROM employees WHERE job_id = 'MK_MAN');

--28. the employee number, name( first name and last name ) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN. Exclude Job title MK_MAN.
SELECT employee_id, (first_name ||  ' ' || last_name) name, job_title
FROM employees e1
         JOIN jobs ON e1.job_id = jobs.job_id
WHERE salary < ANY
      (SELECT salary FROM employees WHERE job_id = 'MK_MAN')
AND jobs.job_id <> 'MK_MAN';

--29. all the information of those employees who did not have any job in the past.
SELECT *
FROM employees
WHERE employee_id
      NOT IN
      (SELECT employee_id FROM job_history)

--30. the employee number, name( first name and last name ) and job title for all employees whose salary is more than any average salary of any department.
SELECT employee_id, (first_name ||  ' ' || last_name) name, job_title
FROM employees
         JOIN jobs USING (job_id)
WHERE salary > ALL
      (SELECT AVG(salary) FROM employees WHERE department_id IS NOT NULL GROUP BY department_id);

--31. the employee id, name ( first name and last name ) and the job id column with a modified title SALESMAN for those employees whose job title is ST_MAN and DEVELOPER for whose job title is IT_PROG.
SELECT employee_id, first_name || ' ' || last_name AS "FULL NAME",
    CASE job_id
        WHEN 'ST_MAN' THEN 'SALESMAN'
        WHEN 'IT_PROG' THEN 'DEVELOPER'
    ELSE job_id
    END AS "JOB"
FROM employees;

--32. the employee id, name ( first name and last name ), salary and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than the average salary of all employees.
SELECT employee_id,
    first_name || ' ' || last_name AS "FULL NAME", salary,
    CASE
        WHEN salary < (SELECT avg(salary) FROM employees) THEN 'LOW'
        WHEN salary > (SELECT avg(salary) FROM employees) THEN 'HIGH'
    ELSE NULL
    END AS "SALARY STATUS"
FROM employees;

--33. the employee id, name ( first name and last name ), SalaryDrawn, AvgCompare (salary - the average salary of all employees)
    -- and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than
    -- the average salary of all employees.
SELECT employee_id, first_name || ' ' || last_name AS "FULL NAME", salary,
    (SELECT ROUND(AVG(salary)) FROM employees) AS "AVG COMPARE",
    CASE
        WHEN salary < (SELECT AVG(salary) FROM employees) THEN 'LOW'
        WHEN salary > (SELECT AVG(salary) FROM employees) THEN 'HIGH'
    ELSE NULL
    END AS "SALARY STATUS"
FROM employees;

--34. all the employees who earn more than the average and who work in any of the IT departments.
SELECT *
FROM employees
    JOIN departments USING (department_id)
    WHERE salary > (SELECT AVG(salary) FROM employees) AND department_name LIKE '%IT%'

--35. who earns more than Mr. Ozer.
SELECT * FROM employees WHERE salary > (SELECT salary FROM employees WHERE last_name || ' ' || first_name LIKE '%Ozer%')

--36. which employees have a manager who works for a department based in the US.
SELECT E.*
FROM employees E
    JOIN employees M
        ON E.manager_id = M.employee_id
    JOIN departments D
        ON M.department_id = D.department_id
    JOIN locations L
        ON L.location_id = D.location_id
    WHERE L.country_id = 'US';

--37. the names of all employees whose salary is greater than 50% of their department’s total salary bill.
SELECT first_name || ' ' || last_name AS "FULL NAME"
FROM employees
    WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = department_id);

--38. the employee id, name ( first name and last name ), salary, department name and city for all
--the employees who gets the salary as the salary earn by the employee which is maximum within the joining person January 1st, 2002 and December 31st, 2003.
SELECT employee_id, first_name || ' ' || last_name AS "FULL NAME", salary, department_name, city
FROM employees
    JOIN departments USING (department_id)
    JOIN locations USING (location_id)
    WHERE salary IN (
        SELECT MAX(salary)
        FROM employees WHERE hire_date BETWEEN TO_DATE('01/01/2002', 'dd/mm/yyyy') AND TO_DATE('31/12/2003', 'dd/mm/yyyy'))

--39. the first and last name, salary, and department ID for all those employees who earn more than the average salary and arrange the list in descending order on salary.
SELECT first_name, last_name, salary, department_id
FROM employees
    WHERE salary > (SELECT AVG(salary) FROM employees) ORDER BY salary DESC

--40. the first and last name, salary, and department ID for those employees who earn more than the maximum salary of a department which ID is 40.
SELECT first_name, last_name, salary, department_id
FROM employees
    WHERE salary > (SELECT MAX(salary) FROM employees WHERE department_id = 40);

--41. the department name and Id for all departments where they located, that Id is equal to the Id for the location where department number 30 is located.
SELECT department_name, department_id
FROM departments
    WHERE location_id = (SELECT location_id FROM departments WHERE department_id = 30)

--42. the first and last name, salary, and department ID for all those employees who work in that department where the employee works who hold the ID 201.
SELECT first_name, last_name, salary, department_id
FROM employees
    WHERE department_id = (SELECT department_id FROM employees WHERE employee_id = 201);

--43. the first and last name, salary, and department ID for those employees whose salary is equal to the salary of the employee who works in that department which ID is 40.
SELECT first_name, last_name, salary, department_id
FROM employees
    WHERE department_id = (SELECT department_id FROM employees WHERE employee_id = 40)
    AND salary = (SELECT salary FROM employees WHERE employee_id = 40);

--44. the first and last name, salary, and department ID for those employees who earn more than the minimum salary of a department which ID is 40.
SELECT first_name, last_name, salary, department_id
FROM employees
    WHERE salary > (SELECT MIN(salary) FROM employees WHERE department_id = 40)

--45. the first and last name, salary, and department ID for those employees who earn less than the minimum salary of a department which ID is 70.
SELECT first_name, last_name, salary, department_id
FROM employees
    WHERE salary < (SELECT MIN(salary) FROM employees WHERE department_id = 70)

--46. the first and last name, salary, and department ID for those employees who earn less than the average salary, and also work at the department where the employee Laura is working as a first name holder.
SELECT first_name, last_name, salary, department_id
FROM employees
    WHERE salary < (SELECT AVG(salary) FROM employees)
    AND department_id = (SELECT department_id FROM employees WHERE first_name = 'Laura');

--47. the full name (first and last name) of manager who is supervising 4 or more employees.
SELECT first_name || ' ' || last_name AS "FULL NAME"
FROM employees
    WHERE employee_id IN (SELECT manager_id FROM employees GROUP BY manager_id HAVING COUNT(employee_id) >= 4)

--48. the details of the current job for those employees who worked as a Sales Representative in the past.
SELECT e.first_name || ' ' || e.last_name AS "FULL NAME", j.job_title, e.salary
FROM employees e
    JOIN jobs j
        ON j.job_id = e.job_id
    JOIN job_history jh
        ON jh.employee_id = e.employee_id
    WHERE jh.job_id IN (
        SELECT job_id
        FROM jobs
            WHERE job_title = 'Sales Representative'
    )
    AND j.job_title != 'Sales Representative'

--49. all the infromation about those employees who earn second lowest salary of all the employees.
SELECT * FROM employees e WHERE 2 = (SELECT COUNT(DISTINCT salary) FROM employees WHERE salary <= e.salary);

--50. the department ID, full name (first and last name), salary for those employees who is highest salary drawar in a department.
SELECT department_id, first_name || ' ' || last_name AS "FULL NAME", salary
FROM employees WHERE salary IN (SELECT MAX(salary) FROM employees GROUP BY department_id);