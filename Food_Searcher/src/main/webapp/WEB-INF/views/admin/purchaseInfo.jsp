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
<div id="area">
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
	<c:if test="${directOrderVO.deliveryStatus eq '배송 준비중' || directOrderVO.deliveryStatus eq '배송 중' || directOrderVO.deliveryStatus eq '배송 완료'}">
		<p>택배사 : ${directOrderVO.deliveryCompany }</p>
		<p>송장 번호 : ${directOrderVO.invoiceNumber }</p>
	</c:if>
	<div style="display: flex;">
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
	
	<button onclick="window.location.href='purchaseHistory?keyword=${param.keyword}&type=${param.type}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'" class="button">뒤로가기</button>
	</div>
</div>
</body>
</html>