<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<script type="text/javascript">
	
	$(document).ready(function(){
	
	// 게시판 대댓글 전체 가져오기
				function getAllComment() {
					let replyId = $(this).prevAll('#replyId').val();
					let url = 'commentAll/' + replyId;
					
					console.log("commentId : " + replyId);
					console.log("address : " + url);
					$.getJSON(
						url, 		
						function(comment) {
							console.log("대댓글 목록 : ", comment);
							
							var comment = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
							
							$(data).each(function(){
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
								
								if('<%=session.getAttribute("memberId") %>' != this.memberId) {
									disabled = 'disabled';
									readonly = 'readonly';
								}
								
								comment += '<div class="comment_item">'
									+ '<input type="hidden" id="replyId" value="'+ this.replyId +'">'
									+ this.memberId
									+ '&nbsp;&nbsp;&nbsp;&nbsp;' + replyDate
									+ '<input type="text" id="replyContent" value="'+ this.replyContent +'">'
									+ '<%if(session.getAttribute("memberId") != null){ %>'
									+ '<button class="btn_delete" '+ disabled +' >삭제</button>'
									+ '<button class="btn_update" '+ disabled + '>수정</button>'
									+ '<br> <br> <br>'
									+ '<%} %>'
									+ '</div>'
									
							}); // end each()
								comment += '<input type="text" id="commentContent">'
										+ '<button id="commentAdd" class="btn_add">작성</button>'
					        
							$('#comment').html(comment);
						} // end function()
					); // end getJSON()
					
				} // end getAllComment()

			}); // end document()
			</script>

</body>
</html>