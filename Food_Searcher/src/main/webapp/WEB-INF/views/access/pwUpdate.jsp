<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	
	<h1>비밀번호 변경</h1>
	
	<p>현재 비밀번호</p>
	<input type=password name="oldPassword" id="oldPassword"
			placeholder="비밀번호 입력" required>
	<br>
	<p>새로운 비밀번호</p>
		<input type=password name="password" id="password"
			placeholder="비밀번호 입력" required> <br>
		<div id="pwMsg" class="message" style="color: red;">비밀번호를 입력해주세요.</div>

	<p>비밀번호 재입력</p>
		<input type=password name="password2" id="password2"
			placeholder="비밀번호 입력" required> <br>
		<div id="pw2Msg" class="message" style="color: red;">비밀번호 다시 입력해주세요.</div>
	
	<button id=btn_update class="button" name="update">비밀번호 수정</button>
	
	<sec:authorize access="!isAuthenticated()">
	<script>window.location.href="../auth/login";</script>
	</sec:authorize>
	
	<script type="text/javascript">
	
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			let pwCheck = false;
			let pw2Check = false;
			
			$('#password').change(function(){
	  			pwCheck = false;
	  			let password = $(this).val();
	  			
	  			// 하나의 정규식을 사용하여 8자리 이상 + 영소문자 + 숫자 + 특수기호 포함 여부 체크
	  		    let passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W_]).{8,}$/;

	  		    if (!passwordRegex.test(password)) {  
	  		        $('#pwMsg').html('비밀번호는 8자리 이상, 영대소문자, 숫자, 특수기호를 모두 포함해야 합니다.').css('color', 'red');
	  		        return;
	  		    } else {
	  				$('#pwMsg').html('사용 가능한 비밀번호입니다.').css('color', 'green');
	  				pwCheck = true;
	  			}
	  		})
	  		
	  		$('#password2').change(function(){
	  			pw2Check = false;
	  			let password = $('#password').val();
	  			let password2 = $(this).val();
	  			
	  			if(pwCheck == false) {
	  				return;
	  			}
	  			else if (password !== password2) {
	  		    	$('#pw2Msg').html('비밀번호와 비밀번호 확인이 일치하지 않습니다.').css('color', 'red');
	  		    } else {
	  		    	$('#pw2Msg').html('비밀번호가 일치합니다.').css('color', 'green');
	  		    	pw2Check = true;
	  		    }
	  		})
			
			$('#btn_update').click(function(){
				let memberId = '<sec:authentication property="name" />';
				let oldPassword = document.getElementById("oldPassword").value;
				let password = document.getElementById("password").value;
		 		let password2 = document.getElementById("password2").value;
		 		let email = '${email }';
		 		let login = true;
		 		
		 		$.ajax({
				    type: 'POST',
				    url: 'pwCheck',
				    data: { password: oldPassword},
				    success: function(result) {
				    	if(result) {
				    		// 비밀번호와 비밀번호 재입력이 일치하는지 확인
			    			if (password !== password2) {
			      				alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
			      				return;
			    			} else if(pwCheck === true && pw2Check === true) {
				    			pwUpdate(password, email, login);			    				
			    			}
				    		
				    	} else {
				    		alert("비밀번호를 다시 한번 확인해주세요.");
				    		return;
				    	}
				    }
	    		});
			
			});
			
		function pwUpdate(password, email, login) {
			
    		$.ajax({
			    type: 'POST',
			    url: 'pwUpdate',
			    data: { password: password,
			    		email: email,
			    		login: login},
			    success: function(result) {
			    	if(result == 1) {
			    		alert("수정이 완료되었습니다. 로그인 화면으로 이동합니다.");
			    		window.location.href="../auth/login";
			    	} else {
			    		alert("다시 한번 시도해주세요.");
			    	}
			    }
    		});
	
		} // end update()
		
		})
	
	</script>
	</div>

</body>
</html>