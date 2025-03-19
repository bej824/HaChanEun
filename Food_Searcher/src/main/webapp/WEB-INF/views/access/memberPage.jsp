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
	<div id="area">
	<h1>Member Page</h1>

	<p>아이디 : <sec:authentication property="name" /><br><br>
	
	이름 : ${memberVO.memberName }<br><br>
	
	성별 :
		<c:if test="${memberVO.memberGender == 'male'}">
			남성 
		</c:if>
		<c:if test="${memberVO.memberGender == 'female'}">
			여성 
		</c:if> <br><br>
		
	나이 : <span id="age"></span><br><br>
	
	별자리 : <span id=constellation></span><br><br>
		
	<%@ include file ="ageConstellation.jsp" %>

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
		</select><br>
	
	이메일 : ${memberVO.email } <button id="btn_emailUpdate" name="btn_emailUpdate" class="button">수정</button><br>
	
	이메일 광고 수신 동의</p>
	<div style="display: flex;">
	<c:if test="${memberVO.emailAgree == 'yes'}">
		<input type="radio" name="emailAgree" value="yes" checked="checked">예
		<input type="radio" name="emailAgree" value="no">아니오
	</c:if>
	<c:if test="${memberVO.emailAgree == 'no'}">
		<input type="radio" name="emailAgree" value="yes">예
		<input type="radio" name="emailAgree" value="no" checked="checked">아니오
	</c:if>
	</div>
	<div style="display: flex;">
	<button id="btn_memberCoupon" class="button">쿠폰함</button>
	<a href="../cart/list/<sec:authentication property="name" />" class="button">장바구니</a>
	<a href="../item/purchaseHistory" class="button">구매 내역</a>
	</div>
	<div style="display: flex;">
	<button id="btn_update" class="button">수정하기</button>
	<button id="btn_pwUpdate" class="button">비밀번호 변경</button>
	<button id="btn_inactive" class="button">회원탈퇴</button>
	</div>

	<script type="text/javascript">
	
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			
		$('#btn_memberCoupon').click(function(){
			window.location.href = "memberCoupon";
		})
			
		$('#btn_update').click(function(){
			let memberId = '<sec:authentication property="name" />';
			let emailAgree = document.querySelector('input[name="emailAgree"]:checked').value;
			let memberMBTI = document.getElementById('memberMBTI').value;
			
			update(memberId, emailAgree, memberMBTI);
		});
		
		
		$('#btn_pwUpdate').click(function(){
			let result = confirm("비밀번호를 수정하시겠습니까?");
			if(result){
			window.location.href = "pwUpdate";
			}
		});
		
		$('#btn_emailUpdate').click(function(){
			let emailUpdate = confirm("이메일을 변경하시려면 이메일 인증 후 가능합니다.\n 변경하시겠습니까?");
			if(emailUpdate){
				window.location.href = "registerEmail?select=emailUpdate";
			}
			
		});
		
		$('#btn_inactive').click(function(){
			let memberId = '<sec:authentication property="name" />';
			let memberStatus = 'inactive';
			
			inactive(memberId, memberStatus);
			
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
				
				$.ajax({
				    type: 'POST',
				    url: '../access/statusUpdate',
				    data: { memberId: memberId,
				    	memberStatus: memberStatus},
				    success: function(result) {
				    	
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
		
		})
	</script>
	</div>

</body>
</html>