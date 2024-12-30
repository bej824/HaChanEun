<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.food.searcher.domain.MarketVO" %>
<%@ page import="com.food.searcher.domain.MarketReplyVO" %>
<!DOCTYPE html>
<html>
<head>

<style type="text/css">
.button, .btn_update, .btn_delete, .btn_comment, .commentAdd {
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

marketContent {
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
		<textarea id="marketContent" rows="20" cols="120" readonly>${marketVO.marketContent }</textarea>
		
	</div>
	
		<!-- 사진 start -->
		<!-- 사진 end -->	
	
	

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
	
	<ul id="allReply">
	<div id="replyArea">
		<div class="reply_item">
		<!-- 댓글 표시 -->
		<span>${marketReplyVO.memberId }</span>		
		<span class="replyDate">${marketReplyVO.replyDateCreated }</span>
		<input type="hidden" id="memberId" value="${sessionScope.memberId}">
		<p class="marketReplyContent">${marketReplyVO.marketReplyContent }</p>
		
		
	<!-- 댓글 작성 -->
	</div>
		<div class="replyadd" style="text-align: center;">
		<textarea id="marketReplyContent" rows="3" cols="50"></textarea>
		<button id="replyBtnAdd">댓글 작성</button>
	</div>
		
	</div>
	</ul>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$('#deleteMarket').click(function() {
				 if (confirm('삭제하시겠습니까?')) {
					$('#deleteForm').submit(); // form 데이터 전송
				 }
			});
		}); // end document
		
	</script>
	
	<input type="hidden" id="memberId" value="${sessionScope.memberId}">
	
	<!-- 댓글 JavaScript -->
	
	<script type="text/javascript">
	
	getAllReply();
	
	replyBtnAdd.addEventListener("click", function(){
		
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
						$("#marketReplyContent").val(""); // text area에 있는 댓글 내용 삭제
						getAllReply();
					}
				}
			}); // end ajax
		}); // end replyAdd.click()
	
	function getAllReply() {
		
		var marketId = $('#marketId').val();
		var url = '../market/all/' + marketId;
		$.getJSON(
			url, 			
			function(data) {
				console.log(data);
				
				var list = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
				var memberId = '${sessionScope.memberId}';
				console.log('memberId = ' + memberId);
				
				$(data).each(function(){
					console.log(this);
				  
					// 전송된 replyDateCreated는 문자열 형태이므로 날짜 형태로 변환이 필요
					var replyDateCreated = new Date(this.replyDateCreated);
					var disabled = '';
					var readonly = '';
					
					if('<%=session.getAttribute("memberId") %>' != this.memberId) {
						disabled = 'disabled';
						readonly = 'readonly';
					}
			
			let marketReplyContent = document.createElement("p");
			marketReplyContent.List.add("replyContent");
			marketReplyContent.innerHTML = marketReplyVO.marketReplyContent;
			
		
		}
			
	} // end function(data)
} // end getAllReply
		
	
	
	
	
	</script>
</body>
</html>