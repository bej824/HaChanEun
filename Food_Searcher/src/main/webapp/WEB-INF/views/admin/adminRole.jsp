<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 권한 부여</title>
</head>
<body>
<body>
<%@ include file ="../header.jsp" %>
<div id="area">
<h1>등급 : ${roleVO.roleName }</h1>

<input type="text" id="memberId" placeholder="운영자 등업 id" required>
<div id="idMsg" class="message" style="color: red;">아이디를 입력해주세요!</div> <br>
<div style="display: flex;">
<button class="button" id="roleUp">등급 업</button>
</div>
</div>

	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
	
		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
		let idCheck = false;
		
		$('#memberId').change(function(){
			let memberId = $(this).val();
			
			if (/[\W_]/.test(memberId) || memberId == '') {
  				$('#idMsg').html('아이디는 공백이나 특수문자를 사용할 수 없습니다.').css('color', 'red');
  				return;
  			} else {
				idCheck = true;
				$('#idMsg').html('');
			}
		})
		
		$('#roleUp').click(function(){
			let memberId = $('#memberId').val();
			
			if(idCheck) {
				roleUpdate(memberId);
			}
		})
		
		function roleUpdate(memberId) {
			let roleName = "ROLE_ADMIN";
			let result = confirm(memberId + "님을 운영자 등록시키겠습니까?");
			if (result) {
				$.ajax({
	  		    	type: 'POST',
	  		    	url: 'roleUpdate',
	  		    	data: { memberId: memberId,
	  		    			roleName: roleName},
	  		    	success: function(result) {
	  		      		alert("등록완료되었습니다.");
	  		    	}
	  		  	});
			} else {
				alert("취소되었습니다.");
			}
		}
	})
		
	</script>
</body>

</body>
</html>