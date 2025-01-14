<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>

<style type="text/css">
.button {
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

.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

textarea {
  width: 100px;
  height: 100px;
  padding: 12px 20px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  background-color: rgb(240, 240, 240, 0);
  font-size: 16px;
  resize: none;
}

.content {
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

button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

.reply_item {
	width: 100%;
	max-width: 600px; /* 댓글 창의 최대 너비 */
	margin: 20px auto; /* 화면 중앙에 배치 */
	padding: 15px 20px; /* 패딩을 조정해서 더 컴팩트하게 */
	border: 1px solid #ddd; /* 테두리 */
	border-radius: 10px; /* 둥근 테두리 */
	box-sizing: border-box; /* 패딩을 포함한 크기 계산 */
}

.comment_item {	
	left : 30px;
	width: 100%;
	max-width: 600px; /* 댓글 창의 최대 너비 */
	margin: 20px auto; /* 화면 중앙에 배치 */
	padding: 15px 20px; /* 패딩을 조정해서 더 컴팩트하게 */
	border: 1px solid #ddd; /* 테두리 */
	border-radius: 10px; /* 둥근 테두리 */
	box-sizing: border-box; /* 패딩을 포함한 크기 계산 */
}


.reply_insert {
	padding:30px 0;
	margin:10px 0;
	font-size:14px;
	font-family:'맑은 고딕', verdana;
	padding:10px;
	width:700px;
	height:150px;
}

.modalBackground {
  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background:rgba(0, 0, 0, 0.5);
  z-index:-1;
  }



</style>


<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<title>전통시장</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>

	<!-- 게시글 -->
	<h2>글 보기</h2>
	<div>
		<p>제목 : ${marketVO.marketTitle }</p>
	</div>
	<div>
		<p>지역 : ${marketVO.marketLocal }</p>
	</div>
	
	<input type="hidden" id="marketId" value="${marketVO.marketId }">
	
	<div>
		<textarea class="content" rows="20" cols="120" readonly>${marketVO.marketContent }</textarea>
		
	</div>
	
	<div class="image"></div>

	<button onclick="location.href='list'" class="button">글 목록</button>
	<br><br>
	
		
	<sec:authorize access="hasRole('ROLE_ADMIN')">
   	 <button onclick="location.href='modify?marketId=${marketVO.marketId }'" class="button">글수정</button>
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
    <button id="deleteMarket" class="button">글 삭제</button>
    <form id="deleteForm" action="delete" method="POST">
        <input type="hidden" name="marketId" value="${marketVO.marketId }">
    </form>
	</sec:authorize>

	
	<sec:authorize access="isAnonymous()">
 	   * 댓글은 로그인이 필요한 서비스입니다.
 	   <a href="/searcher/auth/login">로그인하기</a>
 	</sec:authorize>

	<sec:authorize access="isAuthenticated()">
  	  <input type="hidden" name="marketId" value="${marketVO.marketId }">
	   	<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
   	 <textarea name="marketReplyContent" id="marketReplyContent" class="reply_insert"></textarea>
   	 <button id="btnAdd" class="button">댓글 작성</button>
	</sec:authorize>
	
		<div id="replies">
		<div class="reply_item">
			<div class="comments"></div>
		</div>
		</div>
	
	
	<script type="text/javascript">
		$(document).ready(function() {
			$('#deleteMarket').click(function() {
				
				var marketId = ${marketVO.marketId}
				
				console.log("marketId : " + marketId);
				
				 if (confirm('삭제하시겠습니까?')) {
					 $.ajax({
							type : 'DELETE', 
							url : '../market/deleteReplyByMarket/' + marketId, 
							headers : {
								'Content-Type' : 'application/json'
							},
							success : function(result) {
								console.log(result);
								if(result == 1) {
									console.log("댓글 삭제 성공");
								} else {
									console.log("댓글 삭제 실패");
									}
								}
							}); // end ajax
						} // end confirm
					$('#deleteForm').submit(); // form 데이터 전송
			}); // end deleteMarket.click
		}); // end document
		
	</script>
	
	<input type="hidden" id="marketId" value="${marketVO.marketId}">
	<input type="hidden" id="memberId" value="<%=session.getAttribute("memberId") %>">
		
	<!-- 댓글 -->
	<%@ include file ="/WEB-INF/views/market/reply.jsp" %>


</body>
</html>