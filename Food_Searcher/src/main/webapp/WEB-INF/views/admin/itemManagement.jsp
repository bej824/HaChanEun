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
				<th style="width: 10%">판매자</th>
				<th style="width: 10%">분류</th>
				<th style="width: 10%">가격</th>
				<th style="width: 10%">상태</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<br>
	<ul>
			<!-- 이전 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isPrev() }">
				<li class="pagination_button"><a href="${pageMaker.startNum - 1}" class="button">이전</a></li>
			</c:if>
			<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
			<c:forEach begin="${pageMaker.startNum }"
				end="${pageMaker.endNum }" var="num">
				<li class="pagination_button"><a href="${num }" class="button">${num }</a></li>
			</c:forEach>
			<!-- 다음 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isNext() }">
				<li class="pagination_button"><a href="${pageMaker.endNum + 1}" class="button">다음</a></li>
			</c:if>
		</ul>
	
</div>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		itemList();
		
		$('table tbody').on('click', '.permission', function(){
			let permission = $(this).html();
			let row = $(this).closest("tr");
			let itemId = row.find(".itemId").val();
			
			if(permission == "판매 허가 요청"){
				let result = confirm("해당 물품의 판매를 허가 하시겠습니까?");
				if(result) {
					itemStatus = 100;
					updateItemStatus();
					row.find(".permission").html("판매 중");
					alert("변경 완료");
				}
			} else if(permission == "판매 중") {
				let result = confirm("해당 물품의 판매 허가를 취소하시겠습니까?");
				if(result) {
					itemStatus = 300;
					updateItemStatus();
					row.find(".permission").html("판매 허가 요청");
					alert("변경 완료");
				}
			} else {
				return;
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
			            } else {
			                alert("변경 실패");
			            }
			        },
			    });
			};
		})
		
		function itemList(){
		
			$.ajax({
		    	type: 'GET',
		    	url: 'itemList',
		    	data: {},
		    	success: function(result) {
		    	  	let tbody = $('table tbody');
		          	tbody.empty(); // 기존 테이블 내용 비우기
		    	  	result.forEach(function(itemList) {
		    	  		let itemStatus = "";
		    	  		
		    	  			if(itemList.itemStatus == 300) {
		    	  				itemStatus = "판매 허가 요청"
		    	  			} else if(itemList.itemStatus == 100) {
		    	  				itemStatus = "판매 중"
		    	  			} else if(itemList.itemStatus == 200) {
		    	  				itemStatus = "판매 중지"
		    	  			}
		    	  		
		            	
		                let row = 
		                	'<tr>'
		                    + '<td>' + itemList.itemName + '</td>'
	                		+ '<td>' + itemList.memberId + '</td>'
		                    + '<td>' + itemList.itemTag + '</td>'
		                    + '<td>' + itemList.itemPrice + '</td>'
		                    + '<td> <a class=permission>' + itemStatus + '</a> </td>'
		                    + '<input type="hidden" class="itemId" value="' + itemList.itemId + '">'
		                    + '</tr>';
		                    
		          		tbody.append(row); // 새로운 데이터 행 추가
		    
		  				});
					}
				});
			}
		
		
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