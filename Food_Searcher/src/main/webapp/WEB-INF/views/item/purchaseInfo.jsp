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
	<c:if test="${not empty directOrderVO.deliveryCompletedDate && directOrderVO.deliveryStatus eq '배송 완료'}">
	<div>
		<p>배송 완료일 : <fmt:formatDate value="${directOrderVO.deliveryCompletedDate }" pattern="yyyy/MM/dd-HH:mm:ss" var="deliveryDate"/>${deliveryDate } </p>
	</div>
	</c:if>
	
	<c:if test="${directOrderVO.deliveryStatus eq '결제 완료'}">
		<button id="cancel" class="button">결제 취소</button>
	</c:if>
	<c:set var="now" value="<%=new java.util.Date() %>" />
	<c:if test="${directOrderVO.deliveryStatus eq '배송 완료' && directOrderVO.deliveryRefund >= now}">
		<button id="refund" class="button">환불 신청</button>
	</c:if>

	<script type="text/javascript">
		console.log('<sec:authentication property="name" />');
		console.log('${directOrderVO.memberId }');
		if('<sec:authentication property="name" />' == '${directOrderVO.memberId }') {
		$(document).ready(function() {
			$('#cancel').click(function(){
				console.log("결제 취소");
				let orderId = ${directOrderVO.orderId };
				let deliveryStatus = '결제 취소';
				$.ajax({
					url : 'cancel/' + orderId,
					type : 'PUT',
					headers : {
    			        'Content-Type' : 'application/json' // json content-type 설정
    			    }, 
    			    data : JSON.stringify({ deliveryStatus: deliveryStatus }),
    			    success : function(result) {
    			        console.log("서버 응답:", result); // 서버로부터 받은 응답을 확인
    			        if(result == 1) {
    			            alert('상태 변경');
    			            location.reload();
    			        } else {
    			            alert('예상치 못한 값:', result); // unexpected value
    			        }
    			    }

				});
			});
		});
		
		$(document).ready(function() {
			$('#refund').click(function(){
				console.log("환불 신청");
				let orderId = ${directOrderVO.orderId };
				let deliveryStatus = '환불 신청';
				$.ajax({
					url : 'refund/' + orderId,
					type : 'PUT',
					headers : {
    			        'Content-Type' : 'application/json' // json content-type 설정
    			    }, 
    			    data : JSON.stringify({ deliveryStatus: deliveryStatus }),
    			    success : function(result) {
    			        console.log("서버 응답:", result); // 서버로부터 받은 응답을 확인
    			        if(result == 1) {
    			            alert('상태 변경');
    			            location.reload();
    			        } else {
    			            alert('예상치 못한 값:', result); // unexpected value
    			        }
    			    }

				});
			});
		});
		} else {
			const cancelElement = document.getElementById("cancel");
			const refundElement = document.getElementById("refund");

			if (cancelElement !== null) {
			    cancelElement.style.display = "none";
			}

			if (refundElement !== null) {
			    refundElement.style.display = "none";
			}
		}
	</script>
	
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	<c:if test="${directOrderVO.deliveryStatus eq '결제 완료'}">
		<button id="ready" class="button">배송 준비중</button>
	</c:if>
	<c:if test="${directOrderVO.deliveryStatus eq '배송 준비중'}">
		<button id="completed" class="button">배송 완료</button>
	</c:if>
	<c:if test="${directOrderVO.deliveryStatus eq '환불 신청'}">
		<button id="refundOK" class="button">환불 승인</button>
	</c:if>
	</sec:authorize>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$('#ready').click(function(){
				let orderId = ${directOrderVO.orderId };
				let deliveryStatus = '배송 준비중';
				$.ajax({
					url : 'ready/' + orderId,
					type : 'PUT',
					headers : {
						'Content-Type' : 'application/json'
					},
					data : JSON.stringify({ deliveryStatus : deliveryStatus }),
					success : function(result) {
    			        console.log("서버 응답:", result); // 서버로부터 받은 응답을 확인
    			        if(result == 1) {
    			            alert('상태 변경');
    			            location.reload();
    			        } else {
    			            alert('예상치 못한 값:', result); // unexpected value
    			        }
    			    }
				});
			});
			
			$('#completed').click(function(){
				let orderId = ${directOrderVO.orderId };
				let deliveryStatus = '배송 완료';
				$.ajax({
					url : 'completed/' + orderId,
					type : 'PUT',
					headers : {
						'Content-Type' : 'application/json'
					},
					data : JSON.stringify({ deliveryStatus : deliveryStatus }),
					success : function(result) {
    			        console.log("서버 응답:", result); // 서버로부터 받은 응답을 확인
    			        if(result == 1) {
    			            alert('상태 변경');
    			            location.reload();
    			        } else {
    			            alert('예상치 못한 값:', result); // unexpected value
    			        }
    			    }
				});
			});
			
			$('#refundOK').click(function(){
				let orderId = ${directOrderVO.orderId };
				let deliveryStatus = '환불 완료';
				$.ajax({
					url : 'refundOK/' + orderId,
					type : 'PUT',
					headers : {
						'Content-Type' : 'application/json'
					},
					data : JSON.stringify({ deliveryStatus : deliveryStatus }),
					success : function(result) {
    			        console.log("서버 응답:", result); // 서버로부터 받은 응답을 확인
    			        if(result == 1) {
    			            alert('상태 변경');
    			            location.reload();
    			        } else {
    			            alert('예상치 못한 값:', result); // unexpected value
    			        }
    			    }
				});
			});
		});
	</script>
	
	<button onclick="window.location.href='purchaseHistory'" class="button">뒤로가기</button>
	
</body>
</html>