create database final;
use final;
-- Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

INSERT INTO Students VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

-- Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT
);

INSERT INTO Courses VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

-- Instructors Table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2)
);

INSERT INTO Instructors VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 70000),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 65000);

-- Enrollments Table
CREATE TABLE Enrollments (
    EnrolmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE
);

INSERT INTO Enrollments VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics');
-- 1. CRUD Operations (Examples)
-- CREATE
INSERT INTO Students VALUES (3, 'Sam', 'Brown', 'sam.brown@email.com', '2001-04-30', '2023-09-01');
-- READ
SELECT * FROM Students;
-- UPDATE
UPDATE Students SET Email = 'john.new@email.com' WHERE StudentID = 1;
-- DELETE
DELETE FROM Students WHERE StudentID = 3;

-- 2. Students enrolled after 2022
SELECT * FROM Students WHERE EnrollmentDate > '2022-12-31';

-- 3. Courses offered by Mathematics, limit 5
SELECT * FROM Courses WHERE DepartmentID = 2 LIMIT 5;

-- 4. Number of students in each course, filter >5
SELECT CourseID, COUNT(*) AS EnrolledStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(*) > 5;

-- 5. Students enrolled in both Introduction to SQL and Data Structures
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (
    SELECT e1.StudentID
    FROM Enrollments e1
    JOIN Enrollments e2 ON e1.StudentID = e2.StudentID
    WHERE e1.CourseID = 101 AND e2.CourseID = 102
);

-- 6. Students either enrolled in Introduction to SQL or Data Structures
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102);

-- 7. Avg number of credits for all courses
SELECT AVG(Credits) AS AvgCredits FROM Courses;

-- 8. Max salary of instructors in Computer Science
SELECT MAX(Salary) AS MaxSalary
FROM Instructors
WHERE DepartmentID = 1;

-- 9. Number of students enrolled in each department
SELECT d.DepartmentName, COUNT(e.StudentID) AS StudentCount
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

-- 10. INNER JOIN students and their courses
SELECT s.*, c.CourseName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID;

-- 11. LEFT JOIN: all students and their courses (if any)
SELECT s.*, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- 12. RIGHT JOIN: all courses and their students (if any)
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName
FROM Courses c
RIGHT JOIN Enrollments e ON c.CourseID = e.CourseID
RIGHT JOIN Students s ON e.StudentID = s.StudentID;

-- 13. FULL OUTER JOIN students and their courses
SELECT s.*, c.CourseName
FROM Students s
FULL OUTER JOIN Enrollments e ON s.StudentID = e.StudentID
FULL OUTER JOIN Courses c ON e.CourseID = c.CourseID;

-- 14. Running total of students enrolled in courses
SELECT e.CourseID, e.StudentID,
       COUNT(*) OVER (ORDER BY e.EnrollmentDate) AS RunningTotal
FROM Enrollments e;

-- 15. Running total of students enrolled in courses (per year of enrollment)
SELECT e.CourseID, e.StudentID,
       COUNT(*) OVER (PARTITION BY YEAR(e.EnrollmentDate) ORDER BY e.EnrollmentDate) AS RunningTotalPerYear
FROM Enrollments e;

-- 16. Label students as Senior/Junior by enrollment year
SELECT StudentID, FirstName, LastName, EnrollmentDate,
       CASE
           WHEN YEAR(CURRENT_DATE) - YEAR(EnrollmentDate) > 4 THEN 'Senior'
           ELSE 'Junior'
       END AS StudentLabel
FROM Students;

