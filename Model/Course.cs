using System;
using System.ComponentModel.DataAnnotations;

namespace LMS.Model
{
    public class Course
    {
        public int CourseId { get; set; }

        [Required(ErrorMessage = "Course name is required.")]
        [StringLength(100, ErrorMessage = "Course name cannot exceed 100 characters.")]
        public string CourseName { get; set; }

        [StringLength(500, ErrorMessage = "Description cannot exceed 500 characters.")]
        public string Description { get; set; }

        [Url(ErrorMessage = "Please enter a valid YouTube URL.")]
        [StringLength(255)]
        public string YouTubeLink { get; set; }

        [StringLength(255)]
        public string Thumbnail { get; set; }

        [StringLength(50, ErrorMessage = "Duration format is too long.")]
        public string Duration { get; set; }

        [Required(ErrorMessage = "Teacher is required.")]
        public int TeacherId { get; set; }

        public bool IsActive { get; set; } = true;

        public DateTime CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }
    }
}