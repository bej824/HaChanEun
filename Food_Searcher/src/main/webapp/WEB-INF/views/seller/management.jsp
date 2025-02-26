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
	<h1>판매 관리</h1>
	
	<a href="/searcher/item/register" class="button">상품 등록</a>  
	<button id="btn_memberCoupon" class="button">쿠폰함</button><br>
	<a href="purchaseHistory" class="button">회원 전체 거래 내역</a>
	<sec:authorize access="hasRole('ROLE_MEMBER')">
	<a href="../item/purchaseHistory" class="button">구매 내역</a>
	</sec:authorize>
	
	<script type="text/javascript">
		$('#btn_memberCoupon').click(function(){
			window.location.href = "../access/memberCoupon";
		})
	</script>
</body>
</html>