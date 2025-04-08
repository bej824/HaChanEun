<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file ="../layout/head.jsp" %>
<title>쿠폰 정보</title>
</head>
<body>

	<h1>쿠폰 정보</h1>
	
	<p>쿠폰 이름 : ${discountCouponVO.couponName }</p>
	
	<p>할인가격 : ${discountCouponVO.couponPrice } 원</p>
	
	<p>사용조건 : ${discountCouponVO.couponUseCondition }원 이상 구매 시 사용 가능</p>
	
	<p>쿠폰 사용 기한 : ${discountCouponVO.couponExpirationDate }일 </p>

	<p id="couponEvent"></p>
	
	<p>쿠폰 정보</p>
	<p>${discountCouponVO.couponContent }</p>
	
	<button id="btn_update" class="button">수정</button>
	<button id="btn_delete" class="button">삭제</button>
	<button id="btn_index" class="button">목록</button>
	<button id="btn_issue" class="button">쿠폰 발급</button>
	
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
		
		dataToDisplay();
		
		$('#btn_index').click(function(){
			window.location.href = "list?itemId=" + ${itemId };
		})
		
		$('#btn_issue').click(function(){
			let couponId = '${discountCouponVO.couponId }';
			let couponName = '${discountCouponVO.couponName }';
			let couponIuuser = '${discountCouponVO.couponIssuer }';
			let couponExpirationDate = '${discountCouponVO.couponExpirationDate }';
			let couponEvent = '${discountCouponVO.couponEvent }';
			
			if(couponEvent == 'oneTime') {
			let result = confirm(couponName + "를 발급하시겠습니까?");
			if(result) {
				window.location.href = "activeRegister?itemId= " + ${itemId} + "&couponId=" + ${discountCouponVO.couponId };
			}
			} else {
				alert("해당 쿠폰은 수동 발급할 수 없습니다.");
			}
				
		})
		
		$('#btn_update').click(function(){
			window.location.href = "modify?couponId=" + ${discountCouponVO.couponId };
		})
		
		$('#btn_delete').click(function(){
			let couponId = '${discountCouponVO.couponId }';
			
			let result = confirm("쿠폰을 삭제하시겠습니까?");
			if(result) {
				$.ajax({
				    type: 'POST',
				    url: 'delete',
				    data: { 
				    	couponId: couponId},
				    success: function(result) {
				      if (result == '1') {
				    	alert("쿠폰이 삭제되었습니다.");
				    	window.location.href = "list?itemId=" + ${itemId };
				      } else {
				    	  alert("다시 시도해주세요.");
				      }
				    }
				  });
				
				
			}
			
		})
		
		function dataToDisplay() {
			
			if('${discountCouponVO.couponEvent }' == 'oneTime') {
				$('#couponEvent').html('쿠폰 발급 주기 : 프로모션');
			} else if('${discountCouponVO.couponEvent }' == 'memberDateOfBirth') {
				$('#couponEvent').html('쿠폰 발급 주기 : 생일');
			} else if('${discountCouponVO.couponEvent }' == 'memberMBTI') {
				$('#couponEvent').html('쿠폰 발급 주기 : 오늘의 mbti');
			}
			
			
		}
		
	})
	
	</script>

</body>
</html>