<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	<form  id="emailForm" action="register" method="POST">
	<input type="text" id="email" name="email" placeholder="이메일을 입력해주세요.">
	<div id="confirmMsg" class="message" style="color: red;"></div>
	</form>
	<br>
	<input type="text" id="emailCheck" name="emailCheck" placeholder="인증번호를 입력해주세요." style="display: none;">
	<br> <br>
	<button id="btn_confirm" class="button" onclick="confirm()" style="" >인증번호 발송</button>
	
	<button id="btn_register" class="button" onclick="emailCheck()" style="display: none;">인증</button>

	<script type="text/javascript">
		function confirm() {
			let btn_confirm = document.getElementById('btn_confirm');
			let email = document.getElementsByName("email")[0].value;
			btn_confirm.textContent = "재발송";
			
			$.ajax({
			    type: 'POST',
			    url: '../access/emailConfirm',
			    data: { email: email },
			    success: function(result) {
			      if (result == '1') {
			        $('#confirmMsg').html('인증번호가 발송되었습니다.').css('color', 'green');
			        document.getElementById('btn_register').style.display = '';
			        document.getElementById('emailCheck').style.display = '';
			      } else {
			      }
			    }
			  });
		}
		
		
		function emailCheck() {
			 let emailCheck = document.getElementsByName("emailCheck")[0].value;
			 if (/^\d+$/.test(emailCheck)) {
			 console.log("emailCheck :", emailCheck);  // 입력한 아이디 값이 콘솔에 출력되는지 확인
			 $.ajax({
			    type: 'POST',
			    url: '../access/emailCheck',
			    data: { emailCheck: emailCheck },
			    success: function(result) {
			      if (result == '1') {
			        $('#confirmMsg').html('인증되었습니다.').css('color', 'green');
			        btn_register.textContent = "확인";
			        btn_register.onclick = register;
			        email.readOnly = true;
			      } else {
			        $('#confirmMsg').html('인증번호를 다시 확인해주세요.').css('color', 'red');
			      }
			    }
			  });
			 } else {
				 $('#confirmMsg').html('인증번호를 다시 확인해주세요.').css('color', 'red');
			 }
			} // end emailCheck()
		
		function register(){
			document.getElementById("emailForm").submit();		
		}
	</script>

</body>
</html>