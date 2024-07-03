
CREATE DATABASE IF NOT EXISTS sekolah;
USE sekolah;

CREATE TABLE IF NOT EXISTS teachers (
    id INT AUTO_INCREMENT,
    name VARCHAR(100),
    subject VARCHAR(50),
    PRIMARY KEY (id)
);


INSERT INTO teachers (name, subject) VALUES ('Pak Anton', 'Matematika');
INSERT INTO teachers (name, subject) VALUES ('Bu Dina', 'Bahasa Indonesia');
INSERT INTO teachers (name, subject) VALUES ('Pak Eko', 'Biologi');

CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT,
    name VARCHAR(50),
    teacher_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

INSERT INTO classes (name, teacher_id) VALUES ('Kelas 10A', 1);
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 11B', 2);
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 12C', 3);

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    class_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (class_id) REFERENCES classes(id)
);

INSERT INTO students (name, age, class_id) VALUES ('Budi', 16, 1);
INSERT INTO students (name, age, class_id) VALUES ('Ani', 17, 2);
INSERT INTO students (name, age, class_id) VALUES ('Candra', 18, 3);

SELECT 
    students.name AS student_name, 
    classes.name AS class_name, 
    teachers.name AS teacher_name
FROM 
    students
JOIN 
    classes ON students.class_id = classes.id
JOIN 
    teachers ON classes.teacher_id = teachers.id;


SELECT 
    teachers.name AS teacher_name,
    GROUP_CONCAT(classes.name SEPARATOR ', ') AS class_names
FROM 
    classes
JOIN 
    teachers ON classes.teacher_id = teachers.id
GROUP BY 
    teachers.name;

CREATE VIEW student_class_teacher AS
SELECT 
    students.name AS student_name, 
    classes.name AS class_name, 
    teachers.name AS teacher_name
FROM 
    students
JOIN 
    classes ON students.class_id = classes.id
JOIN 
    teachers ON classes.teacher_id = teachers.id;


SELECT * FROM student_class_teacher;


DELIMITER //

CREATE PROCEDURE GetStudentClassTeacher()
BEGIN
    SELECT 
        students.name AS student_name, 
        classes.name AS class_name, 
        teachers.name AS teacher_name
    FROM 
        students
    JOIN 
        classes ON students.class_id = classes.id
    JOIN 
        teachers ON classes.teacher_id = teachers.id;
END //

DELIMITER ;


CALL GetStudentClassTeacher();


DELIMITER //

CREATE PROCEDURE InsertStudent(
    IN student_name VARCHAR(100), 
    IN student_age INT, 
    IN student_class_id INT
)
BEGIN
    DECLARE student_exists INT;
    
    SELECT COUNT(*) INTO student_exists
    FROM students
    WHERE name = student_name AND age = student_age AND class_id = student_class_id;

    IF student_exists > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Duplicate student data detected!';
    ELSE
        INSERT INTO students (name, age, class_id) 
        VALUES (student_name, student_age, student_class_id);
    END IF;
END //

DELIMITER ;

-- Untuk menggunakan stored procedure
CALL InsertStudent('Budi', 16, 1);
