<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
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
				<th style="width: 5%">상품 번호</th>
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
	
	<script>
	
	$(document).ready(function(){
		var itemStatus = null;
		itemList();
		
		$('table tbody').on('click', '.permission', function(){
			let permission = $(this).html();
			let row = $(this).closest("tr");
			let itemId = parseInt(row.find("td:first").text(), 10);
			
			if(permission == "판매 중"){
				let result = confirm("해당 물품의 판매를 중단 하시겠습니까?");
				console.log("1>2");
				if(result) {
					itemStatus = 2;
					row.find(".permission").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "판매 허가 요청") {
				let result = confirm("해당 물품의 판매를 중단하시겠습니까?");
				console.log("0>2", result)
				if(result) {
					itemStatus = 2;
					row.find(".permission").html("판매 중지");
					alert("변경 완료 : 판매 중지");
				}
				
			} else if(permission == "판매 중지") {
				let result = confirm("해당 물품의 판매 중지를 취소하시겠습니까?");
				console.log("2>0");
				if(result) {
					itemStatus = 0;
					row.find(".permission").html("판매 허가 요청");
					alert("변경 완료 : 판매 허가 요청");
				} 
			} else {
				console.log("취소");
			}
			
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
			})
		
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
		    	  			if(itemList.itemStatus == 0) {
		    	  				itemStatus = "판매 허가 요청"
		    	  			} else if(itemList.itemStatus == 1) {
		    	  				itemStatus = "판매 중"
		    	  			} else if(itemList.itemStatus == 2) {
		    	  				itemStatus = "판매 중지"
		    	  			}
		    	  		}
		    	  		
		                let row = 
		                	'<tr>'
		                    + '<td>' + itemList.itemId + '</td>'
		                    + '<td>' + itemList.itemName + '</td>'
	                		+ '<td>' + itemList.memberId + '</td>'
		                    + '<td>' + itemList.itemTag + '</td>'
		                    + '<td>' + itemList.itemPrice + '</td>'
		                    + '<td> <a class=permission>' + itemStatus + '</a> </td>'
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