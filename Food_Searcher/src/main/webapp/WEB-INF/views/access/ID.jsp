<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.food.searcher.domain.MemberVO" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
		<h1>ID 찾기</h1>
	<form id="ID" action = "ID" method="POST">
	회원 이름 : <input type="text" id="memberName" name="memberName" value="${memberName}" placeholder="ID를 입력해주세요." required> <br>
	email : <input type="text" id="email" name="email" value="${email}" placeholder="이메일을 입력해주세요.">
	<input type="hidden" id="memberId">
	<div id="confirmMsg" class="message" style="color: red;"></div>
	</form>
	<br>
	<input type="text" id="emailCheck" name="emailCheck" placeholder="인증번호를 입력해주세요." style="display: none;">
	<br> <br>
	<button id="btn_confirm" class="button" onclick="confirm()" style="" >인증번호 발송</button>
	
	<button id="btn_register" class="button" onclick="emailCheck()" style="display: none;">인증</button>
	
		<hr>

		<c:if test="${not empty memberVO }">
		<script>
        let memberId = "${memberVO.memberId}";  // memberVO.memberId 값을 JavaScript 변수에 저장
    </script>
		<p>${memberVO.memberName }님의 ID는</p>
		<p>${memberVO.memberId }입니다.</p>
		</c:if>

		<c:if test="${empty memberVO }">
			<p>memberID 출력부분</p>
		</c:if>

	<script type="text/javascript">
		function confirm() {
			let btn_confirm = document.getElementById('btn_confirm');
			console.log("btn_confirm", btn_confirm);
			let email = document.getElementsByName("email")[0].value;
			console.log(email);
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
			        alert('발송 확인');
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
					alert('인증 확인');
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
			document.getElementById("ID").submit();
			alert(memberId); // ??
		}
	</script>


</body>
</html>