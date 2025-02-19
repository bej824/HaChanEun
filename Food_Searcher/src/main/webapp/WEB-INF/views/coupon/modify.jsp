<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file ="../layout/head.jsp" %>
<title>쿠폰 수정</title>
</head>
<body>

	<p>쿠폰 이름 : ${discountCouponVO.couponName }</p>
		
	<p>발급 주체 : ${discountCouponVO.couponIssuer }</p>

	<p>할인 가격</p>
	<input type="text" id="couponPrice" name="couponPrice" placeholder="${discountCouponVO.couponPrice }">원
	<div id="priceMsg" class="message" style="color: red;"></div>
		
	<p>쿠폰 발급 주기</p>
	<select id="couponEvent" name="couponEvent">
    	<option value="oneTime" 
        	<c:if test="${discountCouponVO.couponEvent == 'oneTime'}">selected</c:if>>프로모션용</option>
    	<option value="memberDateOfBirth" 
        	<c:if test="${discountCouponVO.couponEvent == 'memberDateOfBirth'}">selected</c:if>>생일</option>
    	<option value="memberMBTI" 
        	<c:if test="${discountCouponVO.couponEvent == 'memberMBTI'}">selected</c:if>>MBTI</option>
		</select>

	<p>쿠폰 가격 제한</p>
	<input type="text" id="couponUseCondition" name="couponUseCondition" placeholder="${discountCouponVO.couponUseCondition }">원
	<div id="conditionMsg" class="message" style="color: red;"></div>

	<p>쿠폰 정보</p>
	<textarea id="couponContent" name="couponContent" placeholder="${discountCouponVO.couponContent }"></textarea> <br>
		

	<button class="button" name="btn_update" id="btn_update">쿠폰 수정</button>
	<button class="button" name="btn_cancel" id="btn_cancel">취소</button>
		
	<script type="text/javascript">
	
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
	
			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			let couponId = '${discountCouponVO.couponId }';
			
			let priceCheck = true;
			let conditionCheck = true;
			
			$('#couponPrice').change(function(){
				let couponPrice = $(this).val().trim();
				let priceMsg = $('#priceMsg');
				
				if(couponPrice != '' && !/^\d+$/.test(couponPrice)) {
					priceMsg.html('할인 가격은 숫자로만 입력 가능합니다!');
					priceCheck = false;
				} else if(couponPrice < 100 && couponPrice != '') {
					priceMsg.html('할인 가격은 100원 이상만 가능합니다!');
					priceCheck = false;
				} else {
					priceCheck = true;
					priceMsg.html('');
					console.log(couponPrice);
				}
					
			})
			
			$('#couponUseCondition').change(function(){
				let couponUseCondition = $(this).val().trim();
				let conditionMsg = $('#conditionMsg');
				
				if(couponUseCondition != '' && !/^\d+$/.test(couponUseCondition)) {
					conditionMsg.html('가격제한은 숫자로만 입력 가능합니다!');
					conditionCheck = false;
				} else {
					conditionCheck = true;
					conditionMsg.html('');
				}
				
			})
			
			$('#btn_update').click(function(){
				let couponId = '${discountCouponVO.couponId }';
				let couponPrice = $('#couponPrice').val().trim();
				let couponContent = $('#couponContent').val();
				let couponUseCondition = $('#couponUseCondition').val().trim();
				let couponEvent = $('#couponEvent').val()
				
				if(couponPrice == "") {
					couponPrice = '${discountCouponVO.couponPrice }';
				}
				if(couponContent == "") {
					couponContent = '${discountCouponVO.couponContent }';
				}
				if(couponUseCondition == "") {
					couponUseCondition = '${discountCouponVO.couponUseCondition }';
				}
				if(couponEvent == "") {
					couponContent = '${discountCouponVO.couponEvent }';
				}
				
				console.log("가격 : " + couponPrice);
				console.log("상세 : " + couponContent);
				console.log("조건 : " + couponUseCondition);
				console.log("주기 : " + couponEvent);
				
				if(priceCheck == true && conditionCheck == true) {
					
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
					    url: 'update',
					    data: { 
					    	couponId: couponId,
					    	couponPrice: couponPrice,
					    	couponEvent: couponEvent,
					    	couponUseCondition: couponUseCondition,
					    	couponContent: couponContent},
					    success: function(result) {
					      if (result == '1') {
					    	alert("쿠폰이 수정되었습니다.");
					    	window.location.href = 'detail?couponId=' + couponId;
					      } else {
					    	  alert("다시 시도해주세요.");
					      }
					    }
					  });
				}
				
				
			})
			
			$('#btn_cancel').click(function() {
				let result = confirm("쿠폰 수정을 취소하시겠습니까?");
				if(result) {
			    	window.location.href='detail?couponId=' + couponId;
				}
				
			})
			
		})
		
	</script>

</body>
</html>