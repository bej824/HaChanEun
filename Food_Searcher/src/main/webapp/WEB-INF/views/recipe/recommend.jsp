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
		<div>${recommend.food } 어떠신가요?</div>
		<c:set var="imageFound" value="false" />
		<c:forEach var="attachVO" items="${image}">
			<c:if test="${recipeVO.recipeId eq attachVO.boardId }">
				<div class="image_item">
					<img width="200px" height="200px"
						src="../image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}"
						onerror="this.onerror=null; this.src='../resources/image/imageReady.png';" />
				</div>
				<c:set var="imageFound" value="true" />
			</c:if>
		</c:forEach>
		<c:if test="${!imageFound}">
			<div class="image_item">
				<img src="../resources/image/imageReady.png" />
			</div>
		</c:if>
		<c:set var="found" value="true" />
	</c:if>

	<c:if test="${not found}">
		<div>${recipe.recipeFood }(${recipe.category }) 어떠신가요?</div>
		<c:set var="imageFound" value="false" />
		<c:forEach var="attachVO" items="${image}">
			<c:if test="${recipe.recipeId eq attachVO.boardId }">
				<div id="recipe" class="image_item">
					<img width="220px" height="213px"
						src="../image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}"
						onerror="this.onerror=null; this.src='../resources/image/imageReady.png';" />
				</div>
				<c:set var="imageFound" value="true" />
			</c:if>
		</c:forEach>
		<c:if test="${!imageFound}">
			<div class="image_item">
				<img src="../resources/image/imageReady.png" />
			</div>
		</c:if>
	</c:if>

	<button id="recommend">다시 추천</button>
	<script type="text/javascript">
		let recipeId = '${recipe.recipeId}';
		$(document).ready(function() {
			$('#recommend').click(function() {
				location.reload();
			});

		});

		// 이미지 클릭 시 부모 창에 신호 보내기
		$('.image_item').click(function() {
			// 예시로 이미지 ID나 다른 식별자를 보내기
			let recipeId = $(this).data('recipeId'); // 이미지에 data-recipeId 속성이 있다고 가정

			// 부모 창에 신호 보내기
			sendSignalToParent(recipeId); // recipeId를 부모 창으로 전달
		});

		//팝업 창에서 부모 창으로 신호를 보내는 함수
		function sendSignalToParent(signal) {
			if (window.opener) {
				console.log(recipeId)
				window.opener.receiveSignal(recipeId); // 부모 창의 함수 호출
				window.close();
			}
		}
	</script>
</body>
</html>