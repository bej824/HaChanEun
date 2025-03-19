<%@page import="java.time.LocalTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>하찬은 이메일 인증</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	<h1>이메일 확인</h1>
	<%@ include file ="emailAuthHeader.jsp" %>
	</div>
</body>
</html>