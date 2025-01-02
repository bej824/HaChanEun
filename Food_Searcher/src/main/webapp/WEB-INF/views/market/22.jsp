<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>

<style type="text/css">
.button, {
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


.comment_item {
    margin-left: 30px;
    margin-bottom: 10px;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #f9f9f9;
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

button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

.reply_area {
	width : 500px;
    margin-bottom: 15px;
    padding: 10px 10px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background-color: #f7f7f7;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    position: relative;
}


.reply_info {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    gap: 10px;
    font-size: 14px;
    color: #666;
}

.reply_info .memberId {
    font-weight: bold;
    color: #333;
}

.reply_info_wrapper {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.reply_insert {
  width: 700px;
  height: 110px;
  padding: 12px 20px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  background-color: rgb(240, 240, 240, 0);
  font-size: 16px;
  resize: none;
}


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
	
	<% if("admin1".equals(session.getAttribute("memberId"))){ %>
	<button onclick="location.href='modify?marketId=${marketVO.marketId }'" class="button">글수정</button>
	<%} %>
	
	<% if("admin1".equals(session.getAttribute("memberId"))){ %>
	<button id="deleteMarket" class="button">글 삭제</button>
	<form id="deleteForm" action="delete" method="POST">
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
		<div id="input_wrapper">
		<textarea name="marketReplyContent" id="reply_content" class="reply_insert"></textarea>
		</div>
		<button id="btnAdd" class="button">댓글 작성</button>
	<%} %>
	
	<div style="text-align: center;">		
		<div id="replies"></div>
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
	<input type="hidden" id="memberId" value="${sessionScope.memberId}">
	
		
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
						var readonly = '';
						
						if('<%=session.getAttribute("memberId") %>' != this.memberId) {
							disabled = 'disabled';
							readonly = 'readonly';
						}
						
						if(replyDateCreated != null) {
						list += "<div class='reply_area'>" +
				        '<input type="hidden" id="marketReplyId" value="' + this.marketReplyId + '">' +
				        "<ul class='reply_info'>" +
				        '<input type="hidden" id="memberId" value="<%=session.getAttribute("memberId") %>">' +
				        "<li class='memberId'>" + this.memberId + "</li>" +
				        "<li class='replyDateCreated'>" + replyDateCreated + "</li>" +
				        
				        "<li class='replyModify' onclick='replyModify(" + 
		        		this.marketReplyId + ",\"" + this.marketReplyContent + "\");'>댓글수정</li>" + 
		        		
		        		"<li class='btn_delete' onclick='btn_delete'>댓글 삭제</li>" +
		        		
		        		"<li class='btn_comment' onclick='btn_comment'>답글 쓰기</li> " +
		        		
				        "</ul>" +
				        "<div class='reply_view_wrapper'>" +
				        "<div class='reply_view'>" + this.marketReplyContent + "</div>" +
				        "</div>" + // end reply_view_wrapper
				        
						} else {						
							list += "<div class='comment_box'>" +
							'<input type="hidden" id="marketCommentId" value="' + this.marketCommentId + '">' +
							"<ul class='reply_info'>" +
							'<input type="hidden" id="memberId" value="<%=session.getAttribute("memberId") %>">' +
					        "<li class='memberId'>" + this.memberId + "</li>" +
					        "<li class='commentDateCreated'>" + commentDateCreated + "</li>" +
					        
					        "<li class='commentModify' onclick='commentModify(" + 
			        		this.marketCommentId + ",\"" + this.commentContent + "\");'>댓글수정</li>" + 
			        		
			        		"<li class='btn_delete' onclick='btn_delete'>댓글 삭제</li>" +
			        		
			        		"<li class='addComment' onclick='addComment'>답글 쓰기</li> " +
			        		 "</ul>" +
			        		 
			        		 "<div class='comment_view'>" + this.commentContent + "</div>" +
			        		 "</div>";
			        		 
						} 
				        "</div>"; // end reply_area
				        
						list += '</div>';
				}); 		
					$('#replies').html(list); // 저장된 데이터를 replies div 표현
				}
			);
		}// end getAllReply()
		
	function replyModify(marketReplyId, marketReplyContent){
			var marketReplyContent = "" // 댓글 내용 초기화

				marketReplyContent += "<ul class='reply_info'>"
				+ "<li class='replyModify' onclick='btn_update'> 수정 완료 </li>"
				+ "</ul>"
				+ "<div>"
				+ "<div class='reply_view_wrapper'>"
				+ "<textarea id='reply_view' name='marketReplyContent' style='width:100%;'>"+ this.marketReplyContent +"</textarea>"
				+ "</div>"; // end view_wrapper
				
				
				$("#replies" + this.marketReplyId).replaceWith(reply);
				// marketReplyId의 area_wrapper에 있는 내용을 reply로 바꾼다는 내용인데
				// 그럼 이 modify에도 area wrapper가 있어야하는 거 아닌?
				// 댓글 삭제 버튼도 넣고... 위에 코드랑 비슷하게 해야하나

		} // end replyModify
	
		
		// 수정 버튼을 클릭하면 선택된 댓글 수정
		$('#replies').on('click', '.reply_item .btn_update', function(){
			console.log(this);
			
			// 선택된 댓글의 replyId, replyContent 값을 저장
			// prevAll() : 선택된 노드 이전에 있는 모든 형제 노드를 접근
			var marketReplyId = $(this).prevAll('#marketReplyId').val();
			var marketReplyContent = $(this).prevAll('#marketReplyContent').val();
			console.log("선택된 댓글 번호 : " + marketReplyId + ", 댓글 내용 : " + marketReplyContent);
			
			// ajax 요청
			$.ajax({
				type : 'PUT', 
				url : '../market/' + marketReplyId,
				headers : {
					'Content-Type' : 'application/json'
				},			
				data: marketReplyContent,
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 수정 성공!');
						getAllReply();
					}
				}
			});
			
		});	// end btn_update
		
	
		
		// 삭제 버튼을 클릭하면 선택된 댓글 삭제
		$('#replies').on('click', '.reply_area .btn_delete', function(){
			console.log(this);
			var marketId = $('#marketId').val(); // 게시판 번호 데이터
			// var marketReplyId = $(this).prevAll('#marketReplyId').val();
			var marketReplyId = $(this).closest('.reply_area').find('#marketReplyId').val();
			// 삭제 버튼과 가장 가까운 replyarea의 Id 찾기

			
			// ajax 요청
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
					}
				}
			});
		}); // end replies.on()	
		
		function addComment(marketReplyId, marketId){
   			
   				var comment = "";
   				comment += "<div class='comment_box'>";
   				comment += 	"<span class='reply_ico'>└</span>";
   				comment += 		"<ul class='reply_info'>";
   				comment += 			"<li class='id'>"+id+"</li>";
   				comment += 			"<li class='re_reply_btn' onclick='re_reply_btn("+reply_Idx+","+bidx+");'>댓글등록</li>";
   				comment += 			"<li class='cancel' onclick='getCommentList();'>취소</li>";//취소버튼 클릭시 댓글 목록리스트 함수 실행
   				comment +=		"</ul>";
   				comment += 	"<div class='reply_view_wrapper'>";
   				comment += 		"<textarea id='reply_Edit_Content' name='reply_Content' style='width:100%;'></textarea>";
   				comment += 		"<input type='hidden' name='rparent' value="+reply_Idx+">";
   				comment += 	"</div>";
   				comment += "</div>";
	   				$(".comment_box"+ marketReplyId).html(comment);
   			
   			//display 여부에 따라 show,hide
    			if($(".re_reply_area"+reply_Idx).css("display") == "none"){
    				$(".re_reply_area"+reply_Idx).show();
    			}else{
    				$(".re_reply_area"+reply_Idx).hide();
   			}
   		}
		
		// 대댓글 작성
		$('#replies').on('click', '.reply_item .btn_comment', function() {
		    var marketReplyId = $(this).closest('.reply_item').find('#marketReplyId').val(); // 댓글 ID
		    var memberId = $('#commentMemberId').val(); // 사용자 ID
		    var commentContent = $(this).closest('.reply_item').find('#commentContent').val(); // 대댓글 내용

		    var obj = {
		        'marketReplyId': marketReplyId,
		        'memberId': memberId,
		        'commentContent': commentContent
		    };

		    $.ajax({
		        type: 'POST',
		        url: '../market/detail', // 대댓글 controller
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
		}); // end comment add
		
		
		
		

		
		
	}); // end document
	</script>


</body>
</html>