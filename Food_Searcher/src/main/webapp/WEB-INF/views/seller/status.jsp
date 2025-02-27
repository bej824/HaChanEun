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
			
			itemList();
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
		    	  		
		    	  		if(itemList.itemAmount == 0) {
		    	  			itemStatus = "품절"
		    	  		} else {
		    	  			if(itemList.itemStatus == 0) {
		    	  				itemStatus = "판매 허가 요청"
		    	  			} else if(itemList.itemStatus == 1) {
		    	  				itemStatus = "판매 중"
		    	  			} else if(itemList.itemStatus == 2) {
		    	  				itemStatus = "판매자 판매 중단"
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