<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<html>
<head>
<title>Home</title>
</head>
<body>
	<%@ include file ="header.jsp" %>
	<h1>Hello world!</h1>

	<P>The time on the server is ${serverTime}.</P>
	
	<%
	HttpSession session = request.getSession();
	if(session.getAttribute("memberId") != null){ %>	
		<p><%=session.getAttribute("memberId") %>님 환영합니다.</p>
	
	<% } %>
	
	<table border="1">
	<thead>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>음식</th>
			<th>음식명</th>
			<th>작성일</th>
			<th>댓글 수</th>
		</tr>
		</thead>
		<tbody>
		<tr>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		</tr>
		</tbody>
	</table> <br>
	<table border="1">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>음식명</th>
			<th>작성일</th>
			<th>댓글 수</th>
			<th>이미지</th>
		</tr>
	</table>
	<br>
	
	<%if(session.getAttribute("memberId") != null){ %>
	<a href="access/memberPage">멤버페이지</a> <br>
	<a href="logout">로그아웃</a>
	<%} else { %>	
	<a href="access/login">로그인</a> / 
	<a href="access/register">회원가입</a>
	<%} %>
	
</body>
</html>
