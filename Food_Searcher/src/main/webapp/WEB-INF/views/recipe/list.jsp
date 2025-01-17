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

.search {
	margin-left: 335px;
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
	<h1>요리 레시피 공유</h1>
	<!-- 글 작성 페이지 이동 버튼 -->
	    <a href="register" class="button">글 작성</a>
	<hr>
	<table>
		<thead>
			<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 600px">제목</th>
				<th style="width: 100px">음식</th>
				<th style="width: 120px">작성자</th>
				<th style="width: 100px">작성일</th>
				<th style="width: 50px">댓글수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeVO" items="${recipeList }">
				<tr onclick="window.location.href='detail?recipeId=${RecipeVO.recipeId }&recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${param.pageNum == num ? '1' : param.pageNum}'" class="detail_button">
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
        <li class="pagination_button"><a href="list?recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${pageMaker.startNum - 1}" class="button">이전</a></li>
    </c:if>

    <!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
    <c:if test="${not empty pageMaker.startNum and pageMaker.startNum > 0}">
        <c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }" var="num">
            <li class="pagination_button"><a href="list?recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${num}" class="button ${param.pageNum == num ? 'selected' : ''}" onclick="changeColor(this, ${num})">${num}</a></li>
        </c:forEach>
    </c:if>

    <!-- 다음 버튼 생성을 위한 조건문 -->
    <c:if test="${pageMaker.isNext() }">
        <li class="pagination_button"><a href="list?recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${pageMaker.endNum + 1}" class="button">다음</a></li>
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

	<script type="text/javascript">
		$(document).ready(function(){
			$("#searchForm button").on("click", function(e){
				var searchForm = $("#searchForm");
				e.preventDefault(); // a 태그 이벤트 방지
				
				var keywordVal = searchForm.find("input[name='keyword']").val();
				console.log(keywordVal);
				if(keywordVal == '') {
					alert('검색 내용을 입력하세요.');
					return;
				}
				
				var pageNum = 1; // 검색 후 1페이지로 고정
				// 현재 페이지 사이즈값 저장
				var pageSize = "<c:out value='${pageMaker.pagination.pageSize }' />";
				 
				// 페이지 번호를 input name='pageNum' 값으로 적용
				searchForm.find("input[name='pageNum']").val(pageNum);
				// 선택된 옵션 값을 input name='pageSize' 값으로 적용
				searchForm.find("input[name='pageSize']").val(pageSize);
				searchForm.submit(); // form 전송
			}); // end on()
			
		}); // end document()
	</script>

</body>
</html>