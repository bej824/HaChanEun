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
	<%@ include file ="header.jsp" %>
	<h1>Hello world!</h1>

	<P>The time on the server is ${serverTime}.</P>
	
	<%
	HttpSession session = request.getSession();
	if(session.getAttribute("memberId") != null){ %>	
		<p><%=session.getAttribute("memberId") %>님 환영합니다.</p>
	
	<% } %>
	
	<a href="recipe/list" class="button">레시피 공유</a>
	<a href="local/map" class="button">특산품</a>
	<table border="1">
	<thead>
		<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 700px">제목</th>
				<th style="width: 60px">음식</th>
				<th style="width: 120px">작성자</th>
				<th style="width: 100px">작성일</th>
				<th style="width: 40px">댓글수</th>
		</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeVO" items="${recipeList }">
				<tr>
					<td>${RecipeVO.recipeId }</td>
					<td><a href="recipe/detail?recipeId=${RecipeVO.recipeId }">
							${RecipeVO.recipeTitle }</a></td>
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
	<table border="1">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>음식명</th>
			<th>작성일</th>
			<th>댓글 수</th>
			<th>이미지</th>
		</tr>
	</table>
	<br>
	
	<%if(session.getAttribute("memberId") != null){ %>
	<a href="access/memberPage">멤버페이지</a> <br>
	<a href="logout">로그아웃</a>
	<%} else { %>	
	<a href="access/login">로그인</a> / 
	<a href="access/register">회원가입</a>
	<%} %>
	
	미친짓이네?
</body>
</html>
