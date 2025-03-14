<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>

	<%@ include file ="../header.jsp" %>
	<div id="container">
   		<div id="area">
   		</div>
   		<h1>결제가 실패하였습니다.</h1>
   		
   		<button id="btn_goItem">더 쇼핑하기</button>
   		</div>
   		
   	<script type="text/javascript">
   	$(document).ready(function(){
   		
   		$('#btn_goItem').click(function(){
   			window.location.href = "../item/list";
   		})
   		
   	})
   	
   	</script>

</body>
</html>