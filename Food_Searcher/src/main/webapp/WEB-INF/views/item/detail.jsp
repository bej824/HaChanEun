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
.buy {
	background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
}

.button {
	margin : 3px;
}
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
		<p>가격 : <fmt:formatNumber value="${itemVO.itemPrice }" pattern="###,###,###" />원</p>
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
    </form><br>
	
	
	<div class="buy"> 선택된 수량 : <input type="hidden" name="itemPrice" value="${itemVO.itemPrice}">
		<button class="minusBtn">-</button>
		<input type="text" name="itemAmount" class="amount_input" value="1">
		<button class="plusBtn">+</button>
		<br><br>
	<button id="btnCart" class="button">장바구니 담기</button><br>
    <button type="button" id="btnBuy" class="button">바로 구매</button>
	
    <input type="hidden" id="memberId" value=<sec:authentication property="name" />>
    <input type="hidden" id="itemIdInput" name="itemId" value="${itemVO.itemId}">
    
    
	
	</div>
	
	
	
	
	
	
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
	
		let quantity = $(".amount_input").val();
	
		$(".plusBtn").on("click", function(){
			$(".amount_input").val(++quantity);
		}); // end plus_btn
	
	
		$(".minusBtn").on("click", function(){
				if(quantity > 1){
					$(".amount_input").val(--quantity);
			} 
		}); // end minus_btn
		
		const form = {
				memberId : $('#memberId').val(),
				itemId : ${itemVO.itemId},
				itemAmount : '',
		}
		
		console.log(form);
		
		$('#btnCart').on("click", function (e){
			form.itemAmount = $(".amount_input").val();
			
			$.ajax({
				url: '../cart/add',
				type: 'POST',
				data: form,
				success: function(result){
				if (result == '1') {
					alert("장바구니 추가 성공")	
				} else {
					alert("장바구니 추가 성공")
				}
				}
			});
			
		}); // end btnCart
	
		
		document.getElementById("btnBuy").addEventListener("click", function() {
		    let amount = document.querySelector(".amount_input").value;
		    document.getElementById("amountInput").value = amount;

		    document.getElementById("orderForm").submit();
		});

		
		
	</script>
	<!-- 댓글 -->
	
	</div> <!-- area -->
</body>
</html>