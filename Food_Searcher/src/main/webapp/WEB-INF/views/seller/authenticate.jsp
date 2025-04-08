<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	
	<h1>사업자 인증</h1>
	
	<p>대표자 이름 : </p>
	<input type="text" name="CEOName" id="CEOName" maxlength="20" placeholder="대표자명 입력"
		required>
	<div id="CEOMsg" class="message" style="color: red;">대표자님 성함을 입력해주세요!</div>
	
	<p>사업자등록번호 : </p>
	<input type="text" name="businessRegistrationNumber" id="businessRegistrationNumber"
		maxlength="10" placeholder="사업자등록번호 입력" required>
	<div id="BRNMsg" class="message" style="color: red;">대표자분 성함을 입력해주세요!</div>
	
	<p>개업일자 : </p>
	<input type="text" name="openingDate" id="openingDate" placeholder="개업일자 8자리를 입력해주세요."
		maxlength="8" required>
	<div id="dateMsg" class="message" style="color: red;">개업일자를 입력해주세요!</div>
	
	<button id="btn_register" class="button">판매자 등록</button>
	
	</div>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		let CEOCheck = false;
		let BRNCheck = false;
		let dateCheck = false;
		
		$('#CEOName').change(function(){
			let CEOName = $(this).val();
			CEOCheck = false;
			
			if(!/^[가-힣]+$/.test(CEOName) || CEOName == '') {
				$('#CEOMsg').html('대표자님의 성함을 다시 한번 확인 후 입력해주세요.').css('color', 'red');
  				return;
			} else {
				CEOCheck = true;
				$('#CEOMsg').html('');
			}
			
		})
		
		$('#businessRegistrationNumber').change(function(){
			let businessRegistrationNumber = $(this).val();
			BRNCheck = false;
			
			if(!/^\d+$/.test(businessRegistrationNumber) || businessRegistrationNumber.length != 10) {
				$('#BRNMsg').html('사업자등록번호를 다시 한번 확인 후 입력해주세요.').css('color', 'red');
  				return;
			} else {
				BRNCheck = true;
				$('#BRNMsg').html('');
			}
			
		})
		
		$('#openingDate').change(function(){
			let openingDate = $(this).val();
			let nowDate = "${nowDate}";
			BRNCheck = false;
			let msg = $('#dateMsg').html('개업일자를 확인 후 다시 입력해주세요.').css('color', 'red');
			
			if(!/^\d+$/.test(openingDate) || openingDate.length != 8) {
				$(this).val('');
  				return;
			} else {
				
				const year = parseInt(openingDate.slice(0, 4), 10);
  			   	const month = parseInt(openingDate.slice(4, 6), 10);
  			    const day = parseInt(openingDate.slice(6, 8), 10);
  			  	const month31 = new Set([1, 3, 5, 7, 8, 10, 12]);
              	const month30 = new Set([4, 6, 9, 11]);
  			    
  			    if(nowDate - openingDate < 0){
  			    	msg;
  				} else if(month < 1 || month > 12){
  					msg;
  				} else if(day < 1 || day > 31){
  					msg;
  				} else if(month30.has(month) && day == 31){
  					msg;
  				} else if(year % 4 != 0 && month == 2 && day > 28){
  					msg;
  				} else if(year % 4 == 0 && month == 2 && day > 29){
  					msg;
  				} else {
  					BRNCheck = true;
					$('#dateMsg').html('');
  				}
				
			}
			
		})
		
		$('#btn_register').click(function(){
			let CEOName = $('#CEOName').val();
			let businessRegistrationNumber = $('#businessRegistrationNumber').val();
			let openingDate = $('#openingDate').val();
			
			if(!CEOCheck){
				alert("대표자분의 성함을 다시 한번 확인 후 입력해주세요.");
				return;
			} else if(!BRNCheck) {
				alert("사업자등록번호를 다시 한번 확인 후 입력해주세요.");
				return;
			} else if(!dateCheck){
				alert("개업일자를 다시 한번 확인 후 입력해주세요.");
				return;
			}
			
			authenticate ();
			
		})
		
		
		function authenticate () {
			roleUpdate();
		}
		
		function roleUpdate() {
			let memberId = '<sec:authentication property="name" />';
			let result = confirm("판매자 등록하시겠습니까?");
			if (result) {
				$.ajax({
	  		    	type: 'POST',
	  		    	url: 'roleUpdate',
	  		    	data: { },
	  		    	success: function(result) {
	  		      		alert("등록완료되었습니다.");
	  		      	window.location.href = "../home";
	  		    	}
	  		  	});
			} else {
				alert("취소되었습니다.");
			}
		}
		
	})
	
	</script>
	

</body>
</html>