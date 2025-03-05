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
		<c:forEach var="itemList" items="${itemList }">
			<tr>
				<td>${itemList.itemName }</td>
				<td>${itemList.mainCtg }</td>
				<td>${itemList.subCtg }</td>
				<td>${itemList.itemPrice }</td>
				<td id="status">
				    <c:choose>
				        <c:when test="${itemList.itemStatus == 100}">
				            <span class="permission" data-status="100" onclick="changeStatus(${itemList.itemId}, 100)">판매 중</span>
				        </c:when>
				        <c:when test="${itemList.itemStatus == 200}">
				            <span class="permission" data-status="200">판매 중지</span>
				        </c:when>
				        <c:when test="${itemList.itemStatus == 300}">
				            <span class="permission" data-status="300" onclick="changeStatus(${itemList.itemId}, 300)">판매 허가 요청</span>
				        </c:when>
				        <c:otherwise>
				            <span class="permission" onclick="changeStatus(${itemList.itemId}, 0)">상태 미정</span>
				        </c:otherwise>
				    </c:choose>
			<input type="hidden" class="itemId" value="${itemList.itemId }">
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
	
	function changeStatus(itemId, currentStatus) {
	    let itemStatus;
	    console.log("currentStatus" + currentStatus);

	    // 상태에 따른 변경 처리
	    if (currentStatus === 300) { // 판매 중
	    	let result = confirm("해당 물품의 판매를 허가 하시겠습니까?");
			if(result) {
				itemStatus = 100;
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
			            	location.reload();
			            } else {
			                alert("변경 실패");
			            }
			        },
			    });
			}
				alert("변경 완료");
				return;
	    } else if (currentStatus === 100) { // 판매 허가 요청
	    	let result = confirm("해당 물품의 판매 허가를 취소하시겠습니까?");
			if(result) {
				itemStatus = 300;
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
			            	location.reload();
			            } else {
			                alert("변경 실패");
			            }
			        },
			    });
			}
				alert("변경 완료");
				return;
	    } else {
	        alert("이 상태는 변경할 수 없습니다.");
	        return;
	    }
	}
	
	$(document).ready(function(){
		

		
		$('table tbody').on('click', '.permission', function(){
			let row = $(this).closest("tr");  // 클릭된 .permission을 포함하는 행을 찾음
	        let itemId = row.find('.itemId').val(); // .itemId input의 값
	        let itemStatus = $(this).data('status');
	        console.log("itemId : " + itemId);
	        console.log("itemStatus : " + itemStatus);
			
			changeStatus(itemId, itemStatus);
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