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

.btn_update {
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

.btn_delete {
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

.btn_comment {
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
	float: left;
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

		<div class="reply">
			<%
			if (session.getAttribute("memberId") != null) {
			%>
			<div class="replyMemberId">
				<%=session.getAttribute("memberId")%><input type="hidden"
					id="memberId" value="<%=session.getAttribute("memberId")%>">
				<input type="text" id="headerReplyContent">
				<div class="timeButton">
					<button id="btnAdd" class="button">작성</button>
				</div>
			</div>
			<%
			}
			%>
		</div>
	</div>

	<script type="text/javascript">
	
		$(document).ready(function(){
			getAllReply(); // 함수 호출
			
			// 댓글 작성 기능
			$('#btnAdd').click(function(){
				let boardId = $('#Id').val(); // 게시판 번호 데이터
				console.log(boardId);
				let memberId = $('#memberId').val(); // 작성자 데이터
				console.log(memberId);
				let headerReplyContent = $('#headerReplyContent').val(); // 댓글 내용
				console.log(headerReplyContent);
				// javascript 객체 생성
				let obj = {
						'boardId' : boardId,
						'memberId' : memberId,
						'headerReplyContent' : headerReplyContent
				}
				console.log(obj);
				
				// $.ajax로 송수신
				$.ajax({
					type : 'POST', // 메서드 타입
					url : 'replyAdd', // url
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj), // JSON으로 변환
					success : function(result) { // 전송 성공 시 서버에서 result 값 전송
						console.log(result);
						if(result == 1) {
							alert('댓글 입력 성공');
							document.getElementById('headerReplyContent').value = '';
							getAllReply(); // 함수 호출
						}
					}
				});
			}); // end btnAdd.click()
			
			// 게시판 댓글 전체 가져오기
			function getAllReply() {
				let boardId = $('#Id').val();
				let url = 'replyAll/' + boardId;
				
				console.log("boardID : " + boardId);
				console.log("address : " + url);
				$.getJSON(
					url, 		
					function(data) {
						console.log("댓글 목록 : ", data);
						
						var list = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
						
						$(data).each(function(){
							console.log("댓글 데이터: ", this);
							console.log(this.localId);
							console.log(this.replyContent);
							
							// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
							let replyDateCreated = new Date(this.replyDateCreated);
							let year = replyDateCreated.getFullYear();
							let month = (replyDateCreated.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1 해줘야 함
							let day = replyDateCreated.getDate().toString().padStart(2, '0');
							let hours = replyDateCreated.getHours().toString().padStart(2, '0');
							let minutes = replyDateCreated.getMinutes().toString().padStart(2, '0');
							let replyDate = year + "." + month + "." + day + "."
							+ hours + ":" + minutes;
							
							var disabled = '';
							var readonly = '';
							
							if('<%=session.getAttribute("memberId")%>' != this.memberId) {
								disabled = 'disabled';
								readonly = 'readonly';
							}
							
							list += '<div class="reply_item">'
								+ '<input type="hidden" id="replyId" value="'+ this.replyId +'">'
								+ this.memberId
								+ '&nbsp;&nbsp;&nbsp;&nbsp;' + replyDate
								+ '<input type="text" id="replyContent" value="'+ this.replyContent +'">'
								+ '<button class="btn_comment">답글</button>'
								+ '<%if (session.getAttribute("memberId") != null) {%>'
								+ '<button class="btn_delete" '+ disabled +' >삭제</button>'
								+ '<button class="btn_update" '+ disabled + '>수정</button>'
								+ '<%}%>'
								+ '<div id="comment"></div>'
								+ '<br> <br> <br> <br>'
								+ '</div>'
								
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
				var replyId = $(this).prevAll('#replyId').val();
				var replyContent = $(this).prevAll('#replyContent').val();
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : 'updateReply/' + replyId,
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
			
			$('#replies').on('click', '.reply_item .btn_delete', function(){
				console.log(this);
				var replyId = $(this).prevAll('#replyId').val();
				console.log("선택된 댓글 번호 : " + replyId);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : 'deleteReply/' + replyId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : replyId, 
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('댓글 삭제 성공!');
							getAllReply();
						}
					}
				});
			});
			
			$('#replies').on('click', '.reply_item .btn_comment', function(){
				let replyId = $(this).prevAll('#replyId').val();
				let url = 'commentAll/' + replyId;
				
				console.log("commentId : " + replyId);
				console.log("address : " + url);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : 'commentAll/' + replyId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : replyId,
					success : function(result) {
						console.log(result);
						if(result) {
							$(result).each(function(){
								console.log("댓글 데이터: ", this);
								console.log(this.replyId);
								console.log(this.commentContent);
								
								// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
								let commentDateCreated = new Date(this.commentDateCreated);
								let year = commentDateCreated.getFullYear();
								let month = (commentDateCreated.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1 해줘야 함
								let day = commentDateCreated.getDate().toString().padStart(2, '0');
								let hours = commentDateCreated.getHours().toString().padStart(2, '0');
								let minutes = commentDateCreated.getMinutes().toString().padStart(2, '0');
								let replyDate = year + "." + month + "." + day + "."
								+ hours + ":" + minutes;
								
								var disabled = '';
								var readonly = '';
								
								if('<%=session.getAttribute("memberId")%>' != this.memberId) {
									disabled = 'disabled';
									readonly = 'readonly';
								}
								
								comment += '<div class="comment_item">'
									+ '<input type="hidden" id="replyId" value="'+ this.replyId +'">'
									+ this.memberId
									+ '&nbsp;&nbsp;&nbsp;&nbsp;' + replyDate
									+ '<input type="text" id="replyContent" value="'+ this.replyContent +'">'
									+ '<%if (session.getAttribute("memberId") != null) {%>'
									+ '<button class="btn_delete" '+ disabled +' >삭제</button>'
									+ '<button class="btn_update" '+ disabled + '>수정</button>'
									+ '<br> <br> <br>'
									+ '<%}%>'
									+ '</div>'
									
							}); // end each()
							var comment = '';
							comment += '<input type="text" id="commentContent">'
								+ '<button class="comment_add">작성</button>'
							$('#comment').html(comment);
						}
					}
				});
				
			})
			
		 $('#comment').on('click', '.comment_add', function() {
        // 해당 버튼이 속한 댓글 아이템에서 replyId와 commentContent를 가져오기
        console.log(this);
        
        let memberId = <%=session.getAttribute("memberId")%>
        let replyId = $(this).prevAll('#replyId').val();  // 댓글 ID
        let commentContent = $(this).prevAll('#commentContent').val()

        console.log("replyId: " + replyId);
        console.log("memberId: " + memberId);
        console.log("commentContent: " + commentContent);

        // 빈 댓글 내용일 경우
        if (!commentContent.trim()) {
            alert('댓글 내용을 입력해주세요.');
            return;
        }
			
			function commentAdd(replyId, memberId, commentContent){
				console.log(replyId);
				console.log(memberId);
				console.log(commentContent);
				// javascript 객체 생성
				let obj = {
						'replyId' : replyId,
						'memberId' : memberId,
						'commentContent' : commentContent
				}
				console.log(obj);
				
				// $.ajax로 송수신
				$.ajax({
					type : 'POST', // 메서드 타입
					url : 'commentAdd', // url
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj), // JSON으로 변환
					success : function(result) { // 전송 성공 시 서버에서 result 값 전송
						console.log(result);
						if(result == 1) {
							alert('댓글 입력 성공');
							document.getElementById('commentContent').value = '';
						}
					}
				});
			}

		}); // end document()
		
		
	</script>

</body>
</html>