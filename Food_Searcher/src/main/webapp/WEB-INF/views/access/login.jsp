<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>

	<%@ include file ="../header.jsp" %>
	<br>
	<form action = "login" method="POST">
	ID : <input type="text" name="memberId"> <br><br>
	PW : <input type="password" name="password"> <br>
	<input type="submit" value="로그인" class="button">
	</form>
	<a href="registerEmail?select=idSearch" class="button">ID 찾기</a>
	<a href="registerEmail?select=pwSearch" class="button">PW 찾기</a>
	
    <c:if test="${not empty alertMsg}">
       <script> alert("${alertMsg }"); </script>
    </c:if>

	<c:if test="${sessionScope.memberId != null}">
    	<script> window.location.href = "../home"; </script>
	</c:if>
	
    
</body>
</html>