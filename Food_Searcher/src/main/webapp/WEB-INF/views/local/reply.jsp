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

</style>

<meta charset="UTF-8">
<title>댓글 헤더</title>
</head>
<body>
	<div class="replyBox">
		<div id="replies"></div>

	<div class="reply">
	<%if(session.getAttribute("memberId") != null){ %>
		<div class="replyMemberId">
		<%=session.getAttribute("memberId") %><input type="hidden" id="memberId" value="<%=session.getAttribute("memberId") %>">
		<input type="text" id="headerReplyContent">
		<div class = "timeButton">
		<button id="btnAdd" class="button">작성</button>
		</div>
	</div>
	<%} %>
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
				console.log(replyContent);
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
							getAllReply(); // 함수 호출		
						}
					}
				});
			}); // end btnAdd.click()
			

			
			// 게시판 댓글 전체 가져오기
			function getAllReply() {
				console.log(this);
				let boardId = $('#Id').val();
				console.log("boardID : " + boardId);

				let url = 'replyAll?localId=' + boardId;
				console.log("address : " + url);
				$.getJSON(
					url, 		
					function(data) {
						// data : 서버에서 전송받은 list 데이터가 저장되어 있음.
						// getJSON()에서 json 데이터는 
						// javascript object로 자동 parsing됨.
						console.log("댓글 목록 : ", data);
						
						let list = ''; // 댓글 데이터를 HTML에 표현할 문자열 변수
						
						// $(컬렉션).each() : 컬렉션 데이터를 반복문으로 꺼내는 함수
						$(data).each(function(){
							// this : 컬렉션의 각 인덱스 데이터를 의미
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

							console.log(replyDate);

							let disabled = '';
							let readonly = '';
							
							if('<%=session.getAttribute("memberId") %>' != this.memberId) {
								disabled = 'disabled';
								readonly = 'readonly';
							}
							
							list += '<input type="hidden" id="replyId" value="'+ this.replyId +'">'
								+ '<p class="replyMemberId">' + this.memberId
								+ '<input type="text" id="replyContent" value="'+ this.replyContent +'">'
								+ '</p>' + '<p class = "timeButton">'
								+ replyDate
								+ '<%if(session.getAttribute("memberId") != null){ %>'
								+ '<button class="button" '+ disabled +' >수정</button>'
								+ '<button class="button" '+ disabled +' >삭제</button>'
								+ '</p>'
								+ '<br>'
								+ '	<%} %>'
						}); // end each()
				        
						$('#replies').html(list); // 저장된 데이터를 replies div 표현
					} // end function()
				); // end getJSON()
			} // end getAllReply()	


		}); // end document()
	</script>

</body>
</html>