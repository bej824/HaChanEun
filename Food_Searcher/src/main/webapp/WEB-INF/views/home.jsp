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

.item-container {
        display: flex;
        flex-wrap: wrap;  /* 아이템들이 여러 줄로 자동 배치되게 */
        gap: 20px;        /* 아이템 간의 간격 */
        
    }

.item .image_item {
    display: none;
}

.item .image_item:first-child {
    display: block;
}

</style>

<title>Home</title>
</head>
<body>
	<%@ include file ="header.jsp" %>
	<div id="container">
   		<div id="area">
	
	<br>
	
	<a href="recipe/list?type=CATEGORY&keyword=한식" class="button">한식</a>
	
	<div class="item-container">
		<c:forEach var="RecipeVO" items="${koreanList }">
			<div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
			<c:set var="imageFound" value="false"/>
			<c:forEach var="attachVO" items="${attachVO}">
				<c:if test="${RecipeVO.recipeId eq attachVO.boardId }">
				<div class="image_item">
						<img width="150px" height="150px" 
					        src="image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" 
					        onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
					</div>
					<c:set var="imageFound" value="true"/>
				</c:if>
			</c:forEach>
			<c:if test="${!imageFound}">
	            <div class="image_item">
	                <img width="150px" height="150px" 
	                     src="resources/image/imageReady.png"/>
	            </div>
	        </c:if>
				<p>제목 : ${RecipeVO.recipeTitle }</p>
				<p>음식명 : ${RecipeVO.recipeFood }</p>
				<p>조회수 : ${RecipeVO.viewCount }</p>
			</div>
		</c:forEach>
	</div>

	<a href="recipe/list?type=CATEGORY&keyword=중식" class="button">중식</a>
	
	<div class="item-container">
		<c:forEach var="RecipeVO" items="${chinaList }">
			<div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
			<c:set var="imageFound" value="false"/>
			<c:forEach var="attachVO" items="${attachVO}">
				<c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
				<div class="image_item">
						<img width="150px" height="150px" 
					        src="image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" 
					        onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
					</div>
					<c:set var="imageFound" value="true"/>
				</c:if>
			</c:forEach>
			<c:if test="${!imageFound}">
	            <div class="image_item">
	                <img width="150px" height="150px" 
	                     src="resources/image/imageReady.png"/>
	            </div>
	        </c:if>
				<p>제목 : ${RecipeVO.recipeTitle }</p>
				<p>음식명 : ${RecipeVO.recipeFood }</p>
				<p>조회수 : ${RecipeVO.viewCount }</p>
			</div>
		</c:forEach>
	</div>
	
	<a href="recipe/list?type=CATEGORY&keyword=일식" class="button">일식</a>
	
	<div class="item-container">
		<c:forEach var="RecipeVO" items="${japanList }">
			<div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
			<c:set var="imageFound" value="false"/>
			<c:forEach var="attachVO" items="${attachVO}">
				<c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
				<div class="image_item">
						<img width="150px" height="150px" 
					        src="image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" 
					        onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
					</div>
					<c:set var="imageFound" value="true"/>
				</c:if>
			</c:forEach>
			<c:if test="${!imageFound}">
	            <div class="image_item">
	                <img width="150px" height="150px" 
	                     src="resources/image/imageReady.png"/>
	            </div>
	        </c:if>
				<p>제목 : ${RecipeVO.recipeTitle }</p>
				<p>음식명 : ${RecipeVO.recipeFood }</p>
				<p>조회수 : ${RecipeVO.viewCount }</p>
			</div>
		</c:forEach>
	</div>
	
	<a href="recipe/list?type=CATEGORY&keyword=동남아식" class="button">동남아식</a>
	
	<div class="item-container">
		<c:forEach var="RecipeVO" items="${SoutheastList }">
			<div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
			<c:set var="imageFound" value="false"/>
			<c:forEach var="attachVO" items="${attachVO}">
				<c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
				<div class="image_item">
						<img width="150px" height="150px" 
					        src="image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" 
					        onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
					</div>
					<c:set var="imageFound" value="true"/>
				</c:if>
			</c:forEach>
			<c:if test="${!imageFound}">
	            <div class="image_item">
	                <img width="150px" height="150px" 
	                     src="resources/image/imageReady.png"/>
	            </div>
	        </c:if>
				<p>제목 : ${RecipeVO.recipeTitle }</p>
				<p>음식명 : ${RecipeVO.recipeFood }</p>
				<p>조회수 : ${RecipeVO.viewCount }</p>
			</div>
		</c:forEach>
	</div>
	
	<a href="recipe/list?type=CATEGORY&keyword=양식" class="button">양식</a>
	
	<div class="item-container">
		<c:forEach var="RecipeVO" items="${westernList }">
			<div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
			<c:set var="imageFound" value="false"/>
			<c:forEach var="attachVO" items="${attachVO}">
				<c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
				<div class="image_item">
						<img width="150px" height="150px" 
					        src="image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" 
					        onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
					</div>
					<c:set var="imageFound" value="true"/>
				</c:if>
			</c:forEach>
			<c:if test="${!imageFound}">
	            <div class="image_item">
	                <img width="150px" height="150px" 
	                     src="resources/image/imageReady.png"/>
	            </div>
	        </c:if>
				<p>제목 : ${RecipeVO.recipeTitle }</p>
				<p>음식명 : ${RecipeVO.recipeFood }</p>
				<p>조회수 : ${RecipeVO.viewCount }</p>
			</div>
		</c:forEach>
	</div>
	
	</div>
	</div>
</body>
</html>
