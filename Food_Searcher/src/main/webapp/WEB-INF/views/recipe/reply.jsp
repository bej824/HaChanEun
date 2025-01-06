<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
/* 댓글창을 감싸는 replyBox 스타일 */
.replyBox {
	width: 100%;
	max-width: 600px; /* 댓글 창의 최대 너비 */
	margin: 20px auto; /* 화면 중앙에 배치 */
	padding: 15px 20px; /* 패딩을 조정해서 더 컴팩트하게 */
	border: 1px solid #ddd; /* 테두리 */
	border-radius: 10px; /* 둥근 테두리 */
	box-sizing: border-box; /* 패딩을 포함한 크기 계산 */
}

/* 댓글 입력란 스타일 (왼쪽 정렬) */
.replyBox input[type="text"] {
	width: 100%;
	padding: 10px;
	font-size: 14px;
	border: 1px solid #ccc;
	border-radius: 5px;
	background-color: #fff;
	margin-top: 5px; /* 댓글 입력란과 제목 간의 간격을 줄임 */
	outline: none;
	box-sizing: border-box; /* padding 포함 */
	text-align: left; /* 왼쪽 정렬 */
}

/* 댓글 리스트 스타일 */
.replyBox .reply-list {
	margin-top: 20px;
	padding: 0;
	list-style: none;
}

.replyMemberId {
	font-size: 14px;
	color: #505050;
}

.timeButton {
	text-align: right;
}

.comment {
	width: 85%;
	max-width: 500px; /* 댓글 창의 최대 너비 */
	padding: 15px 20px; /* 패딩을 조정해서 더 컴팩트하게 */
	box-sizing: border-box; /* 패딩을 포함한 크기 계산 */
}

.wbutton, .btn_update, .btn_delete, .comment_add {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	margin: 4px 2px;
	cursor: pointer;
	float: right;
}

.btn_comment {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	margin: 4px 2px;
	cursor: pointer;
	float: left;
}

.btn_update:disabled, .btn_delete:disabled, .comment_add:disabled, .btn_commentupdate:disabled, .btn_commentdelete:disabled {
    display: none;
}


.btn_add {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
	float: right;
}
</style>

