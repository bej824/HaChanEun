<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.food.searcher.domain.MarketVO" %>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<title>전통시장</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
	
	<%  String memberId = null; 
		boolean log;
		if(session.getAttribute("memberId") != null) {
			log = false;
		}
	%>
	<!-- 변수명 ? -->
	
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

	<button onclick="location.href='list'">글 목록</button>
	
	
	<button onclick="location.href='modify?marketId=${marketVO.marketId }'">글수정</button>

	<button id="deleteMarket">글 삭제</button>
	<form id="deleteForm" action="delete" method="POST">
		<input type="hidden" name="marketId" value="${marketVO.marketId }">
	</form>
	
	<div style="text-align: center;">
		<input type="text" id="marketReplyContent">
		<button id="btnAdd">작성</button>
	</div>

	
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
					}
				}
			});
		}); // end btnAdd.click()
		
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
						
						if(memberId != this.memberId) {
							disabled = 'disabled';
							readonly = 'readonly';
						}

						list += '<div class="reply_item">'
							+ '<pre>'	
							+ '<input type="hidden" id="marketReplyId" value="'+ this.marketReplyId +'">'
							+ this.memberId
							+ '&nbsp;&nbsp;' // 공백
							+ '<input type="text" id="marketReplyContent" value="'+ this.marketReplyContent +'">'
							+ '&nbsp;&nbsp;'
							+ replyDateCreated
							+ '&nbsp;&nbsp;'
							+ '<button class="btn_update" >수정</button>'
							+ '<button class="btn_delete" >삭제</button>'
							+ '</pre>'
							+ '</div>';
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
				data : marketReplyContent, 
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 수정 성공!');
						getAllReply();
					}
				}
			});
			
		});	
		
		// 삭제 버튼을 클릭하면 선택된 댓글 삭제
		$('#replies').on('click', '.reply_item .btn_delete', function(){
			console.log(this);
			var marketId = $('#marketId').val(); // 게시판 번호 데이터
			var marketReplyId = $(this).prevAll('#marketReplyId').val();
			
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
		
	}); // end document
	</script>


</body>
</html>