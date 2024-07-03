# database_setup_SERU

query untuk melihat data view
SELECT * FROM student_class_teacher;

untuk menjalankan stored produced menampikan data siswa, kelas, dan guru
CALL GetStudentClassTeacher();

stored procedure untuk menambahkan data siswa baru dan periksa apakah ada duplikasi
CALL InsertStudent('Budi', 16, 1);

(sebelumnya saya sudah tambahkan nama budi )
