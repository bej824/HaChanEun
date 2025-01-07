<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 인증</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>

body {
    margin-left: 20px !important;
}
#btn_confirm:disabled, #btn_auth:disabled {
      background-color: #d3d3d3; /* 회색 배경 */
      color: #a9a9a9;            /* 회색 글자 */
      cursor: not-allowed;       /* 클릭 불가 커서 */
      border: 1px solid #a9a9a9; /* 회색 테두리 */
    }

</style>
</head>
<body>

<h1>이메일 확인</h1>
	<form  id="emailForm" action="register" method="POST">
	<input type="text" id="email" name="email" placeholder="이메일을 입력해주세요.">
	<a id="countdown"></a>
	<div id="emailMsg" class="message" style="color: red;"></div>
	<div id="confirmMsg" class="message" style="color:green;"></div>
	</form>
	<br>
	<input type="text" id="emailCheck" name="emailCheck" placeholder="인증번호를 입력해주세요." style="display: none;">
	<br>
	<button id="btn_confirm" class="button" onclick="confirm()" style="" >인증번호 발송</button>
	
	<button id="btn_auth" class="button" onclick="emailCheck()" style="display: none;">인증</button>

	<script type="text/javascript">
		let DateCreated = new Date();
		let hours = DateCreated.getHours().toString().padStart(2, '0');
		let minutes = DateCreated.getMinutes().toString().padStart(2, '0');
		let replyDate = hours + ":" + minutes;
	
		function confirm() {
			let btn_confirm = document.getElementById('btn_confirm');
			let btn_auth = document.getElementById('btn_auth');
			
			let email = document.getElementsByName("email")[0].value;
			let emailCheck = document.getElementsByName("emailCheck")[0].value;
			
			if(email == ""){
				$('#emailMsg').html('이메일을 확인하여주세요.');
			} else {
			$.ajax({
			    type: 'POST',
			    url: '../access/emailConfirm',
			    data: { email: email },
			    success: function(result) {
			      if (result == '1') {
					btn_countDown();
					AuthTimeover();
					$('#emailMsg').html('재발송은 30초 후 가능합니다.');
			        $('#confirmMsg').html('인증번호가 발송되었습니다. 인증번호는 5분까지 유효합니다.');
			        btn_auth.disabled = false;
			        btn_auth.style.display = '';
			        document.getElementById('emailCheck').style.display = '';
			      } else {
			      }
			    }
			  });
			}
			
		}
		
		
		function emailCheck() {
			 let email = document.getElementsByName("email")[0].value;
			 let emailCheck = document.getElementsByName("emailCheck")[0].value;
			 if (/^\d+$/.test(emailCheck)) {
			 console.log("emailCheck :", emailCheck);  // 입력한 아이디 값이 콘솔에 출력되는지 확인
				 
			 $.ajax({
			    type: 'POST',
			    url: '../access/emailCheck',
			    data: { email : email,
			    	emailCheck: emailCheck },
			    success: function(result) {
			      if (result == '1') {
			        $('#confirmMsg').html('인증되었습니다.').css('color', 'green');
			        btn_auth.textContent = "확인";
			        btn_auth.onclick = register;
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
			
			function btn_countDown(){
				console.log("btn_countDown()");
				let count = 30;
				let countdown = document.getElementById('countdown');
				const countInterval = setInterval(function() {
			        count--; // 카운트 감소
			        countdown.textContent = count;
					btn_confirm.textContent = "재발송";
			        btn_confirm.disabled = true;
			        // 카운트가 0이 되면 타이머 멈추기
			        if (count <= 0) {
			          clearInterval(countInterval);
			          btn_confirm.disabled = false;
			        }
			      }, 1000);
			}
			
			function AuthTimeover(){
				console.log("AuthTimeover()");
				let timelimit = 30;
				let btn_auth = document.getElementById('btn_auth');
				
				const timeoverInterval = setInterval(function(){
					timelimit--; // 인증 유효시간
					btn_auth.disabled = false;
					
					if (timelimit <= 0 || btn_auth.onclick == "register()"){
						clearInterval(timeoverInterval);
						btn_auth.disabled = true;
						$('#confirmMsg').html('인증시간이 지났습니다. 인증번호를 재발송해주세요.').css('color', 'red');
					}
					
				}, 1000);
				
			}
		
		function register(){
			document.getElementById("emailForm").submit();		
		}
	</script>

</body>
</html>