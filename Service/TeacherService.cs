using System;
using System.Collections.Generic;
using LMS.Model;
using LMS.Repository;

namespace LMS.Services
{
    public class TeacherService
    {
        private readonly TeacherRepository _teacherRepository;

        public TeacherService(TeacherRepository teacherRepository)
        {
            _teacherRepository = teacherRepository ?? throw new ArgumentNullException(nameof(teacherRepository));
        }

        public int RegisterTeacher(Teacher teacher)
        {
            try
            {
                if (_teacherRepository.IsEmailExists(teacher.Email))
                    throw new Exception("Email is already registered.");

                teacher.IsActive = true;
                return _teacherRepository.AddTeacher(teacher);
            }
            catch (Exception ex)
            {
                throw new Exception($"Registration failed: {ex.Message}", ex);
            }
        }

        public Teacher GetTeacher(int teacherId)
        {
            try
            {
                var teacher = _teacherRepository.GetTeacherById(teacherId);
                if (teacher == null)
                    throw new Exception("Teacher not found.");

                return teacher;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving teacher: {ex.Message}", ex);
            }
        }

        public List<Teacher> ListAllTeachers()
        {
            try
            {
                return _teacherRepository.GetAllTeachers();
            }
            catch (Exception ex)
            {
                throw new Exception("Error listing all teachers.", ex);
            }
        }

        public bool UpdateTeacherProfile(Teacher teacher)
        {
            try
            {
                if (_teacherRepository.IsEmailExists(teacher.Email, teacher.TeacherId))
                    throw new Exception("Email already in use by another teacher.");

                return _teacherRepository.UpdateTeacher(teacher);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating teacher profile.", ex);
            }
        }

        public bool RemoveTeacher(int teacherId)
        {
            try
            {
                return _teacherRepository.DeleteTeacher(teacherId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting teacher.", ex);
            }
        }

        public List<Teacher> SearchByTerm(string searchTerm)
        {
            try
            {
                return _teacherRepository.SearchTeachers(searchTerm);
            }
            catch (Exception ex)
            {
                throw new Exception("Error searching teachers.", ex);
            }
        }

        public bool ActivateDeactivateTeacher(Teacher teacher)
        {
            try
            {
                return _teacherRepository.ActivateDeactivateTeacher(teacher);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating teacher status: " + ex.Message, ex);
            }
        }

        public int CountTotalTeachers()
        {
            try
            {
                return _teacherRepository.GetTotalTeacherCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting total teachers.", ex);
            }
        }

        public int CountActiveTeachers()
        {
            try
            {
                return _teacherRepository.GetActiveTeacherCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting active teachers.", ex);
            }
        }
    }
}
