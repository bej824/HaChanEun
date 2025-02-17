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
<style>
</style>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>Insert title here</title>

</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

<h2>글 작성 페이지</h2>
	
	<form id="registerForm" action="register" method="POST">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	
	<div>
	<p>판매자 : <sec:authentication property="name" /></p>
	<p>음식 이름 : 
	<input type="text" id="itemName" name="itemName" placeholder="음식 입력"
	maxlength="200" required></p>
	</div>
	
	<div>
	<p>가격 :
	<input type="text" id="itemPrice" name="itemPrice" placeholder="가격 입력"
	maxlength="100" required></p>
	</div> 
	
	<div>
	<p>수량 :
	<input type="text" id="itemAmount" name="itemAmount" placeholder="현재 수량 입력"
	maxlength="1000" required></p>
	</div>
	
	<div>
	<p>태그 : 
	<input type="text" id="itemTag" name="itemTag" placeholder="태그 입력"
	maxlength="100" required></p>
	</div>
	
	<div>
	<p>상품 설명 : </p>
	<textarea rows="20" cols="120" id="itemContent" name="itemContent" placeholder="내용을 입력하세요." maxlength="1500" required>
	</textarea><br>
	<button id="registerItem"> 등록 </button>
	</div>
	
	</form>

<script>
$(document).ajaxSend(function(e, xhr, opt){
	console.log("ajaxSend");
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	xhr.setRequestHeader(header, token);
});

$(document).ready(function() {
	$('#registerItem').click(function(e) {
		e.preventDefault();  // 기본 폼 제출 동작을 막음
		registerForm.submit();
	});
});

</script>

</div> <!-- area -->
</body>
</html>