<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
.button {
	margin : 5px;
}

#increasedAmount {
	width:5em;
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
<title>판매 관리</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	
	<div id="area">
	
	<h1>판매 관리</h1>
	
	<div style="display: flex;">
	<a href="/searcher/item/register" class="button">상품 등록</a>
	<a href="purchaseHistory" class="button">상품 거래 내역</a>
	</div>
	
	<table>
		<thead>
			<tr>
				<th style="width: 10%">상품 명</th>
				<th style="width: 10%">분류</th>
				<th style="width: 10%">가격</th>
				<th style="width: 10%">상태</th>
				<th style="width: 10%">수량</th>
				<th style="width: 10%"></th>
				<th style="width: 10%"></th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="ItemVO" items="${itemList}">
			<tr>
				<td>${ItemVO.itemName }</td>
				<td>${ItemVO.mainCtg}</td>
				<td><fmt:formatNumber value="${ItemVO.itemPrice}" pattern="###,###,###" />원</td>
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
					<input type="number" id="increasedAmount" min="1" maxlength="6" required oninput="numberMaxLength(this); preventNegative(this);" >
					<button class="plusBtn">증가</button></td>
				<td>
				<span class="updateItem" id="${ItemVO.itemId }" data-status="${ItemVO.itemStatus }">수정</span><br><br>
				<span class="deleteItem" id="${ItemVO.itemId }" data-id="${ItemVO.itemName }" data-status="${ItemVO.itemStatus }">삭제</span>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>	
	<br>
	
	<ul>
			<!-- 이전 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isPrev() }">
				<li class="pagination_button"><a href="status?&pageNum=${pageMaker.startNum - 1}" class="button">이전</a></li>
			</c:if>
			<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
			<c:forEach begin="${pageMaker.startNum }"
				end="${pageMaker.endNum }" var="num">
				<li class="pagination_button"><a href="status?&pageNum=${num }" class="button">${num }</a></li>
			</c:forEach>
			<!-- 다음 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isNext() }">
				<li class="pagination_button"><a href="status?&pageNum=${pageMaker.endNum + 1}" class="button">다음</a></li>
			</c:if>
		</ul>
		
	</div>
	<script type="text/javascript">
	
	$(document).ready(function(){
		$('#btn_memberCoupon').click(function(){
			window.location.href = "../access/memberCoupon";
		})
		
		$('#btn_couponList').click(function(){
			window.open("../coupon/list", "_blank", "width=800,height=600,scrollbars=yes,resizable=yes");
		})

		$('.deleteItem').click(function() {
			// 게시글 삭제 클릭 시
			let itemId = $(this).attr('id');
			let itemName = $(this).attr('data-id');
			let permission = $(this).attr('data-status');
			if(permission != "100" ) {
			 if (confirm(itemName + '을 삭제하시겠습니까?')) {
				 
				 $.ajax({
				        type: "POST",
				        url: "../item/delete",
				        data: {itemId:itemId},
				        success: function (result) {
				            if (result == 1) {
				            	alert("삭제가 완료되었습니다.");
				            	location.reload(true);
				            } else {
				                alert("삭제에 실패하였습니다.");
				            }
				        },
				    });
			 }
			} else {
				alert("판매중인 상품은 삭제하실수 없습니다.");
			}
		});
		
		$('.updateItem').click(function() {
			let permission = $(this).attr('data-status');
			let itemId = $(this).attr('id');
			if(permission != "100" ) {
				location.href = '/searcher/item/modify?itemId=' + itemId;
			} else {
				alert("판매중인 상품은 수정하실수 없습니다.");
			}
		});
		
		$('.itemStatus').on('click', function(){
			let permission = $(this).data("status");
			let row = $(this).closest("tr");
			let itemId = row.find(".itemId").val();
			
			if(permission == "100"){
				let result = confirm("해당 물품의 판매를 중단 하시겠습니까?");
				
				if(result) {
					$(this).data("status", 200);
					itemStatus = 200;
					updateItemStatus();
					row.find(".itemStatus").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "300") {
				let result = confirm("해당 물품의 판매를 중단하시겠습니까?");
				
				if(result) {
					$(this).data("status", 200);
					itemStatus = 200;
					updateItemStatus();
					row.find(".itemStatus").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "200") {
				let result = confirm("해당 물품의 판매 중지를 취소하시겠습니까?");
				
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
			            if (result == 1) {
			            	location.reload(true);
			            } else {
			                alert("변경 실패");
			            }
			        },
			    });
			};
			
		});
	
		$('.plusBtn').on('click', function(){
			let row = $(this).closest("tr");
			let itemAmount = parseInt(row.find(".itemAmount").data("amount"), 10);
			let increasedAmount = parseInt(row.find("#increasedAmount").val(), 10);
			let itemId = row.find(".itemId").val();
			itemAmount = itemAmount + increasedAmount;
			
			$.ajax({
		        type: "PATCH",
		        url: "../seller/status/" + itemId + "/" + itemAmount,
		        headers: {
		            "Content-Type": "application/json",
		        },
		        data: JSON.stringify(itemId, itemAmount),
		        success: function (result) {
		            if (result == 1) {
		            	 location.reload(true);
		            } else {
		                alert("변경 실패");
		            }
		        },
		    });
			
		});
	});
	
	 function numberMaxLength(e){ // 길이 제한 스크립트

	        if(e.value.length > e.maxLength){
	            e.value = e.value.slice(0, e.maxLength);
	        }
	 }
	 
	 function preventNegative(element) { // 음수 제한 스크립트
		    if (element.value < 0) {
		        element.value = "";
		    }
		}
	
	</script>
</body>
</html>