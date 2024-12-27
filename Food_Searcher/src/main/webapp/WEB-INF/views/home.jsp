<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
</style>
<title>Home</title>
</head>
<body>
	<%@ include file ="/WEB-INF/views/header.jsp" %>
	<h1>Hello world!</h1>

	<P>The time on the server is ${serverTime}.</P>
	
	<%
	
	if(session.getAttribute("memberId") != null){ %>	
		<p><%=session.getAttribute("memberId") %>님 환영합니다.</p>
	
	<% } %>

	
	<a href="recipe/list" class="button">레시피 공유</a>
	<table border="1">
	<thead>
		<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 600px">제목</th>
				<th style="width: 100px">음식</th>
				<th style="width: 120px">작성자</th>
				<th style="width: 100px">작성일</th>
				<th style="width: 40px">댓글수</th>
		</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeVO" items="${recipeList }">
				<tr onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }'">
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
	</table> <br>

	<a href="market/list" class="button">전통시장</a>
	<table border="1">
	<thead>
		<tr>
			<th style="width: 60px">번호</th>
			<th style="width: 700px">제목</th>
			<th style="width: 120px">지역</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="MarketVO" items="${marketList }">
			<tr onclick="window.location.href='market/detail?marketId=${MarketVO.marketId}'">
			<td>${MarketVO.marketId }</td>
			<td>${MarketVO.marketTitle }</td>
			<td>${MarketVO.marketLocal }</td>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	<br>
		
	<a href="local/map" class="button">특산품</a>
	
	
</body>
</html>
