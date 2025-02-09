<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var registration = "<%= request.getParameter("registration") %>";
    if (registration === "success") {
        swal("Registration Successful!", "Your account has been created successfully.", "success");
    } else if (registration === "error") {
        swal("Registration Failed", "Unable to create your account. Please try again.", "error");
    }
});
</script>
</body>
</html>