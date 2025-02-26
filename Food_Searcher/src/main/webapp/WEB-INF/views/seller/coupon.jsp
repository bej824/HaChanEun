<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매자 상품 쿠폰 관리</title>
</head>
<body>
	<h1>상품별 첫구매, 재구매 쿠폰 관리</h1>
	
	<table>
		<thead>
			<tr>
				<th style="width: 16.67%">쿠폰 이름</th>
				<th style="width: 20%">쿠폰 가격</th>
				<th style="width: 20%">쿠폰 제한</th>
				<th style="width: 20%">쿠폰 사용 기한</th>
				<th style="width: 16.67%">쿠폰 발급조건</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		let couponList = [];
		
		function FR_coupon(){
			
			$.ajax({
			    type: 'GET',
			    url: 'FRCouponList',
			    data: {},
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
        	
    	 	tableList.forEach(function(coupon) {
    		  
    		  if(coupon.couponEvent == 'FIRST_ORDER_COUPON') {
    			  event = "첫구매 쿠폰";
    		  } else if(coupon.couponEvent == 'REPEAT_ORDER_COUPON') {
    			  event = "재구매 쿠폰";
    		  }
            	
                let row = 
                	'<tr onclick="window.location.href=\'detail?itemId='
                	+ ${itemId }
                	+ '&couponId=' + coupon.couponId + '\'">'
                    + '<td>' + coupon.couponName + '</td>'
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