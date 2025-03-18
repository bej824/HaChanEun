<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.search {
	margin-left: 750px;
}
</style>
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
</script>
<meta charset="UTF-8">
<title>레시피 공유 게시판</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<%@ include file ="../layout/side.jsp" %>
	<div id="area">
	<h1>요리 레시피 공유</h1>
	<!-- 글 작성 페이지 이동 버튼 -->
	    <a href="register" class="button">글 작성</a>
	<hr>
	<table>
		<thead>
			<tr>
				<th style="width: 5%">번호</th>
				<th style="width: 40%">제목</th>
				<th style="width: 10%">음식</th>
				<th style="width: 10%">카테고리</th>
				<th style="width: 12%">작성자</th>
				<th style="width: 10%">작성일</th>
				<th style="width: 5%">댓글수</th>
				<th style="width: 5%">조회수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeVO" items="${recipeList }">
				<tr onclick="window.location.href='detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'" class="detail_button">
					<td>${RecipeVO.recipeId }</td>
					<td style="text-align: left;">${RecipeVO.recipeTitle }</td>
					<td>${RecipeVO.recipeFood }</td>
					<td>${RecipeVO.category }</td>
					<td>${RecipeVO.memberId }</td>
					<!-- boardDateCreated 데이터 포멧 변경 -->
					<fmt:formatDate value="${RecipeVO.recipeDateCreated }"
						pattern="yyyy-MM-dd" var="recipeDateCreated" />
					<td>${recipeDateCreated }</td>
					<td style="text-align: right;">${RecipeVO.replyCount }</td>
					<td style="text-align: right;">${RecipeVO.viewCount }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
	<form id="searchForm" method="GET" action="list" class="search">
	    <input type="text" name="keyword" placeholder="검색어 입력" required>
	    <select name="type">
	        <option value="RECIPE_TITLE">제목</option>
	        <option value="RECIPE_FOOD">음식</option>
	        <option value="CATEGORY">카테고리</option>
	        <option value="INGREDIENT">재료</option>
	        <option value="RECIPE_CONTENT">내용</option>
	        <option value="MEMBER_ID">작성자</option>
	    </select>
	    <button type="submit" class="button">검색</button>
	</form>
	
		<!-- 게시글 번호, 페이지 번호, 페이지 사이즈를 전송하는 form  -->
		<form id="detailForm" action="detail" method="get">
			<input type="hidden" name="recipeId" >
			<input type="hidden" name="pageNum" >
	    	<input type="hidden" name="pageSize" >
	    	<input type="hidden" name="type" >
			<input type="hidden" name="keyword" >
		</form>
		
		<!-- 페이지 번호와 페이지 사이즈를 전송하는 form -->
		<form id="listForm" action="list" method="get">
	    	<input type="hidden" name="pageNum" >
	    	<input type="hidden" name="pageSize" >
	    	<input type="hidden" name="type">
			<input type="hidden" name="keyword">
	    </form>
	<ul>
		<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
		    <li class="pagination_button">
		        <a href="list?keyword=${param.keyword}&type=${param.type}&pageNum=${pageMaker.startNum - 1}" class="button">이전</a>
		    </li>
		</c:if>
		
		<c:set var="pageNum" value="${param.pageNum != null && param.pageNum > 0 ? param.pageNum : 1}" />
		<!-- 페이지 번호 생성 (시작 번호부터 끝 번호까지) -->
		<c:if test="${not empty pageMaker.startNum and pageMaker.startNum > 0}">
		    <c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }" var="num">
		        <li class="pagination_button">
		            <a href="list?keyword=${param.keyword}&type=${param.type}&pageNum=${num}" 
		               class="button ${param.pageNum == num ? 'selected' : ''}"
		               onclick="changeColor(this, ${num}); return isNumber(${num})">${num}</a>
		        </li>
		    </c:forEach>
		</c:if>
		
		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
		    <li class="pagination_button">
		        <a href="list?keyword=${param.keyword}&type=${param.type}&pageNum=${pageMaker.endNum + 1}" class="button">다음</a>
		    </li>
		</c:if>
	</ul>

	<script>
	function changeColor(button, pageNum) {
	    // 현재 URL의 쿼리 파라미터를 가져옵니다.
	    const url = new URL(window.location.href);
	
	    // 페이지 번호를 쿼리 파라미터로 설정
	    url.searchParams.set('pageNum', pageNum);
	
	    // 'recipeTitle'과 'filterBy' 파라미터는 기존 URL에서 가져옵니다.
	    let keyword = new URLSearchParams(window.location.search).get('keyword');
	    let type = new URLSearchParams(window.location.search).get('type');
	    
	    // 'recipeTitle'과 'filterBy'가 없으면 빈 값으로 설정
	    if (keyword === null) {
	    	keyword = '';
	    }
	    if (type === null) {
	    	type = '';
	    }
	
	    // 'recipeTitle'과 'filterBy'를 빈 값으로 설정
	    url.searchParams.set('keyword', keyword);
	    url.searchParams.set('type', type);
	
	    // URL 업데이트
	    window.history.pushState({}, '', url);  // URL을 업데이트
	
	    // 모든 버튼에서 'selected' 클래스를 제거
	    let buttons = document.querySelectorAll('.button');
	    buttons.forEach(function(btn) {
	        btn.classList.remove('selected');
	    });
	
	    // 클릭된 버튼에 'selected' 클래스를 추가
	    button.classList.add('selected');
	}
	
	function isNumber(value) {
	    if (isNaN(value) || value <= 0) {
	      alert('숫자만 입력 가능합니다.');
	      return false;  // 링크 이동을 막음
	    }
	    return true;  // 숫자일 경우 링크 이동
	  }
	</script>
	
	<script type="text/javascript">
		window.onload = function() {
		    // 새로고침이 감지된 경우
		    if (sessionStorage.getItem("reloaded")) {
		
		        // URL에서 검색어 제거
		        window.history.replaceState({}, document.title, window.location.pathname);
		
		        // 새로고침 플래그 삭제
		        sessionStorage.removeItem("reloaded");
		    }
		};
		
		function insertSpeciality(){
			console.log("insertSpeciality()");
			window.location.href = 'register';
		}
	</script>
</div>
</body>
</html>