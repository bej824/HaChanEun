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
<link rel="stylesheet"
	href="../resources/css/Base.css">
	
<meta charset="UTF-8">
<title>전통시장 리스트</title>
<script src="https://code.jquery.com/jquery-3.7.1.js">
	
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	
	<div id="area">
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
			<tr>
					<td>${MarketVO.marketId }</td>
					<td class="detail_button"><a href="${MarketVO.marketId }"><span><c:out value="${MarketVO.marketTitle }" /></span></a></td>
					<td>${MarketVO.marketLocal }</td>
					<td>${MarketVO.marketReplyCount	}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
	
	<form id="searchForm" method="get" action="list">
		<input type="hidden" name="pageNum">
		<select name="type">
			<option value="MARKET_TITLE">제목</option>
			<option value="MARKET_CONTENT">내용</option>
			<option value="MARKET_LOCAL">지역</option>
		</select>
		<input type="text" name="keyword">
		<button> 검색 </button>

	</form>
	
		<!-- 게시글 번호, 페이지 번호, 페이지 사이즈를 전송하는 form  -->
	    <form id="detailForm" action="detail" method="get">
			<input type="hidden" name="marketId" >
			<input type="hidden" name="pageNum" >
	    	<input type="hidden" name="type" >
			<input type="hidden" name="keyword" >
		</form>
		

	<ul>
		<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
			<li><a href="list?pageNum=${pageMaker.startNum - 1}"
				class="button">이전</a></li>
		</c:if>

		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }"
			var="num">
			<li class="pagination_button"><a href="${num }" class="button">${num }</a></li>
		</c:forEach>

		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li><a href="list?pageNum=${pageMaker.endNum + 1}"
				class="button">다음</a></li>
		</c:if>

	</ul>

		<!-- 페이지 번호와 페이지 사이즈를 전송하는 form -->
		<form id="listForm" action="list" method="get">
	    	<input type="hidden" name="pageNum" >
	    	<input type="hidden" name="type" >
			<input type="hidden" name="keyword">
	    </form>
	    
		
	    		
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});	  
	
	$(document).ready(function(){
		
		// pagination_button을 클릭하면 페이지 이동
		$(".pagination_button a").on("click", function(e){
			var listForm = $("#listForm"); // form 객체 참조
			e.preventDefault(); // a 태그 이벤트 방지
		
			var pageNum = $(this).attr("href"); // a태그의 href 값 저장
			// 현재 페이지 사이즈값 저장
			var type = "<c:out value='${pageMaker.pagination.type }' />";
			var keyword = "<c:out value='${pageMaker.pagination.keyword }' />";
			 
			// 페이지 번호를 input name='pageNum' 값으로 적용
			listForm.find("input[name='pageNum']").val(pageNum);
			// type 값을 적용
			listForm.find("input[name='type']").val(type);
			// keyword 값을 적용
			listForm.find("input[name='keyword']").val(keyword);
			listForm.submit(); // form 전송
		}); // end on()
		
		// detail_button을 클릭하면 페이지 이동
		$(".detail_button a").on("click", function(e){
			var detailForm = $("#detailForm");
			e.preventDefault(); // a 태그 이벤트 방지
		
			var marketId = $(this).attr("href"); // a태그의 href 값 저장

			var type = "<c:out value='${pageMaker.pagination.type }' />";
			var keyword = "<c:out value='${pageMaker.pagination.keyword }' />";
			var pageNum = "<c:out value='${pageMaker.pagination.pageNum }' />";
			
			// 클릭된 게시글 번호를 input name='marketId' 값으로 적용
			detailForm.find("input[name='marketId']").val(marketId);
			// 페이지 번호를 input name='pageNum' 값으로 적용
			detailForm.find("input[name='pageNum']").val(pageNum);
			// type 값을 적용
			detailForm.find("input[name='type']").val(type);
			// keyword 값을 적용
			detailForm.find("input[name='keyword']").val(keyword);
			detailForm.submit(); // form 전송
		}); // end on()
		
		$("#searchForm button").on("click", function(e){
			var searchForm = $("#searchForm");
			e.preventDefault(); // a 태그 이벤트 방지
			
			var keywordVal = searchForm.find("input[name='keyword']").val();  // 사용자가 입력한 키워드 저장
			console.log(keywordVal);
			if(keywordVal == '') {
				alert('검색 내용을 입력하세요.');
				return;
			}
			
			var pageNum = 1; // 검색 후 1페이지로 고정
			// 현재 페이지 사이즈값 저장
			 
			// 페이지 번호를 input name='pageNum' 값으로 적용
			searchForm.find("input[name='pageNum']").val(pageNum);
			searchForm.submit(); // form 전송
		}); // end on()
		
	}); // end document()
	
	
	</script>
	</div>
</body>
</html>