<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>


.item {
	margin-top: 20px; /* 첨부 목록 위에 여백 추가 */
    background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
    margin-bottom: 20px; /* 첨부 목록 아래에 여백 추가 */
    height: 200px; /* 첨부 목록의 고정 높이 설정 */
    width: 500px; /* 첨부 목록의 고정 너비 설정 */
}

li {
	display:inline-block;
}

</style>

<link rel="stylesheet"
	href="../resources/css/Base.css">
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>상품 리스트</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

<h1>상품 리스트</h1>

<sec:authorize access="hasRole('ROLE_ADMIN')">
<a href="/searcher/item/register" class="button">상품 등록</a>
</sec:authorize>

<hr>

			<c:forEach var="itemVO" items="${itemList}">
			<div class="item" onclick="window.location.href='detail?itemId=${itemVO.itemId}'">
			
					<div>썸네일 삽입 예정</div><br>
					<p>상품명 : ${itemVO.itemName }</p>
					<p>상품번호 : ${itemVO.itemId }</p>
					<p>분류 : ${itemVO.itemTag }</p>
					<p>가격 : <fmt:formatNumber value="${itemVO.itemPrice}" pattern="###,###,###"/>원</p>
					
			</div>
			</c:forEach>
	
	<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
	
	<sec:authorize access="hasRole('ROLE_MEMBER')">
	<a id="cartLink" href="#">장바구니로 이동</a>
	</sec:authorize>

<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	  document.addEventListener("DOMContentLoaded", function () {
	        let memberId = document.getElementById("memberId").value;  // 숨겨진 input에서 memberId 가져오기
	        let cartLink = document.getElementById("cartLink");  // <a> 태그 선택
	        if (memberId) {
	            cartLink.href = "../cart/list/" + encodeURIComponent(memberId); // href 속성 설정
	        } else {
	            console.warn("memberId가 존재하지 않습니다.");
	        }
	    });
	
		  
	  
	
</script>	
</div> <!-- area -->
</body>
</html>