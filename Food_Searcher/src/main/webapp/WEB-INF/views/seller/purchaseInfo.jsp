<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
		<p>총 구매 가격 : <fmt:formatNumber value="${directOrderVO.totalPrice }" pattern="###,###,###" />원</p>
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
	<c:if test="${directOrderVO.deliveryStatus eq '환불 완료' }">
	<div>
		<p>환불 사유 : ${directOrderVO.refundReason }</p>
		<p>내용</p>
		<textarea rows="" cols="" readonly>${directOrderVO.refundContent }</textarea>
	</div>
	</c:if>
	<c:if test="${directOrderVO.deliveryStatus eq '상품 준비중'}">
		<p>택배사 :
		<select name="deliveryCompany">
			<option>CJ대한통운</option>
			<option>로젠택배</option>
			<option>경동택배</option>
			<option>한진택배</option>
			<option>우체국택배</option>
		</select></p>
		<c:set var="now" value="<%=new java.util.Date() %>" />
		<fmt:formatDate value="${now }" pattern="yyyyMMddHHmmss" var="Date"/>
		<p>송장 번호 : <input type="text" id="invoiceNumber" value="${Date }" required></p>
		<button id="ready" class="button">배송 준비중</button>
	</c:if>
	<c:if test="${directOrderVO.deliveryStatus eq '배송 준비중' || directOrderVO.deliveryStatus eq '배송 중' || directOrderVO.deliveryStatus eq '배송 완료'}">
		<p>택배사 : ${directOrderVO.deliveryCompany }</p>
		<p>송장 번호 : ${directOrderVO.invoiceNumber }</p>
	</c:if>
	
	<c:if test="${directOrderVO.deliveryStatus eq '배송 준비중'}">
		<button id="delivering" class="button">배송 중</button>
	</c:if>
	<c:if test="${directOrderVO.deliveryStatus eq '배송 중'}">
		<button id="completed" class="button">배송 완료</button>
	</c:if>
	<c:if test="${directOrderVO.deliveryStatus eq '환불 신청'}">
		<p>환불 사유 : ${directOrderVO.refundReason }</p>
		<p>내용</p>
		<textarea rows="" cols="" readonly>${directOrderVO.refundContent }</textarea>
		<button id="refundOK" class="button">환불 승인</button>
	</c:if>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$('#ready').click(function(){
				let orderId = '${directOrderVO.orderId }';
				let deliveryCompany = $("select[name='deliveryCompany']").val();
				console.log(deliveryCompany);
				let invoiceNumber = $("#invoiceNumber").val();
				console.log(invoiceNumber);
				$.ajax({
					url : 'ready/' + orderId,
					type : 'PUT',
					headers : {
						'Content-Type' : 'application/json'
					},
					data : JSON.stringify({ 
						deliveryCompany : deliveryCompany,
						invoiceNumber : invoiceNumber}),
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
			
			$('#delivering').click(function(){
				let orderId = '${directOrderVO.orderId }';
				$.ajax({
					url : 'delivering/' + orderId,
					type : 'PUT',
					headers : {
						'Content-Type' : 'application/json'
					},
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
				let orderId = '${directOrderVO.orderId }';
				$.ajax({
					url : 'completed/' + orderId,
					type : 'PUT',
					headers : {
						'Content-Type' : 'application/json'
					},
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
				let orderId = '${directOrderVO.orderId }';
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