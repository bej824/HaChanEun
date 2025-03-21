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

.userInfo {
	margin:10px;
	padding:5px;
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
	<br>
	<sec:authorize access="isAnonymous()">
		* 문의를 작성하려면 로그인 해주세요.
	</sec:authorize>
					
	<sec:authorize access="isAuthenticated()">
		  	<input type="text" name="askContent" class="askContent" placeholder="문의 내용을 입력하세요." required><br>
		  	<button id="askAdd" class="button">문의 작성</button>
	</sec:authorize>
	
	<div class="askBox">
		<div id="asks">
			<div class="ask_item">
				<input type="hidden" id="itemId" name="itemId" />
				<input type="hidden" id="memberId" value=<sec:authentication property="name" />>
				<input type="hidden" id="role" value="<sec:authentication property='authorities' />">
				</div>
		</div>
	</div>
	
	
<script type="text/javascript">
$(document).ajaxSend(function(e, xhr, opt){
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	xhr.setRequestHeader(header, token);
});	 

	
$(document).ready(function(){
	getAllAsk();
		
	$("#askAdd").on("click", function() {
		let itemId = $('#itemId').val();
		let memberId = $('#memberId').val();
		let askContent = $('input[name="askContent"]').val();

		
		let obj = {
			'itemId' : itemId,
			'memberId' : memberId,
			'askContent' : askContent
		};
		
		if(!askContent) {
			alert("내용을 입력해주세요.");			
		}
		
		$.ajax({
			type : 'POST',
			url : '../product',
			headers : { // 헤더 정보
				'Content-Type' : 'application/json; charset=UTF-8' // json content-type 설정
			}, 
			data : JSON.stringify(obj), 
			success: function (response) {
	            alert("문의가 등록되었습니다.");
	            getAllAsk();
	            location.reload(true);
		        },
		        error: function (xhr) {
		            alert("문의는 하루에 한 번만 작성 가능합니다.");
		        }
		    });
		
	}); // end askAdd
	
		// 모달창 띄우기
		$(document).on("click", ".btn_update", function(){
			$(".replyModal").attr("style", "display:block;");
			let askId = $(this).closest('.ask_item').find('#askId').val();   // 댓글 Id 가져오기
			let askContent = $(this).closest('.ask_item').find(".askContent").text(); // 원본 댓글 내용 가져오기
			
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
					url : '../product/' + askId,
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
							 location.reload(true);
						} else {
							alert('문의 수정 실패');
						}
					}
					});
			}); // end modal_modify_btn	
			
		$(".modal_cancle").click(function(){	
		  	$(".replyModal").attr("style", "display:none;");
		});
		
			
		$(".answer_cancle").click(function(){	
			let answerContent = $('#answerContent').val();
			$("#answerContent").val("");
		  	$(".answerModal").attr("style", "display:none;");
		});
		
		$(".answer_modify_cancle").click(function(){	
			let answerModifyContent = $('#answerModifyContent').val();
			$("#answerModifyContent").val("");
		  	$(".answerModifyModal").attr("style", "display:none;");
		});
			
		$('#asks').on('click', '.btn_delete', function(){
			console.log(this);
			let askId = $(this).closest('.ask_item').find('#askId').val();
			let deleteConfirm = confirm('정말로 삭제하시겠습니까?');
			
			if(deleteConfirm) {
			
			$.ajax({
				type : 'DELETE', 
				url : '../product/delete/' + askId,
				headers : {
					'Content-Type' : 'application/json'
				},
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 삭제 성공!');
						getAllAsk();
						location.reload(true);
					} else {
						alert('댓글 삭제 실패')
						}
					}
				});
				
			}
		}); // end btn_delete
		
		$(document).on("click", '.addAnswer', function(){ // 답변 작성 모달
			$(".answerModal").attr("style", "display:block;");
			let askId = $(this).closest('.ask_item').find('#askId').val();
			
			console.log("askId : " + askId);
			
			 $("#modalAnswerId").val(askId);
			 
			});
		
		// 답변 입력
		$(".answer_add_btn").on("click", function(){
			console.log(this);
			let askId = parseInt($("#modalAnswerId").val());
			let answerContent = $('#answerContent').val();
			let memberId = $('#memberId').val();
							
			console.log("문의 번호 : " + askId + ", 답변 내용 : " + answerContent, "아이디 : " + memberId);
				
			let obj = {
				'askId' : askId,	
				'answerContent' : answerContent,
				'memberId' : memberId
			};
			console.log(obj);
				
				// ajax 요청
				$.ajax({
					type : 'POST', 
					url : '../product/answer-post/' + askId,
					headers : {
						'Content-Type' : 'application/json' 
					},
					data : JSON.stringify(obj),
					success : function(data) {
						console.log(data);
							getAllAsk();
							alert("답변이 등록되었습니다.");
							 $(".answerModal").attr("style", "display:none;");
							 $("#answerContent").val("");
							 location.reload(true);
							}, 
							error:function(xhr) {
								alert("문의당 답변은 한 개까지만 등록 가능합니다.");
						}
				});
			});
		
		// 모달창 띄우기
		$(document).on("click", ".btn_answerUpdate", function(){
			$(".answerModifyModal").attr("style", "display:block;");
			let answerId = $(this).closest('.ask_item').find('#answerId').val();   // 댓글 Id 가져오기
			let answerContent = $(this).closest('.ask_item').find(".answerContent").text(); // 원본 댓글 내용 가져오기
			
			console.log("answerId : " + answerId, ", answerContent : " + answerContent);
			
			 $("#answerModifyContent").val(answerContent);
			 $("#modifyAnswerId").val(answerId);
			 
			});
			
			// 수정 버튼을 클릭하면 선택된 댓글 수정
		$(".answer_modify_btn").on("click", function(){
			console.log(this);
				
			let answerId = $("#modifyAnswerId").val();
			let answerContent = $("#answerModifyContent").val();
							
			console.log("수정된 댓글 번호 : " + answerId + ", 수정된 댓글 내용 : " + answerContent);
				
				// ajax 요청
				$.ajax({
					type : 'PUT', 
					url : '../product/answer-modify/' + answerId,
					headers : {
						'Content-Type' : 'application/json' 
					},
					data : answerContent,
					success : function(result) {
						console.log(result);
						if(result == 1) {
							alert('문의가 수정되었습니다.');
							getAllAsk();
							 $(".answerModifyModal").attr("style", "display:none;");
							 console.log("modified");
							 location.reload(true);
						} else {
							alert('문의 수정 실패');
						}
					}
					});
			});
		
		$('#asks').on('click', '.btn_answerDelete', function(){
			let answerId = $(this).closest('.ask_item').find('#answerId').val();
			let deleteConfirm = confirm('정말로 삭제하시겠습니까?');
			
			if(deleteConfirm) {
			
			$.ajax({
				type : 'DELETE', 
				url : '../product/answer-delete/' + answerId,
				headers : {
					'Content-Type' : 'application/json'
				},
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('댓글 삭제 성공!');
						getAllAsk();
						location.reload(true); // 고칠것
					} else {
						alert('댓글 삭제 실패')
						}
					}
				});
				
			}
		}); // end btn_delete
			
		$(document).ready(function() {
		    getAllAsk();
		});

		function getAllAsk() {
		    let itemId = $('#itemId').val();
		    let memberId = $('#memberId').val();
		    let url = '../product/ask/' + itemId;
		    let role = $('#role').val();
		    
		    $.getJSON(url, function(data) {
		        console.log(data);
		        
		        var list = '';
		        
		        if (data.length == 0) {
		            list += '<div class="noAsk">작성된 문의가 없습니다.</div>'
		        } else {
		            $(data).each(function() {

		                let askDate = new Date(this.askDate).toLocaleString();
		                let disabled = (memberId != this.memberId) ? 'disabled' : '';
		                
		                list += '<div class="ask_item" value="' + this.askId + '">'
		                      + '<div class="userInfo">'
		                      + '<input type="hidden" id="askId" value="' + this.askId + '">'
		                      + '<span class="askLabel">질문</span>'
		                      + '<span class="memberId">' + this.memberId + '&nbsp</span>'
		                      + '<span class="askDate">' + askDate + '&nbsp</span>'
		                      + '<button class="btn_update" ' + disabled + '> 수정 </button>'
		                      + '<button class="btn_delete" ' + disabled + '> 삭제 </button>'
		                      + '</div>' // end userInfo
		                      + '<div class="askContent">' + this.askContent + '</div>'
		                      + '<div class="answer">'
				                if (role.includes("ROLE_SELLER")) {
				                    list += '&nbsp;<button class="addAnswer">답변 작성</button>';
				                }
		                
		                list += '</div>' // end answer
		                      + '<div class="answer_list"></div>'
		                      + '</div>'; // end ask_item
		            });
		            
		            $("#asks").html(list);
					
		            // 답변
		            $('.ask_item').each(function() {
		                let askItem = $(this);
		                let askId = askItem.find('#askId').val();
		                let answerDiv = askItem.find('.answer_list');
		                let url = '../product/answer/' + askId;
		                
		                $.getJSON(url, function(data) {
		                    let answers = '';
		                    
		                    $(data).each(function() {
		                        let answerDate = new Date(this.answerDate).toLocaleString();
		                        let disabled = '';
		                        
		                        if(memberId != this.memberId){
									disabled = 'disabled';
								}
		                        
		                        answers += '<div class="answer_item" value="' + this.answerId + '">'
		                                  + '<div class="userInfo">'
		                                  + '<input type="hidden" id="answerId" value="' + this.answerId + '">'
		                                  + '<span>└</span><span class="answerLabel">답변</span>'
		                                  + '<span class="memberId">' + this.memberId + '&nbsp</span>'
		                                  + '<span class="answerDate">' + answerDate + '&nbsp</span>'
		                                  + '<button class="btn_answerUpdate" ' + disabled + '> 수정 </button>'
		                                  + '<button class="btn_answerDelete" ' + disabled + '> 삭제 </button>'
		                                  + '</div>' // end userInfo
		                                  + '<div class="answerContent">' + this.answerContent + '</div>'
		                                  + '</div>';
		                    });
		                    answerDiv.html(answers);
		                });
		            });
		        }
		    });
		}

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
 
</div> <!-- modal -->

 <div class="answerModal">

 <div class="answerModalContent">
  <input type="hidden" id="modalAnswerId">  
  <div>
   <textarea id="answerContent" name="answerContent"></textarea>
  </div>
  
  <div>
   <button type="button" class="answer_add_btn">입력</button>
   <button type="button" class="answer_cancle">취소</button>
  </div>
  </div>
  <div class="modalBackground"></div>
  
 </div> <!-- modal -->
 
 <div class="answerModifyModal">
 
 <div class="answerModify">
  <input type="hidden" id="modifyAnswerId">  
  <div>
   <textarea id="answerModifyContent" name="answerModifyContent"></textarea>
  </div>
  
  <div>
   <button type="button" class="answer_modify_btn">수정</button>
   <button type="button" class="answer_modify_cancle">취소</button>
  </div>
  </div>
  <div class="modalBackground"></div>
  
 </div> <!-- modal -->
	
</body>
</html>