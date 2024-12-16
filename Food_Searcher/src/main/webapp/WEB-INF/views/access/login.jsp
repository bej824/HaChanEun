<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<form action = "login" method="POST">
	<p>ID : </p>
	<input type="text" name="memberId"> <br>
	<p>PW : </p>
	<input type="password" name="password"> <br>
	<input type="submit" value="로그인">
	</form>
	
	<%
	if(session.getAttribute("memberId") != null){
		response.sendRedirect("../home");
	}
	%>
    
</body>
</html>