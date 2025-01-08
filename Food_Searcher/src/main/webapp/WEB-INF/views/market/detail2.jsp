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
  padding: 6px 12px;
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
  width: 300px;
  height: 100px;
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
	left : 20px;
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
	width:500px;
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


<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<title>전통시장</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
<%session.getAttribute("memberId"); %>

	<!-- 게시글 -->
	<h2>글 보기</h2>
	<div>
		<p>글 번호 : ${marketVO.marketId }</p>
	</div>
	<div>
		<p>제목 : ${marketVO.marketTitle }</p>
	</div>
	
	<input type="hidden" id="marketId" value="${marketVO.marketId }">
	
	<div>
		<textarea rows="20" cols="120" readonly>${marketVO.marketContent }</textarea>
		
	</div>
	
	<div class="image"></div>

	<button onclick="location.href='list'" class="button">글 목록</button>
	<br><br>
	
		
	<% if("admin1".equals(session.getAttribute("memberId"))){ %>
	<button onclick="location.href='modify?marketId=${marketVO.marketId }'" class="button">글수정</button>
	<%} %>
	
	<% if("admin1".equals(session.getAttribute("memberId"))){ %>
	<button id="deleteMarket" class="button">글 삭제</button>
	<form id="deleteForm" action="delete">
		<input type="hidden" name="marketId" value="${marketVO.marketId }">
	</form>
	<%} %>

	
	<% if(session.getAttribute("memberId") == null){ %>
	* 댓글은 로그인이 필요한 서비스입니다.
	<a href="/searcher/access/login">로그인하기</a>
	<%} %>
	
	<% if(session.getAttribute("memberId") != null){ %>
		<input type="hidden" name="marketId" value=${marketVO.marketId }>
		<input type="hidden" name="memberId" value=${sessionScope.memberId }>
		<textarea name="marketReplyContent" id="marketReplyContent" class="reply_insert"></textarea>
		<button id="btnAdd" class="button">댓글 작성</button>
	<%} %>
	
	
		<div id="replies">
		<div class="reply_item">
			<div class="comments"></div>
		</div>
		</div>
	
	
	

	
	
	<script type="text/javascript">
		$(document).ready(function() {
			$('#deleteMarket').click(function() {
				 if (confirm('삭제하시겠습니까?')) {
					$('#deleteForm').submit(); // form 데이터 전송
				 }	
			});
		}); // end document
		
	</script>
	
	<input type="hidden" id="marketId" value="${marketVO.marketId}">
	<input type="hidden" id="memberId" value="<%=session.getAttribute("memberId") %>">
		
	<!-- 댓글 -->
	
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
						var disable = '';
						
						if('<%=session.getAttribute("memberId") %>' != this.memberId) {
							disabled = 'disabled';
						}
						
						if('<%=session.getAttribute("memberId") %>' == null) {
							disable = 'disabled';
						}
						
						
						list +=
							'<div class="reply_item" value="' + this.marketReplyId + '">'
						
							+ '<div class="userInfo">'
							+ '<input type="hidden" id="marketReplyId" value="'+ this.marketReplyId +'">'
							+ '<span class="memberId">' + this.memberId + '&nbsp'
							+ '<span class="date">' + replyDateCreated + " "
							+ '</div>'
							+ '<br>'
							
							+ '<div class="marketReplyContent">' + this.marketReplyContent + "</div>"
							+ '<br>'
							
							+ '<div class = "replyFooter">'
							+ '<button class="btn_update"' + disabled + ' > 수정 </button>'
							+ '<button class="btn_delete"' + disabled + ' > 삭제 </button>'
							+ '<button class="btn_commentAdd" ' + disable + ' > 답글 작성 </button>'
							+ '<button class="btn_commentList" value="' + this.marketReplyId + '"> 답글 보기 </button> '
							+ '<input type="hidden" id="commentMemberId" value="' + this.memberId + '">' 
							+ "</div>" // end replyFooter
							
							+ '<ul class="comment_item"></ul>'
							+ "</div>" // end reply_item
							
							
					
					}); // end each()
						
					$('#replies').html(list); // 저장된 데이터를 replies div 표현
					
					
					
				} // end function
			);  // end JSON
		}// end getAllReply()
		
		
		
		
		
		$(document).on("click", ".btn_commentList", function(){
			var marketReplyId = $(this).closest('.reply_item').find('#marketReplyId').val();
			var commentDiv = $(this).closest('.reply_item').find('.comment_item');
			
			console.log("btn_commentList | " + "marketReplyId : " + marketReplyId + " |");
			
			
		     var url = '../market/commentall/' + marketReplyId;
		        
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
						
						if('<%=session.getAttribute("memberId") %>' != this.memberId) {
							disabled = 'disabled';
						}
						
				
						comment +=
						 '<ul class="comment_item">'
						+ '<div class="userInfo">'
						+ '<input type="hidden" id="marketCommentId" value="' + this.marketCommentId + '">'
						+ '<input type="hidden" class="marketReplyId" value="'+ this.marketReplyId +'">'
						+ '<span class="memberId">' + this.memberId + ""
						+ '<span class="date">' + commentDateCreated + ""
						+ '</div>'
						+ '<br>'
						
						+ '<div class="marketCommentContent">' + this.marketCommentContent + "</div>"

						+ '<br>'
						+ '<div class = "replyFooter">'
						+ '<button class="btn_updateComment" ' + disabled + '> 수정 </button>'
						+ '<button class="btn_deleteComment"' + disabled + ' > 삭제 </button>'
						+ '<button class="btn_commentAdd"> 답글 </button>'
						
						+ '</ul>'; // end comment_item
					
					}); // end each()
						
					commentDiv.html(comment); // 저장된 데이터를 comments div 표현
					
				
				} // end function
			);  // end JSON
		}); //end commentList onclick
	
		// 수정 버튼 클릭 시 모달창 띄우기
		$(document).on("click", ".btn_update", function(){
			$(".replyModal").attr("style", "display:block;");
			
			var replyId = $(this).closest('.reply_item').find('#marketReplyId').val();   // 댓글 Id
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
				});
			} // end deleteConfirm
		}); // end btn_delete
	
	// 대댓글 작성 버튼 클릭 시 모달창 띄우기
	$(document).on("click", ".btn_commentAdd", function(){
		$(".commentModal").attr("style", "display:block;");
		
		var commentReplyId =$(this).closest('.reply_item').find('#marketReplyId').val();
		var memberId = $(this).closest('.reply_item').find('#commentMemberId').val();	
		console.log("commentReplyId : " + commentReplyId, "memberId : " + memberId);
		
		 $("#commentReplyId").val(commentReplyId);
		 $("#memberId").val(memberId);
	});
		
			
	// 대댓글 작성 버튼
	$('.modal_comment_btn').click(function(){
		var marketReplyId =$('#commentReplyId').val();
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


<!-- 대댓글 모달 -->
<div class="commentModal">

 <div class="modalCommentContent">
	<input type="hidden" id="commentMemberId">  
	<input type="hidden" id="commentReplyId">
	
  <div>
   <textarea id="marketCommentContent" name="modal_comment_content"></textarea>
  </div>
  
  <div>
   <button type="button" class="modal_comment_btn">작성</button>
   <button type="button" class="modal_comment_cancle">취소</button>
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

$(".modal_comment_cancle").click(function(){
	$(".commentModal").attr("style", "display:none;");
});

$(".modify_comment_cancle").click(function(){
	$(".commentModifyModal").attr("style", "display:none;");
});

	
</script>

</body>
</html>