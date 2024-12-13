<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<html>
<head>
<title>Home</title>
</head>
<body>
	<h1>Hello world!</h1>

	<P>The time on the server is ${serverTime}.</P>
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
</body>
</html>
