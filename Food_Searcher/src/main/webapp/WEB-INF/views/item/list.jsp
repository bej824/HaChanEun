<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>
.item-container {
        display: flex;
        flex-wrap: wrap;  /* 아이템들이 여러 줄로 자동 배치되게 */
        gap: 20px;        /* 아이템 간의 간격 */
    }

.item {
	margin-top: 20px; /* 첨부 목록 위에 여백 추가 */
    background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
    margin-bottom: 20px; /* 첨부 목록 아래에 여백 추가 */
    height: 300px; /* 첨부 목록의 고정 높이 설정 */
    width: 250px;     /* 각 아이템의 너비 */
    box-sizing: border-box;
}

li {
	display:inline-block;
}

</style>

<link rel="stylesheet"
	href="../resources/css/Base.css">
<link rel="stylesheet"
	href="../resources/css/Detail.css">
	
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>상품 리스트</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div id="area">

<h1>상품 리스트</h1>

<sec:authorize access="hasRole('ROLE_MEMBER')">
<a id="cartLink" href="../cart/list/<sec:authentication property="name" />">장바구니로 이동</a>
</sec:authorize>
<br><br>
<a id="testLink" href="http://localhost:8080/searcher/cart/list/test1">테스트용 장바구니 이동</a>

<hr>
		<div class="item-container">
			<c:forEach var="itemVO" items="${itemList}">
			<div class="item" onclick="window.location.href='detail?itemId=${itemVO.itemId}'">
					<input type="hidden" value="${itemVO.itemStatus }" >
					<c:forEach var="attachVO" items="${attachVO}">
					<c:if test="${itemVO.itemId eq attachVO.itemId}">
					<div class="image_item">
					        <img width="100px" height="100px" 
					        src="../images/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" />
				        </div>
				        </c:if>
				        </c:forEach>
					<p>상품명 : ${itemVO.itemName }</p>
					<p>상품번호 : ${itemVO.itemId }</p>
					<p>분류 : ${itemVO.itemTag }</p>
					<p>가격 : <fmt:formatNumber value="${itemVO.itemPrice}" pattern="###,###,###"/>
							원 &nbsp;&nbsp;&nbsp; 상태 : ${itemVO.itemStatus }</p>
					
			</div>
			</c:forEach>
		</div>
	<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
	<input type="hidden" value="${itemVO.itemStatus }" >
	
	<ul>
			<!-- 이전 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isPrev() }">
				<li class="pagination_button"><a href="list?pageNum=${pageMaker.startNum - 1}">이전</a></li>
			</c:if>
			<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
			<c:forEach begin="${pageMaker.startNum }"
				end="${pageMaker.endNum }" var="num">
				<li class="pagination_button"><a href="list?pageNum=${num }">${num }</a></li>
			</c:forEach>
			<!-- 다음 버튼 생성을 위한 조건문 -->
			<c:if test="${pageMaker.isNext() }">
				<li class="pagination_button"><a href="list?pageNum=${pageMaker.endNum + 1}">다음</a></li>
			</c:if>
		</ul>
	
<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
</script>	
</div> <!-- area -->
</body>
</html>