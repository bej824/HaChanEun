<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta name="authenticatedUser" content="${authentication.name}">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="../resources/css/Base.css">
<title>쿠폰 생성기</title>
</head>
<body>

		<p>쿠폰 이름</p>
		<input type="text" id="couponName" name="couponName" placeholder="쿠폰 이름 입력">
		<div id="nameMsg" class="message" style="color: red;">쿠폰 이름을 입력해주세요!</div>
		<br>

		<p>할인 가격</p>
		<input type="text" id="couponPrice" name="couponPrice" placeholder="할인가격을 입력해주세요.">원
		<div id="priceMsg" class="message" style="color: red;">할인 가격을 입력해주세요!</div>
		<br>
		
		<p>쿠폰 발급 주기</p>
		<select id="couponEvent" name="couponEvent">
			<option value="oneTime">프로모션용</option>
			<option value="memberDateOfBirth">생일</option>
			<option value="memberMBTI">MBTI</option>
		</select>

		<p>쿠폰 가격 제한</p>
		<input type="text" id="couponUseCondition" name="couponUseCondition" placeholder="가격 제한을 걸어주세요.">원
		<div id="conditionMsg" class="message" style="color: red;">가격 제한을 걸어주세요!</div>

		<p>쿠폰 정보</p>
		<textarea id="couponContent" name="couponContent"></textarea> <br>
		

		<button class="button" name="insert" id="insert">쿠폰 등록</button>
		
		<script type="text/javascript">
		
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
		
			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			let nameCheck = false;
			let priceCheck = false;
			let conditionCheck = false;
			
			$('#couponName').change(function(){
				let couponName = $(this).val();
				let nameMsg = $('#nameMsg');
				
				if(couponName == "") {
					nameCheck = false;
					nameMsg.html('쿠폰 이름을 입력해주세요!');
				} else {
					nameCheck = true;
					nameMsg.html('');
					console.log(couponName);
				}
					
			})
			
			$('#couponPrice').change(function(){
				let couponPrice = $(this).val();
				let priceMsg = $('#priceMsg');
				
				if(!/^\d+$/.test(couponPrice)) {
					priceMsg.html('할인 가격은 숫자로만 입력 가능합니다!');
				} else if(couponPrice == "") {
					priceCheck = false;
					priceMsg.html('할인 가격을 입력해주세요!');
				} else {
					priceCheck = true;
					priceMsg.html('');
					console.log(couponPrice);
				}
					
			})
			
			$('#couponEvent').change(function(){
				let couponEvent = $(this).val();
				console.log(couponEvent);
				
			})
			
			$('#couponUseCondition').change(function(){
				let couponUseCondition = $(this).val();
				let conditionMsg = $('#conditionMsg');
				
				if(!/^\d+$/.test(couponUseCondition)) {
					conditionMsg.html('가격제한은 숫자로만 입력 가능합니다!');
				} else if(couponUseCondition == "") {
					conditionMsg.html('가격 제한을 걸어주세요!');
				} else {
					conditionCheck = true;
					conditionMsg.html('');
				}
				
			})
			
			$('#insert').click(function(){
				let couponName = $('#couponName').val();
				let couponPrice = $('#couponPrice').val();
				let couponEvent = $('#couponEvent').val();
				let couponContent = $('#couponContent').val();
				let couponUseCondition = $('#couponUseCondition').val();
				
				console.log(couponEvent);
				
				if(nameCheck == true && priceCheck == true && conditionCheck == true) {
					
					if(couponUseCondition == 0) {
						let result = confirm("가격제한을 0원으로 설정하시겠습니까?");
						if(result) {
							console.log(result);
						} else {
							return;
						}
					}
					$.ajax({
					    type: 'POST',
					    url: 'register',
					    data: { couponName: couponName,
					    	couponPrice: couponPrice,
					    	couponEvent: couponEvent,
					    	couponUseCondition, couponUseCondition,
					    	couponContent: couponContent},
					    success: function(result) {
					      if (result == '1') {
					    	alert("쿠폰이 생성되었습니다.");
					    	window.close();
					      } else {
					    	  alert("다시 시도해주세요.");
					      }
					    }
					  });
				}
			})
			
		})
		
		
		</script>

</body>
</html>