<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file ="../layout/head.jsp" %>
<link rel="stylesheet"
	href="../resources/css/Base.css">
<title>쿠폰 목록</title>
</head>
<body>

	<h1>쿠폰 목록</h1>
	
	<select id="searchBy" name="searchBy">
		<option value="0">쿠폰 이름</option>
		<option value="1">발급자</option>
		<option value="2">쿠폰 가격</option>
		<option value="3">쿠폰 제한</option>
	</select>
	<input id="searchText"> <button id="btn_search" class="button">검색</button>
	<button id="btn_clear" class="button">검색어 지우기</button>

	<table>
		<thead>
			<tr>
				<th style="width: 16.67%">쿠폰 이름</th>
				<th style="width: 16.67%">발급 권한</th>
				<th style="width: 20%">쿠폰 가격</th>
				<th style="width: 20%">쿠폰 제한</th>
				<th style="width: 20%">쿠폰 사용 기한</th>
				<th style="width: 16.67%">쿠폰 발급조건</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<button id="btn_create" class="button">쿠폰 생성</button>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		let inputCheck = false;
		
		couponManagement('', '');
		
		$('#btn_create').click(function(){
			window.location.href = "register";
		})
		
		$('#btn_search').click(function(){
			let searchBy = $('#searchBy').val();
			let searchText = $('#searchText').val().trim();
			let searchByList = ["COUPON_NAME", "COUPON_ISSUER", "COUPON_PRICE", "COUPON_USE_CONDITION"];
			
			if(searchText == '') {
				couponManagement('', '');
				return;
			}
			
			searchBy = searchByList[searchBy] ?? '';
			console.log(searchBy);
			
			if(searchBy == "COUPON_PRICE" || searchBy == "COUPON_USE_CONDITION") {
				if(!/^\d+$/.test(searchText)){
					alert("해당 검색 필터로는 숫자만 입력 가능합니다!");
					return;
				}
			}
			
			if(searchBy == '') {
				couponManagement('', '');
			} else {
				couponManagement(searchBy, searchText);
			}
			
		})
		
		$('#btn_clear').click(function(){
			$('#searchText').val('');
			couponManagement('', '');
		})
		
		function couponManagement(searchBy, searchText){
			let event = "";
			let issuer = "";
			
			$.ajax({
			    type: 'GET',
			    url: 'getCoupon',
			    data: {searchBy: searchBy,
			    	searchText: searchText},
			    success: function(result) {
			    	  let tbody = $('table tbody');
			          tbody.empty(); // 기존 테이블 내용 비우기
			    	  result.forEach(function(DiscountCouponVO) {
			    		  if(DiscountCouponVO.couponEvent == 'memberDateOfBirth') {
			    			  event = "생일";
			    		  } else if(DiscountCouponVO.couponEvent == 'oneTime') {
			    			  event = "프로모션";
			    		  } else if(DiscountCouponVO.couponEvent == 'memberMBTI') {
			    			  event = "MBTI";
			    		  } else {
			    			  event = DiscountCouponVO.couponEvent;
			    		  }
			    		  
			    		  if(DiscountCouponVO.couponIssuer == 'ROLE_ADMIN') {
			    			  issuer = "운영자";
			    		  } else if(DiscountCouponVO.couponIssuer == 'ROLE_SELLER') {
			    			  issuer = "판매자";
			    		  }
			            	
			                let row = 
			                	'<tr onclick="window.location.href=\'detail?itemId='
			                	+ ${itemId }
			                	+ '&couponId=' + DiscountCouponVO.couponId + '\'">'
			                    + '<td>' + DiscountCouponVO.couponName + '</td>'
			                    + '<td>' + issuer + '</td>'
			                    + '<td>' + DiscountCouponVO.couponPrice + "원" + '</td>'
			                    + '<td>' + DiscountCouponVO.couponUseCondition + "원" + '</td>'
		                		+ '<td>' + DiscountCouponVO.couponExpirationDate + "일" + '</td>'
			                    + '<td>' + event + '</td>'
			                    + '</tr>';
			                    
			          		tbody.append(row); // 새로운 데이터 행 추가
			      		})
			    }
			    
			  });
			
		}
		
	})
		
	
	</script>

</body>
</html>