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
<hr>


<table>
    <thead>
        <tr>
            <th style="width: 10%">선택</th>
            <th style="width: 20%">썸네일</th>
            <th style="width: 20%">상품명</th>
            <th style="width: 20%">수량 조정</th>
            <th style="width: 20%">금액</th>
            <th style="width: 10%">삭제</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="CartVO" items="${cartVO }"> 
            <tr>
                <td id="btnCheck" onclick="btnCheck()">□</td> <!-- 선택 버튼 -->
                <td>(썸네일)</td>	
                <td>${CartVO.itemName } </td>
                <td>
                    <button class="minusBtn">-</button>
                    <input type="text" style="width: 50px; text-align: center;"
						   name="itemAmount" class="itemAmount" value="${CartVO.cartAmount }">
                    <button class="plusBtn">+</button>
                </td>
                <td>각 ${CartVO.itemPrice} | 총 ${CartVO.itemPrice * CartVO.cartAmount }</td>
                <td><button class="delBtn" >×</button></td>
            <td>
           	<input type="hidden" class="cartId" value="${CartVO.cartId }">
        	<input type="hidden" class="memberId" value="${CartVO.memberId }">
        	<input type="hidden" class="itemId" value="${CartVO.itemId }">
        	<input type="hidden" class="itemName" value="${CartVO.itemName }">
        	<input type="hidden" class="itemPrice" value="${CartVO.itemPrice }">
        	<input type="hidden" class="cartDate" value="${CartVO.cartDate }"></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
	
	
	<p>합계 : ?</p>
	<div class="divOrder">
	<a id="btnOrder" href="">주문하기</a>
	</div>


<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		xhr.setRequestHeader(header, token);
	});	 
	
	 document.addEventListener("DOMContentLoaded", function () {
	        let memberId = document.getElementById("memberId").value;  // 숨겨진 input에서 memberId 가져오기
	        let btnOrder = document.getElementById("btnOrder");  // <a> 태그 선택
	        if (memberId) {
	            btnOrder.href = "../order/" + encodeURIComponent(memberId); // href 속성 설정
	        } else {
	            console.warn("memberId가 존재하지 않습니다.");
	        }
	    });
	 
		$(".plusBtn").on("click", function(){
			 var cartAmount = $(this).closest('tr').find(".itemAmount").val(); // tr에 있는 itemAmount 찾기
			 var cartId = $(this).closest('tr').find(".cartId").val();
			 
			 var obj = {
					 'cartAmount' : cartAmount,
					 'cartId' : cartId
			 };
			 console.log(obj);
			 
			 $.ajax({
					type : 'PUT',
					url : '../' + cartId + '/' + cartAmount,
					headers : {
						'Content-Type' : 'application/json'
					}, 
					data : JSON.stringify(obj),							
					success : function(result) {
						console.log(result);
						if(result == 1) {
							 cartAmount++;
							alert("수량 갱신") // 테스트 후 빼기
						}
					}
				}); // end ajax

		}); // end plus_btn
		
	
		$(".minusBtn").on("click", function(){
				var $itemAmount = $(this).closest('tr').find(".itemAmount");
			    var quantity = parseInt($itemAmount.val(), 10);
			    
			    if(quantity > 1) {
			    quantity--;
			    $itemAmount.val(quantity);
			}
		}); // end minus_btn
		
		
	 $('.delBtn').on('click', function(){
		 var cartId =  $(this).closest('tr').find('.cartId').val();
		 var memberId = $(this).closest('tr').find('.memberId').val(); // 같은 행에서 memberId 가져오기
		 var deleteConfirm = confirm('정말로 삭제하시겠습니까?');
		 console.log("cartId : " + cartId, "memberId : " + memberId);
		 
		 if(deleteConfirm) {
			 $.ajax({
				 type : 'DELETE',
				 url : '../delete/' + cartId,
				 headers : {
						'Content-Type' : 'application/json'
					}, 
				 success : function(result){
					 console.log(result);
					 if(result == 1) {
						 alert('삭제 완료');
						 location.reload(true);
					 } else {
						alert('삭제 실패');
						location.reload(true);
					 }
				 }
				 
			 });
		 }
	 });
		
	
	 
	
</script>
</div> <!-- area -->
</body>
</html>