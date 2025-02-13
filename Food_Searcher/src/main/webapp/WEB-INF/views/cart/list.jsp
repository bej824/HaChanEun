<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>

</style>

<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Base.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Cart.css">

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

<h2><sec:authentication property="name" />님의 장바구니</h2>



<table>
    <thead>
        <tr>
            <th style="width: 60px">선택</th>
            <th style="width: 100px">썸네일</th>
            <th style="width: 120px">상품명</th>
            <th style="width: 200px">수량 조정</th>
            <th style="width: 160px">금액</th>
            <th style="width: 60px">삭제</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="CartVO" items="${cartVO }"> 
            <tr>
                <td id="checkBtn" onclick="btnCheck">□</td> <!-- 선택 버튼 -->
                <td>(썸네일)</td>
                <td>${CartVO.itemName }</td>
                <td>
                    <button class="minusBtn">-</button>
                    <input type="text" style="width: 50px; text-align: center;" name="itemAmount" class="itemAmount" value="${CartVO.cartAmount }">
                    <button class="plusBtn">+</button>
                </td>
                <td>가격</td>
                <td class="cartInfo">
                <input type="hidden" class="cartId" value="${CartVO.cartId }">
                <input type="hidden" class="memberId" value="${CartVO.memberId }">
                <input type="hidden" class="itemId" value="${CartVO.itemId }">
                <input type="hidden" class="itemName" value="${CartVO.itemName }">
                <input type="hidden" class="itemPrice" value="${CartVO.itemPrice }">
                <input type="hidden" class="cartDate" value="${CartVO.cartDate }">
                
                </td>
                <td><button class="delBtn" data-cartid="${CartVO.cartId }">×</button></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
	
	<form action="/cart/delete" method="post" class="deleteForm">
				<input type="hidden" name="cartId" class="deleteCartId">
				<input type="hidden" name="memberId" value="${CartVO.memberId}">
	</form>
	
	
	<p>합계 : ?</p>
	<div class="divOrder">
	<a id="btnOrder" href="#">주문하기</a>
	</div>


<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});	 
	
	 document.addEventListener("DOMContentLoaded", function () {
	        let memberId = document.getElementById("memberId").value;  // 숨겨진 input에서 memberId 가져오기
	        let btnOrder = document.getElementById("btnOrder");  // <a> 태그 선택
	        if (memberId) {
	            btnOrder.href = "../cart/order/" + encodeURIComponent(memberId); // href 속성 설정
	        } else {
	            console.warn("memberId가 존재하지 않습니다.");
	        }
	    });
	 
	 $('#delBtn').on('click', function(e){
		 e.preventDefault();
		 const cartId = $(this).data("cartId");
		 // del 버튼에 data속성으로 심어진 cartId 데이터 가져오기
		 $(".deleteCartId").val(cartId);
		 $(".deleteForm").submit();
		 // delete 실행, Form 제출
		 
	 });
	 
	
</script>
</div> <!-- area -->
</body>
</html>