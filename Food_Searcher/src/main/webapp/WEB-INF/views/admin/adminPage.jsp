<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
<%@ include file ="../header.jsp" %>
<div id="area">
<h1>사이트 관리</h1>
<div style="display: flex;">
<button class="button" id="roleUp">운영자 권한 부여</button>
<button class="button" id="itemManagement">판매 상품 관리 목록</button>

<button class="button" onclick="couponList()">쿠폰 목록</button>
</div>
<div style="display: flex;">
<a href="purchaseHistory" class="button">회원 전체 거래 내역</a>
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
			window.location.href = "adminRole";
		})
		
		$('#itemManagement').click(function(){
			window.location.href = "itemManagement";
		})
		
		$('#financialManagement').click(function(){
			window.location.href = "financialManagement";
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
	
		
		function couponList() {
			window.open("../coupon/list", "_blank", "width=800,height=600,scrollbars=yes,resizable=yes");
		}
		
	</script>
</body>
</html>