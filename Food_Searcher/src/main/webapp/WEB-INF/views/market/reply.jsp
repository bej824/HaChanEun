<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Reply.css">
	<link rel="stylesheet"
	href="../resources/css/Base.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>Insert title here</title>
</head>
<body>
<form>
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
</form>
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});	  
	
	$(document).ready(function(){
		getAllReply();
		
			
		$(document).on('click', '#btnAdd', function() {
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
			var memberId = $('#memberId').val();
			var url = '../market/all/' + marketId;
			
			
			$.getJSON(
				url, 			
				function(data) {
					console.log(data);
					
					var list = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
					
					if (data.length === 0) {
			            // 댓글이 하나도 없을 때
			            list += '<div class="no_reply">작성된 댓글이 없습니다.</div>';
			        
					} else {
					
					$(data).each(function(){
						console.log(this);
					  
						// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
						// .toLocaleString(); 빼면
						var replyDateCreated = new Date(this.replyDateCreated).toLocaleString();
						var disabled = '';
						modified = '';
										
						if(memberId != this.memberId){
							disabled = 'disabled';
						}
						
						list +=
							'<div class="reply_item" value="' + this.marketReplyId + '">'
						
							+ '<div class="userInfo">'
							+ '<input type="hidden" id="marketReplyId" value="'+ this.marketReplyId +'">'
							+ '<span class="memberId">' + this.memberId + '&nbsp'
							+ '<span class="date">' + replyDateCreated + '&nbsp' + '&nbsp'+ '&nbsp'+ '&nbsp'+ '&nbsp'
							+ '<span id="isModified">' + modified + '</span>'
							+ '<button class="btn_update"' + disabled + ' > 수정 </button>' + '&nbsp'
							+ '<button class="btn_delete"' + disabled + ' > 삭제 </button>'
							+ '</div>'
							+ '<div class="marketReplyContent">' + this.marketReplyContent + "</div>"
							+ '<br>'
							
							+ '<div class = "replyFooter">'
							+ '<button class="btn_commentList" value="' + this.marketReplyId + '"> 답글 보기(' + this.commentList.length + ') </button> '
							+ '<input type="hidden" class="commentMemberId" value="' + this.memberId + '">' 
							+ "</div>" // end replyFooter
							
							+ '<div class="comment"></div>'
							list += "</div>"; // end reply_item
					}); // end each()
					
					}
					$('#replies').html(list); // 저장된 데이터를 replies div 표현
				
					 if ($('.replyInputBox').length === 0) {
				            $('#replies').append(`
				            		<br>
				                <div class="replyInputBox">
				                    <sec:authorize access="isAuthenticated()">
				                        <input type="hidden" name="marketId" value="${marketVO.marketId }">
				                        <input type="hidden" id="memberId" value=<sec:authentication property="name" />>
				                        <input type="text" name="marketReplyContent" id="marketReplyContent" placeholder="댓글을 입력하세요" />
				                        <button id="btnAdd" class="button">댓글 작성</button>
				                    </sec:authorize>
				                </div>
				            `);
				        }
					
				} // end function
			);  // end JSON
		}// end getAllReply()	
		
		
		
		
		$(document).on("click", ".btn_commentList", function(){
			var marketReplyId = $(this).closest('.reply_item').find('#marketReplyId').val();
			var commentDiv = $(this).closest('.reply_item').find('.comment');
			
			console.log("marketReplyId : " + marketReplyId);
			
		     var url = '../market/commentall/' + marketReplyId;
		     if(commentDiv.html() == ''){   
		    	// 만약 답글 창이 닫혀있을 경우
		    	
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
						
						if('<sec:authentication property="name" />'!= this.memberId){
							disabled = 'disabled';
						}
				
				
						comment +=
						 '<div class="comment_item">'
						+ '<div class="userInfo">'
						+ '<input type="hidden" id="marketCommentId" value="' + this.marketCommentId + '">'
						+ '<input type="hidden" class="marketReplyId" value="'+ this.marketReplyId +'">'
						+ '└ ' + '<span class="memberId" style="color: blue;" onclick="getText(this)">' + this.memberId + '&nbsp' + '</span>'
						+ '<span class="date">' + commentDateCreated + '&nbsp'+ '&nbsp'+ '&nbsp'+ '&nbsp'+ '&nbsp'
						+ '<button class="btn_commentUpdate"' + disabled + '> 수정 </button>'
						+ '<button class="btn_commentDelete"' + disabled + '> 삭제 </button>'
						+ '</div>'
						+ '<div id="marketCommentContent">' + this.marketCommentContent + "</div>"	

						+ '<br>'
						+ '</div>'; // end comment_item
					
					}); // end each()
					
					<sec:authorize access="isAuthenticated()">
					 comment += '<textarea id="addCommentContent" ></textarea>' + '<br>'
				    		+ '<button id="btn_commentAdd" class="button" value="' + marketReplyId + '"> 답글 작성</button>';
				    </sec:authorize>
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
			
			 $("#modal_repCon").val(replyContent);
			 $("#modalReplyId").val(replyId);
			 
			}); // end modal
		
		// 수정 버튼을 클릭하면 선택된 댓글 수정
		$(".modal_modify_btn").on("click", function(){
			console.log(this);
			
			var marketReplyId = $("#modalReplyId").val();
			var marketReplyContent = $("#modal_repCon").val();
						
			console.log("수정된 댓글 번호 : " + marketReplyId + ", 수정된 댓글 내용 : " + marketReplyContent);
			
			
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
						 console.log("modified");
						 modified.innerHTML = '(수정됨)';
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
		console.log('btn_commentAdd');
		var marketReplyId = $(this).val(); // Id 가져오기
		var memberId = $('#memberId').val();
		var marketCommentContent = $('#addCommentContent').val();
		
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
	$(document).on("click", ".btn_commentUpdate", function(){
		$(".commentModifyModal").attr("style", "display:block;");
		
		var commentId = $(this).closest('.comment_item').find('#marketCommentId').val(); 
		var commentContent = $(this).closest('.comment_item').find('#marketCommentContent').text();  // 원본 댓글 내용 가져오기
		
		console.log("commentId : " + commentId, "commentContent : " + commentContent);
		
		 $("#modal_comCon").val(commentContent);
		 $("#modalCommentId").val(commentId);
		 
		}); // end modal
		
	// 선택된 대댓글 수정
	$(".comment_modify_btn").click(function(){
		console.log(this);
		
		var marketCommentId = $("#modalCommentId").val();
		var marketCommentContent = $("#modal_comCon").val();
		console.log("수정된 대댓글 번호 : " + marketCommentId + ", 수정된 대댓글 내용 : " + marketCommentContent);
		
		
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
	$(document).on('click', '.comment_item .btn_commentDelete', function(){
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

function getText(clickedElement) {
  let memberId = clickedElement.textContent;
  console.log("clicked : " + memberId);
  
  $('#addCommentContent').val(memberId +" → ");
} // end getText


$(".modal_modify_btn").on("click", function(){
	console.log("modified");
	modified.innerHTML = '(수정됨)';
});
	</script>

<!-- 수정 모달 -->
<div class="replyModal">

 <div class="modalContent">
  <input type="hidden" id="modalReplyId">  
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
  <input type="hidden" id="modalCommentId">  
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

	$(".modal_cancle").click(function(){	
 	  $(".replyModal").attr("style", "display:none;");
	});

	$(".modify_comment_cancle").click(function(){
		$(".commentModifyModal").attr("style", "display:none;");
	});

	
</script>

</body>
</html>