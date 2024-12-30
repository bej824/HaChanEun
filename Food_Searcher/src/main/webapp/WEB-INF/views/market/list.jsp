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

.search {
	margin-left: 335px;
}

</style>
<meta charset="UTF-8">
<title>전통시장 리스트</title>
<script src="https://code.jquery.com/jquery-3.7.1.js">
</script>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
	<h1>전통 시장 리스트</h1>
	
	<%
	if(session.getAttribute("memberId") == null){ %>
		<button type="button" style="display : none;">글 작성</button>
	<%} %>
	<% if("admin1".equals(session.getAttribute("memberId"))){ %>
		<a href="/searcher/market/register" class="button">글 작성</a>
	<%} %>

	
	<hr>	
	<table>
		<thead>
			<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 700px">제목</th>
			</tr>
		</thead>
		
		<tbody>
			<c:forEach var="MarketVO" items="${marketList}">
				<tr onclick="location.href='detail?marketId=${MarketVO.marketId }'">
					<td>${MarketVO.marketId }</td>
					<td><a href="detail?marketId=${MarketVO.marketId}">
					${MarketVO.marketTitle }</a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
	
	
	<ul>
		<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
			<li><a href="list?pageNum=${pageMaker.startNum - 1}">이전</a></li>
		</c:if>
		
		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }"
			end="${pageMaker.endNum }" var="num">
			<li><a href="list?pageNum=${num }">${num }</a></li>
		</c:forEach>
		
		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li><a href="list?pageNum=${pageMaker.endNum + 1}">다음</a></li>
		</c:if>
		
	</ul>
</body>
</html>