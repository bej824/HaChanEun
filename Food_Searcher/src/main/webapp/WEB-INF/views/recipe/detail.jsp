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

</style>
<meta charset="UTF-8">
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
		<textarea rows="20" cols="120" readonly>${recipeVO.recipeContent }</textarea>
	</div>

	<c:forEach var="attachVO" items="${idList }">
	<p>
<%--     <img src="${attachVO.attachPath }/${attachVO.attachChgName }" alt="${attachVO.attachRealName }.${attachVO.attachExtension }" style="max-width: 100%; height: auto;">
    <img src="src/main/webapp/image/${attachVO.attachChgName }" alt="${attachVO.attachRealName }.${attachVO.attachExtension }" style="max-width: 100%; height: auto;">
    
    <img src="detail/image/${attachVO.attachPath }/${attachVO.attachChgName }" alt="${attachVO.attachRealName }.${attachVO.attachExtension }" style="max-width: 100%; height: auto;">
	 --%>
	<img src="${imagePath}" alt="${attachVO.attachRealName }.${attachVO.attachExtension }" />
	</p><br>
	</c:forEach>

	<button onclick="location.href='list'" class="button">글 목록</button>
	
	<script>
function goBackToList() {
    // 이전 페이지로 돌아가기
    window.location.href = document.referrer || '/searcher/recipe/list';
}
</script>
	
	<% 
    String sessionMemberId = (String) session.getAttribute("memberId");
	RecipeVO recipeVO = (RecipeVO) request.getAttribute("recipeVO");
    String recipeMemberId = recipeVO.getMemberId(); // Get memberId from recipeVO
%>

<% if(sessionMemberId == null){ %>
    <button onclick="location.href='../access/login'" class="button">글 수정</button>
    <button id="deleteBoard" class="button" disabled>글 삭제</button>
<% } else if(sessionMemberId != null && sessionMemberId.equals(recipeMemberId)){ %>
    <button onclick="location.href='modify?recipeId=${recipeVO.recipeId}'" class="button">글 수정1</button>
    <button id="deleteBoard" class="button">글 삭제1</button>
<% } else { %>
    <button onclick="location.href='modify?recipeId=${recipeVO.recipeId}'" class="button" disabled>글 수정2</button>
    <button id="deleteBoard" class="button" disabled>글 삭제2</button>
<% } %>
	<form id="deleteForm" action="delete" method="POST">
		<input type="hidden" name="recipeId" value="${recipeVO.recipeId }">
	</form>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$('#deleteBoard').click(function(){
				if(confirm('삭제하시겠습니까?')){
					$('#deleteForm').submit(); // form 데이터 전송
				}
			});
		}); // end document
	</script>
	
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