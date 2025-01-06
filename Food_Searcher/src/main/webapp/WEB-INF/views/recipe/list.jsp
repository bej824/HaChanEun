<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>
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

.search {
	margin-left: 335px;
}
</style>
<meta charset="UTF-8">
<title>레시피 공유 게시판</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<h1>요리 레시피 공유</h1>
	<!-- 글 작성 페이지 이동 버튼 -->
	<%if(session.getAttribute("memberId") == null){ %>
		<a href="/searcher/access/login?redirect=${pageContext.request.requestURI}" class="button">글 작성</a>
	<%} %>
	<%if(session.getAttribute("memberId") != null){ %>
		<a href="register" class="button">글 작성</a>
	<%} %>
	<hr>
	<table>
		<thead>
			<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 670px">제목</th>
				<th style="width: 90px">음식</th>
				<th style="width: 120px">작성자</th>
				<th style="width: 100px">작성일</th>
				<th style="width: 50px">댓글수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeVO" items="${recipeList }">
				<tr onclick="window.location.href='detail?recipeId=${RecipeVO.recipeId }'">
					<td>${RecipeVO.recipeId }</td>
					<td>${RecipeVO.recipeTitle }</td>
					<td>${RecipeVO.recipeFood }</td>
					<td>${RecipeVO.memberId }</td>
					<!-- boardDateCreated 데이터 포멧 변경 -->
					<fmt:formatDate value="${RecipeVO.recipeDateCreated }"
						pattern="yyyy-MM-dd" var="recipeDateCreated" />
					<td>${recipeDateCreated }</td>
					<td>${RecipeVO.replyCount }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
	<form id="searchForm" method="GET" action="list" class="search">
	    <input type="text" name="recipeTitle" placeholder="검색어 입력" required>
	    <select name="filterBy">
	        <option value="RECIPE_TITLE">제목</option>
	        <option value="RECIPE_FOOD">음식</option>
	        <option value="RECIPE_CONTENT">내용</option>
	        <option value="MEMBER_ID">작성자</option>
	    </select>
	    <button type="submit" class="button">검색</button>
	</form>
<ul>
    <!-- 이전 버튼 생성을 위한 조건문 -->
    <c:if test="${pageMaker.isPrev() }">
        <li><a href="list?recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${pageMaker.startNum - 1}" class="button">이전</a></li>
    </c:if>

    <!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
    <c:if test="${not empty pageMaker.startNum }">
        <c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }" var="num">
            <li><a href="list?recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${num}" class="button ${param.pageNum == num ? 'selected' : ''}" onclick="changeColor(this, ${num})">${num}</a></li>
        </c:forEach>
    </c:if>

    <!-- 다음 버튼 생성을 위한 조건문 -->
    <c:if test="${pageMaker.isNext() }">
        <li><a href="list?recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${pageMaker.endNum + 1}" class="button">다음</a></li>
    </c:if>
</ul>

<script>
function changeColor(button, pageNum) {
    // 현재 URL의 쿼리 파라미터를 가져옵니다.
    const url = new URL(window.location.href);

    // 페이지 번호를 쿼리 파라미터로 설정
    url.searchParams.set('pageNum', pageNum);

    // 'recipeTitle'과 'filterBy' 파라미터는 기존 URL에서 가져옵니다.
    let recipeTitle = new URLSearchParams(window.location.search).get('recipeTitle');
    let filterBy = new URLSearchParams(window.location.search).get('filterBy');
    
    // 'recipeTitle'과 'filterBy'가 없으면 빈 값으로 설정
    if (recipeTitle === null) {
        recipeTitle = '';
    }
    if (filterBy === null) {
        filterBy = '';
    }

    // 'recipeTitle'과 'filterBy'를 빈 값으로 설정
    url.searchParams.set('recipeTitle', recipeTitle);
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
}
</script>


</body>
</html>