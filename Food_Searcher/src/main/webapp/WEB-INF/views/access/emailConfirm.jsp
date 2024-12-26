<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>

body {
    margin-left: 20px !important;
}

</style>
<meta charset="UTF-8">
<title>하찬은 이메일 인증</title>
<%@ include file="../header.jsp"%>
</head>
<body>
	<h1>이메일 확인</h1>
	<form  id="emailForm" action="register" method="GET">
	</form>
	<input type="text" id="email" name="email" placeholder="이메일을 입력해주세요.">
	<div id="confirmMsg" class="message" style="color: red;"></div>
	<button id="btn_confirm" class="button" onclick="confirm()" style="" >인증</button>
	<button id="btn_register" class="button" onclick="register()" style="display: none;">확인</button>

	<script type="text/javascript">
		function confirm() {
			let btn_confirm = document.getElementById('btn_confirm');
			let email = document.getElementsByName("email")[0].value;
			btn_confirm.textContent = "재발송";
			
			document.getElementById('btn_register').style.display = '';
			$('#confirmMsg').html("test");
		}
		
		function register(){
			document.getElementById("insertForm").submit();	
		}
	</script>

</body>
</html>