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
	<p>회원가입에 사용될 이메일을 입력해주세요. 이메일은 ID, 패스워드 찾기에 사용됩니다.</p>
	<%@ include file ="emailAuthHeader.jsp" %>
	</div>
</body>
</html>