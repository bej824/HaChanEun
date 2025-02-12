<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>
.buy {
	background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
    width:500px;
}

.button {
	margin : 3px;
}
</style>

<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Detail.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Base.css">

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<title>장바구니</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
<div id="area">
<input type="hidden" id="memberId" value=<sec:authentication property="name" />>

<h2>장바구니</h2>
<p>주문자 : <sec:authentication property="name" /></p>

<c:forEach var="CartVO" items="${cartVO }"> 
	<div class="buy">
		<div>(썸네일)</div>
		<p>상품명 : ${CartVO.itemName }</p>
		<p>상품 가격 : <fmt:formatNumber value="${CartVO.itemPrice }" /></p>
		<p>상품 수량 : ${CartVO.cartAmount }</p>
		<p>상품 번호 : ${CartVO.itemId }</p><br>
		<p>가격 : <fmt:formatNumber value="${CartVO.totalPrice }" /></p>
	</div><br>
	</c:forEach>
	
	
	<p>합계 : ?</p>
	<a id="btnOrder" href="#">주문하기</a>
	


<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});	 
	
	 document.addEventListener("DOMContentLoaded", function () {
	        let memberId = document.getElementById("memberId").value;  // 숨겨진 input에서 memberId 가져오기
	        let btnOrder = document.getElementById("cartLink");  // <a> 태그 선택
	        if (memberId) {
	            cartLink.href = "../cart/order/" + encodeURIComponent(memberId); // href 속성 설정
	        } else {
	            console.warn("memberId가 존재하지 않습니다.");
	        }
	    });
	 
	
</script>
</div> <!-- area -->
</body>
</html>