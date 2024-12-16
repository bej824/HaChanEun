<%@page import="com.food.searcher.service.MemberService"%>
<%@page import="com.food.searcher.domain.MemberVO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
	<form id="insertForm" action="../home" method="POST">
		<p>아이디</p>
		<input type="text" name="memberId" id="memberId" placeholder="아이디 입력"
			required onblur="checkId(this.value)">
		<div id="idMsg" class="message" style="color: red;">아이디를 입력해주세요!</div>
		<br>

		<p>비밀번호</p>
		<input type=password name="password" id="password"
			placeholder="비밀번호 입력" required> <br>

		<p>비밀번호 재입력</p>
		<input type=password name="password2" id="password2"
			placeholder="비밀번호 입력" required> <br>

		<p>이름</p>
		<input type=text name="memberName" placeholder="이름을 입력해주세요." required>
		<br>

		<p>성별</p>
		<input type="radio" name="memberGender" value="male">남 <input
			type="radio" name="memberGender" value="female">여

		<p>생일</p>
		<input type=date name="birth" required> <br>

		<p>
			MBTI <select name="memberMBTI" id="mbti">
				<!-- MBTI 유형 옵션 -->
				<option value=" "></option>
				<option value="ISFJ">ISFJ</option>
				<option value="INFJ">INFJ</option>
				<option value="INTJ">INTJ</option>
				<option value="ISTP">ISTP</option>
				<option value="ISFP">ISFP</option>
				<option value="INFP">INFP</option>
				<option value="INTP">INTP</option>
				<option value="ESTP">ESTP</option>
				<option value="ESFP">ESFP</option>
				<option value="ENFP">ENFP</option>
				<option value="ENTP">ENTP</option>
				<option value="ESTJ">ESTJ</option>
				<option value="ESFJ">ESFJ</option>
				<option value="ENFJ">ENFJ</option>
				<option value="ENTJ">ENTJ</option>
			</select>
		</p>

		<p>이메일</p>
		<input type=text name=email placeholder="이메일을 입력해주세요."> <br>

		<p>이메일 광고 수신 동의</p>
		<input type="radio" name="emailAgree" value="yes" checked="checked">예
		<input type="radio" name="emailAgree" value="no">아니오 <br>
	</form>

	<button name="insert" onclick="insert()">회원가입</button>

	<script type="text/javascript">

	function checkId(memberId) {
		  console.log("ID Value:", memberId);  // 입력한 아이디 값이 콘솔에 출력되는지 확인
		  $.ajax({
		    type: 'GET',
		    url: '../access/idCheck',
		    data: { memberId: memberId },
		    success: function(result) {
		      if (!result) {
		        $('#idMsg').html('사용 가능한 아이디입니다.').css('color', 'green');
		        idCheck = true;
		      } else {
		        $('#idMsg').html('중복된 아이디입니다.').css('color', 'red');
		        idCheck = false;
		      }
		    }
		  });
		}
		
		function insert() {
			let password = document.getElementById("password").value;
			let password2 = document.getElementById("password2").value;
			let memberId = document.getElementById("memberId").value;
			
			if (password !== password2) {
				alert("비밀번호를 확인하여 주세요.");
				return;
			}
			if (idCheck === true){
			document.getElementById("insertForm").submit();				
			} else {
				alert("아이디 확인 후 다시 입력해주세요.");
				return;
			}
		}
		</script>

</body>
</html>