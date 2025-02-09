<%@ page language="java" contentType="text/html; charset=UTF-8"
	    pageEncoding="UTF-8"%>
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="../css/loginRegister.css" />
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<% 
    Boolean registration_success = (Boolean) session.getAttribute("status");
    Boolean registration_error = (Boolean) session.getAttribute("status_err");
%>
<script>
    window.onload = function() {
        <% if (Boolean.TRUE.equals(registration_success)) { %>
            Swal.fire({
                title: 'Success!',
                text: 'Account Created Successfully.',
                icon: 'success',
                confirmButtonText: 'Login'
            });
            <% session.removeAttribute("status"); %>
        <% } else if (Boolean.TRUE.equals(registration_error)) { %>
            Swal.fire({
                title: 'Error!',
                text: 'Email already exists.',
                icon: 'error',
                confirmButtonText: 'Ok'
            });
            <% session.removeAttribute("status_err"); %>
        <% } %>
    }
</script>
	<main>
     <div class="box">
       <div class="inner-box">
         <div class="forms-wrap">
           <form method="post" action="<%=request.getContextPath()%>/login" autocomplete="off" class="sign-in-form">
             <div class="logo">
               <img src="../img/logo.png" alt="easyclass" />
               <h4>Zen.Home Cleaning</h4>
             </div>

             <div class="heading">
               <h2>Welcome Back</h2>
               <h6>Not registered yet?</h6>
               <a href="#" class="toggle">Sign up</a>
             </div>

             <div class="actual-form">
             	<%
				String error_status = request.getParameter("error");
				if(error_status != null){ %>
				<div>
           			<p style="color: red;"><%= request.getParameter("error") %></p>
           		</div>
   				<% } %>
               <div class="input-wrap">
                 <input
                   type="email"
                   name ="email"
                   minlength="4"
                   class="input-field"
                   autocomplete="off"
                   required
                 />
                 <label>Email</label>
               </div>

               <div class="input-wrap">
                 <input
                   type="password"
                   name="password"
                   minlength="4"
                   class="input-field"
                   autocomplete="off"
                   required
                 />
                 <label>Password</label>
               </div>

               <input type="submit" value="Sign In" class="sign-btn" />

               <p class="text">
                 Forgotten your password or you login datails?
                 <a href="#">Get help</a> signing in
               </p>
             </div>
           </form>

           <form action="<%=request.getContextPath()%>/register" method="post" autocomplete="off" class="sign-up-form">
             <div class="logo">
               <img src="../img/logo.png" alt="easyclass" />
               <h4>Zen.home Cleaning</h4>
             </div>

             <div class="heading">
               <h2>Get Started</h2>
               <h6>Already have an account?</h6>
               <a href="#" class="toggle">Sign in</a>
             </div>

             <div class="actual-form">
               <div class="input-wrap">
                 <input
                   type="text"
                   minlength="4"
                   class="input-field"
                   autocomplete="off"
                   name="username"
                   required
                 />
                 <label>Name</label>
               </div>

               <div class="input-wrap">
                 <input
                   type="email"
                   class="input-field"
                   autocomplete="off"
                   name="email"
                   required
                 />
                 <label>Email</label>
               </div>

               <div class="input-wrap">
                 <input
                   type="password"
                   minlength="4"
                   class="input-field"
                   autocomplete="off"
                   name="password"
                   required
                 />
                 <label>Password</label>
               </div>

               <input type="submit" value="Sign Up" class="sign-btn" />

               <p class="text">
                 By signing up, I agree to the
                 <a href="#">Terms of Services</a> and
                 <a href="#">Privacy Policy</a>
               </p>
             </div>
           </form>
         </div>

         <div class="carousel">
           <div class="images-wrapper">
             <img src="../img/homeCleaning.jpg" class="image img-1 show" alt="" />
             <img src="../img/officeCleaning.jpeg" class="image img-2" alt="" />
             <img src="../img/specializedCleaning.jpg" class="image img-3" alt="" />
           </div>

           <div class="text-slider">
             <div class="text-wrap">
               <div class="text-group">
                 <h2>Home Cleaning</h2>
                 <h2>Office Cleaning</h2>
                 <h2>Specialized Cleaning</h2>
               </div>
             </div>

             <div class="bullets">
               <span class="active" data-value="1"></span>
               <span data-value="2"></span>
               <span data-value="3"></span>
             </div>
           </div>
         </div>
       </div>
     </div>
   </main>
	   
   <script src="../js/loginRegister.js"></script>
</body>
</html>