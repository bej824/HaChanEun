<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta name="authenticatedUser" content="${authentication.name}">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="../resources/css/Base.css">
<title>쿠폰 목록</title>
</head>
<body>

	<h1>쿠폰 목록</h1>
	
	<input id="couponName"> <button id="search"></button>

	<table>
		<thead>
			<tr>
				<th style="width: 100px"></th>
				<th style="width: 100px">쿠폰 이름</th>
				<th style="width: 300px">발급자</th>
				<th style="width: 120px">쿠폰 할인가</th>
				<th style="width: 120px">쿠폰 제한</th>
				<th style="width: 40px">쿠폰 발급조건</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		
		
		
		function couponList(){
			
			$.ajax({
			    type: 'GET',
			    url: 'couponList',
			    data: { },
			    success: function(result) {
			      if (result == '1') {
			    	  let tbody = $('table tbody');
			          tbody.empty(); // 기존 테이블 내용 비우기
			    	  result.forEach(function(DiscountCouponVO) {
			            	
			                let row = '<tr>'
			                	+ '<td><input type="radio" name="couponRadio" value="'+ DiscountCouponVO.couponId +'"></td>'
			                    + '<td>' + DiscountCouponVO.couponName + '</td>'
			                    + '<td>' + DiscountCouponVO.couponIssuer + '</td>'
			                    + '<td>' + DiscountCouponVO.couponPrice + '</td>'
			                    + '<td>' + DiscountCouponVO.couponUseCondition + '</td>'
			                    + '<td>' + DiscountCouponVO.couponEvent + '</td>'
			                    + '</tr>';
			                    
			          		tbody.append(row); // 새로운 데이터 행 추가
			      		})
			      	
			    	}
			    }
			    
			  });
			
		}
		
		
	})
	
	</script>

</body>
</html>