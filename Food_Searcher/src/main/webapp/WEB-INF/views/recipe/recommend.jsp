<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>추천 음식</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<c:set var="found" value="false" />


<c:if test="${recommend.memberId eq memberId }">
	<div>
		${recommend.food }  어떠신가요?
	</div>
    <c:set var="imageFound" value="false"/>
    <c:forEach var="attachVO" items="${image}">
				<c:if test="${recipeVO.recipeId eq attachVO.boardId }">
				<div class="image_item">
						<img width="200px" height="200px" 
					        src="../image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" 
					        onerror="this.onerror=null; this.src='../resources/image/imageReady.png';"/>
					</div>
					<c:set var="imageFound" value="true"/>
				</c:if>
			</c:forEach>		
    <c:if test="${!imageFound}">
    	<div class="image_item">
    		<img src="../resources/image/imageReady.png"/>
    	</div>
    </c:if>
<c:set var="found" value="true" />
</c:if>

<c:if test="${not found}">
	<div>
    	${random.recipeFood }(${random.category }) 어떠신가요?
    </div>
    <c:set var="imageFound" value="false"/>
    <c:forEach var="attachVO" items="${image}">
				<c:if test="${random.recipeId eq attachVO.boardId }">
				<div class="image_item">
						<img id="recipe" width="220px" height="213px" 
					        src="../image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" 
					        onerror="this.onerror=null; this.src='../resources/image/imageReady.png';"/>
					</div>
					<c:set var="imageFound" value="true"/>
				</c:if>
			</c:forEach>
    <c:if test="${!imageFound}">
    	<div class="image_item">
    		<img src="../resources/image/imageReady.png"/>
    	</div>
    </c:if>
</c:if>

<button id="recommend">다시 추천</button>
<script type="text/javascript">
$(document).ready(function(){
	$('#recommend').click(function(){
		location.reload();
	});
	
	$('#recipe').click(function(){
		let = '${attachVO.recipeId}'
		
		window.location.href = '/searcher/home';
	});
});
</script>
</body>
</html>