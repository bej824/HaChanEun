<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Reply.css">
<style>
</style>

<meta charset="UTF-8">
<title>댓글 헤더</title>
</head>
<body>
<div class="replyBox">
	<div id="replies"></div>

	<sec:authorize access="isAnonymous()">
		* 댓글 작성은 로그인이 필요한 서비스입니다.
	</sec:authorize>

	<sec:authorize access="isAuthenticated()">
			<sec:authentication property="name" /><input type="hidden" id="memberId" value="<sec:authentication property="name" />"> <br>
			<input type="text" id="recipeReplyContent" class="replyContentAdd" required> <br>
			<button id="btnAdd" class="button" style="text-align: right;">작성</button>
	</sec:authorize>
</div>

		<script type="text/javascript">
		
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			
			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
			getAllReply(); // 함수 호출	
			
			// 댓글 작성 기능
			$('#btnAdd').click(function(){
				let boardId = $('#recipeId').val(); // 게시판 번호 데이터
				let memberId = $('#memberId').val(); // 작성자 데이터
				let replyContent = $('#recipeReplyContent').val(); // 댓글 내용
				
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
				
				// $.ajax로 송수신
				$.ajax({
					type : 'POST', // 메서드 타입
					url : '../recipe', // url
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj), // JSON으로 변환
					success : function(result) { // 전송 성공 시 서버에서 result 값 전송
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
				let boardId = $('#recipeId').val();
				let memberId = $('#memberId').val();
				
				let url = '../recipe/all/' + boardId;
				$.getJSON(
					url, 		
					function(data) {
						// data : 서버에서 전송받은 list 데이터가 저장되어 있음.
						// getJSON()에서 json 데이터는 
						// javascript object로 자동 parsing됨.
						
						let list = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
						
						// $(컬렉션).each() : 컬렉션 데이터를 반복문으로 꺼내는 함수
						$(data).each(function(){
							// this : 컬렉션의 각 인덱스 데이터를 의미
							
							// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
							let replyDateCreated = new Date(this.replyDateCreated);
							let year = replyDateCreated.getFullYear();
							let month = (replyDateCreated.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1 해줘야 함
							let day = replyDateCreated.getDate().toString().padStart(2, '0');
							let hours = replyDateCreated.getHours().toString().padStart(2, '0');
							let minutes = replyDateCreated.getMinutes().toString().padStart(2, '0');
							let replyDate = year + "." + month + "." + day + "."
							+ hours + ":" + minutes;
							
							let replyDated = new Date(this.replyDateCreated).toLocaleString();
							
							let disabled = '';
							let readonly = '';
							
							if(memberId != this.memberId){
								disabled = 'disabled';
								readonly = 'readonly';
							}
							
							let commentcount;
							if(this.comments.length == 0) {
								commentcount = '<button class="btn_commentList">답글</button>'
							} else {
								commentcount = '<button class="btn_commentList">답글 보기 ('+this.comments.length +')</button>'
							}
							
							list += '<div class="reply_item">'
								+ '<input type="hidden" id="replyId" value="'+ this.replyId +'">'
								+ this.memberId + '&nbsp;&nbsp;' // 공백
								+ replyDated + '&nbsp;&nbsp;'
								+ '<button class="btn_update " '+ disabled +' >수정</button>' + '&nbsp'
								+ '<button class="btn_delete" '+ disabled +' >삭제</button>'
								+ '<div class="replyContent">' + this.replyContent + '</div>'
								+ '<input type="hidden" id="replyContent" value="'+ this.replyContent +'">'
								+ commentcount
								+ '<div class="comment"></div>'
					            list += '</div>'; // 댓글 닫기
						}); // end each()
				        
						$('#replies').html(list); // 저장된 데이터를 replies div 표현
					} // end function()
				); // end getJSON()
			} // end getAllReply()
			
			// 수정 버튼 클릭 시 모달창 띄우기
			$(document).on("click", ".btn_update", function(){
				$(".replyModal").attr("style", "display:block;");
				
				let replyId = $(this).closest('.reply_item').find('#replyId').val();   // 댓글 Id 가져오기
				let replyContent = $(this).closest('.reply_item').find('#replyContent').val(); // 원본 댓글 내용 가져오기
				
				let text = ' (수정됨)'
				if(replyContent.includes(text)) {
					replyContent = replyContent.replace(text, "");
				}
				
				 $("#modal_repCon").val(replyContent); // 모달에 원본 댓글 내용 넣기
				 $("#recipeReplyId").val(replyId);     // 모달에 댓글 Id 넣기
				 
				}); // end btn_update
			
				
			// 수정 버튼을 클릭하면 선택된 댓글 수정
			$(".modal_modify_btn").on("click", function(){
				let replyId = $("#recipeReplyId").val();
				let replyContent = $("#modal_repCon").val();
			
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : '../recipe/' + replyId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : replyContent + ' (수정됨)', 
					success : function(result) {
						if(result == 1) {
							alert('댓글 수정 성공!');
							getAllReply();
							location.reload();
						}
					}
				});
				
			}); // end modal_modify_btn
			
			// 삭제 버튼을 클릭하면 선택된 댓글 삭제
			$('#replies').on('click', '.reply_item .btn_delete', function(){
				let boardId = $('#recipeId').val(); // 게시판 번호 데이터
				let replyId = $(this).prevAll('#replyId').val();
				
				// ajax 요청
				$.ajax({
					type : 'DELETE', 
					url : '../recipe/' + replyId + '/' + boardId, 
					headers : {
						'Content-Type' : 'application/json'
					},
					success : function(result) {
						if(result == 1) {
							alert('댓글 삭제 성공!');
							getAllReply();
							location.reload();
						}
					}
				});
			}); // end replies.on()		
			
			// 대댓글 수정 모달창 띄우기
			$(document).on("click", ".btn_commentupdate", function(){
				$(".commentModifyModal").attr("style", "display:block;");
				
				let commentId =  $(this).closest('.comment_item').find("#recipeCommentId").val();
				let commentContent =  $(this).closest('.comment_item').find("#commentContent").val(); // 원본 댓글 내용 가져오기
				
				let text = ' (수정됨)'
					if(commentContent.includes(text)) {
						commentContent = commentContent.replace(text, "");
					}
				
				 $("#modal_comCon").val(commentContent);
				 $("#recipeReplyId").val(commentId);
				 
				}); // end modal
			
			// 대댓글 수정 버튼 클릭 시
			$(".comment_modify_btn").click(function(){
				// 선택된 댓글의 replyId, replyContent 값을 저장
				// prevAll() : 선택된 노드 이전에 있는 모든 형제 노드를 접근
				let recipeCommentId = $('#recipeReplyId').val();
				let commentContent = $('#modal_comCon').val();
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : '../recipe/detail/comment/' + recipeCommentId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : commentContent + ' (수정됨)',
					success : function(result) {
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
				let recipeReplyId = $(this).closest('.reply_item').find('#replyId').val();
				let recipeCommentId = $(this).prevAll('#recipeCommentId').val();
				
				// ajax 요청
				$.ajax({
					type : 'DELETE', 
					url : '../recipe/detail/comment/' + recipeCommentId + '/' + recipeReplyId, 
					headers : {
						'Content-Type' : 'application/json'
					},
					data : recipeCommentId,
					success : function(result) {
						if(result == 1) {
							alert('대댓글 삭제 성공!');
							getAllReply();
							location.reload();
						}
					}
				});
			}); // end replies.on()		
			
			$('#replies').on('click', '.reply_item .btn_commentList', function(){
				$('.reply_item .comment').not($(this).closest('.reply_item').find('.comment')).html('');
				
				let replyId = $(this).prevAll('#replyId').val();
				let recipeCommentId = $(this).closest('.reply_item').find('#recipeCommentId').val();
				let commentDiv = $(this).closest('.reply_item').find('.comment');
				let memberId = "<sec:authentication property="name" />";
				
				let url = 'all/' + replyId;
				
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
						let comment = '';
						if(result) {
							comment += '<br> <br>'
							$(result).each(function(){
								// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
								let commentDateCreated = new Date(this.commentDateCreated);
								let year = commentDateCreated.getFullYear();
								let month = (commentDateCreated.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1 해줘야 함
								let day = commentDateCreated.getDate().toString().padStart(2, '0');
								let hours = commentDateCreated.getHours().toString().padStart(2, '0');
								let minutes = commentDateCreated.getMinutes().toString().padStart(2, '0');
								let replyDate = year + "." + month + "." + day + "."
								+ hours + ":" + minutes;
								
								let commentDated = new Date(this.commentDateCreated).toLocaleString();
								
								let disabled = '';
								let readonly = '';
								
								if(memberId != this.memberId){
									disabled = 'disabled';
									readonly = 'readonly';
								}

								comment += '<div class="comment_item">'
									+ '<input type="hidden" id="recipeCommentId" value="'+ this.recipeCommentId +'">'
									+ '└ ' + '<span class="memberId" style="color: blue;" onclick="getText(this)">' + this.memberId + '</span>'
									+ '&nbsp;&nbsp;&nbsp;&nbsp;' + commentDated + '&nbsp;&nbsp;'
									+ '<button class="btn_commentupdate" '+ disabled + '>수정</button>&nbsp;'
									+ '<button class="btn_commentdelete" '+ disabled +' >삭제</button>'
									+ '<div class="commentContent">' + this.commentContent + '</div>'
									+ '<input type="hidden" id="commentContent" value="'+ this.commentContent +'">'
									+ '<br>'
									+ '</div>'
									
							}); // end each()
							<sec:authorize access="isAuthenticated()">
					        // 로그인한 사용자가 있을 경우 댓글 작성 입력란과 버튼을 추가
					        comment += '<textarea id="commentContentAdd"></textarea>'
					            + '<button class="btn_commentAdd" value="'+ replyId +'">작성</button>';
					            </sec:authorize>
							commentDiv.html(comment);
						}
					}
				});
				}
				else {
					commentDiv.html("");
				}
				
			}) // end btn_comment()
			
			$('#replies').on('click', '.btn_commentAdd', function() {
		        // 해당 버튼이 속한 댓글 아이템에서 replyId와 commentContent를 가져오기
		        let memberId = "<sec:authentication property="name" />"
		        let recipeReplyId = $(this).closest('.reply_item').find('#replyId').val();  // 댓글 ID
		        let commentContent = $(this).prevAll('#commentContentAdd').val();

		        // 빈 댓글 내용일 경우
		        if (!commentContent.trim()) {
		            return;
		        }
		        
						let obj = {
								'recipeReplyId' : recipeReplyId,
								'memberId' : memberId,
								'commentContent' : commentContent
						}
						
						// $.ajax로 송수신
						$.ajax({
							type : 'POST', // 메서드 타입
							url : 'detail/comment', // url
							headers : { // 헤더 정보
								'Content-Type' : 'application/json' // json content-type 설정
							}, 
							data : JSON.stringify(obj), // JSON으로 변환
							success : function(result) { // 전송 성공 시 서버에서 result 값 전송
								if(result == 1) {
									alert('대댓글 입력 성공');
									getAllReply();
									location.reload();
								}
							}
						});
					
				 }); // end btn_commentAdd()
				 
		}); // end document()
		
	    // getText 함수는 전역에서 정의되어야 합니다.
	    function getText(clickedElement) {
	      // 클릭한 span의 텍스트를 가져옵니다.
	      let memberId = clickedElement.textContent;
	      
	      $('#commentContentAdd').val(memberId +" → ");
	    }
		
	</script>
	
		
