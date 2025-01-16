<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ID 찾기</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	
	<h1>ID 찾기</h1>
	회원 이름 : <input type="text" id="memberName" name="memberName" placeholder="이름을 입력해주세요." required> <br>
	
	<form id="emailForm" action="pwSearch" method="POST">
	<input type="hidden" name="memberId" id = "memberId">
	<input type="hidden" name="email" id ="email">
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<button id="btn_search" class="button">ID 찾기</button>

	<script type="text/javascript">
	
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			
		$('#btn_search').click(function(){
			let memberName = document.getElementById('memberName').value;
			let email = "${email }"
			idSearch(memberName, email);
		});
		
		function idSearch(memberName, email){
			
			$.ajax({
			    type: 'POST',
			    url: 'idSearchAjax',
			    data: { memberName: memberName,
			    	email: email},
			    success: function(memberVO) {
			    	if(memberVO.memberId != null) {
			    	
			    	if(memberVO.memberStatus == "active") {
			    		
			    		let result = confirm(memberVO.memberName + "님의 아이디는" + memberVO.memberId + "입니다. \n 패스워드찾기로 이동하시겠습니까?");
			    		if (result) {
			    			let emailForm = document.getElementById("emailForm");
			    			emailForm.memberId.value = memberVO.memberId;
			    			emailForm.email.value=email;
			    			emailForm.submit();
			    		}
			    		
			    		} else if(memberVO.memberStatus == "inactive") {
			    		
			    			let result = confirm(memberVO.memberName + "님의 아이디는 " + memberVO.memberId + "입니다. \n 현재" + memberVO.memberStatus + "상태입니다. 활성화하시겠습니까?");			    			
			    		
			    		if (result) {
			    			active(memberVO.memberId);
			    		}
			    	
			    		}
			    	
			    	} else {
			    		alert("회원님의 아이디를 찾을 수 없습니다. 처음부터 다시 진행하여 주십시오.");
			    		window.location.href="registerEmail?select=idSearch";
			    	}
			    }
			  });
		}
	
		function active(memberId){
			let memberStatus = 'active';
			
			console.log(status);
			
			$.ajax({
			    type: 'POST',
			    url: 'statusUpdate',
			    data: { memberId: memberId,
			    	memberStatus: memberStatus},
			    success: function(result) {
			    	console.log(result);
			      if (result == 1) {
			    	  alert("활성화되었습니다.");
			    	  window.location.href = "login";
			      } else {
			    	  alert("다시 시도해주세요.");
			      }
			    }
			  });
			
		}
		
		})
	</script>


</body>
</html>