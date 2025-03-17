<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
	<%@ page import="java.io.*, java.util.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	<link rel="stylesheet"
	href="../resources/css/Base.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

<form id="reviewRegister" action="reviewRegister" method="POST">
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
<input type="hidden" name="itemId" value="${reviewVO.itemId }">
	
	<p>상품 : ${reviewVO.itemName }</p>
	<p>설명 : ${reviewVO.itemContent }</p>
	<p>작성자 : <sec:authentication property="name" /></p>
	<div>
	<p>내용 : </p>
	<textarea rows="20" cols="120" id="reviewContent" name="reviewContent" placeholder="내용을 입력하세요." maxlength="1500" required></textarea><br>
	</div>
	
	<div>
	<p>이 상품을 추천하시나요?</p>
	<input type="radio" name="reviewLove" value="1" /><label>예</label>
	<input type="radio" name="reviewLove" value="0" /><label>아니오</label>
	</div>
	
	<input type="hidden" name="reviewLove" value="1">
	<input type="hidden" name="likesCount" value="1">
	
	<button id="register" class="button">등록</button>
</form>
</div> <!-- area -->

<script>
	
</script>

</body>
</html>