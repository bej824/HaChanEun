<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file ="../header.jsp" %>
</head>
<body>
	<div id="area">
	<h1>사이트 재무 관리</h1>
	
	<p>쿠폰 총 정산금 : <span id="couponSettledAll">0</span>원</p>
	
	<p>쿠폰 지급 정산금 : <span id="couponSettledPayment">0</span>원</p>
	<p>쿠폰 잔여 정산금 : <span id="couponSettledRemaining">0</span>원</p>
	
	<table>
		<thead>
			<tr>
				<th style="width: 10%">사용자</th>
				<th style="width: 10%">쿠폰가액</th>
				<th style="width: 10%">상품판매자</th>
				<th style="width: 10%">구매상품</th>
				<th style="width: 10%">발행일</th>
				<th style="width: 10%">사용일</th>
				<th style="width: 10%">정산유무</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="couponHistory" items="${couponHistory }">
			<tr>
				<td>${couponHistory.memberId }</td>
				<td>${couponHistory.couponPrice }원</td>
				<td>${couponHistory.sellerId }</td>
				<td>${couponHistory.itemName }</td>
				<td>${couponHistory.couponIssuedDate }</td>
				<td>${couponHistory.couponUseDate }</td>
				<td>${couponHistory.settled }</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	
	<br>
	<ul>
			<!-- 이전 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isPrev() }">
				<li class="pagination_button"><a href="financialManagement?&pageNum=${pageMaker.startNum - 1}" class="button">이전</a></li>
			</c:if>
			<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
			<c:forEach begin="${pageMaker.startNum }"
				end="${pageMaker.endNum }" var="num">
				<li class="pagination_button"><a href="financialManagement?&pageNum=${num }" class="button">${num }</a></li>
			</c:forEach>
			<!-- 다음 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isNext() }">
				<li class="pagination_button"><a href="financialManagement?&pageNum=${pageMaker.endNum + 1}" class="button">다음</a></li>
			</c:if>
		</ul>
	</div>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		selltedInfo();
		
		function selltedInfo(){
			
			// 서버에서 전달받은 String 데이터를 처리
		    var selltedList = '${selltedList}';
		    let parts = selltedList.split("CouponHistoryVO");
		    let cleanedList = parts.map(item => item.replace(/[\[\]()]/g, '').trim());
		    let list = [];
		    let settled = [];
		    let couponPrice = [];
		    let sellerId = [];
		    cleanedList.forEach(function(selltedList){
		    	parts = selltedList.split(",").map(item => item.trim());
		    	list.push(parts);
		    })
		    
		    console.log(list[1]);
		    console.log(list[1][6]);
		    console.log(list[1][7]);
		    console.log(list[1][9]);
		    
		    for(let i=1; i < list.length; i++){
		    	
		    settled.push(list[i][6].split("=")[1]);
		    sellerId.push(list[i][7].split("=")[1]);
		    couponPrice.push(list[i][9].split("=")[1]);
		    }
		    
		    console.log("settled : " + settled);
		    console.log("couponPrice : " + couponPrice);
		    console.log("sellerId : " + sellerId);
		    
		    
		}
		
	})
	
	</script>
	
</body>
</html>