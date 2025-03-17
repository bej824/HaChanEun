<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매 관리</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	
	<div id="area">
	
	<h1>판매 관리</h1>
	
	<a href="/searcher/item/register" class="button">상품 등록</a>
	<a href="/searcher/seller/status" class="button">상품 관리</a><br>
	<a href="purchaseHistory" class="button">상품 거래 내역</a>
	<sec:authorize access="hasRole('ROLE_MEMBER')">
	<a href="../item/purchaseHistory" class="button">구매 내역</a>
	</sec:authorize>
	
	</div>
	
	<script type="text/javascript">
		$('#btn_memberCoupon').click(function(){
			window.location.href = "../access/memberCoupon";
		})
		
		$('#btn_couponList').click(function(){
			window.open("../coupon/list", "_blank", "width=800,height=600,scrollbars=yes,resizable=yes");
		})
	</script>
</body>
</html>