<meta charset="UTF-8">
<title>댓글 헤더</title>
</head>
<body>
	<div class="replyBox">
		<div id="replies"></div>
			<%if(session.getAttribute("memberId") == null){ %>
		* 댓글은 로그인이 필요한 서비스입니다.
		<a href="../access/login?redirect=${pageContext.request.requestURI}">로그인 하기</a>
	<%} %>
	<%if(session.getAttribute("memberId") != null){ %>
			<div style="text-align: left;">
		<%=session.getAttribute("memberId") %><input type="hidden" id="memberId" value="<%=session.getAttribute("memberId") %>">
		<input type="text" id="recipeReplyContent" required>
		<button id="btnAdd" class="wbutton">작성</button>
	</div>
	<%} %>
	</div>

		<script type="text/javascript">
		$(document).ready(function(){
			getAllReply(); // 함수 호출	
			
			// 댓글 작성 기능
			$('#btnAdd').click(function(){
				let boardId = $('#recipeId').val(); // 게시판 번호 데이터
				console.log("게시판 번호 : " + boardId);
				let memberId = $('#memberId').val(); // 작성자 데이터
				console.log("작성자 : " + memberId);
				let replyContent = $('#recipeReplyContent').val(); // 댓글 내용
				console.log("댓글 내용 : " + replyContent);
				
		        // 빈 댓글 내용일 경우
		        if (!replyContent.trim()) {
		            return;
		        }
		        
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
							document.getElementById('recipeReplyContent').value = '';
							getAllReply(); // 함수 호출	
							location.reload();
						}
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
							console.log("댓글 Id : ", this.replyId);
							
							// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
							let replyDateCreated = new Date(this.replyDateCreated);
							let year = replyDateCreated.getFullYear();
							let month = (replyDateCreated.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1 해줘야 함
							let day = replyDateCreated.getDate().toString().padStart(2, '0');
							let hours = replyDateCreated.getHours().toString().padStart(2, '0');
							let minutes = replyDateCreated.getMinutes().toString().padStart(2, '0');
							let replyDate = year + "." + month + "." + day + "."
							+ hours + ":" + minutes;
							
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
								+ replyDate
								+ '<br><input type="text" id="replyContent" value="'+ this.replyContent +'">'
								+ '&nbsp;&nbsp;'
								+ '<%if(session.getAttribute("memberId") != null){ %>'
								+ '<button class="btn_delete" '+ disabled +' >삭제</button>'
								+ '<button class="btn_update " '+ disabled +' >수정</button>'
								+ '<br>'
								+ '	<%} %>'
								+ '<button class="btn_comment">답글'+this.comments.length +'</button>'
								+ '<div class="comment"></div>'
								+ '</pre>'

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
							location.reload();
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
							location.reload();
						}
					}
				});
			}); // end replies.on()		
			
			// 수정 버튼을 클릭하면 선택된 대댓글 수정
			$('#replies').on('click', '.reply_item .btn_commentupdate', function(){
				console.log(this);
				
				// 선택된 댓글의 replyId, replyContent 값을 저장
				// prevAll() : 선택된 노드 이전에 있는 모든 형제 노드를 접근
				let recipeCommentId = $(this).prevAll('#recipeCommentId').val();
				let commentContent = $(this).prevAll('#commentContent').val();
				console.log("선택된 댓글 번호 : " + recipeCommentId + ", 댓글 내용 : " + commentContent);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : '../recipe/detail/comment/' + recipeCommentId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : commentContent,
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('대댓글 수정 성공!');
							getAllReply();
							location.reload();
						}
					}
				});
				
			}); // end replies.on()
			
			// 삭제 버튼을 클릭하면 선택된 대댓글 삭제
			$('#replies').on('click', '.reply_item .btn_commentdelete', function(){
				console.log("삭제 : " + this);
				let recipeReplyId = $(this).closest('.reply_item').find('#replyId').val();
				let recipeCommentId = $(this).prevAll('#recipeCommentId').val();
				console.log("recipeReplyId : " + recipeReplyId + ", recipeCommentId : " + recipeCommentId);
				
				// ajax 요청
				$.ajax({
					type : 'DELETE', 
					url : '../recipe/detail/comment/' + recipeCommentId + '/' + recipeReplyId, 
					headers : {
						'Content-Type' : 'application/json'
					},
					data : recipeCommentId,
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('대댓글 삭제 성공!');
							getAllReply();
							location.reload();
						}
					}
				});
			}); // end replies.on()		
			
			$('#replies').on('click', '.reply_item .btn_comment', function(){
				
				$('.reply_item .comment').not($(this).closest('.reply_item').find('.comment')).html('');
				
				let replyId = $(this).prevAll('#replyId').val();
				let recipeCommentId = $(this).closest('.reply_item').find('#recipeCommentId').val();
				console.log("CommentId : " + recipeCommentId);
				let commentDiv = $(this).closest('.reply_item').find('.comment');
				
				
				let url = 'all/' + replyId;
				
				console.log("replyId : " + replyId);
				console.log("address : " + url);
				
				if(commentDiv.html() == ''){
				// ajax 요청
				$.ajax({
					type : 'GET', 
					url : 'detail/all/' + replyId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : replyId,
					success : function(result) {
						console.log(result);
						let comment = '';
						if(result) {
							comment += '<br> <br>'
							$(result).each(function(){
								console.log("대댓글 데이터: ", this);
								console.log(this.recipeCommentId);
								console.log(this.commentContent);
								console.log("replyId : ", this.recipeReplyId);
								console.log("길이 : ", result.length);
								
								// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
								let commentDateCreated = new Date(this.commentDateCreated);
								let year = commentDateCreated.getFullYear();
								let month = (commentDateCreated.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1 해줘야 함
								let day = commentDateCreated.getDate().toString().padStart(2, '0');
								let hours = commentDateCreated.getHours().toString().padStart(2, '0');
								let minutes = commentDateCreated.getMinutes().toString().padStart(2, '0');
								let replyDate = year + "." + month + "." + day + "."
								+ hours + ":" + minutes;
								
								let disabled = '';
								let readonly = '';
								
								console.log(this.memberId);
								
								if('<%=session.getAttribute("memberId")%>' != this.memberId) {
									disabled = 'disabled';
									readonly = 'readonly';
								}

								comment += '<div class="comment_item">'
									+ '<input type="hidden" id="recipeCommentId" value="'+ this.recipeCommentId +'">'
									+ '<span class="memberId" style="color: blue;" onclick="getText(this)">' + this.memberId + '</span>'
									+ '&nbsp;&nbsp;&nbsp;&nbsp;' + replyDate
									+ '<br><input type="text" id="commentContent" class="commentContent" value="'+ this.commentContent +'" '+ readonly +'>'
									+ '<button class="btn_commentupdate" '+ disabled + '>수정</button>'
									+ '<button class="btn_commentdelete" '+ disabled +' >삭제</button>'
									
									+ '</div>'
									
							}); // end each()
							+ '<%if(session.getAttribute("memberId") != null){ %>'
							comment += '<input type="text" id="commentContentAdd" >'
								+ '<button class="comment_add" value='+ replyId +'>작성</button>';
								+ '	<%} %>'
							commentDiv.html(comment);
						}
					}
				});
				}
				else {
					commentDiv.html("");
				}
				
			}) // end btn_comment()
			
			$('#replies').on('click', '.comment_add', function() {
		        // 해당 버튼이 속한 댓글 아이템에서 replyId와 commentContent를 가져오기
		        console.log(this);
		        
		        let memberId = "<%=session.getAttribute("memberId")%>"
		        let recipeReplyId = $(this).closest('.reply_item').find('#replyId').val();  // 댓글 ID
		        let commentContent = $(this).prevAll('#commentContentAdd').val();

		        console.log("recipeReplyId: " + recipeReplyId);
		        console.log("memberId: " + memberId);
		        console.log("commentContent: " + commentContent);

		        // 빈 댓글 내용일 경우
		        if (!commentContent.trim()) {
		            return;
		        }
		        
						let obj = {
								'recipeReplyId' : recipeReplyId,
								'memberId' : memberId,
								'commentContent' : commentContent
						}
						console.log(obj);
						
						// $.ajax로 송수신
						$.ajax({
							type : 'POST', // 메서드 타입
							url : 'detail/comment', // url
							headers : { // 헤더 정보
								'Content-Type' : 'application/json' // json content-type 설정
							}, 
							data : JSON.stringify(obj), // JSON으로 변환
							success : function(result) { // 전송 성공 시 서버에서 result 값 전송
								console.log(result);
								if(result == 1) {
									alert('대댓글 입력 성공');
									getAllReply();
									document.getElementById('commentContent').value = '';
									location.reload();
								}
							}
						});
					
				 }); // end comment_add()
				 
		}); // end document()
		
	    // getText 함수는 전역에서 정의되어야 합니다.
	    function getText(clickedElement) {
	      // 클릭한 span의 텍스트를 가져옵니다.
	      let memberId = clickedElement.textContent;
	      console.log(memberId);
	      
	      $('#commentContentAdd').val(memberId +" → ");
	    }
		
	</script>
	
</body>
</html>