<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<style type="text/css">

#marketCommentContent {
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

div.replyModal { position:relative; z-index:1; display:none; }
div.modalContent { position:fixed; top:20%; left:calc(50% - 250px); width:500px; height:250px; padding:20px 10px; background:#fff; border:2px solid #666; }
div.modalContent textarea { font-size:16px; font-family:'맑은 고딕', verdana; padding:10px; width:500px; height:200px; }
div.modalContent button { font-size:20px; padding:5px 10px; margin:10px 0; background:#fff; border:1px solid #ccc; }
div.modalContent button.modal_cancle { margin-left:20px; }
div.replyFooter button { font-size:14px; border: 1px solid #999; background:none; margin-right:10px; }

div.commentModal { position:relative; z-index:1; display:none; }
div.modalCommentContent { position:fixed; top:20%; left:calc(50% - 250px); width:500px; height:380px; padding:20px 10px; background:#fff; border:2px solid #666; }
div.modalCommentContent textarea { font-size:16px; font-family:'맑은 고딕', verdana; padding:10px; width:500px; height:200px; }
div.modalCommentContent button { font-size:20px; padding:5px 10px; margin:10px 0; background:#fff; border:1px solid #ccc; }
div.modalCommentContent button.modal_comment_cancle { margin-left:20px; }


div.commentModifyModal { position:relative; z-index:1; display:none; }
div.modalModifyContent { position:fixed; top:20%; left:calc(50% - 250px); width:500px; height:250px; padding:20px 10px; background:#fff; border:2px solid #666; }
div.modalModifyContent textarea { font-size:16px; font-family:'맑은 고딕', verdana; padding:10px; width:500px; height:200px; }
div.modalModifyContent button { font-size:20px; padding:5px 10px; margin:10px 0; background:#fff; border:1px solid #ccc; }
div.modalModifyContent button.modify_comment_cancle { margin-left:20px; }
</style>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


	<script type="text/javascript">
	
	$(document).ready(function(){
		getAllReply();
		
			
		$('#btnAdd').click(function(){
			var marketId = $('#marketId').val(); // 게시판 번호 데이터
			var memberId = $('#memberId').val(); // 작성자 데이터
			var marketReplyContent = $('#marketReplyContent').val(); // 댓글 내용 데이터
			
			var obj = {
					'marketId' : marketId,
					'memberId' : memberId,	
					'marketReplyContent' : marketReplyContent
			};	
			console.log(obj);
			
			if (!marketReplyContent) {
			     alert('댓글 내용을 입력해주세요.');
			     return;
			}
			
			$.ajax({
				type : 'POST',
				url : '../market',
				headers : { // 헤더 정보
					'Content-Type' : 'application/json' // json content-type 설정
				}, 
				data : JSON.stringify(obj), 
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 입력 성공');
						getAllReply();
						$("#marketReplyContent").val("");
					}
				}
			}); // end ajax
		}); // end btnAdd.click()
		
		
		function getAllReply() {
			var marketId = $('#marketId').val();
			
			var url = '../market/all/' + marketId;
			$.getJSON(
				url, 			
				function(data) {
					console.log(data);
					
					var list = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
					
					$(data).each(function(){
						console.log(this);
					  
						// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
						// .toLocaleString(); 빼면
						var replyDateCreated = new Date(this.replyDateCreated).toLocaleString();
						var disabled = '';
										
						if("${sessionScope.memberId}" != this.memberId){
							disabled = 'disabled';
						}
					
						
						list +=
							'<div class="reply_item" value="' + this.marketReplyId + '">'
						
							+ '<div class="userInfo">'
							+ '<input type="hidden" id="marketReplyId" value="'+ this.marketReplyId +'">'
							+ '<span class="memberId">' + this.memberId + '&nbsp'
							+ '<span class="date">' + replyDateCreated
							+ '</div>'
							+ '<br>'
							
							+ '<div class="marketReplyContent">' + this.marketReplyContent + "</div>"
							+ '<br>'
							
							+ '<div class = "replyFooter">'
							+ '<button class="btn_update"' + disabled + ' > 수정 </button>'
							+ '<button class="btn_delete"' + disabled + ' > 삭제 </button>'
							+ '<button class="btn_commentList" value="' + this.marketReplyId + '"> 답글 보기(' + this.commentList.length + ') </button> '
							+ '<input type="hidden" class="commentMemberId" value="' + this.memberId + '">' 
							+ "</div>" // end replyFooter
							
							+ '<ul class="comment_item"></ul>'
							list += "</div>"; // end reply_item
					}); // end each()
					
					$('#replies').html(list); // 저장된 데이터를 replies div 표현
					
				} // end function
			);  // end JSON
		}// end getAllReply()
		
		
		
		
		$(document).on("click", ".btn_commentList", function(){
			var marketReplyId = $(this).closest('.reply_item').find('#marketReplyId').val();
			var commentDiv = $(this).closest('.reply_item').find('.comment_item');
			
			console.log("marketReplyId : " + marketReplyId);
			
		     var url = '../market/commentall/' + marketReplyId;
		     if(commentDiv.html() == ''){   
				$.getJSON(
				url, 			
				function(data) {
					console.log(data);
					
					var comment = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
					
					$(data).each(function(){
						console.log(this);
					  
						// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
						// .toLocaleString(); 빼면
						var commentDateCreated = new Date(this.commentDateCreated).toLocaleString();
						var disabled = '';
						
						if("${sessionScope.memberId}" != this.memberId){
							disabled = 'disabled';
						}
				
				
						comment +=
						 '<ul class="comment_item">'
						+ '<div class="userInfo">'
						+ '<input type="hidden" id="marketCommentId" value="' + this.marketCommentId + '">'
						+ '<input type="hidden" class="marketReplyId" value="'+ this.marketReplyId +'">'
						+ '<span class="memberId">' + this.memberId + '&nbsp'
						+ '<span class="date">' + commentDateCreated
						+ '</div>'
						+ '<br>'
						
						+ '<div class="marketCommentContent">' + this.marketCommentContent + "</div>"	

						+ '<br>'
						+ '<div class = "replyFooter">'
						+ '<%if(session.getAttribute("memberId") != null){ %>'
						+ '<button class="btn_updateComment" ' + disabled + '> 수정 </button>'
						+ '<button class="btn_deleteComment"' + disabled + ' > 삭제 </button>'
						+ '	<%} %>' 
						
						+ '</ul>'; // end comment_item
					
					}); // end each()
					
				    <%if(session.getAttribute("memberId") != null){ %>
				    comment += '<textarea id="marketCommentContent" ></textarea>'
				    		+ '<button id="btn_commentAdd" class="button" value="' + marketReplyId + '">작성</button>';
					<%} %>
					// 대댓글창 맨 아래에 있는 내용 입력 창
					
					commentDiv.html(comment); // 저장된 데이터를 comments div 표현
					
				
				} // end function
			);  // end JSON
		     } else {
		    	 commentDiv.html("");
		     }
		}); //end getAllComment
		
	
		// 수정 버튼 클릭 시 모달창 띄우기
		$(document).on("click", ".btn_update", function(){
			$(".replyModal").attr("style", "display:block;");
			
			var replyId = $(this).closest('.reply_item').find('#marketReplyId').val();   // 댓글 Id 가져오기
			var replyContent = $(this).parent().parent().children(".marketReplyContent").text(); // 원본 댓글 내용 가져오기
			
			console.log("replyId : " + replyId, "replyContent : " + replyContent);
			
			 $(".modal_repCon").val(replyContent);
			 $("#marketReplyId").val(replyId);
			 
			}); // end modal
		
		// 수정 버튼을 클릭하면 선택된 댓글 수정
		$(".modal_modify_btn").click(function(){
			console.log(this);
			
			var marketReplyId = $("#marketReplyId").val();
			var marketReplyContent = $(".modal_repCon").val();
			console.log("선택된 댓글 번호 : " + marketReplyId + ", 댓글 내용 : " + marketReplyContent);
			
			
			// ajax 요청
			$.ajax({
				type : 'PUT', 
				url : '../market/' + marketReplyId,
				headers : {
					'Content-Type' : 'application/json' 
				},
				data : marketReplyContent,
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 수정 성공!');
						getAllReply();
						 $(".replyModal").attr("style", "display:none;");
					} else {
						alert('댓글 수정 실패');
					}
				}
				});
		}); // end modal_modify_btn
			
		// 삭제 버튼을 클릭하면 선택된 댓글 삭제
		$('#replies').on('click', '.reply_item .btn_delete', function(){
			console.log(this);
			var marketId = $('#marketId').val(); // 게시판 번호 데이터
			var marketReplyId = $(this).closest('.reply_item').find('#marketReplyId').val();
			var deleteConfirm = confirm('정말로 삭제하시겠습니까?');
			
			if(deleteConfirm) {
			
			$.ajax({
				type : 'DELETE', 
				url : '../market/' + marketReplyId + '/' + marketId, 
				headers : {
					'Content-Type' : 'application/json'
				},
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 삭제 성공!');
						getAllReply();
					} else {
						alert('댓글 삭제 실패')
						}
					}
				}); // end reply delete ajax
				
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
				}); // end commentByReply delete ajax
				
				
			} // end deleteConfirm
		}); // end btn_delete
	
			
	// 대댓글 작성 버튼
	$(document).on('click', '#btn_commentAdd', function() {
		var marketReplyId = $(this).val(); // Id 가져오기
		var memberId = $('#memberId').val();
		var marketCommentContent = $('#marketCommentContent').val();
		
		var obj = {
				'marketReplyId' : marketReplyId,
				'memberId' : memberId,	
				'marketCommentContent' : marketCommentContent
		};
		console.log(obj);
		
		if (!marketCommentContent) {
		     alert('댓글 내용을 입력해주세요.');
		     return;
		}
		
		$.ajax({
			type : 'POST',
			url : '../market/commentadd/' + marketReplyId,
			headers : { // 헤더 정보
				'Content-Type' : 'application/json' // json content-type 설정
			}, 
			data : JSON.stringify(obj), 
			success : function(result) {
				console.log(result);
				if(result == 1) {
					alert('대댓글 입력 성공');
					getAllReply();
					$("#marketCommentContent").val("");
				} else {
					alert('대댓글 입력 실패');
					}
				}
		}); // end ajax
	}); // end btnComment
	
	
	// 대댓글 수정 모달창 띄우기
	$(document).on("click", ".btn_updateComment", function(){
		$(".commentModifyModal").attr("style", "display:block;");
		
		var commentId = $(this).closest('.comment_item').find('#marketCommentId').val(); 
		var commentContent = $(this).parent().parent().children(".marketCommentContent").text(); // 원본 댓글 내용 가져오기
		
		console.log("commentId : " + commentId, "commentContent : " + commentContent);
		
		 $(".modal_comCon").val(commentContent);
		 $("#marketCommentId").val(commentId);
		 
		}); // end modal
		
	
	// 선택된 대댓글 수정
	$(".comment_modify_btn").click(function(){
		console.log(this);
		
		var marketCommentId = $("#marketCommentId").val();
		var marketCommentContent = $(".modal_comCon").val();
		console.log("선택된 대댓글 번호 : " + marketCommentId + ", 대댓글 내용 : " + marketCommentContent);
		
		
		// ajax 요청
		$.ajax({
			type : 'PUT', 
			url : '../market/commentmodify/' + marketCommentId,
			headers : {
				'Content-Type' : 'application/json' 
			},
			data : marketCommentContent,
			success : function(result) {
				console.log(result);
				if(result == 1) {
					alert('대댓글 수정 성공!');
					getAllReply();
					 $(".commentModifyModal").attr("style", "display:none;");
				} else {
					alert('대댓글 수정 실패');
				}
			}
			});
	}); // end modal_modify_btn
		
	// 삭제 버튼을 클릭하면 선택된 대댓글 삭제
	$(document).on('click', '.comment_item .btn_deleteComment', function(){
		console.log(this);
		
		var marketReplyId =  $(this).closest('.comment_item').find('.marketReplyId').val();
		var marketCommentId = $(this).closest('.comment_item').find('#marketCommentId').val();
		var deleteConfirm = confirm('정말로 삭제하시겠습니까?');
		
		console.log("댓글 ID : " + marketReplyId, "대댓글 ID : " + marketCommentId);
		
		if(deleteConfirm) {
		
		$.ajax({
			type : 'DELETE', 
			url : '../market/commentdelete/' + marketCommentId + '/' + marketReplyId,
			headers : {
				'Content-Type' : 'application/json'
			},
			success : function(result) {
				console.log(result);
				if(result == 1) {
					alert('대댓글 삭제 성공!');
					getAllReply();
				} else {
					alert('대댓글 삭제 실패')
					}
				}
			});
		} // end deleteConfirm
	}); // end btn_deleteComment

}); // end document

// getText 함수는 전역에서 정의되어야 합니다.
function getText(clickedElement) {
  // 클릭한 span의 텍스트를 가져옵니다.
  let memberId = clickedElement.textContent;
  console.log(memberId);
  
  $('.marketCommentContent').val(memberId +" → ");
}

	</script>

<!-- 수정 모달 -->
<div class="replyModal">

 <div class="modalContent">
  <input type="hidden" class="marketReplyId" value="${marketReplyVO.marketReplyId }">  
  <p> 댓글 아이디 : </p>
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
  <input type="hidden" class="marketReplyId" value="${marketReplyVO.marketReplyId }">  
  <div>
   <textarea class="modal_comCon" name="modal_comCon"></textarea>
  </div>
  
  <div>
   <button type="button" class="comment_modify_btn">수정</button>
   <button type="button" class="modify_comment_cancle">취소</button>
  </div>
  
 </div>

 <div class="modalBackground"></div>
 
</div>


<script>

$(".modal_cancle").click(function(){	
   $(".replyModal").attr("style", "display:none;");
});

$(".modify_comment_cancle").click(function(){
	$(".commentModifyModal").attr("style", "display:none;");
});

	
</script>


</body>
</html>