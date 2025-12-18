using System;
using System.Collections.Generic;
using LMS.Models;
using LMS.Repository;

namespace LMS.Services
{
    public class StudentService
    {
        private readonly StudentRepository _studentRepository;

        public StudentService(StudentRepository studentRepository)
        {
            _studentRepository = studentRepository ?? throw new ArgumentNullException(nameof(studentRepository));
        }


        public int RegisterStudent(Student student)
        {
            try
            {
                if (_studentRepository.IsEmailExists(student.Email))
                    throw new Exception("Email is already registered.");

                student.IsActive = true;
                return _studentRepository.AddStudent(student);
            }
            catch (Exception ex)
            {
                throw new Exception($"Registration failed: {ex.Message}", ex);
            }
        }

        public Student GetStudent(int studentId)
        {
            try
            {
                var student = _studentRepository.GetStudentById(studentId);
                if (student == null)
                    throw new Exception("Student not found.");

                return student;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving student: {ex.Message}", ex);
            }
        }

        public List<Student> ListAllStudents()
        {
            try
            {
                return _studentRepository.GetAllStudents();
            }
            catch (Exception ex)
            {
                throw new Exception("Error listing all students.", ex);
            }
        }

        public Student GetStudentById(int studentId)
        {
            try
            {
                return _studentRepository.GetStudentById(studentId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error listing all students.", ex);
            }
        }

        public List<Student> ListActiveStudents()
        {
            try
            {
                return _studentRepository.GetActiveStudents();
            }
            catch (Exception ex)
            {
                throw new Exception("Error listing active students.", ex);
            }
        }

        public bool UpdateStudentProfile(Student student)
        {
            try
            {
                if (_studentRepository.IsEmailExists(student.Email, student.StudentId))
                    throw new Exception("Email already in use by another student.");

                return _studentRepository.UpdateStudent(student);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating student profile.", ex);
            }
        }

        public bool ActivateDeactivateStudent(Student student)
        {
            try
            {
                return _studentRepository.ActivateDeactivateStudent(student);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating student profile: " + ex.Message, ex);
            }
        }

        public bool RemoveStudent(int studentId)
        {
            try
            {
                    return _studentRepository.DeleteStudent(studentId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting student.", ex);
            }
        }

        public List<Student> SearchByTerm(string term)
        {
            try
            {
                return _studentRepository.SearchStudents(term);
            }
            catch (Exception ex)
            {
                throw new Exception("Error searching students.", ex);
            }
        }

        public List<Student> FilterByGender(Gender gender)
        {
            try
            {
                return _studentRepository.GetStudentsByGender(gender);
            }
            catch (Exception ex)
            {
                throw new Exception("Error filtering students by gender.", ex);
            }
        }

        public int CountTotalStudents()
        {
            try
            {
                return _studentRepository.GetTotalStudentCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting total students.", ex);
            }
        }

        public int CountActiveStudents()
        {
            try
            {
                return _studentRepository.GetActiveStudentCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting active students.", ex);
            }
        }
    }
}
