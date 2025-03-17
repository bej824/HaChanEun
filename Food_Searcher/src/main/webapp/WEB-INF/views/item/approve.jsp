<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns:layout="http://www.ultraq.net.nz/web/thymeleaf/layout" xmlns:th="http://www.thymeleaf.org/">
<head>
<meta charset="UTF-8">
<title>Kakaopay Sample</title>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
</head>
<body>
<%@ include file ="../header.jsp" %>
	<p th:text="${response}"></p>
	<a href="/" target="_parent"></a>
	<div id="container">
   		<div id="area">
   		</div>
   		<h1>결제가 완료되었습니다.</h1>
   		
   		<button id="btn_goItem">더 쇼핑하기</button>
   		<button id="purchase">구매내역 이동</button>
   	</div>
   		
   	<script type="text/javascript">
   	$(document).ready(function(){
   		
   		$('#btn_goItem').click(function(){
   			window.location.href = "../item/list";
   		});
   		
   		$('#btn_goItem').click(function(){
   			window.location.href = "../item/purchaseHistory";
   		});
   		
   	});
   	
   	</script>
</body>
</html>