using System;
using System.Collections.Generic;
using LMS.Model;
using LMS.Repository;

namespace LMS.Service
{
    public class CourseService
    {
        private readonly CourseRepository _courseRepository;

        public CourseService(CourseRepository courseRepository)
        {
            _courseRepository = courseRepository ?? throw new ArgumentNullException(nameof(courseRepository));
        }

        public int CreateCourse(Course course)
        {
            try
            {
                // Validate teacher exists and is active
                if (!_courseRepository.IsTeacherValid(course.TeacherId))
                    throw new Exception("Selected teacher is not valid or inactive.");

                // Check if course name already exists
                if (_courseRepository.IsCourseNameExists(course.CourseName))
                    throw new Exception("Course name already exists.");

                course.IsActive = true;
                course.CreatedAt = DateTime.Now;
                return _courseRepository.AddCourse(course);
            }
            catch (Exception ex)
            {
                throw new Exception($"Course creation failed: {ex.Message}", ex);
            }
        }

        public Course GetCourse(int courseId)
        {
            try
            {
                var course = _courseRepository.GetCourseById(courseId);
                if (course == null)
                    throw new Exception("Course not found.");

                return course;
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving course: {ex.Message}", ex);
            }
        }

        public Course GetCourseById(int courseId)
        {
            try
            {
                return _courseRepository.GetCourseById(courseId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving course.", ex);
            }
        }

        public List<Course> ListAllCourses()
        {
            try
            {
                return _courseRepository.GetAllCourses();
            }
            catch (Exception ex)
            {
                throw new Exception("Error listing all courses.", ex);
            }
        }

        public List<Course> ListActiveCourses()
        {
            try
            {
                return _courseRepository.GetActiveCourses();
            }
            catch (Exception ex)
            {
                throw new Exception("Error listing active courses.", ex);
            }
        }

        public bool UpdateCourseDetails(Course course)
        {
            try
            {
                // Validate teacher exists and is active
                if (!_courseRepository.IsTeacherValid(course.TeacherId))
                    throw new Exception("Selected teacher is not valid or inactive.");

                // Check if course name already exists (excluding current course)
                if (_courseRepository.IsCourseNameExists(course.CourseName, course.CourseId))
                    throw new Exception("Course name already exists.");

                return _courseRepository.UpdateCourse(course);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating course details.", ex);
            }
        }

        public bool ActivateDeactivateCourse(Course course)
        {
            try
            {
                return _courseRepository.ActivateDeactivateCourse(course);
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating course status: " + ex.Message, ex);
            }
        }

        public bool RemoveCourse(int courseId)
        {
            try
            {
                return _courseRepository.DeleteCourse(courseId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting course.", ex);
            }
        }

        public List<Course> SearchByTerm(string term)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(term))
                    return new List<Course>();

                return _courseRepository.SearchCourses(term.Trim());
            }
            catch (Exception ex)
            {
                throw new Exception("Error searching courses.", ex);
            }
        }

        public List<Course> GetCoursesByTeacher(int teacherId)
        {
            try
            {
                return _courseRepository.GetCoursesByTeacher(teacherId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error retrieving courses by teacher.", ex);
            }
        }

        public int CountTotalCourses()
        {
            try
            {
                return _courseRepository.GetTotalCourseCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting total courses.", ex);
            }
        }

        public int CountActiveCourses()
        {
            try
            {
                return _courseRepository.GetActiveCourseCount();
            }
            catch (Exception ex)
            {
                throw new Exception("Error counting active courses.", ex);
            }
        }

        public bool AssignTeacherToCourse(int courseId, int teacherId)
        {
            try
            {
                // Validate teacher exists and is active
                if (!_courseRepository.IsTeacherValid(teacherId))
                    throw new Exception("Selected teacher is not valid or inactive.");

                var course = _courseRepository.GetCourseById(courseId);
                if (course == null)
                    throw new Exception("Course not found.");

                course.TeacherId = teacherId;
                course.UpdatedAt = DateTime.Now;

                return _courseRepository.UpdateCourse(course);
            }
            catch (Exception ex)
            {
                throw new Exception("Error assigning teacher to course.", ex);
            }
        }

        public bool ValidateTeacher(int teacherId)
        {
            try
            {
                return _courseRepository.IsTeacherValid(teacherId);
            }
            catch (Exception ex)
            {
                throw new Exception("Error validating teacher.", ex);
            }
        }
    }
}