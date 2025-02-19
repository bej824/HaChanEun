<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file ="../layout/head.jsp" %>
<%@ include file ="../header.jsp" %>
<title>나의 쿠폰 확인하기</title>
</head>
<body>

	<h1>할인 쿠폰</h1>
	
	<table>
		<thead>
			<tr>
				<th style="width: 30%">쿠폰 이름</th>
				<th style="width: 20%">쿠폰 가격</th>
				<th style="width: 20%">사용 조건</th>
				<th style="width: 20%">유효 기간</th>
				<th style="width: 10%">사용 여부</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		couponList();
		
		function couponList() {
			let memberId = '<sec:authentication property="name" />';
			
			$.ajax({
			    type: 'POST',
			    url: '../coupon/memberCouponList',
			    data: {memberId: memberId},
			    success: function(result) {
			    	
			    	let tbody = $('table tbody');
			        tbody.empty(); // 기존 테이블 내용 비우기
			    	result.forEach(function(CouponActiveVO) {
			    		
			    		let	couponUsed = "미사용";
			    		let	couponUseCondition = "";
			    		
			    		let year = CouponActiveVO.couponExpireDate[0];
			    		let month = CouponActiveVO.couponExpireDate[1];
			    		let day = CouponActiveVO.couponExpireDate[2];
			    		let couponExpireDate = year + "년 " + month + "월 " + day + "일까지";
			    		
			    		if(CouponActiveVO.couponUsedDate != null) {
			    			couponUsed = "사용 완료";
			    		}
			    		
			    		if(CouponActiveVO.couponUseCondition != 0) {
			    			couponUseCondition = CouponActiveVO.couponUseCondition + "원 이상 구매 시";
			    		}
			    		
			    		
			    		let row = 
			    			  '<tr>'
		                    + '<td>' + CouponActiveVO.couponName + '</td>'
		                    + '<td>' + CouponActiveVO.couponPrice + "원" + '</td>'
		                    + '<td>' + couponUseCondition + '</td>'		                    	
	                		+ '<td>' + couponExpireDate + '</td>'
		                    + '<td>' + couponUsed + '</td>'
		                    + '</tr>';
		                    
		          		tbody.append(row); // 새로운 데이터 행 추가
			    	})
			    	
			    }
			    	
			})
		}
		
	})
	
	</script>

</body>
</html>