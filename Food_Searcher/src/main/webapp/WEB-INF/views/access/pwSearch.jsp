<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<h1>비밀번호 찾기</h1>

    <form id="pwUpdateForm" action="pwUpdate" method="POST">
	
	<p>아이디</p>
	<input type="text" name="memberId" id="memberId" value="${memberId }" placeholder="아이디 입력" required>
	<input type="hidden" name="email" id ="email" value="${email }">
	<br>
	
	<p>비밀번호</p>
		<input type=password name="password" id="password"
			placeholder="비밀번호 입력" required> <br>

	<p>비밀번호 재입력</p>
		<input type=password name="password2" id="password2"
			placeholder="비밀번호 입력" required> <br>
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<button id=btn_update class="button" name="update">비밀번호 수정</button>
	
	<script type="text/javascript">
	
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			
			$('#btn_update').click(function(){
				let memberId = document.getElementById("memberId").value;
				let password = document.getElementById("password").value;
		 		let password2 = document.getElementById("password2").value;
		 		let email = document.getElementById("email").value;
		 		
		 		
				// 비밀번호와 비밀번호 재입력이 일치하는지 확인
    			if (password !== password2) {
      				alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
      				return;
    			}
				
				pwUpdate(memberId, password, email);
			
			});
			
		function pwUpdate(memberId, password, email) {
			
    		$.ajax({
			    type: 'POST',
			    url: 'pwUpdate',
			    data: { memberId : memberId,
			    		password: password,
			    		email: email},
			    success: function(result) {
			    	if(result == 1) {
			    		alert("수정이 완료되었습니다. 로그인 화면으로 이동합니다.");
			    		window.location.href="../auth/login";
			    	} else {
			    		alert("다시 시도하여주십시오.");
			    	}
			    }
    		});
	
		} // end update()
		
		})
	
	</script>

</body>
</html>