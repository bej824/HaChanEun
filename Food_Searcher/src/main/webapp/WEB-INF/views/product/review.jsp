<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<style>
.moveHistory {
	color:blue;
}
</style>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>리뷰</title>
</head>

<body>

<h2>리뷰</h2>
<p>리뷰 작성은 <a href="../item/purchaseHistory" class="moveHistory">구매 내역</a>에서 가능합니다.</p>
<input type="hidden" id="itemId" value="${reviewVO.itemId }">

<div class="reviewBox">
	<div id="reviews">
		<div class="review_item"></div>
			<input type="hidden" id="itemId" name="itemId">
			<input type="hidden" id="memberId" value=<sec:authentication property="name" /> >
		<p>테스트</p>
	</div>
</div>

</body>
<script type="text/javascript">
$(document).ajaxSend(function(e, xhr, opt){
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	xhr.setRequestHeader(header, token);
});	 

$(document).ready(function() {
	console.log("ID : " + $('#itemId').val());
	
	$(document).on("click", ".btn_reviewUpdate", function(){
		$(".reviewModal").attr("style", "display:block;");
		let reviewId = $(this).closest('.review_item').find('#reviewId').val();   // 댓글 Id 가져오기
		let reviewContent = $(this).closest('.review_item').find(".reviewContent").text(); // 원본 댓글 내용 가져오기
		
		console.log("reviewId : " + reviewId, ", reviewContent : " + reviewContent);
		
		 $("#modal_revCon").val(reviewContent);
		 $("#modalReviewId").val(reviewId);
		 
		});
		
		// 수정 버튼을 클릭하면 선택된 댓글 수정
	$(".review_modify_btn").on("click", function(){
		console.log(this);
			
		let reviewId = $("#modalReviewId").val();
		let reviewContent = $("#modal_revCon").val();
						
		console.log("수정된 댓글 번호 : " + reviewId + ", 수정된 댓글 내용 : " + reviewContent);
			
			// ajax 요청
			$.ajax({
				type : 'PUT', 
				url : '../product/review-update/' + reviewId,
				headers : {
					'Content-Type' : 'application/json' 
				},
				data : reviewContent,
				success : function(result) {
					console.log(result);
					if(result == 1) {
						alert('리뷰가 수정되었습니다.');
						getAllReview();
						 $(".replyModal").attr("style", "display:none;");
						 console.log("modified");
						 location.reload(true);
					} else {
						alert('리뷰 수정 실패');
					}
				}
				});
		}); // end modal_modify_btn	
	
	$(".review_modify_cancle").click(function(){	
	  	$(".reviewModal").attr("style", "display:none;");
	});
	
	getAllReview();
	
	function getAllReview() {
		let itemId = $("#itemId").val();
		let url = '../product/review/list/' + itemId;
		let memberId = $('#memberId').val();
		
		 $.getJSON(url, function(data) {
		        console.log(data);
		        
		        var list = '';
		        
		        if (data.length == 0) {
		            list += '<div class="noReview">작성된 리뷰가 없습니다.</div>'
		        } else {
		            $(data).each(function() {
		                console.log(this);
		                
		                let reviewDate = new Date(this.reviewDate).toLocaleString();
		                let disabled = '';
		                if (memberId != this.memberId) {
		                	disabled = 'disabled';
		                }
		                
		                list += '<div class="review_item" value="' + this.reviewId + '">'
		                	  + '<div class="userInfo">'
		                      + '<input type="hidden" id="reviewId" value="' + this.reviewId + '">'
		                      + '<span class="memberId">' + this.memberId + '&nbsp</span>'
		                      + '<span class="reviewDate">' + reviewDate + '&nbsp</span>'
		                      + '<button class="btb_reviewUpdate"' + disabled + '> 수정 </button>'
		                      + '<button class="btn_reviewDelete"' + disabled + '> 삭제 </button>'
		                      + '</div>' // end userInfo
		                      + '<div class="reviewContent">' + this.reviewContent + '</div>'
		                      + '<span class="reviewLove">' + this.reviewLove + '</span>'
		                	  + '</div>';
		                });
		            $("#reviews").html(list);
		            
		        }
		        
		 });
	} // end getAllReview
	
	
	
}); // end document

</script>

<div class="reviewModal">

 <div class="reviewModalContent">
  <input type="hidden" id="modalReviewId">  
  <div>
   <textarea id="modal_revCon" name="modal_revCon"></textarea>
  </div>
  
  <div>
   <button type="button" class="review_modify_btn">수정</button>
   <button type="button" class="review_modify_cancle">취소</button>
  </div>
  
 </div>

 <div class="modalBackground"></div>
 
</div> <!-- modal -->

</html>