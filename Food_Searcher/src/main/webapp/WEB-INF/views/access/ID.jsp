<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>ID 찾기</h2>
	<form action = "ID" method="POST">
		<p>회원 이름</p>
		<input type="text" id="memberName" name="memberName">
		<p>email</p>
		<input type="email" id="email" name="email">
		<br>
		<input type="submit" value="ID 찾기">
		<p>Member ID: ${memberVO.id}</p>
		<p>Member Name: ${memberVO.name}</p>
		<p>Member Email: ${memberVO.email}</p>
	
	</form>
	

	<hr>
	
	
	<c:forEach var="MemberVO" items="${memberList }">
		<p>${MemberVO.memberName }</p>
		<p>${MemberVO.email }</p>
	</c:forEach>

	<c:if test="${memberName eq memberVO.memberName }">
		<p>${memberVO.memberName }</p>
	</c:if>
	<c:if test="${memberName eq null }">
		<p>memberID 출력부분</p>
	</c:if>
</body>
</html>