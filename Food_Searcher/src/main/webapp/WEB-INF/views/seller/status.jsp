<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
.button {
	margin : 5px;
}
</style>
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Base.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Cart.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/attach.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Detail.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Reply.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/image.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file ="../header.jsp" %>
<div id="area">
<input type="hidden" id="memberId" value=<sec:authentication property="name" />>

<h1>상품 관리</h1>

	<table>
		<thead>
			<tr>
				<th style="width: 10%">상품 명</th>
				<th style="width: 10%">분류</th>
				<th style="width: 10%">가격</th>
				<th style="width: 10%">상태</th>
				<th style="width: 10%">수량</th>
				<th style="width: 10%"></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="ItemVO" items="${itemList}">
			<tr>
				<td>${ItemVO.itemName }</td>
				<td>${ItemVO.mainCtg}</td>
				<td>${ItemVO.itemPrice}</td>
				<td class="itemStatus" data-status="${ItemVO.itemStatus}">
				    <c:choose>
				        <c:when test="${ItemVO.itemStatus == 0}">전체 보기</c:when>
				        <c:when test="${ItemVO.itemStatus == 100}">판매 중</c:when>
				        <c:when test="${ItemVO.itemStatus == 200}">판매 중지</c:when>
				        <c:when test="${ItemVO.itemStatus == 300}">판매 허가 요청</c:when>
	  				</c:choose>
				<input type="hidden" value="${ItemVO.itemId }" class="itemId">
				</td>
				<td class="itemAmount" data-amount="${ItemVO.itemAmount }">
					${ItemVO.itemAmount }
				</td>
				<td>
					<input type="text" size=3 id="increasedAmount">
					<button id="plusBtn" class="button">증가</button></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	
	<script>
	
	$(document).ready(function(){
		
		$('.itemStatus').on('click', function(){
			let permission = $(this).data("status");
			let row = $(this).closest("tr");
			let itemId = row.find(".itemId").val();
			
			if(permission == "100"){
				let result = confirm("해당 물품의 판매를 중단 하시겠습니까?");
				console.log("100>200");
				
				if(result) {
					$(this).data("status", 200);
					itemStatus = 200;
					updateItemStatus();
					row.find(".itemStatus").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "300") {
				let result = confirm("해당 물품의 판매를 중단하시겠습니까?");
				console.log("300>200")
				
				if(result) {
					$(this).data("status", 200);
					itemStatus = 200;
					updateItemStatus();
					row.find(".itemStatus").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "200") {
				let result = confirm("해당 물품의 판매 중지를 취소하시겠습니까?");
				console.log("200>300");
				
				if(result) {
					$(this).data("status", 300);
					itemStatus = 300;
					updateItemStatus();
					row.find(".itemStatus").html("판매 허가 요청");
					alert("변경 완료 : 판매 허가 요청");
				} 
			}
			
			function updateItemStatus(){
				
				$.ajax({
			        type: "PUT",
			        url: "../seller/status/" + itemId,
			        headers: {
			            "Content-Type": "application/json",
			        },
			        data: JSON.stringify(itemStatus),
			        success: function (result) {
			            console.log(result);
			            if (result == 1) {
			            	 location.reload(true);
			            } else {
			                alert("변경 실패");
			            }
			        },
			    });
			};
			
		});
	
		$('#plusBtn').on('click', function(){
			let row = $(this).closest("tr");
			let itemAmount = parseInt(row.find(".itemAmount").data("amount"), 10);
			let increasedAmount = parseInt(row.find("#increasedAmount").val(), 10);
			let itemId = parseInt(row.find(".itemId").val(), 10);
			
			console.log("수량 : " + itemAmount, " | 증가될 수량 : " + increasedAmount, "상품 번호 : " + itemId);
			
			itemAmount = itemAmount + increasedAmount;
			
			console.log("증가된 수량 : " + itemAmount);
			
			$.ajax({
		        type: "PATCH",
		        url: "../seller/status/" + itemId + "/" + itemAmount,
		        headers: {
		            "Content-Type": "application/json",
		        },
		        data: JSON.stringify(itemId, itemAmount),
		        success: function (result) {
		            console.log(result);
		            if (result == 1) {
		            	 location.reload(true);
		            } else {
		                alert("변경 실패");
		            }
		        },
		    });
			
			
		});
	});
	</script>

</div>
</body>
</html>