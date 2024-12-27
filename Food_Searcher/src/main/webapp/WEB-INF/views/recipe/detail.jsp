<%@page import="com.food.searcher.domain.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.food.searcher.domain.RecipeVO" %>
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
        margin-left: 100px; /* 대댓글은 부모 댓글보다 30px 들여쓰기 */
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

	<input type="hidden" id="recipeId" value="${recipeVO.recipeId }">

	<%if(session.getAttribute("memberId") == null){ %>
		* 댓글은 로그인이 필요한 서비스입니다.
		<a href="../access/login">로그인하기</a>
	<%} %>
	<%if(session.getAttribute("memberId") != null){ %>
			<div style="text-align: center;">
		<%=session.getAttribute("memberId") %><input type="hidden" id="memberId" value="<%=session.getAttribute("memberId") %>">
		<input type="text" id="replyContent" required>
		<button id="btnAdd" class="button">작성</button>
	</div>
	<%} %>

	<hr>
	<div style="text-align: center;">
		<div id="replies"></div>
	</div>

	<script type="text/javascript">
		$(document).ready(function(){
			getAllReply(); // 함수 호출	
			
			// 댓글 작성 기능
			$('#btnAdd').click(function(){
				let boardId = $('#recipeId').val(); // 게시판 번호 데이터
				console.log(boardId);
				let memberId = $('#memberId').val(); // 작성자 데이터
				console.log(memberId);
				let replyContent = $('#replyContent').val(); // 댓글 내용
				console.log(replyContent);
				// javascript 객체 생성
				let obj = {
						'boardId' : boardId,
						'memberId' : memberId,
						'replyContent' : replyContent
				}
				console.log(obj);
				
				// $.ajax로 송수신
				$.ajax({
					type : 'POST', // 메서드 타입
					url : '../recipe', // url
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj), // JSON으로 변환
					success : function(result) { // 전송 성공 시 서버에서 result 값 전송
						console.log(result);
						if(result == 1) {
							alert('댓글 입력 성공');
							getAllReply(); // 함수 호출		
						}
					console.log(headers);
					console.log(data);
					}
				});
			}); // end btnAdd.click()
			

			
			// 게시판 댓글 전체 가져오기
			function getAllReply() {
				console.log(this);
				let boardId = $('#recipeId').val();
				console.log("boardID : " + boardId);

				
				let url = '../recipe/all/' + boardId;
				console.log("address : " + url);
				$.getJSON(
					url, 		
					function(data) {
						// data : 서버에서 전송받은 list 데이터가 저장되어 있음.
						// getJSON()에서 json 데이터는 
						// javascript object로 자동 parsing됨.
						console.log("댓글 목록 : ", data);
						
						let list = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
						
						// $(컬렉션).each() : 컬렉션 데이터를 반복문으로 꺼내는 함수
						$(data).each(function(){
							// this : 컬렉션의 각 인덱스 데이터를 의미
							console.log("댓글 데이터: ", this);
							
							// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
							let replyDateCreated = new Date(this.replyDateCreated);
							console.log("날짜 : ", replyDateCreated);

							let disabled = '';
							let readonly = '';
							
							if('<%=session.getAttribute("memberId") %>' != this.memberId) {
								disabled = 'disabled';
								readonly = 'readonly';
							}

							list += '<div class="reply_item">'
								+ '<pre>'
								+ '<input type="hidden" id="replyId" value="'+ this.replyId +'">'
								+ this.memberId
								+ '&nbsp;&nbsp;' // 공백
								+ '<input type="text" id="replyContent" value="'+ this.replyContent +'">'
								+ '&nbsp;&nbsp;'
								+ replyDateCreated
								+ '&nbsp;&nbsp;'
								+ '<%if(session.getAttribute("memberId") != null){ %>'
								+ '<button class="btn_update " '+ disabled +' >수정</button>'
								+ '<button class="btn_delete" '+ disabled +' >삭제</button>'
								+ '<br>'
								+ 'ㄴ<%=session.getAttribute("memberId") %>'
								+ '<input type="hidden" id="commentMemberId" value="<%=session.getAttribute("memberId") %>">'
								+ '<input type="text" id="commentContent">'
								+ '<button id="btnReAdd" class="btn_comment">답글 작성</button>'
								+ '	<%} %>'
								+ '</pre>'
					            // 대댓글
					            if (this.comments) {
					            	console.log("대댓글 데이터: ", this.comments);
					                list += '<div class="comment_item">'; // 대댓글을 위한 div 추가
					                $(this.comments).each(function() {

										let updel = '';
										if('<%=session.getAttribute("memberId") %>' == this.memberId) {
											updel = '<button class="btn_commentupdate">수정</button>'
					                        + '<button class="btn_commentdelete">삭제</button>'
										}
					                	
					                    list += '<div class="comment_item">'
					                        + '<pre>'
					                        + 'ㄴ <input type="hidden" id="recipeCommentId" value="'+ this.recipeCommentId +'">'
					                        + this.memberId
					                        + '&nbsp;&nbsp;'
					                        + '<input type="text" id="commentContent" value="'+ this.commentContent +'">'
					                        + '&nbsp;&nbsp;' + new Date(this.commentDateCreated)
					                        + '&nbsp;&nbsp;'
											+ '<%if(session.getAttribute("memberId") != null){ %>'
					                        + updel
											+ '	<%} %>'
					                        + '</pre>'
					                        + '</div>';
					                });
					                list += '</div>'; // 대댓글 닫기
					            }

					            list += '</div>'; // 댓글 닫기
						}); // end each()
				        
						$('#replies').html(list); // 저장된 데이터를 replies div 표현
					} // end function()
				); // end getJSON()
			} // end getAllReply()
			
			// 수정 버튼을 클릭하면 선택된 댓글 수정
			$('#replies').on('click', '.reply_item .btn_update', function(){
				console.log(this);
				
				// 선택된 댓글의 replyId, replyContent 값을 저장
				// prevAll() : 선택된 노드 이전에 있는 모든 형제 노드를 접근
				let replyId = $(this).prevAll('#replyId').val();
				let replyContent = $(this).prevAll('#replyContent').val();
				console.log("선택된 댓글 번호 : " + replyId + ", 댓글 내용 : " + replyContent);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : '../recipe/' + replyId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : replyContent, 
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('댓글 수정 성공!');
							getAllReply();
						}
					}
				});
				
			}); // end replies.on()
			
			// 삭제 버튼을 클릭하면 선택된 댓글 삭제
			$('#replies').on('click', '.reply_item .btn_delete', function(){
				console.log(this);
				let boardId = $('#recipeId').val(); // 게시판 번호 데이터
				console.log(boardId);
				let replyId = $(this).prevAll('#replyId').val();
				
				// ajax 요청
				$.ajax({
					type : 'DELETE', 
					url : '../recipe/' + replyId + '/' + boardId, 
					headers : {
						'Content-Type' : 'application/json'
					},
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('댓글 삭제 성공!');
							getAllReply();
						}
					}
				});
			}); // end replies.on()		

			// 대댓글 입력
			$('#replies').on('click', '.reply_item .btn_comment', function() {
			    let recipeReplyId = $(this).closest('.reply_item').find('#replyId').val(); // 댓글 ID
			    let memberId = $('#commentMemberId').val(); // 사용자 ID
			    let commentContent = $(this).closest('.reply_item').find('#commentContent').val(); // 대댓글 내용

			    let obj = {
			        'recipeReplyId': recipeReplyId,
			        'memberId': memberId,
			        'commentContent': commentContent
			    };

			    $.ajax({
			        type: 'POST',
			        url: '../recipe/detail', // 대댓글을 처리할 URL
			        headers: {
			            'Content-Type': 'application/json'
			        },
			        data: JSON.stringify(obj),
			        success: function(result) {
			            if(result == 1) {
			                alert('대댓글 입력 성공');
			                getAllReply(); // 댓글 목록 갱신
			            }
			        }
			    });
			});
			
			// 수정 버튼을 클릭하면 선택된 대댓글 수정
			$('#replies').on('click', '.reply_item .btn_commentupdate', function(){
				console.log(this);
				
				// 선택된 댓글의 replyId, replyContent 값을 저장
				// prevAll() : 선택된 노드 이전에 있는 모든 형제 노드를 접근
				let replyId = $(this).prevAll('#recipeCommentId').val();
				let replyContent = $(this).prevAll('#commentContent').val();
				console.log("선택된 댓글 번호 : " + replyId + ", 댓글 내용 : " + replyContent);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : '../recipe/comment/' + replyId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : replyContent, 
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('대댓글 수정 성공!');
							getAllReply();
						}
					}
				});
				
			}); // end replies.on()
			
			// 삭제 버튼을 클릭하면 선택된 대댓글 삭제
			$('#replies').on('click', '.reply_item .btn_commentdelete', function(){
				console.log(this);
				let recipeReplyId = $(this).closest('.reply_item').find('#replyId').val();
				let recipeCommentId = $(this).prevAll('#recipeCommentId').val();
				console.log("recipeReplyId : " + recipeReplyId + ", recipeCommentId : " + recipeCommentId);
				
				// ajax 요청
				$.ajax({
					type : 'DELETE', 
					url : '../recipe/comment/' + recipeCommentId + '/' + recipeReplyId, 
					headers : {
						'Content-Type' : 'application/json'
					},
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('대댓글 삭제 성공!');
							getAllReply();
						}
					}
				});
			}); // end replies.on()		


		}); // end document()
	</script>
</body>
</html>