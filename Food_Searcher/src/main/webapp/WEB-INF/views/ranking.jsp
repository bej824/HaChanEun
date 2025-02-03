<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file ="header.jsp" %>
	
	<form id="searchForm" method="GET" action="rank" class="search">
	    <select name="subject">
	        <option value="MEMBER_AGE">나이</option>
	        <option value="MEMBER_GENDER">성별</option>
	        <option value="MEMBER_MBTI">MBTI</option>
	        <option value="MEMBER_CONSTELLATION">별자리</option>
	    </select>
	    <button type="submit" class="button">검색</button>
	</form>
	
	
	<table border="1">
	<thead>
		<tr>
				<th style="width: 100px">게시글 번호</th>
				<th style="width: 600px">좋아요 수</th>
				<th style="width: 100px">검색항목</th>
		</tr>
		</thead>
		<tbody>
			<c:forEach var="RecipeLikesVO" items="${likeList }">
				<tr onclick="window.location.href='recipe/detail?recipeId=${RecipeLikesVO.recipeBoardId }'">
					<td>${RecipeLikesVO.recipeBoardId }</td>
					<td></td>
					<td></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>