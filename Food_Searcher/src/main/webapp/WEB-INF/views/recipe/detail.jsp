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
<style>
#area2 {
    max-width: 900px;
    margin: 20px auto;
    padding: 20px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

/* 제목 스타일 */
h1 {
    text-align: center;
    font-size: 30px;
    color: #333;
    margin-bottom: 10px;
}

/* 작성자 정보 */
.memberId, .recipeDate {
    font-size: 14px;
    color: #777;
}

/* 레시피 카테고리 스타일 */
.recipeFood {
    font-size: 20px;
    font-weight: bold;
    color: #444;
}

.recipeCtg {
	font-size : 16px;
}

/* 입력 영역 스타일 */
.content, textarea {
    width: 100%;
    padding: 12px;
    box-sizing: border-box;
    border: 1px solid #ddd;
    border-radius: 8px;
    background: #f9f9f9;
    font-size: 16px;
    resize: none;
    margin-bottom: 10px;
    height: 280px;
}

/* 버튼 공통 스타일 */
.button {
    display: inline-block;
    padding: 8px 16px;
    font-size: 16px;
    color: white;
    background: #04AA6D;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.3s ease-in-out;
    text-align: center;
    text-decoration: none;
    
}

.button:hover {
    background: #038a58;
}

/* 삭제 버튼 스타일 */
#deleteBoard {
    background: #d9534f;
}

#deleteBoard:hover {
    background: #c9302c;
}

/* 이미지 리스트 스타일 */
.image-list {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 10px;
}

.image_item img {
    border-radius: 6px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    max-width:250px;
	max-height:260px;
}

.image_item {	
	flex-direction: row; /* 가로 정렬 */
    align-items: center; /* 수직 중앙 정렬 */
}

/* 재료 클릭 스타일 */
.clickable-word {
    display: inline-block;
    padding: 5px 10px;
    margin: 2px;
    background: #eee;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
}

.word-button {
    padding: 5px 10px;
    font-size: 14px;
    background: #3498db;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background 0.3s;
}

.word-button:hover {
    background: #217dbb;
}

.memberId {
	font-size : 22px;
}

.recipeFood, #buttonRecipeModify {
	margin-left:10px;
}

.recipeDiv {
	flex-direction: column;
	align-items: center; /* 수직 중앙 정렬 */
}

</style>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area2">
	<h1>${recipeVO.recipeTitle }</h1>
	    <div class="recipeDiv">
	        <span class="memberId">${recipeVO.memberId }</span>
	        
	        <span class="recipeDate">
	        <fmt:formatDate value="${recipeVO.recipeDateCreated }" pattern="yyyy-MM-dd" var="recipeDateCreated"/> 
	        작성일 : ${recipeDateCreated }</span>
	        
	        <div>
		        <sec:authorize access="isAuthenticated() and principal.username == '${recipeVO.memberId }'">
		            <button onclick="location.href='modify?recipeId=${recipeVO.recipeId}'" class="button" id="buttonRecipeModify">글 수정</button>
		            <button id="deleteBoard" class="button">글 삭제</button>
		        </sec:authorize>
	        </div>
	        
	        <p class="recipeFood">${recipeVO.recipeFood } <span class="recipeCtg">(${recipeVO.category })</span></p>
	    </div>
	    
	
	<br><br><br>
    <p>＜재료＞</p>
    <span class="clickable-word">${recipeVO.ingredient }</span>

    <p>＜레시피＞</p>
    <textarea class="recipeContent" readonly>${recipeVO.recipeContent }</textarea>

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
			<div class="image-list">
				<!-- 이미지 파일 처리 코드 -->
				<c:forEach var="attachVO" items="${idList}">
				    <c:if test="${attachVO.attachExtension eq 'jpg' or 
				    			  attachVO.attachExtension eq 'jpeg' or 
				    			  attachVO.attachExtension eq 'png' or 
				    			  attachVO.attachExtension eq 'gif'}">
				        <div class="image_item">
				        	<a href="../image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" target="_blank">
					        <img class="recipeImgDiv"
					        src="../image/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" /></a>
				        </div>
				    </c:if>
				</c:forEach>
			</div>
		</div>
	</div>

    <a href="/searcher/recipe/list?keyword=${param.keyword}&type=${param.type}&pageNum=${pagination.pageNum}" class="button">글 목록</a>
    <c:set var="sessionMemberId" value="${sessionScope.memberId}" />
    <c:set var="recipeMemberId" value="${recipeVO.memberId}" />

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
	<br><br>
	<%@ include file="reply.jsp"%>
	<input type="hidden" id="recipeId" value="${recipeVO.recipeId }">
	<div style="text-align: center;">
		<div id="replies"></div>
	</div>
	</div>
</body>
</html>