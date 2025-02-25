<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<html>
<head>
<style type="text/css">
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
  text-color: white;
  padding: 6px 12px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
}

</style>

<link rel="stylesheet"
	href="./resources/css/Base.css">
<title>Home</title>
</head>
<body>
	<%@ include file ="header.jsp" %>
	<div id="container">
   		<div id="area">

	<c:if test="${session.memberId != null}">	
		<p>${session.memberId }님 환영합니다.</p>
	
	</c:if>

	<a href="recipe/list" class="button">레시피 공유</a>
	<table border="1">
	<thead>
		<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 600px">제목</th>
				<th style="width: 120px">음식</th>
				<th style="width: 40px">댓글수</th>
		</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeVO" items="${recipeList }">
				<tr onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }'">
					<td>${RecipeVO.recipeId }</td>
					<td>${RecipeVO.recipeTitle }</td>
					<td>${RecipeVO.recipeFood }</td>
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
			<th style="width: 600px">제목</th>
			<th style="width: 120px">지역</th>
			<th style="width: 40px">댓글 수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="MarketVO" items="${marketList }">
			<tr onclick="window.location.href='market/detail?marketId=${MarketVO.marketId}'">
			<td>${MarketVO.marketId }</td>
			<td>${MarketVO.marketTitle }</td>
			<td>${MarketVO.marketLocal }</td>
			<td>${MarketVO.marketReplyCount }</td>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	<br>
		
	<a href="local/list" class="button">특산품</a>
	<table border="1">
	<thead>
		<tr>
			<th style="width: 60px">번호</th>
			<th style="width: 600px">특산품</th>
			<th style="width: 120px">지역</th>
			<th style="width: 40px">댓글수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="localSpecialityVO" items="${localList }">
			<tr onclick="window.location.href='local/detail?localId=${localSpecialityVO.localId }'">
			<td>${localSpecialityVO.localId }</td>
			<td>${localSpecialityVO.localTitle }</td>
			<td>${localSpecialityVO.localLocal} ${localSpecialityVO.localDistrict }</td>
			<td>${localSpecialityVO.replyCount }</td>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	
	</div>
	</div>
</body>
</html>
