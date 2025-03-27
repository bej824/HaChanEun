<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<html>
<head>

<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/Home.css">
<style type="text/css">


</style>

<title>Home</title>
</head>
<body>

<!-- 헤더 포함 -->
<%@ include file="header.jsp" %>

<div class="container">

    <!-- 세션 정보 출력 -->
    <c:if test="${session.memberId != null}">
        <p style="text-align:center; font-size: 18px; font-weight: bold;">${session.memberId}님 환영합니다.</p>
    </c:if>
    
    <!-- 카테고리 버튼 -->

    <!-- 레시피 목록 -->
<div class="itemContainer2">
    <div class="item-container">
        <c:forEach var="RecipeVO" items="${koreanList}">
            <div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
                <c:set var="imageFound" value="false"/>
                <c:forEach var="attachVO" items="${attachVO}">
                    <c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
                        <div class="image_item">
                            <img src="image/get?attachId=${attachVO.attachId}&attachChgName=${attachVO.attachChgName}" 
                                 onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
                        </div>
                        <c:set var="imageFound" value="true"/>
                    </c:if>
                </c:forEach>
                <c:if test="${!imageFound}">
                    <div class="image_item">
                        <img src="resources/image/imageReady.png"/>
                    </div>
                </c:if>
                <div class="titleDiv">
                    <p class="titleText">${RecipeVO.recipeTitle }</p>
                </div>
                <div class="infoDiv">
	                <p class="memberText">작성자| ${RecipeVO.memberId }</p>
	                <p class="viewsText">조회수 ${RecipeVO.viewCount }회</p>
                </div>
            </div>
        </c:forEach>
    </div>
    <a href="recipe/list?type=CATEGORY&keyword=한식" class="button-item">한식으로 이동》</a>
</div>

<div class="itemContainer2">
    <div class="item-container">
        <c:forEach var="RecipeVO" items="${chinaList }">
            <div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
            <c:set var="imageFound" value="false"/>
            <c:forEach var="attachVO" items="${attachVO}">
                <c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
                <div class="image_item">
                        <img 
                            src="image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" 
                            onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
                    </div>
                    <c:set var="imageFound" value="true"/>
                </c:if>
            </c:forEach>
            <c:if test="${!imageFound}">
                <div class="image_item">
                    <img 
                         src="resources/image/imageReady.png"/>
                </div>
            </c:if>
                <div class="titleDiv">
                    <p class="titleText">${RecipeVO.recipeTitle }</p>
                </div>
                <div class="infoDiv">
	                <p class="memberText">작성자| ${RecipeVO.memberId }</p>
	                <p class="viewsText">조회수 ${RecipeVO.viewCount }회</p>
                </div>
                </div>
        </c:forEach>
    </div>
    <a href="recipe/list?type=CATEGORY&keyword=중식" class="button-item">중식으로 이동》</a>
</div>

<div class="itemContainer2">
    <div class="item-container">
        <c:forEach var="RecipeVO" items="${japanList }">
            <div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
            <c:set var="imageFound" value="false"/>
            <c:forEach var="attachVO" items="${attachVO}">
                <c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
                <div class="image_item">
                        <img
                            src="image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" 
                            onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
                    </div>
                    <c:set var="imageFound" value="true"/>
                </c:if>
            </c:forEach>
            <c:if test="${!imageFound}">
                <div class="image_item">
                    <img
                         src="resources/image/imageReady.png"/>
                </div>
            </c:if>
                <div class="titleDiv">
                    <p class="titleText">${RecipeVO.recipeTitle }</p>
                </div>
                <div class="infoDiv">
	                <p class="memberText">작성자| ${RecipeVO.memberId }</p>
	                <p class="viewsText">조회수 ${RecipeVO.viewCount }회</p>
                </div>
                </div>
        </c:forEach>
    </div>
    <a href="recipe/list?type=CATEGORY&keyword=일식" class="button-item">일식으로 이동》</a>
</div>

<div class="itemContainer2">
    <div class="item-container">
        <c:forEach var="RecipeVO" items="${SoutheastList }">
            <div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
                <c:set var="imageFound" value="false"/>
                <c:forEach var="attachVO" items="${attachVO}">
                    <c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
                        <div class="image_item">
                            <img
                                src="image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" 
                                onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
                        </div>
                        <c:set var="imageFound" value="true"/>
                    </c:if>
                </c:forEach>
                <c:if test="${!imageFound}">
                    <div class="image_item">
                        <img src="resources/image/imageReady.png"/>
                    </div>
                </c:if>
                <div class="titleDiv">
                    <p class="titleText">${RecipeVO.recipeTitle }</p>
                </div>
                <div class="infoDiv">
	                <p class="memberText">작성자| ${RecipeVO.memberId }</p>
	                <p class="viewsText">조회수 ${RecipeVO.viewCount }회</p>
                </div>
                </div>
        </c:forEach>
    </div>
    <a href="recipe/list?type=CATEGORY&keyword=동남아식" class="button-item">동남아로 이동》</a>
</div>

<div class="itemContainer2">
    <div class="item-container">
        <c:forEach var="RecipeVO" items="${westernList }">
            <div class="item" onclick="window.location.href='recipe/detail?recipeId=${RecipeVO.recipeId }&keyword=${param.keyword}&type=${param.type}'">
                <c:set var="imageFound" value="false"/>
                <c:forEach var="attachVO" items="${attachVO}">
                    <c:if test="${RecipeVO.recipeId eq attachVO.boardId}">
                        <div class="image_item">
                            <img  
                                src="image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" 
                                onerror="this.onerror=null; this.src='resources/image/imageReady.png';"/>
                        </div>
                        <c:set var="imageFound" value="true"/>
                    </c:if>
                </c:forEach>
                <c:if test="${!imageFound}">
                    <div class="image_item">
                        <img src="resources/image/imageReady.png"/>
                    </div>
                </c:if>
	               <div class="titleDiv">
                    <p class="titleText">${RecipeVO.recipeTitle }</p>
                </div>
                <div class="infoDiv">
	                <p class="memberText">작성자| ${RecipeVO.memberId }</p>
	                <p class="viewsText">조회수 ${RecipeVO.viewCount }회</p>
                </div>
                </div>
        </c:forEach>
    </div>
    <a href="recipe/list?type=CATEGORY&keyword=양식" class="button-item">양식으로 이동》</a>
</div>

</div> <!-- container -->

	<sec:authorize access="isAuthenticated()">
	<script type="text/javascript">
		let referer = "${referer}";
		
		if(referer != null && referer != '') {
		let newWindow = window.open('/searcher/recipe/recommend', 'newWindow', 'width=400,height=300,resizable=yes,scrollbars=yes,left=750');			
		}

		function receiveSignal(signal) {
		    setTimeout(function() {
		        window.location.href = 'recipe/detail?recipeId=' + signal;
		    }, 100);
		    
		}
	    
	</script>
	</sec:authorize>

</body>
</html>
