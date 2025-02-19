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

<h2>${memberId }님의 장바구니</h2>
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
                <td id="btnCheck">
                <input type="checkbox" class="checkBox" checked="checked">
                </td> <!-- 선택 버튼 -->
                <td>(썸네일)</td>	
                <td>${CartVO.itemName } </td>
                <td>
                    <button class="minusBtn">-</button>
                    <input type="text" style="width: 50px; text-align: center;"
						   name="itemAmount" class="itemAmount" value="${CartVO.cartAmount }" readonly>
                    <button class="plusBtn">+</button>
                </td>
                <td> <div class="itemEachPrice">
                각 <fmt:formatNumber value="${CartVO.itemPrice }" pattern="###,###,###" /> </div>
                <div class="itemTotalPrice" >
                총 <fmt:formatNumber value="${CartVO.itemPrice * CartVO.cartAmount }" pattern="###,###,###" />
                   <input type="hidden" value="total">
                </div> </td>
                <td><button class="delBtn" >×</button></td>
	            <td>
		            <div style="display: none;">
			           	<input type="hidden" class="cartId" value="${CartVO.cartId }">
			        	<input type="hidden" class="memberId" value="${CartVO.memberId }">
			        	<input type="hidden" class="itemId" value="${CartVO.itemId }">
			        	<input type="hidden" class="itemName" value="${CartVO.itemName }">
			        	<input type="hidden" class="itemPrice" value="${CartVO.itemPrice }">
			        	<input type="hidden" class="cartDate" value="${CartVO.cartDate }">
			        	<input type="hidden" class="itemAmount" value="${CartVO.itemAmount }">
		        	</div>
	        	</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

	<p>합계 : <span id="totalPrice"></span> 원</p>
	<div class="divOrder">
	<a id="btnOrder" href="">주문하기</a>
	</div>


	<script>
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		xhr.setRequestHeader(header, token);
	});	 
	
 
		$(".plusBtn").on("click", function() {
			let $row = $(this).closest('tr'); // 현재 버튼이 속한 tr
			let quantity = parseInt($row.find(".itemAmount").val()); // tr에 있는 itemAmount 찾기
			let cartId = $row.find(".cartId").val();
			let itemPrice = parseInt($row.find(".itemPrice").val());
			let itemAmount = $row.find("itemAmount").val();
			 
			console.log("itemAmount : " + itemAmount);
			 // 수량 증가
				 quantity += 1;
				 parseInt($row.find(".itemAmount").val(quantity));
				 console.log("quantity : " + quantity, "cartId : " + cartId, "itemPrice : " + itemPrice);
				 
				 let itemTotalPrice = itemPrice * quantity;
				 let cartAmount = quantity.toString(); 
				 
			 $.ajax({
					type : 'PUT',
					url : '../update/' + cartId,
					headers : {
						'Content-Type' : 'application/json'
					}, 
					data : cartAmount,
					success : function(result) {
						console.log(result);
							if(result == 1) {
								let textContent = "총 " + itemTotalPrice.toLocaleString();
								$row.find(".itemTotalPrice").text(textContent);
								$row.find(".itemTotalPrice").val(itemTotalPrice);
								alert("수량 증가됨");
							} else {
								alert("증가 실패");
							}
						}
				}); // end ajax
		}); // end plus_btn
		
	
		$(".minusBtn").on("click", function(){
			let $row = $(this).closest('tr'); // 현재 버튼이 속한 tr
			let quantity = parseInt($row.find(".itemAmount").val()); // tr에 있는 itemAmount 찾기
			let cartId = $row.find(".cartId").val();
			let itemPrice = parseInt($row.find(".itemPrice").val());
			 
		 
		 // 수량 감소
		 if (quantity > 1) {
			 quantity -= 1;
			 parseInt($row.find(".itemAmount").val(quantity));
			 console.log("quantity : " + quantity, "cartId : " + cartId, "itemPrice : " + itemPrice);
			 
			 let itemTotalPrice = itemPrice * quantity;
			 let cartAmount = quantity.toString(); 
			 console.log("상품 가격 합계 : " + itemTotalPrice);
				 $.ajax({
					type : 'PUT',
					url : '../update/' + cartId,
					headers : {
						'Content-Type' : 'application/json'
					}, 
					data : cartAmount,
					success : function(result) {
						console.log("result = " + result);
							if(result == 1) {
								let textContent = "각 " + itemPrice.toLocaleString() + " | 총 " + itemTotalPrice.toLocaleString();
								$row.find(".itemTotalPrice").text(textContent);
								$row.find(".itemTotalPrice").val(itemTotalPrice);
								alert("수량 감소됨");
								} else {
									alert("감소 실패");
								}
							}
						}); // end ajax
				 } else {
					 alert("최소 수량입니다.");
				 }
			 
			}); 
		
		function setTotalPrice(){
			let row = $(this).closest('tr'); // 현재 버튼이 속한 tr 찾기
			let itemTotalPrice = row.find(".itemTotalPrice").(); // tr에 있는 itemTotalPrice(cartId마다의 총 가격) 찾기
			let totalPrice = 0; // 주문 가격 합계
			
			console.log("itemTotalPrice : " + itemTotalPrice);
			
			 $(".itemTotalPrice").each(function (){ 
				 totalPrice += itemTotalPrice;
				 let textContent = totalPrice;
				 row.find("#totalPrice").text(textContent);
			 });
		};

		$(document).ready(function () {
		    setTotalPrice(); // 페이지 로드 시 실행
		    $(".checkBox, .plusBtn, .minusBtn").on("change click", setTotalPrice); // 체크박스 및 수량 변경 시 업데이트
		});
		
	 $('.delBtn').on('click', function(){
		 let cartId =  $(this).closest('tr').find('.cartId').val();
		 let memberId = $(this).closest('tr').find('.memberId').val(); // 같은 행에서 memberId 가져오기
		 let deleteConfirm = confirm('정말로 삭제하시겠습니까?');
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