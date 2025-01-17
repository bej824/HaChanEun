<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 인증</title>
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

#btn_confirm{
	 width: 150px;
}

</style>
</head>
<body>

	<!-- 사용 시 '"헤더를 적용시킬 url" + ?select="form을 전달할 url"로 작성할 것.' -->
	<form  id="emailForm" action="${select }" method="POST">
	<input type="text" id="email" name="email" placeholder="이메일을 입력해주세요.">
	<a id="countdown"></a>
	<div id="confirmMsg" class="message" style="color:green;"></div>
	<div id="emailMsg" class="message" style="color: red;"></div>
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	<br>
	<input type="text" id="emailCheck" name="emailCheck" placeholder="인증번호를 입력해주세요." style="display: none;">
	<br>
	<button id="btn_confirm" class="button" onclick="confirm()" style="" >인증번호 발송</button>
	
	<button id="btn_auth" class="button" onclick="emailAuth()" style="display: none;">인증</button>

	<script type="text/javascript">
	
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
	
			xhr.setRequestHeader(header, token);
		});
	
		
		// 카운트 제한 변수
		const count = 300; // 재발송 시간
		
		// 버튼 변수
		const btn_auth = document.getElementById('btn_auth');
		const btn_confirm = document.getElementById('btn_confirm');
		const countdown = document.getElementById('countdown');
		
		// email 변수
		const email = document.getElementById('email');
		
		// 메세지 변수
		const emailMsg = $('#emailMsg');
		const confirmMsg = $('#confirmMsg');
	
		function confirm() {
			
			if(email.value == ""){
				emailMsg.html('이메일을 확인하여주세요.');
			} else {
			countDown();
			$.ajax({
			    type: 'POST',
			    url: '../access/emailConfirm',
			    data: { email: email.value},
			    success: function(result) {
			      if (result == '1') {
			      } else {
			    	  emailMsg.html('다시 시도하여주세요.');
			      }
			    }
			  });
			}
			
		}
		
		
		function emailAuth() {
			let emailCheck = document.getElementById('emailCheck');
			 if (/^\d+$/.test(emailCheck.value)) {
			 $.ajax({
			    type: 'POST',
			    url: '../access/emailCheck',
			    data: { email : email.value,
			    	emailCheck: emailCheck.value },
			    success: function(result) {
			      if (result == '1') {
			    	confirmMsg.html('인증되었습니다.').css('color', 'green');
			        btn_auth.textContent = "확인";
			        btn_auth.onclick = register;
			        email.readOnly = true;
			        emailMsg.html('');
			      } else {
			    	confirmMsg.html('인증번호를 다시 확인해주세요.').css('color', 'red');
			      }
			    }
			  });
			 
			 } else {
				 confirmMsg.html('인증번호를 다시 확인해주세요.').css('color', 'red');
			 }
			} // end emailAuth()
			
			function countDown(){
				let timelimit = count; // 인증 유효시간
				
		        btn_auth.disabled = false;
		        btn_auth.style.display = '';

		        btn_confirm.disabled = true;
				btn_confirm.textContent = "인증번호 재발송";
		        
				emailCheck.textContent = '';
				emailCheck.style.display = '';
				
				 emailMsg.html('재발송은 30초 후 가능합니다.');
				 confirmMsg.html('인증번호가 발송되었습니다. 인증번호는 5분까지 유효합니다.');
				
				const timeoverInterval = setInterval(function(){
					let emailCheck = document.getElementById('emailCheck');
					timelimit--; // 인증 유효시간
			        countdown.textContent = timelimit; // 지울 예정
					
					if (count - timelimit == 30) {
				          btn_confirm.disabled = false;
				          emailMsg.html('');
				        }
					
					if (timelimit <= 0){
						clearInterval(timeoverInterval);
						btn_auth.disabled = true;
						emailMsg.html('');
						confirmMsg.html('인증시간이 지났습니다. 인증번호를 재발송해주세요.').css('color', 'red');
					}
					
					if (btn_auth.onclick == register && count - timelimit >= 30){
						clearInterval(timeoverInterval);
					}
					
				}, 1000);
			}
		
		function register(){
			document.getElementById("emailForm").submit();		
		}
	</script>

</body>
</html>