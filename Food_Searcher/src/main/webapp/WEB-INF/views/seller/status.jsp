<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>


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
				<th style="width: 10%">수량</th>
				<th style="width: 10%">분류</th>
				<th style="width: 10%">가격</th>
				<th style="width: 10%">상태</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	
	<script>
	
	$(document).ready(function(){
		itemList();
		
		$('table tbody').on('click', '.permission', function(){
			let permission = $(this).html();
			let row = $(this).closest("tr");
			let itemId = row.find(".itemId").val();
			
			if(permission == "판매 중"){
				let result = confirm("해당 물품의 판매를 중단 하시겠습니까?");
				console.log("100>200");
				if(result) {
					itemStatus = 200;
					updateItemStatus();
					row.find(".permission").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "판매 허가 요청") {
				let result = confirm("해당 물품의 판매를 중단하시겠습니까?");
				console.log("300>200")
				if(result) {
					itemStatus = 200;
					updateItemStatus();
					row.find(".permission").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "판매 중지") {
				let result = confirm("해당 물품의 판매 중지를 취소하시겠습니까?");
				console.log("200>300");
				if(result) {
					itemStatus = 300;
					updateItemStatus();
					row.find(".permission").html("판매 허가 요청");
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
			            } else {
			                alert("변경 실패");
			            }
			        },
			    });
			};
			
		});
		
		function itemList(){
			let memberId = $("#memberId").val();
			console.log(memberId);
			
			$.ajax({
		    	type: "GET",
		    	url: "../seller/status/" + memberId,
		    	
		    	data: {},
		    	success: function(result) {
		    	  	let tbody = $('table tbody');
		          	tbody.empty(); // 기존 테이블 내용 비우기
		    	  	result.forEach(function(itemList) {
		    	  		let itemStatus = "";
		    	  		
		    	  		if(itemList.itemAmount == 0) {
		    	  			itemStatus = "품절"
		    	  		} else {
		    	  			if(itemList.itemStatus == 300) {
		    	  				itemStatus = "판매 허가 요청"
		    	  			} else if(itemList.itemStatus == 100) {
		    	  				itemStatus = "판매 중"
		    	  			} else if(itemList.itemStatus == 200) {
		    	  				itemStatus = "판매 중지"
		    	  			}
		    	  		}
		    	  		
		                let row = 
		                	'<tr>'
		                    + '<td>' + itemList.itemName + '</td>'
		                    + '<td><input type="text" size="3"  value="' + itemList.itemAmount + '"><button>입력</button></td>'
		                    + '<td>' + itemList.itemTag + '</td>'
		                    + '<td>' + itemList.itemPrice + '</td>'
		                    + '<td> <a class=permission>' + itemStatus + '</a> </td>'
		                    + '<input type="hidden" class="itemId" value="' + itemList.itemId + '">'
		                    + '</tr>';
		                    
		          		tbody.append(row); // 새로운 데이터 행 추가	
		      		})
		    	}
		    
		  	});
		
		}
	});
	</script>

</div>
</body>
</html>