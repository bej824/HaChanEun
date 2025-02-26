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
<p>회원 전체 거래 내역</p>
	<table border="1">
		<thead>
			<tr>
				<th style="width: 8%">회원Id</th>
				<th style="width: 5%">수량</th>
				<th style="width: 8%">결제 금액</th>
				<th style="width: 30%">주소</th>
				<th style="width: 9%">배송 상태</th>
				<th style="width: 15%">결제일</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="DirectOrderList" items="${directOrderVO }">
			<tr onclick="window.location.href='purchaseInfo?orderId=${DirectOrderList.orderId}'">
				<td>${DirectOrderList.memberId }</td>
				<td style="text-align: right;">${DirectOrderList.totalCount }</td>
				<td><fmt:formatNumber value="${DirectOrderList.totalPrice}" pattern="###,###,###"/>원</td>
				<td>${DirectOrderList.deliveryAddress }</td>
				<td>${DirectOrderList.deliveryStatus }</td>
				<fmt:formatDate value="${DirectOrderList.deliveryDate }" pattern="yyyy/MM/dd-HH:mm:ss" var="deliveryDate"/>
				<td>${deliveryDate }</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</body>
</html>