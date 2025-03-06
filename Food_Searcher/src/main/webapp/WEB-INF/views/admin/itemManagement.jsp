<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file ="../header.jsp" %>
</head>
<body>
<div id="area">
<h1>사이트 상품 관리 페이지</h1>
	
	<table>
		<thead>
			<tr>
				<th style="width: 10%">상품 명</th>
				<th style="width: 10%">대분류</th>
				<th style="width: 10%">소분류</th>
				<th style="width: 10%">가격</th>
				<th style="width: 10%">상태</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="ItemVO" items="${itemList}">
			<tr>
				<td>${ItemVO.itemName }</td>
				<td>${ItemVO.mainCtg}</td>
				<td>${ItemVO.subCtg }</td>
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
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<br>
	<ul>
			<!-- 이전 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isPrev() }">
				<li class="pagination_button"><a href="itemManagement?&pageNum=${pageMaker.startNum - 1}" class="button">이전</a></li>
			</c:if>
			<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
			<c:forEach begin="${pageMaker.startNum }"
				end="${pageMaker.endNum }" var="num">
				<li class="pagination_button"><a href="itemManagement?&pageNum=${num }" class="button">${num }</a></li>
			</c:forEach>
			<!-- 다음 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isNext() }">
				<li class="pagination_button"><a href="itemManagement?&pageNum=${pageMaker.endNum + 1}" class="button">다음</a></li>
			</c:if>
		</ul>
	
</div>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		$('.itemStatus').on('click', function(){
			
			let permission = $(this).data("status");
			let row = $(this).closest("tr");
			let itemId = row.find(".itemId").val();
			
			console.log(permission, itemId);
			
			if(permission == "100"){
				let result = confirm("해당 물품의 판매를 중단 하시겠습니까?");
				
				if(result) {
					$(this).data("status", 300);
					itemStatus = 300;
					updateItemStatus();
					row.find(".itemStatus").html("판매 허가 요청");
					alert("변경 완료 : 판매 허가 요청");
				}
			
			} else if(permission == "300") {
				let result = confirm("해당 물품의 판매를 허가하시겠습니까?");
				
				if(result) {
					$(this).data("status", 100);
					itemStatus = 100;
					updateItemStatus();
					row.find(".itemStatus").html("판매 중");
					alert("변경 완료 : 판매 중");
				}
			} else if(permission == "200") {
				alert("변경할 수 없는 상태입니다.");
				
			} else if(permission == "0") {
				let result = confirm("해당 물품의 상태를 변경하시겠습니까?");
				
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
				        url: "../admin/updateStatus/" + itemId,
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
			
		
		function roleUpdate() {
			let memberId = document.getElementById("memberId").value;
			let roleName = "ROLE_SELLER";
			let result = confirm(memberId + "님을 운영자 등록시키겠습니까?");
			if (result) {
				$.ajax({
	  		    	type: 'POST',
	  		    	url: 'roleUpdate',
	  		    	data: { memberId: memberId,
	  		    			roleName: roleName},
	  		    	success: function(result) {
	  		      		alert("등록완료되었습니다.");
	  		    	}
	  		  	});
			} else {
				alert("취소되었습니다.");
			}
		}
	
	});
	
	
	</script>

</body>
</html>