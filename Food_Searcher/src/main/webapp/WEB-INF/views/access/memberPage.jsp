<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 개인 정보</title>
</head>
<body>

	<%@ include file ="../header.jsp" %>
	<h1>Member Page</h1>

	<form id="updateForm" action="update" method="post">
		<p>아이디 : ${memberVO.memberId }</p>
		<input type="hidden" name="memberId" value="${memberVO.memberId }">

		<p>이름 : ${memberVO.memberName }</p>

		<p>
			성별 :
			<c:if test="${memberVO.memberGender == 'male'}">
		남성 
		</c:if>
			<c:if test="${memberVO.memberGender == 'female'}">
		여성 
		</c:if>
		</p>
		<p>나이 : ${memberVO.memberAge }</p>

		<p>별자리 : ${memberVO.memberConstellation }</p>

		<p>
			MBTI : <select name="memberMBTI" id="memberMBTI">
				<!-- MBTI 유형 옵션 -->
				<option value=" "
					<c:if test="${memberVO.memberMBTI == ' '}">selected</c:if>> </option>
				<option value="ISTJ"
					<c:if test="${memberVO.memberMBTI == 'ISTJ'}">selected</c:if>>ISTJ</option>
				<option value="ISFJ"
					<c:if test="${memberVO.memberMBTI == 'ISFJ'}">selected</c:if>>ISFJ</option>
				<option value="INFJ"
					<c:if test="${memberVO.memberMBTI == 'INFJ'}">selected</c:if>>INFJ</option>
				<option value="INTJ"
					<c:if test="${memberVO.memberMBTI == 'INTJ'}">selected</c:if>>INTJ</option>
				<option value="ISTP"
					<c:if test="${memberVO.memberMBTI == 'ISTP'}">selected</c:if>>ISTP</option>
				<option value="ISFP"
					<c:if test="${memberVO.memberMBTI == 'ISFP'}">selected</c:if>>ISFP</option>
				<option value="INFP"
					<c:if test="${memberVO.memberMBTI == 'INFP'}">selected</c:if>>INFP</option>
				<option value="INTP"
					<c:if test="${memberVO.memberMBTI == 'INTP'}">selected</c:if>>INTP</option>
				<option value="ESTP"
					<c:if test="${memberVO.memberMBTI == 'ESTP'}">selected</c:if>>ESTP</option>
				<option value="ESFP"
					<c:if test="${memberVO.memberMBTI == 'ESFP'}">selected</c:if>>ESFP</option>
				<option value="ENFP"
					<c:if test="${memberVO.memberMBTI == 'ENFP'}">selected</c:if>>ENFP</option>
				<option value="ENTP"
					<c:if test="${memberVO.memberMBTI == 'ENTP'}">selected</c:if>>ENTP</option>
				<option value="ESTJ"
					<c:if test="${memberVO.memberMBTI == 'ESTJ'}">selected</c:if>>ESTJ</option>
				<option value="ESFJ"
					<c:if test="${memberVO.memberMBTI == 'ESFJ'}">selected</c:if>>ESFJ</option>
				<option value="ENFJ"
					<c:if test="${memberVO.memberMBTI == 'ENFJ'}">selected</c:if>>ENFJ</option>
				<option value="ENTJ"
					<c:if test="${memberVO.memberMBTI == 'ENTJ'}">selected</c:if>>ENTJ</option>
			</select>
		</p>

		<p> 이메일 : ${memberVO.email }</p>
			<input type="hidden" name="email" value="${memberVO.email }" readonly="readonly">

		<p>이메일 광고 수신 동의</p>
		<c:if test="${memberVO.emailAgree == 'yes'}">
			<input type="radio" name="emailAgree" value="yes" checked="checked">예
		<input type="radio" name="emailAgree" value="no">아니오
	</c:if>
		<c:if test="${memberVO.emailAgree == 'no'}">
			<input type="radio" name="emailAgree" value="yes">예
		<input type="radio" name="emailAgree" value="no" checked="checked">아니오
	</c:if>
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<br>

	<button id="btn_update" class="button">수정하기</button>
	<button id="btn_inactive" class="button">회원탈퇴</button>
	<br>
	<button id="btn_pwUpdate" class="button">비밀번호 변경</button>
	
	<br>
	<a href="/searcher/access/admin">운영자</a>

	<script type="text/javascript">
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			
		$('#btn_update').click(function(){
			let memberId = '<sec:authentication property="name" />';
			let emailAgree = document.querySelector('input[name="emailAgree"]:checked').value;
			let memberMBTI = document.getElementById('memberMBTI').value;
			
			update(memberId, emailAgree, memberMBTI);
		});
		
		$('#btn_inactive').click(function(){
			let memberId = '${memberVO.memberId }';
			let memberStatus = 'inactive';
			
			inactive(memberId, memberStatus);
			
		});
		
		$('#btn_pwUpdate').click(function(){
			pwUpdate();
		});
	
		function update(memberId, emailAgree, memberMBTI) {
			let result = confirm("수정하시겠습니까?");
			if (result) {
				$.ajax({
				    type: 'POST',
				    url: '../access/update',
				    data: { memberId: memberId,
				    	emailAgree: emailAgree,
				    	memberMBTI: memberMBTI},
				    success: function(result) {
				    	console.log(result);
				      if (result == 1) {
				    	  alert("수정이 완료되었습니다.");
				      } else {
				    	  alert("다시 시도해주세요.");
				      }
				    }
				  });
			}
		}
		
		function inactive(memberId, memberStatus) {
			let result = confirm("회원 탈퇴하시겠습니까?");
			if (result) {
				
				console.log(status);
				
				$.ajax({
				    type: 'POST',
				    url: '../access/statusUpdate',
				    data: { memberId: memberId,
				    	memberStatus: memberStatus},
				    success: function(result) {
				    	console.log(result);
				      if (result == 1) {
				    	  alert("회원 탈퇴가 완료되었습니다. 이용해주셔서 감사합니다.");
				    	  window.location.href="../auth/login";
				      } else {
				    	  alert("다시 시도해주세요.");
				      }
				    }
				  });
		}
		}
		
		function pwUpdate() {
			let result = confirm("비밀번호를 변경하시겠습니까?");
			if (result) {
				 window.location.href = "registerEmail?select=pwSearch";
				} else {
					alert("취소되었습니다.");
				}
		}
		
		})
	</script>


</body>
</html>