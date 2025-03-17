<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns:layout="http://www.ultraq.net.nz/web/thymeleaf/layout" xmlns:th="http://www.thymeleaf.org/">
<head>
<meta charset="UTF-8">
<title>Kakaopay Sample</title>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
</head>
<body>
<%@ include file ="../header.jsp" %>
<h1>승인 결과(result of approval)</h1>
<p th:text="${response}"></p>
<a href="../home" target="_parent">go to index page</a>
</body>
</html>