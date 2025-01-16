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

		<div class="reply">
			<div class="replyMemberId">
			</div>
				<sec:authorize access="isAuthenticated()">
				<sec:authentication property="name" /><input type="hidden"
					id="memberId" value=<sec:authentication property="name" />>
				<input type="text" id="headerReplyContent">
				<div class="timeButton">
				<button id="btnAdd" class="button">작성</button>
				</div>
				</sec:authorize>
		</div>
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
				let localId = $('#localId').val(); // 게시판 번호 데이터
				let memberId = '<sec:authentication property="name" />'
				
				let headerReplyContent = $('#headerReplyContent').val(); // 댓글 내용
				console.log(headerReplyContent);
				// javascript 객체 생성
				let obj = {
						'localId' : localId,
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
				const memberId = "${authentication.name}"
				console.log("로그인한 유저 : " + memberId);
				let localId = $('#localId').val();
				let url = 'replyAll/' + localId;
				
				console.log("localID : " + localId);
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
							
							if('<sec:authentication property="name" />' != this.memberId){
								disabled = 'disabled';
								readonly = 'readonly';
							}
							
							list += '<div class="reply_item">'
								+ '<input type="hidden" id="replyId" value="'+ this.replyId +'">'
								+ this.memberId
								+ '&nbsp;&nbsp;&nbsp;&nbsp;' + replyDate
								+ '<input type="text" id="replyContent" value="'+ this.replyContent +'" ' + readonly + '>'
								+ '<button class="btn_comment">답글 ' + this.commentCount + '개</button>'
								+ '<button class="btn_delete" '+ disabled +' >삭제</button>'
								+ '<button class="btn_update" '+ disabled + '>수정</button>'
								+ '<div class="comment"></div>'
								+ '<br> <br>'
								+ '</div>'
								
						}); // end each()
				        
						$('#replies').html(list); // 저장된 데이터를 replies div 표현
					} // end function()
				); // end getJSON()
				
			} // end getAllReply()
			
			// 수정 버튼 클릭시 모달 띄우기 
			$(document).on("click", ".btn_update", function(){
				$(".replyModal").attr("style", "display:block;");
				
				var replyId = $(this).closest('.reply_item').find('#replyId').val();   // 댓글 Id 가져오기
				var replyContent = $(this).closest('.reply_item').find("#replyContent").val(); // 원본 댓글 내용 가져오기
				
				console.log("replyId : " + replyId, "replyContent : " + replyContent);
				
				 $(".modal_repCon").val(replyContent);
				 $("#localReplyId").val(replyId);
				
				}); // end modal
				 
				// 수정 버튼을 클릭하면 선택된 댓글 수정
				$(".modal_modify_btn").on("click", function(){
					console.log(this);
					
					const token = $("meta[name='_csrf']").attr("content");
					const header = $("meta[name='_csrf_header']").attr("content");
					
					// 선택된 댓글의 replyId, replyContent 값을 저장
					// prevAll() : 선택된 노드 이전에 있는 모든 형제 노드를 접근
					const replyId = $("#localReplyId").val();
					const replyContent = $(".modal_repCon").val();
					
					console.log("선택된 replyId : " + replyId, ", 수정된 replyContent : " + replyContent);
					
					// ajax 요청
					$.ajax({
						type : 'PUT', 
						url : 'updateReply/' + replyId,
						headers : {
							'Content-Type' : 'application/json'
						},
						data : replyContent,
						beforeSend: function (xhr) {
							xhr.setRequestHeader(header, token);  // CSRF 토큰을 헤더에 설정
				            },
						success : function(result) {
							console.log(result);
							if(result == 1) {
								alert('댓글 수정 성공!');
								getAllReply();
								$(".replyModal").attr("style", "display:none;");
							}
						}
					});
				}); // end btn_update()
			
			$('#replies').on('click', '.reply_item .btn_delete', function(){
				
				let replyId = $(this).prevAll('#replyId').val();
				let localId = $('#localId').val();
				console.log("선택된 댓글 번호 : " + replyId);
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : 'deleteReply/' + localId + '/' + replyId,
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
			}); // end btn_delete()
			
			$('#replies').on('click', '.reply_item .btn_comment', function(){
				let replyId = $(this).prevAll('#replyId').val();
				let commentDiv = $(this).closest('.reply_item').find('.comment');
				
				let url = 'commentAll/' + replyId;
				
				console.log("replyId : " + replyId);
				console.log("address : " + url);
				
				if(commentDiv.html() == ''){
				// ajax 요청
				$.ajax({
					type : 'GET', 
					url : 'commentAll/' + replyId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : replyId,
					success : function(result) {
						console.log(result);
						var comment = '';
						if(result) {
							comment += '<br> <br>'
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
								
								if('<sec:authentication property="name" />'!= this.memberId){
									disabled = 'disabled';
									readonly = 'readonly';
								}
								
								comment += '<div class="comment_item">'
									+ '<input type="hidden" id="commentId" value="'+ this.commentId +'">'
									+ this.memberId
									+ '&nbsp;&nbsp;&nbsp;&nbsp;' + replyDate
									+ '<input type="text" id="commentContent" class="commentContent" value="'+ this.commentContent +'">'
									+ '<button class="comment_delete" '+ disabled +' >삭제</button>'
									+ '<button class="comment_update" '+ disabled + '>수정</button>'
									+ '</div>'
									
							}); // end each()
							comment += '<input type="text" id="commentContent">'
								+ '<button class="comment_add" value='+ replyId +'>작성</button>';
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
        
        let localId = $('#localId').val();
        let memberId = '<sec:authentication property="name" />';
        let replyId = $(this).val();  // 댓글 ID
        let commentContent = $(this).prevAll('#commentContent').val();

        console.log("replyId: " + replyId);
        console.log("memberId: " + memberId);
        console.log("commentContent: " + commentContent);

        // 빈 댓글 내용일 경우
        if (!commentContent.trim()) {
            return;
        }
        
				let obj = {
						'replyId' : replyId,
						'memberId' : memberId,
						'commentContent' : commentContent
				}
				console.log(obj);
				
				// $.ajax로 송수신
				$.ajax({
					type : 'POST', // 메서드 타입
					url : 'commentAdd/' + localId, // url
					headers : { // 헤더 정보
						'Content-Type' : 'application/json' // json content-type 설정
					}, 
					data : JSON.stringify(obj), // JSON으로 변환
					success : function(result) { // 전송 성공 시 서버에서 result 값 전송
						console.log(result);
						if(result == 1) {
							alert('댓글 입력 성공');
							document.getElementById('commentContent').value = '';
							getAllReply();
						}
					}
				});
			
		 }); // end comment_add()
		 
		// 대댓글 수정 모달창 띄우기
			$(document).on("click", ".comment_update", function(){
				$(".commentModifyModal").attr("style", "display:block;");
				
				var commentId =  $(this).closest('.comment_item').find("#commentId").val(); // 원본 댓글 내용 가져오기
				var commentContent =  $(this).closest('.comment_item').find("#commentContent").val(); // 원본 댓글 내용 가져오기
				
				console.log("commentId : " + commentId, "commentContent : " + commentContent);
				
				 $("#modal_comCon").val(commentContent);
				 $("#localCommentId").val(commentId);
				 
				}); // end modal
		 
				
				// 대댓글 수정 버튼 클릭 시
				$(".comment_modify_btn").click(function(){
				console.log(this);
				
				const token = $("meta[name='_csrf']").attr("content");
				const header = $("meta[name='_csrf_header']").attr("content");
				
				// 선택된 댓글의 replyId, replyContent 값을 저장
				// prevAll() : 선택된 노드 이전에 있는 모든 형제 노드를 접근
				let commentId = $('#localCommentId').val();
				let commentContent = $('#modal_comCon').val();
				
				console.log("수정된 commentId : " + commentId, "수정된 commentContent : " + commentContent);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : 'updateComment/' + commentId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : commentContent,
					beforeSend: function (xhr) {
						xhr.setRequestHeader(header, token);  // CSRF 토큰을 헤더에 설정
			            },
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('대댓글 수정 성공!');
							getAllReply();
							 $(".commentModifyModal").attr("style", "display:none;");
						}
					}
				});
			}); // end comment_update()
			
			
			$('#replies').on('click', '.reply_item .comment_delete', function(){
				console.log(this);
				
				let localId = $('#localId').val();
				let commentId = $(this).prevAll('#commentId').val();
				console.log("선택된 댓글 번호 : " + commentId);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : 'deleteComment/' + localId + '/' + commentId,
					headers : {
						'Content-Type' : 'application/json'
					},
					data : commentId,
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('대댓글 삭제 성공!');
							getAllReply();
						}
					}
				});
			}); // end comment_delete()

		}); // end document()
		
		
	</script>

<!-- 수정 모달 -->
<div class="replyModal">

 <div class="modalContent">
  <input type="hidden" id="localReplyId">  
  <div>
   <textarea class="modal_repCon" name="modal_repCon"></textarea>
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
  <input type="hidden" id="localCommentId">  
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
	
	// 대댓글 수정 취소
	$(".modify_comment_cancle").click(function(){
		$(".commentModifyModal").attr("style", "display:none;");
	});
</script>

</body>
</html>