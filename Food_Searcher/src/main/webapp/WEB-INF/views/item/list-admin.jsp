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

<h1>전체 상품 리스트</h1>

<sec:authorize access="hasRole('ROLE_ADMIN')">
<a href="/searcher/item/register" class="button">상품 등록</a>  
</sec:authorize>

<sec:authorize access="hasRole('ROLE_MEMBER')">
<a id="cartLink" href="../cart/list/<sec:authentication property="name" />">장바구니로 이동</a>
</sec:authorize>
<br><br>

<hr>
	<div class="item-container">
			<c:forEach var="itemVO" items="${itemList}">
			<div class="item" onclick="window.location.href='detail?itemId=${itemVO.itemId}'">
					<input type="hidden" value="${itemVO.itemStatus }" >
					<div>썸네일 삽입 예정</div><br>
					<p>상품명 : ${itemVO.itemName }</p>
					<p>상품번호 : ${itemVO.itemId }</p>
					<p>분류 : ${itemVO.itemTag }</p>
					<p>가격 : <fmt:formatNumber value="${itemVO.itemPrice}" pattern="###,###,###"/>원
							&nbsp;&nbsp;&nbsp; 상태 : ${itemVO.itemStatus }</p>
					
			</div>
			</c:forEach>
	</div>
	<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
	<input type="hidden" value="${itemVO.itemStatus }" >
	
		
	<form id="listForm" action="list-admin" method="get">
	    	<input type="hidden" name="pageNum" >
	    </form>
	
	<ul>
			<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
			<li class="pagination_button"><a href="${pageMaker.startNum - 1}"
				class="button">이전</a></li>
		</c:if>

		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }"
			var="num">
			<li class="pagination_button ${param.pageNum == num ? 'selected' : ''}"
               onclick="changeColor(this, ${num}); return isNumber(${num})"></li>
               <a href="list-admin?keyword=${param.keyword}&type=${param.type}&pageNum=${num}" class="button">${num}</a>
		</c:forEach>

		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li class="pagination_button"><a href="${pageMaker.endNum + 1}"
				class="button">다음</a></li>
		</c:if>
	</ul>
	
	<%@ include file="relation.jsp"%>
	
<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	// pagination_button을 클릭하면 페이지 이동
	$(".pagination_button a").on("click", function(e){
		var listForm = $("#listForm"); // form 객체 참조
		e.preventDefault(); // a 태그 이벤트 방지
	
		var pageNum = $(this).attr("href"); // a태그의 href 값 저장
		// 현재 페이지 사이즈값 저장
		 
		// 페이지 번호를 input name='pageNum' 값으로 적용
		listForm.find("input[name='pageNum']").val(pageNum);
		
		// ⭐ 모든 버튼에서 'selected' 클래스를 제거 후 현재 버튼에 추가
        $(".pagination_button").removeClass("selected");
        $(this).parent().addClass("selected");

        // URL을 새로 업데이트
        const url = new URL(window.location.href);
        url.searchParams.set("pageNum", pageNum);
        window.history.pushState({}, '', url); 
		
		listForm.submit(); // form 전송
	}); // end on()
	
	
</script>	
</div> <!-- area -->
</body>
</html>