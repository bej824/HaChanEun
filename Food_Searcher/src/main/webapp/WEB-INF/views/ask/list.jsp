<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="../resources/css/Reply.css">
<meta charset="UTF-8">
<style>
.askContent {
	width: 400px;
	height: 50px;
}

.info {
	margin: 10px;
}

</style>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<meta name="authenticatedUser" content="${authentication.name}">
<title>상품 문의</title>
</head>
<body>
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	<h2>상품 문의</h2>
	
	<div class="info">
	<span>구매한 상품의 취소/반품은 구매내역에서 신청 가능합니다.</span><br>
	<span>상품문의 및 후기게시판을 통해 취소나 환불, 반품 등은 처리되지 않습니다.</span><br>
	</div>
	
	<div class="askBox">
		<br>
			<sec:authorize access="isAnonymous()">
			* 문의를 작성하려면 로그인 해주세요.
			</sec:authorize>
			
			<sec:authorize access="isAuthenticated()">
				<input type="hidden" id="itemId" name="itemId" />
			 	<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
  	 			<input type="text" name="askContent" class="askContent" placeholder="문의 내용을 입력하세요." required><br>
  	 			<button id="askAdd" class="button">문의 작성</button>
			</sec:authorize>
	</div>
	
	<div class="ask_item"></div>
		
<script type="text/javascript">
$(document).ajaxSend(function(e, xhr, opt){
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	xhr.setRequestHeader(header, token);
});	 

	
$(document).ready(function(){
	getAllAsk();
	console.log("게시글 ID : " + $('#itemId').val());
	
	$("#askAdd").on("click", function() {
		let itemId = $('#itemId').val();
		let memberId = $('#memberId').val();
		let askContent = $('input[name="askContent"]').val();

		
		let obj = {
			'itemId' : itemId,
			'memberId' : memberId,
			'askContent' : askContent
		};
		console.log(obj);
		
		if(!askContent) {
			alert("내용을 입력해주세요.");			
		}
		
		$.ajax({
			type : 'POST',
			url : '../ask',
			headers : { // 헤더 정보
				'Content-Type' : 'application/json' // json content-type 설정
			}, 
			data : JSON.stringify(obj), 
			success : function(response) {
				console.log(response);
				if(result == 1) {
					alert('문의가 입력되었습니다.');
					getAllAsk();
					$(".askContent").val("");
				} else {
					error: function (xhr) {
			        alert(xhr.responseText); // "하루에 한 번만 문의를 작성할 수 있습니다."
				}
			}
		}); // end ajax
		
		
	}); // end askAdd
	
	function getAllAsk() {
		let itemId = $('#itemId').val();
		let memberId = $('#memberId').val();
		let url = '../ask/list/' + itemId;
		
		console.log("itemId : " + itemId, "memberId : " + memberId);
		
		$.getJSON(url, function(data) {
				console.log(data);
						
				var list = '';
						
				if(data.length == 0) {
					list += '<div class="noAsk">작성된 문의가 없습니다.</div>'
							
					} else {
						$(data).each(function(){
							console.log(this);
									
							let askDate = new Date(this.askDate).toLocaleString();
							let disabled = '';
													
							if(memberId != this.memberId){
								disabled = 'disabled';
							}
							
							list +=
							  '<div class="ask_item" value="' + this.askId + '">'
							  + '<div class="userInfo">'
							  + '<input type="hidden" id="askId" value="'+ this.askId +'">'
							  + '<span class="memberId">' + this.memberId + '&nbsp' + '</span>'
							  + '<span class="askDate">' + askDate + '&nbsp' + '&nbsp'+ '&nbsp'+ '&nbsp'+ '&nbsp' + '</span>'
							  + '</div>' // end userInfo
							  + '<button class="btn_update"' + disabled + ' > 수정 </button>' + '&nbsp'
							  + '<button class="btn_delete"' + disabled + ' > 삭제 </button>'
							  + '<div class="askContent">' + this.askContent + "</div>"
							  list += "</div>"; // end ask_item
						});
						$(".ask_item").html(list);
					}
				});
			}
			
		// 모달창 띄우기
		$(document).on("click", ".btn_update", function(){
			$(".replyModal").attr("style", "display:block;");
			var askId = $(this).closest('.ask_item').find('#askId').val();   // 댓글 Id 가져오기
			var askContent = $(this).closest('.ask_item').find(".askContent").text(); // 원본 댓글 내용 가져오기
			
			console.log("askId : " + askId, ", askContent : " + askContent);
			
			 $("#modal_repCon").val(askContent);
			 $("#modalReplyId").val(askId);
			 
			});
			
			// 수정 버튼을 클릭하면 선택된 댓글 수정
		$(".modal_modify_btn").on("click", function(){
			console.log(this);
				
			let askId = $("#modalReplyId").val();
			let askContent = $("#modal_repCon").val();
							
			console.log("수정된 댓글 번호 : " + askId + ", 수정된 댓글 내용 : " + askContent);
				
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : '../ask/' + askId,
					headers : {
						'Content-Type' : 'application/json' 
					},
					data : askContent,
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('문의가 수정되었습니다.');
							getAllAsk();
							 $(".replyModal").attr("style", "display:none;");
							 console.log("modified");
							 modified.innerHTML = '(수정됨)';
						} else {
							alert('문의 수정 실패');
						}
					}
					});
			}); // end modal_modify_btn	
			
		$(".modal_cancle").click(function(){	
		  	$(".replyModal").attr("style", "display:none;");
		});
			
			
		$('.ask_item').on('click', '.btn_delete', function(){
			console.log(this);
			let askId = $(this).closest('.ask_item').find('#askId').val();
			let deleteConfirm = confirm('정말로 삭제하시겠습니까?');
			
			if(deleteConfirm) {
			
			$.ajax({
				type : 'DELETE', 
				url : '../ask/delete/' + askId,
				headers : {
					'Content-Type' : 'application/json'
				},
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 삭제 성공!');
						getAllAsk();
					} else {
						alert('댓글 삭제 실패')
						}
					}
				});
				
			}
		}); // end btn_delete
		
		
			
			
		
		}); // end document
	
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
	
</body>
</html>