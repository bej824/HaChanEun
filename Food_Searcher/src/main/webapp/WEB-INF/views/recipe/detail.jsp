<%@page import="com.food.searcher.domain.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.food.searcher.domain.RecipeReplyVO" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
</script>
<style type="text/css">
	.content {
		width: 700px;
		height: 80px;
		box-sizing: border-box;
		border: 2px solid #ccc;
		border-radius: 4px;
		background-color: #f8f8f8;
		font-size: 16px;
		resize: none;
    	
    }

textarea {
	width: 700px;
	height: 280px;
	padding: 12px 20px;
	box-sizing: border-box;
	border: 2px solid #ccc;
	border-radius: 4px;
	background-color: #f8f8f8;
	font-size: 16px;
	resize: none;
}
</style>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- css 파일 불러오기 -->
<link rel="stylesheet"
	href="../resources/css/Detail.css">
<link rel="stylesheet"
	href="../resources/css/Base.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/image.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<title>${recipeVO.recipeTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	<div class="fixed-element">
	<h2>글 보기</h2>
	<div>
		<p>글 번호 : ${recipeVO.recipeId }</p>
	</div>
	<div>
		<p>제목 : ${recipeVO.recipeTitle }</p>
	</div>
	<div>
		<p>작성자 : ${recipeVO.memberId }</p>
		<!-- boardDateCreated 데이터 포멧 변경 -->
		<fmt:formatDate value="${recipeVO.recipeDateCreated }"
					pattern="yyyy-MM-dd" var="recipeDateCreated"/>
		<p>작성일 : ${recipeDateCreated }</p>
		<p>음식 : <span>${recipeVO.recipeFood }</span></p>
	</div>
	<div>
		<p>카테고리 : ${recipeVO.category }</p>
	</div>
	<div>
	<p>재료 : </p>
	<div class="content">
		<span class="clickable-word">${recipeVO.ingredient } </span>
	</div>
	<p>레시피 : </p>
	<textarea rows="20" cols="120" readonly>${recipeVO.recipeContent } </textarea>
	  </div>

	<form id="listForm" action="list" method="GET">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="pageSize" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >	
	</form>
	<form id="modifyForm" action="modify" method="GET">
		<input type="hidden" name="recipeId">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="pageSize" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >
	</form>
	<form id="deleteForm" action="delete" method="POST">
		<input type="hidden" name="recipeId" value="${recipeVO.recipeId}">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="pageSize" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >
    	<input type="hidden" name="memberId" value="${recipeVO.memberId}">
    	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<!-- 이미지 파일 영역 -->
	<div class="image-upload">
		<div class="image-view">
			<h3>이미지 파일 리스트</h3>
			<div class="image-list">
				<!-- 이미지 파일 처리 코드 -->
				<c:forEach var="attachVO" items="${idList}">
				    <c:if test="${attachVO.attachExtension eq 'jpg' or 
				    			  attachVO.attachExtension eq 'jpeg' or 
				    			  attachVO.attachExtension eq 'png' or 
				    			  attachVO.attachExtension eq 'gif'}">
				        <div class="image_item">
				        	<a href="../image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" target="_blank">
					        <img width="100px" height="100px" 
					        src="../image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" /></a>
				        </div>
				    </c:if>
				</c:forEach>
			</div>
		</div>
	</div>

    <a href="/searcher/recipe/list?keyword=${param.keyword}&type=${param.type}&pageNum=${pagination.pageNum}" class="button">글 목록</a>
    <c:set var="sessionMemberId" value="${sessionScope.memberId}" />
    <c:set var="recipeMemberId" value="${recipeVO.memberId}" />

    <sec:authorize access="isAuthenticated() and principal.username == '${recipeVO.memberId }'">
        <button onclick="location.href='modify?recipeId=${recipeVO.recipeId}'" class="button">글 수정</button>
        <button id="deleteBoard" class="button">글 삭제</button>
    </sec:authorize>
	<form id="deleteForm" action="delete" method="POST" enctype="multipart/form-data">
	    <!-- 레시피 ID hidden 필드 -->
	    <input type="hidden" name="recipeId" value="${recipeVO.recipeId}">
	   
	</form>

	<script>
		let deleteButton = document.getElementById("deleteBoard");
	
		if (deleteButton) {
			deleteButton.addEventListener("click", function(event) {
	        // 삭제 확인 팝업
	        if (confirm("삭제하시겠습니까?")) {
	            // 폼을 제출하여 서버로 delete 요청을 보냄
	            document.getElementById("deleteForm").submit();
	        } else {
	            // 취소 시 동작하지 않도록
	            event.preventDefault();
	        }
	    });
		}
	</script>

	<script type="text/javascript">
	    $(document).ready(function () {
	        // .clickable-word 클래스를 가진 요소를 선택합니다.
	        let $spanElement = $('.clickable-word');
	        let textContent = $spanElement.text();  // ingredient 내용 가져오기
	
	        let localList = `${localList}`;
	        let localsplit = localList.split(' ');
	
	        let local = [...new Set(localsplit)];
	
	        // ingredient 값을 공백으로 구분하여 배열로 만듭니다.
	        let words = textContent.split(', ');  // 공백 기준으로 단어 분리
	
	        // 기존 텍스트를 지우고 다시 처리하기 위해 span의 내용을 초기화
	        $spanElement.empty();
	
	        // 각 단어를 span 태그로 감싸고 클릭 이벤트 추가
	        words.forEach(function (word) {
	            let $wordSpan = $('<span></span>');  // 새로운 span 태그 생성
	            $wordSpan.addClass('clickable-word');  // 클릭 가능한 클래스 추가
	            $wordSpan.text(word);
	
	            if (word != '' && word != ' ') {
	                // 버튼 생성
	                let $button = $('<button></button>');  
	                $button.text('구매');  // 버튼에 표시될 텍스트
	                $button.addClass('word-button');  // 버튼 스타일을 위한 클래스 추가
	
	                // 버튼 클릭 이벤트 (버튼을 눌렀을 때 동작)
	                $button.on('click', function () {
	                    console.log('클릭된 단어:', word);
	                    	localStorage.setItem('buttonCreated', 'true');
	                        let url = '/searcher/item/list?pageNum=1&type=ITEM_NAME&keyword=' + encodeURIComponent(word);
	                        window.open(url, '_self');
	                });
	
	                // 새로 생성된 단어 span 추가
	                $spanElement.append($wordSpan);
	                $spanElement.append(' ');  // 단어 사이에 공백 추가
	                // 새로 생성된 버튼 추가
	                $spanElement.append($button);
	                $spanElement.append(' / ');  // 단어들 사이에 구분자 추가
	            } else {
	                $spanElement.text("재료가 선택되지 않았습니다.");
	            }
	        });
	    });
	</script>

	<%@ include file="likes.jsp"%>

	</div>
	<%@ include file="reply.jsp"%>
	<input type="hidden" id="recipeId" value="${recipeVO.recipeId }">
	<div style="text-align: center;">
		<div id="replies"></div>
	</div>
	</div>
</body>
</html>