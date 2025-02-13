<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<style>
.replyInputBox {
	max-width: 400px;
	max-height: 100px;
	font-size: 16px;
	border-radius: 5px;
	margin-top: 5px; /* 댓글 입력란과 제목 간의 간격을 줄임 */
	outline: none;
	box-sizing: border-box; /* padding 포함 */
	text-align: left, top; /* 왼쪽 정렬 */
}
</style>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>전통시장</title>
</head>
<body>
		<%@ include file ="/WEB-INF/views/header.jsp" %>
	<!-- 게시글 -->
	<div id="area">
	<h2>글 보기</h2>
	<div>
		<p>제목 : ${marketVO.marketTitle }</p>
		<p>음식 : <span id="marketFood">${marketVO.marketFood } <button class="searchFood"> 레시피 검색 </button></span>
		<p>가게 : ${marketVO.marketName }</p>    
		<p>지역 : ${marketVO.marketLocal }</p>
	</div>
	
	
	
	<input type="hidden" id="marketId" value="${marketVO.marketId }">
	
	<div>
		<textarea class="content" rows="20" cols="120" readonly>${marketVO.marketContent }</textarea>
		
	</div>
	
	<div class="image"></div>

	<button onclick="location.href='list'" class="button" id="listBoard">글 목록</button>
	<br><br>
	
		
	<sec:authorize access="hasRole('ROLE_ADMIN')">
   	 <button onclick="location.href='modify?marketId=${marketVO.marketId }'" class="button">글수정</button>
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
    <button id="deleteMarket" class="button">글 삭제</button>
    <form id="deleteForm" action="delete" method="POST">
        <input type="hidden" name="marketId" value="${marketVO.marketId }">
        <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
        <input type="hidden" autocomplete="off" class="form-control" id="userName" name="name" value="${session.memberId }">
    </form>
	</sec:authorize>
	
	<form id="listForm" action="list" method="GET">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >	
	</form>
	<form id="modifyForm" action="modify" method="GET">
		<input type="hidden" name="boardId">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >
	</form>
	<form id="deleteForm" action="delete" method="POST">
		<input type="hidden" name="boardId">
		<input type="hidden" name="pageNum" >
    	<input type="hidden" name="type" >
    	<input type="hidden" name="keyword" >
    	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	
	<form id="searchForm" action="list" method="get">
			<input type="hidden" name="marketFood" >
			<input type="hidden" name="pageNum" >
	    	<input type="hidden" name="type" >
			<input type="hidden" name="keyword" >
		</form>
		
	<!-- 이미지 파일 영역 -->
	<div class="image-upload">
		<div class="image-view">
			<h2>이미지 파일 리스트</h2>
			<div class="image-list">
				<!-- 이미지 파일 처리 코드 -->
				<c:forEach var="attachVO" items="${marketVO.marketAttachList}">
				    <c:if test="${attachVO.attachExtension eq 'jpg' or 
				    			  attachVO.attachExtension eq 'jpeg' or 
				    			  attachVO.attachExtension eq 'png' or 
				    			  attachVO.attachExtension eq 'gif'}">
				        <div class="image_item">
				        	<a href="../images/get?attachId=${marketAttachVO.attachId }" target="_blank">
					        <img width="100px" height="100px" 
					        src="../images/get?attachId=${marketAttachVO.attachId }&attachExtension=${marketAttachVO.attachExtension}"/></a>
				        </div>
				    </c:if>
				</c:forEach>
			</div>
		</div>
	</div>
	
	<br><br>
	
	<sec:authorize access="isAnonymous()">
 	   * 댓글은 로그인이 필요한 서비스입니다.
 	</sec:authorize>

	
	<div class="replyBox">
		<div id="replies">
		<div class="reply_item">
			
			<br>
			<div class="replyInputBox">
				<sec:authorize access="isAuthenticated()">
  					<input type="hidden" name="marketId" value="${marketVO.marketId }">
			 		<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
  	 				<input type="text" name="marketReplyContent" id= "marketReplyContent" class="replyContentAdd">
  	 		 		<button id="btnAdd" class="button">댓글 작성</button>
				</sec:authorize>
			</div>
			
			<div class="comments"></div>
		</div>
		</div>
	</div>
	
	<script type="text/javascript">
		// 댓글 삭제 관련
		$(document).ready(function() {
			$('#deleteMarket').click(function() {
				// 게시글 삭제 클릭 시
				var marketId = ${marketVO.marketId}
				var url = '../market/all/' + marketId;
				// 게시글ID 불러오기. url은 댓글 출력 url
				
				console.log("marketId : " + marketId, ", url : " + url);
				
				 if (confirm('삭제하시겠습니까?')) {
					 
					 $.getJSON(
								url, 			
								function(data) {
									console.log(data);
					 // 위의 url로 출력된 댓글을 data로 받아옴
									
						$.ajax({
							type : 'DELETE',
							url : '../market/commentByReply/' + marketReplyId,
							headers : {
								'Content-Type' : 'application/json'
							},
							success : function(result) {
								console.log(result);
								if(result == 1) {
									console.log("댓글에 대한 대댓글 삭제 성공!");
									getAllReply();
								} else {
									console.log("댓글에 대한 대댓글 삭제 실패");
									}
								}
						}); // end commentByReply
						
						
					 $.ajax({
							type : 'DELETE', 
							url : '../market/deleteReplyByMarket/' + data, 
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
							}); // end deleteReplyByMarket
							

								});
						} // end confirm
					$('#deleteForm').submit(); // form 데이터 전송
			}); // end deleteMarket.click
			
			
			$("#listBoard").click(function(){
				var listForm = $("#listForm"); // form 객체 참조
				
				// c:out을 이용한 현재 페이지 번호값 저장
				var pageNum = "<c:out value='${pagination.pageNum }' />";
				var type = "<c:out value='${pagination.type }' />";
				var keyword = "<c:out value='${pagination.keyword }' />";
				
				// 페이지 번호를 input name='pageNum' 값으로 적용
				listForm.find("input[name='pageNum']").val(pageNum);
				// type 값을 적용
				listForm.find("input[name='type']").val(type);
				// keyword 값을 적용
				listForm.find("input[name='keyword']").val(keyword);
				listForm.submit(); // form 전송
			}); // end click()
			
			$(document).ready(function() {
		        $(".searchFood").click(function() {
		            var marketFood = "${marketVO.marketFood}".trim(); // marketFood 값 가져오기
		            var pageNum = 1; // pageNum 기본값, 변경 가능
		            
		            var searchUrl = "../recipe/list?recipeTitle=" + encodeURIComponent(marketFood) + "&filterBy=RECIPE_TITLE&pageNum=" + pageNum;
		            
		            window.location.href = searchUrl; // 해당 URL로 이동
		        });
		    });
			
		}); // end document
	</script>
	
	<input type="hidden" id="marketId" value="${marketVO.marketId}">
		
	<!-- 댓글 -->
	<%@ include file ="/WEB-INF/views/market/reply.jsp" %>
	</div>
</body>
</html>