<!-- 수정 모달 -->
<div class="replyModal">

 <div class="modalContent">
  <input type="hidden" id="recipeReplyId">  
  <div>
   <textarea id="modal_repCon" name="modal_repCon"></textarea>
  </div>
  
  <div>
   <button type="button" class="modal_modify_btn">수정</button>
   <button type="button" class="modal_cancle">취소</button>
  </div>
  
 </div>

 <div class="modalBackground"></div>
 
</div>

<!-- 대댓글 수정 모달 -->
<div class="commentModifyModal">

 <div class="modalModifyContent">
  <input type="hidden" id="recipeReplyId">  
  <div>
   <textarea id="modal_comCon" name="modal_comCon"></textarea>
  </div>
  
  <div>
   <button type="button" class="comment_modify_btn">수정</button>
   <button type="button" class="modify_comment_cancle">취소</button>
  </div>
  
 </div>

 <div class="modalBackground"></div>
 
</div>

<script>
	// 모달에서 취소 버튼 클릭시 실행(모달 숨기기)
	$(".modal_cancle").click(function(){	
	   $(".replyModal").attr("style", "display:none;");
	});
	
	// 대댓글 모달 취소
	$(".modify_comment_cancle").click(function(){
		$(".commentModifyModal").attr("style", "display:none;");
	});
</script>	
	
</body>
</html>