<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Detail.css">
<link rel="stylesheet"
	href="../resources/css/Reply.css">
	<link rel="stylesheet"
	href="../resources/css/Base.css">
<style>
</style>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>상품</title>
</head>
<body>
		<%@ include file ="/WEB-INF/views/header.jsp" %>
	<!-- 게시글 -->
	<div id="area">
	<h2>글 보기</h2>
	<div>
		<p>음식 이름 : ${itemVO.itemName }</p>
		<p>가격 : ${itemVO.itemPrice }</p>
		<p>현재 수량 : ${itemVO.itemAmount }</p>
		<p>등록 일자 : <fmt:formatDate pattern="yyyy-MM-dd" value="${itemVO.itemDate }" /></p>
	</div>
	
	
	
	<input type="hidden" id="itemId" value="${itemVO.itemId }">
	
	<div>
		<textarea class="content" rows="20" cols="120" readonly>${itemVO.itemContent }</textarea>
		
	</div>
	
	<button onclick="location.href='list'" class="button" id="listBoard">글 목록</button>
	<br><br>
	
		
   	 <button onclick="location.href='modify?itemId=${itemVO.itemId }'" class="button">글수정</button><br>
	
    <button id="deleteItem" class="button">글 삭제</button>
    <form id="deleteForm" action="delete" method="POST">
        <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
        <input type="hidden" autocomplete="off" class="form-control" id="userName" name="name" value="${session.memberId }">
    </form>
	
	<br><br>
	
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});	 
	
	$(document).ready(function() {
		$('#deleteItem').click(function() {
			// 게시글 삭제 클릭 시
			var itemId = ${itemVO.itemId}
			// 게시글ID 불러오기
			
			console.log("marketId : " + marketId);
			
			 if (confirm('삭제하시겠습니까?')) {
				 $('#deleteForm').submit();
			 }
		});
	}); // end deleteItem
		

	</script>
	<!-- 댓글 -->
	
	</div> <!-- area -->
</body>
</html>