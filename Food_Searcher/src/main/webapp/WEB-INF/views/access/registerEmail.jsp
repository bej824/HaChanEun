<%@page import="java.time.LocalTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>하찬은 이메일 인증</title>
</head>
<body>
	<jsp:include page="../header.jsp" />
	<h1>이메일 확인</h1>
	<jsp:include page="emailAuthHeader.jsp" />

</body>
</html>