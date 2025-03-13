<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

<p>상품 : </p>
<p>작성자 : <sec:authentication property="name" /></p>
<div>
<p>내용 : </p>
<textarea rows="20" cols="120" id="itemContent" name="itemContent" placeholder="내용을 입력하세요." maxlength="1500" required></textarea><br>
</div>

</div> <!-- area -->
</body>
</html>