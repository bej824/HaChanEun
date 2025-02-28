<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매내역</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<p>구매내역</p>

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
		<c:forEach var="DirectOrderVO" items="${directOrderVO }">
			<tr onclick="window.location.href='purchaseInfo?orderId=${DirectOrderVO.orderId}&keyword=${param.keyword}&type=${param.type}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'">
				<td>${DirectOrderVO.memberId }</td>
				<td style="text-align: right;">${DirectOrderVO.totalCount }</td>
				<td><fmt:formatNumber value="${DirectOrderVO.totalPrice}" pattern="###,###,###"/>원</td>
				<td>${DirectOrderVO.deliveryAddress }</td>
				<td>${DirectOrderVO.deliveryStatus }</td>
				<fmt:formatDate value="${DirectOrderVO.deliveryDate }" pattern="yyyy/MM/dd-HH:mm:ss" var="deliveryDate"/>
				<td>${deliveryDate }</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	
	<ul>
			<!-- 이전 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isPrev() }">
			    <li class="pagination_button">
			        <a href="purchaseHistory?keyword=${param.keyword}&type=${param.type}&pageNum=${pageMaker.startNum - 1}" class="button">이전</a>
			    </li>
			</c:if>
			
			<!-- 페이지 번호 생성 (시작 번호부터 끝 번호까지) -->
			<c:if test="${not empty pageMaker.startNum and pageMaker.startNum > 0}">
			    <c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }" var="num">
			        <li class="pagination_button">
			            <a href="purchaseHistory?keyword=${param.keyword}&type=${param.type}&pageNum=${num}">${num}</a>
			        </li>
			    </c:forEach>
			</c:if>
			
			<!-- 다음 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isNext() }">
			    <li class="pagination_button">
			        <a href="purchaseHistory?keyword=${param.keyword}&type=${param.type}&pageNum=${pageMaker.endNum + 1}" class="button">다음</a>
			    </li>
			</c:if>		
		</ul>
</body>
</html>