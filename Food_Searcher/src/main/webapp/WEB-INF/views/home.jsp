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

<title>Home</title>
</head>
<body>
	<%@ include file ="header.jsp" %>
	<div id="container">
   		<div id="area">
	<a href="./product/reviewRegister?itemId=47">리뷰 작성 테스트</a>
	<c:if test="${session.memberId != null}">	
		<p>${session.memberId }님 환영합니다.</p>
	
	</c:if>
	<br>
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
	</table>
	
	</div>
	</div>
</body>
</html>
