<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 전체 거래 내역</title>
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
			<tr onclick="window.location.href='purchaseInfo?orderId=${DirectOrderList.orderId}&keyword=${param.keyword}&type=${param.type}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'">
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
	
	<form id="searchForm" method="GET" action="purchaseHistory" class="search">
	    <select name="keyword" id="keyword" style="display:none;">
        <!-- 추가적인 옵션들이 동적으로 들어갈 부분 -->
    	</select>
	    <select name="type" id="type" onchange="updateFilters()">
	    	<option>전체</option>
	        <option value="DELIVERY_STATUS">배송 상태</option>
	        <option value="DELIVERY_DATE">결제일</option>
	    </select>
	    <button type="submit" class="button">검색</button>
	</form>
	
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
			            <a href="purchaseHistory?keyword=${param.keyword}&type=${param.type}&pageNum=${num}" class="button">${num}</a>
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
		
	<script type="text/javascript">
	    function updateFilters() {
	        let type = document.getElementById("type").value;
	        let keyword = document.getElementById("keyword");
	
	        // 추가 필터 초기화 (기존 옵션 제거)
	        keyword.innerHTML = '';
	
	        // 필터를 선택한 type 값에 따라 다르게 처리
	        if (type === "DELIVERY_DATE") {
	            // 'DELIVERY_DATE'에 대한 추가 필터 옵션
	            let options = ["1일", "1주일", "1달", "3달", "6달", "1년"];
	            keyword.style.display = "inline-block";  // 추가 필터 보이기
	            options.forEach(function(optionText) {
	                let option = document.createElement("option");
	                option.value = optionText;
	                option.text = optionText;
	                keyword.appendChild(option);
	            });
	        } else if (type === "DELIVERY_STATUS") {
	        	let options = ["상품 준비중", "배송 준비중", "배송 중", "배송 완료", "환불 신청", "환불 승인", "환불 완료", "결제 취소", "주문 취소"];
	        	keyword.style.display = "inline-block";  // 추가 필터 보이기
	            options.forEach(function(optionText) {
	                let option = document.createElement("option");
	                option.value = optionText;
	                option.text = optionText;
	                keyword.appendChild(option);
	            });
	        } else {
	            keyword.style.display = "none";  // 'DELIVERY_DATE' 이외의 타입에서는 필터 숨기기
	        }
	    }
	</script>
</body>
</html>