<%@page import="com.food.searcher.domain.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.food.searcher.domain.RecipeReplyVO" %>
<!DOCTYPE html>
<html>
<head>
<!-- jquery 라이브러리 import -->
<script src="https://code.jquery.com/jquery-3.7.1.js">
</script>
<style type="text/css">
.button, .btn_update, .btn_delete, .btn_comment, .btn_commentupdate, .btn_commentdelete {
	  background-color: #04AA6D;
  border: none;
  color: white;
  padding: 4px 12px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
}

.reply_item {
        margin-left: 1px; /* 대댓글은 부모 댓글보다 30px 들여쓰기 */
        margin-bottom: 10px;
    }

.comment_item {
        margin-left: 30px; /* 대댓글은 부모 댓글보다 30px 들여쓰기 */
        margin-bottom: 10px;
    }

.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

textarea {
  width: 700px;
  height: 280px;
  padding: 12px 20px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  background-color: rgb(240, 240, 240, 0);
  font-size: 16px;
  resize: none;
}

    .image-list {
        display: flex;
        flex-wrap: wrap; /* 이미지가 가로로 나오고, 공간이 부족할 경우 줄 바꿈 */
    }
    .image_item {
        margin: 5px; /* 이미지 간 간격 */
    }

</style>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<!-- css 파일 불러오기 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/image.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/attach.css">
<title>${recipeVO.recipeTitle }</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<%session.getAttribute("memberId"); %>
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
		<p>음식 : ${recipeVO.recipeFood }</p>
	</div>
	<div>
		<textarea rows="20" cols="120" readonly>${recipeVO.recipeContent } </textarea>
	</div>

    <!-- 이미지 파일 영역 -->
    <div class="image-upload">
        <div class="image-view">
            <h2>이미지 파일 리스트1</h2>
            <div class="image-list">
                <!-- 이미지 파일 처리 코드 -->
                <c:forEach var="attachVO" items="${idList}">
                    <c:if test="${attachVO.attachExtension eq 'jpg' or 
                                  attachVO.attachExtension eq 'jpeg' or 
                                  attachVO.attachExtension eq 'png' or 
                                  attachVO.attachExtension eq 'gif' or
                                  attachVO.attachExtension eq 'webp'}">
                        <div class="image_item">
                            <a href="../image/get?attachId=${attachVO.attachId }" target="_blank">
                                <img width="100px" height="100px" 
                                     src="../image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}"/>
                            </a>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
    
    <!-- 이미지 재시도 -->

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
			<h2>이미지 파일 리스트</h2>
			<div class="image-list">
				<!-- 이미지 파일 처리 코드 -->
				<c:forEach var="attachVO" items="${idList}">
				    <c:if test="${attachVO.attachExtension eq 'jpg' or 
				    			  attachVO.attachExtension eq 'jpeg' or 
				    			  attachVO.attachExtension eq 'png' or 
				    			  attachVO.attachExtension eq 'gif' or
                                  attachVO.attachExtension eq 'webp'}">
				        <div class="image_item">
				        	<a href="../image/get?attachId=${attachVO.attachId }" target="_blank">
					        <img width="100px" height="100px" 
					        src="../image/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}"/></a>
				        </div>
				    </c:if>
				</c:forEach>
			</div>
		</div>
	</div>
	
	<!-- 첨부 파일 영역 -->
	<div class="attach-upload">
		<div class="attach-view">
			<h2>첨부 파일 리스트</h2>
			<div class="attach-list">
			<c:forEach var="attachVO" items="${idList}">
		 		<c:if test="${not (attachDTO.attachExtension eq 'jpg' or 
			    			  attachVO.attachExtension eq 'jpeg' or 
			    			  attachVO.attachExtension eq 'png' or 
			    			  attachVO.attachExtension eq 'gif')}">
			    	<div class="attach_item">
			    	<p><a href="../attach/download?attachId=${attachVO.attachId }">${attachVO.attachRealName }.${attachVO.attachExtension }</a></p>
			    	</div>
			    </c:if>
			</c:forEach>
			</div>
		</div>
	</div>

	<!-- 이미지 재시도 -->

    <button onclick="location.href='list'" class="button">글 목록</button>

    <c:set var="sessionMemberId" value="${sessionScope.memberId}" />
    <c:set var="recipeMemberId" value="${recipeVO.memberId}" />

    <c:if test="${empty sessionMemberId}">
        <button onclick="location.href='../access/login'" class="button">글 수정</button>
        <button id="deleteBoard" class="button" disabled>글 삭제</button>
    </c:if>

    <c:if test="${not empty sessionMemberId and sessionMemberId == recipeMemberId}">
        <button onclick="location.href='modify?recipeId=${recipeVO.recipeId}'" class="button">글 수정1</button>
        <button id="deleteBoard" class="button">글 삭제1</button>
    </c:if>

    <c:if test="${not empty sessionMemberId and sessionMemberId != recipeMemberId}">
        <button onclick="location.href='modify?recipeId=${recipeVO.recipeId}'" class="button" disabled>글 수정2</button>
        <button id="deleteBoard" class="button" disabled>글 삭제2</button>
    </c:if>
<form id="deleteForm" action="delete" method="POST" enctype="multipart/form-data">
    <!-- 레시피 ID hidden 필드 -->
    <input type="hidden" name="recipeId" value="${recipeVO.recipeId}">
</form>

<script>
    document.getElementById("deleteBoard").addEventListener("click", function(event) {
        // 삭제 확인 팝업
        if (confirm("삭제하시겠습니까?")) {
            // 폼을 제출하여 서버로 delete 요청을 보냄
            document.getElementById("deleteForm").submit();
        } else {
            // 취소 시 동작하지 않도록
            event.preventDefault();
        }
    });
</script>
	
		<script>
function goBackToList() {
    // 이전 페이지로 돌아가기
    window.location.href = '/searcher/recipe/list?recipeTitle=${recipeTitle}&filterBy=${filterBy}&pageNum=${pageNum}';
}
</script>

	<!-- 목록 -->
	<script type="text/javascript">
		$(document).ready(function(){
		$("#listBoard").click(function(){
			var listForm = $("#listForm"); // form 객체 참조
			
			// c:out을 이용한 현재 페이지 번호값 저장
			var pageNum = "<c:out value='${pagination.pageNum }' />";
			var pageSize = "<c:out value='${pagination.pageSize }' />"; 
			var type = "<c:out value='${pagination.type }' />";
			var keyword = "<c:out value='${pagination.keyword }' />";
			
			// 페이지 번호를 input name='pageNum' 값으로 적용
			listForm.find("input[name='pageNum']").val(pageNum);
			// 선택된 옵션 값을 input name='pageSize' 값으로 적용
			listForm.find("input[name='pageSize']").val(pageSize);
			// type 값을 적용
			listForm.find("input[name='type']").val(type);
			// keyword 값을 적용
			listForm.find("input[name='keyword']").val(keyword);
			listForm.submit(); // form 전송
		}); // end click()
	});

	</script>
	<!-- 목록 -->
	
	
	<%-- 추천 비추천 작업 예정 
	<button id="up" class="button">추천${recipeVO.like }</button>
	<button id="down" class="button">비추천${recipeVO.unlike }</button>
	--%>

	<%@ include file="reply.jsp"%>
	<input type="hidden" id="recipeId" value="${recipeVO.recipeId }">



	<div style="text-align: center;">
		<div id="replies"></div>
	</div>


</body>
</html>