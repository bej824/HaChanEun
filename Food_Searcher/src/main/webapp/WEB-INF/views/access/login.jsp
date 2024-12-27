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

	<%@ include file ="../header.jsp" %>
	<br>
	<form action = "login" method="POST">
	ID : <input type="text" name="memberId"> <br><br>
	PW : <input type="password" name="password"> <br>
	<input type="submit" value="로그인" class="button">
	</form>
	<a href="ID" class="button">ID 찾기</a>
	<a href="" class="button">PW 찾기</a>
	<%
	if(session.getAttribute("memberId") != null){
		response.sendRedirect("../home");
	}
	%>
	
	<script type="text/javascript">
        <c:if test="${not empty param.status}">
            alert("현재 ${param.status}의 계정입니다.");
        </c:if>
    </script>
    
</body>
</html>