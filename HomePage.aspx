<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Public.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="LMS.HomePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hero-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
            color: white;
        }
        .hero-section .btn-primary {
            background-color: #ff6f61;
            border: none;
        }
        .hero-section .btn-primary:hover {
            background-color: #ff4b3e;
        }
        .about-section p {
            font-size: 1.1rem;
            line-height: 1.6;
        }
        .features-section {
            background-color: #f8f9fa;
            padding: 50px 0;
        }
        .feature-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
        .feature-icon {
            font-size: 40px;
            color: #ff6f61;
            margin-bottom: 20px;
        }
        .testimonial-section {
            background-color: #182848;
            color: white;
            padding: 60px 0;
            text-align: center;
        }
        .testimonial {
            font-style: italic;
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }
        .testimonial-author {
            font-weight: bold;
            margin-top: 0.5rem;
        }
        .newsletter-section {
            background: #ff6f61;
            color: white;
            padding: 40px 0;
            text-align: center;
            border-radius: 0 0 15px 15px;
        }
        .newsletter-input {
            max-width: 400px;
            margin: 0 auto;
        }
        @media (max-width: 767px) {
            .about-section {
                flex-direction: column !important;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class ="container-fluid">
         <!-- hero -->
        <div class="hero-section text-center bg-light rounded-3">
            <div class="container">
                <h1 class="display-5 fw-bold">Welcome to ITVerse</h1>
                <p class="hero-text">Explore courses, resources, and opportunities in tech.</p>
                <a href="/Pages/Public/Courses.aspx" class="btn btn-primary btn-lg">Browse Courses</a>
             </div>
        </div>
         <!--about--->
        <div class="about-section row align-items-center mt-5">
            <div class="col-md-5 ms-5">
                <img src='<%= ResolveUrl("~/Images/study.jpg") %>' class="img-fluid rounded shadow" alt="study"/>
            </div>
            <div class="col-md-6 text-center">
                <h2 class="text-dark fw-bold mb-3 border-bottom border-3 border-primary pb-2">
                    Why Choose ITVerse?
                </h2>                
                <p>We provide hands-on, real-world IT courses to empower students and professionals across Nepal. Join us to grow your skills and build your tech future. Our platform offers multimedia-rich content, interactive tools, and real-time mock exams and MCQs to enhance your learning journey.</p>
                <a href="/Pages/Public/AboutUs.aspx" class="btn btn-outline-primary mt-3">Learn More</a>
            </div>
        </div>
      <!--Featured--->

         <section class="features-section text-center mt-5">
                    <div class="container">
                        <h2 class="fw-bold mb-4">Our Key Features</h2>
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="feature-card">
                                    <div class="feature-icon">💻</div>
                                    <h4>Interactive Learning</h4>
                                    <p>Engage with video tutorials, quizzes, and hands-on projects to deepen your understanding.</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card">
                                    <div class="feature-icon">📚</div>
                                    <h4>Comprehensive Courses</h4>
                                    <p>Access a wide variety of IT subjects including Cybersecurity, Data Science, Cloud Computing, and more.</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card">
                                    <div class="feature-icon">🎓</div>
                                    <h4>Certification</h4>
                                    <p>Earn certificates to showcase your skills and boost your career prospects.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
    <!--testimonials-->
        <section class="testimonial-section mt-5">
            <div class="container">
                <h2 class="fw-bold mb-5">What Our Students Say</h2>
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <p class="testimonial">"ITVerse transformed my career by providing practical, easy-to-follow courses. The mock exams helped me pass certification with confidence!"</p>
                        <div class="testimonial-author">– Sita Sharma</div>
                        <hr class="bg-white my-4"/>
                        <p class="testimonial">"The interactive tools and community support make learning enjoyable and effective. Highly recommended for anyone serious about IT."</p>
                        <div class="testimonial-author">– Rajesh Thapa</div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</asp:Content>
