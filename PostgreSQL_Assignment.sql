-- Active: 1729260720451@@127.0.0.1@5432@university_db


--database create
CREATE DATABASE university_db


--create student table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 0),
    email VARCHAR(255) UNIQUE NOT NULL,
    frontend_mark INT NOT NULL ,
    backend_mark INT NOT NULL,
    status VARCHAR(20)  
)

--create course table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0)
)

--create enrollment table
CREATE TABLE enrollment (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(course_id) ON DELETE CASCADE
);

--insert data in student table
INSERT INTO students (student_name, age, email, frontend_mark, backend_mark, status)
VALUES
('Sameer', 21, 'sameer@example.com', 48, 60, NULL),
('Zoya', 23, 'zoya@example.com', 52, 58, NULL),
('Nabil', 22, 'nabil@example.com', 37, 46, NULL),
('Rafi', 24, 'rafi@example.com', 41, 40, NULL),
('Sophia', 22, 'sophia@example.com', 50, 52, NULL),
('Hasan', 23, 'hasan@gmail.com', 43, 39, NULL);

--insert data in course table
INSERT INTO courses (course_name, credits)
VALUES
('Next.js', 3),
('React.js', 4),
('Databases', 3),
('Prisma', 3);

--insert data in enrollment table
INSERT INTO enrollment (student_id, course_id)
VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2);


--get student table data
SELECT * FROM students

--get course table data
SELECT * from courses

--get enrollment table data
SELECT * FROM  enrollment


--drop table command
DROP TABLE students

DROP TABLE courses

DROP TABLE enrollment





-- query-1: insert single data in student table
INSERT INTO students (student_name, age, email, frontend_mark, backend_mark, status)
VALUES
('Abir', 27, 'abir@gmail.com', 50, 65, NULL);

-- query-2: Retrieve the names of all students who are enrolled in the course titled 'Next.js'
SELECT student_name FROM students
JOIN enrollment ON students.student_id=enrollment.student_id
JOIN courses ON   enrollment.course_id=courses.course_id
WHERE course_name='Next.js';

-- query-3: Update the status of the student with the highest total (frontend_mark + backend_mark) to 'Awarded'
UPDATE students 
SET status ='Awarded'
WHERE student_id=(SELECT student_id
    FROM students
    ORDER BY (frontend_mark + backend_mark) DESC
    LIMIT 1);


-- query-4: Delete all courses that have no students enrolled.
DELETE FROM courses
where course_id IN(SELECT courses.course_id
    FROM courses 
    LEFT JOIN enrollment ON courses.course_id = enrollment.course_id
    GROUP BY courses.course_id
    HAVING COUNT(enrollment.student_id) = 0);

-- query-5: Retrieve the names of students using a limit of 2, starting from the 3rd student.
SELECT student_name
FROM students
ORDER BY student_id
OFFSET 2 LIMIT 2;

-- query-6: Retrieve the course names and the number of students enrolled in each course.
SELECT course_name, COUNT(e.student_id) AS number_of_students
FROM courses c
LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- query-7: Calculate and display the average age of all students.
SELECT  ROUND(AVG(age), 2) FROM students;

-- query-8: Retrieve the names of students whose email addresses contain 'example.com'.
SELECT student_name,email
FROM students
WHERE email LIKE '%example.com%';
