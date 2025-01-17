<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
table {
	border-style: solid;
	border-radius: 4px;
	border-width: 1px;
	text-align: center;
}

th, td {
	border-style: outset;
	border-width: 1px;
	text-align: center;
}

ul {
	list-style-type: none;
	text-align: center;
}

li {
	display: inline-block;
}

.button {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
}

.button:hover {
	background-color: #45a049; /* 마우스를 올렸을 때의 배경색 */
	color: white; /* 글자색 */
}

 .button.selected {
        background-color: red;
        color: white;
    }

.button:active {
	background-color: darkgreen;
}

#search {
	margin-left: 335px;
}
</style>
<meta charset="UTF-8">
<title>전통시장 리스트</title>
<script src="https://code.jquery.com/jquery-3.7.1.js">
	
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<h1>전통 시장 리스트</h1>
	
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	<button type="button" style="display: none;">글 작성</button>
	</sec:authorize>
	
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	<a href="/searcher/market/register" class="button">글 작성</a>
	</sec:authorize>
	
	

	<hr>
	<table>
		<thead>
			<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 700px">제목</th>
				<th style="width: 120px">지역</th>
				<th style="width: 60px">댓글수</th>
			</tr>
		</thead>

		<tbody>
			<c:forEach var="MarketVO" items="${marketList}">
				<tr onclick="location.href='detail?marketId=${MarketVO.marketId }'">
					<td>${MarketVO.marketId }</td>
					<td>${MarketVO.marketTitle }</td>
					<td>${MarketVO.marketLocal }</td>
					<td>${MarketVO.marketReplyCount	}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>



	<ul>
		<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
			<li><a href="list?pageNum=${pageMaker.startNum - 1}"
				class="button">이전</a></li>
		</c:if>

		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }"
			var="num">
			<li><a href="list?pageNum=${num }" class="button ${param.pageNum == num ? 'selected' : ''}" onclick="changeColor(this, ${num})">${num}</a></li>
		</c:forEach>

		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li><a href="list?pageNum=${pageMaker.endNum + 1}"
				class="button">다음</a></li>
		</c:if>

	</ul>

	<form id="searchForm" method="GET" action="list" class="search">
		<input type="text" name="" placeholder="검색어 입력" required> <select
			name="filterBy">
			<option value="제목">제목</option>
			<option value="내용">내용</option>
			<option value="지역">지역</option>
		</select>
		<button type="submit" class="button">검색</button>

	</form>
	
	<!-- 게시글 번호, 페이지 번호, 페이지 사이즈를 전송하는 form  -->
		<form id="detailForm" action="detail" method="get">
			<input type="hidden" name="boardId" >
			<input type="hidden" name="pageNum" >
	    	<input type="hidden" name="pageSize" >
	    	<input type="hidden" name="type" >
			<input type="hidden" name="keyword" >
		</form>
		






	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});	  
	
	function changeColor(button, pageNum) {
	    // 현재 URL의 쿼리 파라미터를 가져옵니다.
	    const url = new URL(window.location.href);

	    // 페이지 번호를 쿼리 파라미터로 설정
	    url.searchParams.set('pageNum', pageNum);

	    // 'recipeTitle'과 'filterBy' 파라미터는 기존 URL에서 가져옵니다.
	    let marketTitle = new URLSearchParams(window.location.search).get('marketTitle');
	    let filterBy = new URLSearchParams(window.location.search).get('filterBy');
	    
	    // 'recipeTitle'과 'filterBy'가 없으면 빈 값으로 설정
	    if (marketTitle === null) {
	    	marketTitle = '';
	    }
	    if (filterBy === null) {
	        filterBy = '';
	    }

	    // 'recipeTitle'과 'filterBy'를 빈 값으로 설정
	    url.searchParams.set('marketTitle', marketTitle);
	    url.searchParams.set('filterBy', filterBy);

	    // URL 업데이트
	    window.history.pushState({}, '', url);  // URL을 업데이트

	    // 모든 버튼에서 'selected' 클래스를 제거
	    let buttons = document.querySelectorAll('.button');
	    buttons.forEach(function(btn) {
	        btn.classList.remove('selected');
	    });

	    // 클릭된 버튼에 'selected' 클래스를 추가
	    button.classList.add('selected');
	} // end changeColor
	
	
	</script>
</body>
</html>