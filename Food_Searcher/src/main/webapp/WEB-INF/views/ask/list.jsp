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
	
	<span class="info">구매한 상품의 취소/반품은 구매내역에서 신청 가능합니다.</span><br>
	<span class="info">상품문의 및 후기게시판을 통해 취소나 환불, 반품 등은 처리되지 않습니다.</span><br>
	<div class="ask_item">
	
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
			success : function(result) {
				console.log(result);
				if(result == 1) {
					alert('문의가 입력되었습니다.');
					getAllAsk();
					$(".askContent").val("");
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
							  + '<span class="memberId">' + this.memberId + '&nbsp' + '</span>'
							  + '<span class="askDate">' + askDate + '&nbsp' + '&nbsp'+ '&nbsp'+ '&nbsp'+ '&nbsp' + '</span>'
							  + '</div>' // end userInfo
							  + '<div class="askContent">' + this.askContent + "</div>"
							  list += "</div>"; // end ask_item
						});
						$(".ask_item").html(list);
					}
				}); // <-- .getJSON() 닫는 괄호 추가
			} // <-- getAllAsk() 닫는 중괄호 추가
			
			
		}); // end document
	
</script>
	
</body>
</html>