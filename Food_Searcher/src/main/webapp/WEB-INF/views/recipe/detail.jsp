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

.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

    .image-list {
        display: flex;
        flex-wrap: wrap; /* 이미지가 가로로 나오고, 공간이 부족할 경우 줄 바꿈 */
    }
    .image_item {
        margin: 5px; /* 이미지 간 간격 */
    }
    
    .clickable-word {	
	left : 30px;
	width: 100%;
	max-width: 600px; /* 댓글 창의 최대 너비 */
	margin: 20px auto; /* 화면 중앙에 배치 */
	box-sizing: border-box; /* 패딩을 포함한 크기 계산 */
}

	.content {
	width: 700px;
	height: 280px;
	padding: 12px 20px;
    background-color: #f2f2f2;
    resize: none;
    border: 1px solid gray;  /* 2px 두께의 검은색 실선 테두리 추가 */
    
    }
    
        .new-line {
            display: block;  /* 새로운 줄로 나누기 */
            margin-top: 10px;  /* 위쪽에 여백 추가 (선택 사항) */
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
	<div class="content">
		<span class="clickable-word">${recipeVO.recipeContent } </span>
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

    <a href="/searcher/recipe/list?recipeTitle=${param.recipeTitle}&filterBy=${param.filterBy}&pageNum=${pagination.pageNum}" class="button">글 목록</a>
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

<script>
document.addEventListener('DOMContentLoaded', function () {
    let spanElement = document.querySelector('.clickable-word');
    let textContent = spanElement.innerText;

    // 시작 단어와 끝 단어 정의
    let startWord = "재료 :";
    let endWord = "레시피 :";

    // 시작 단어와 끝 단어의 인덱스 찾기
    let startIndex = textContent.indexOf(startWord) + startWord.length;
    let endIndex = textContent.indexOf(endWord);

    // 클릭 가능한 단어만 선택할 수 있도록 처리
    if (startIndex >= 0 && endIndex > startIndex) {
        let selectedText = textContent.slice(startIndex, endIndex).trim();  // 시작과 끝 단어 제외하고 중간 텍스트 가져오기
        let words = selectedText.split(' ');

        // 기존 span 태그에서 시작 단어 이전까지 텍스트 출력
        spanElement.innerHTML = textContent.slice(0, startIndex);  // "시작" 단어 이전 텍스트

        // 중간 단어를 클릭 가능한 span 태그로 감싸기
        words.forEach(function (word) {
            let wordSpan = document.createElement('span');
            wordSpan.classList.add('clickable-word');  // 클릭 가능한 클래스 추가
            wordSpan.innerText = word;

            // 클릭 이벤트 추가 (단어 클릭시 URL로 이동)
            wordSpan.addEventListener('click', function () {
                console.log('클릭된 단어:', word);
                var url = 'list?recipeTitle=' + encodeURIComponent(word) + '&filterBy=RECIPE_CONTENT';
                window.location.href = url;
            });

            // 새로 생성된 단어 span 추가
            spanElement.appendChild(wordSpan);  
            spanElement.appendChild(document.createTextNode(' '));  // 단어들 사이에 공백 추가
        });

        // 끝 단어 이후 텍스트 추가
        let endText = textContent.slice(endIndex);
        let endTextNode = document.createElement('div');  // 새로운 줄로 분리하기 위한 div
        endTextNode.classList.add('new-line');
        endTextNode.innerText = endText;  // 끝 텍스트 추가
        spanElement.appendChild(endTextNode);
    } else {
        console.log('시작 단어와 끝 단어 사이에 유효한 텍스트가 없습니다.');
    }
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