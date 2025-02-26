<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file ="../layout/head.jsp" %>
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
	<button id="btn_change" class="button">이벤트 쿠폰</button>

	<table>
		<thead>
			<tr>
				<th style="width: 16.67%">쿠폰 이름</th>
				<th style="width: 16.67%">발급자</th>
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
		let oneCouponCheck = true;
		let couponList = [];
		
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
			
			if(searchBy == "COUPON_PRICE" || searchBy == "COUPON_USE_CONDITION") {
				if(!/^\d+$/.test(searchText)){
					alert("해당 검색 필터로는 숫자만 입력 가능합니다!");
					return;
				}
			} else if(searchBy == "COUPON_ISSUER") {
				if(searchText == "운영자") {
					searchText = 'ROLE_ADMIN';
	    		  } else if(searchText == "판매자") {
	    			  searchText = 'ROLE_SELLER';
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
		
		$('#btn_change').click(function(){
			
			if(oneCouponCheck == true) {
				oneCouponCheck = false;
				$(this).html('프로모션 쿠폰');
			} else {
				oneCouponCheck = true;
				$(this).html('이벤트 쿠폰');
			}
			
			couponTable();
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
			    	couponList = [];
			    	result.forEach(function(DiscountCouponVO) {
			    		couponList.push(DiscountCouponVO);
			    		  
			      	})
			      	couponTable();
			    }
			    
			  });
			
		}
		
		function couponTable() {
				let tbody = $('table tbody');
	        	tbody.empty(); // 기존 테이블 내용 비우기
	        	
	        	let tableList = [];
	        		
	    	 	if(oneCouponCheck == true) {
	    	 		
	    			tableList = couponList.filter(function(result) {
					return result.couponEvent.includes('oneTime');
					});
	    	 	} else if(oneCouponCheck == false) {
	    	 		tableList = couponList.filter(function(result) {
						return !result.couponEvent.includes('oneTime');
					});
	    	 	}
	    	 	
	    	 	tableList.forEach(function(coupon) {
	    		  
	    		  if(coupon.couponEvent == 'memberDateOfBirth') {
	    			  event = "생일";
	    		  } else if(coupon.couponEvent == 'oneTime') {
	    			  event = "프로모션";
	    		  } else if(coupon.couponEvent == 'memberMBTI') {
	    			  event = "MBTI";
	    		  } else {
	    			  event = coupon.couponEvent;
	    		  }
	    		  
	    		  if(coupon.couponIssuer == 'ROLE_ADMIN') {
	    			  issuer = "운영자";
	    		  } else if(coupon.couponIssuer == 'ROLE_SELLER') {
	    			  issuer = "판매자";
	    		  }
	            	
	                let row = 
	                	'<tr onclick="window.location.href=\'detail?itemId='
	                	+ ${itemId }
	                	+ '&couponId=' + coupon.couponId + '\'">'
	                    + '<td>' + coupon.couponName + '</td>'
	                    + '<td>' + issuer + '</td>'
	                    + '<td>' + coupon.couponPrice + "원" + '</td>'
	                    + '<td>' + coupon.couponUseCondition + "원" + '</td>'
              		+ '<td>' + coupon.couponExpirationDate + "일" + '</td>'
	                    + '<td>' + event + '</td>'
	                    + '</tr>';
	                    
	          		tbody.append(row); // 새로운 데이터 행 추가
	      		})
		}
		
	})
		
	
	</script>

</body>
</html>