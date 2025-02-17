<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 상세 정보</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
	<div>
		<p>구매 번호 : ${directOrderVO.orderId }</p> 
	</div>
	<div>
		<p>구매한 회원 : ${directOrderVO.memberId }</p> 
	</div>
	<div>
		<p>구매한 상품 : ${itemVO.itemName }</p>
	</div>
	<div>
		<p>구매 수량 : ${directOrderVO.totalCount }</p>
	</div>
	<div>
		<p>총 구매 가격 : ${directOrderVO.totalPrice }원</p>
	</div>
	<div>
		<p>배송지 : ${directOrderVO.deliveryAddress }</p>
	</div>
	<div>
		<p>배송 현황 : ${directOrderVO.deliveryStatus }</p>
	</div>
	
	<c:if test="${directOrderVO.deliveryStatus eq '결제 완료'}">
		<button id="cancel">결제 취소</button>
	</c:if>
	<c:if test="${directOrderVO.deliveryStatus eq '배송 완료'}">
		<button id="refund">환불 신청</button>
	</c:if>

	<script type="text/javascript">
		console.log('<sec:authentication property="name" />');
		console.log('${directOrderVO.memberId }');
		$(document).ready(function() {
			$('#cancel').click(function(e){
				
			});
		});
	</script>
	
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<button>배송 준비중</button>
		<button>배송 완료</button>
	</sec:authorize>
	
	<button onclick="goBack()" class="button">뒤로가기</button>
	
	
	<script>
		function goBack() {
		  const referrer = document.referrer;
		  if (referrer) {
		    window.location.href = referrer;  // 이전 페이지로 이동
		  } else {
		    alert("이전 페이지가 없습니다.");
		  }
		}
	</script>
</body>
</html>