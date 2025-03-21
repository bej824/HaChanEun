<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>

<link rel="stylesheet"
	href="../resources/css/Base.css">
<style>

#img {
	width:500px;
	height:500px;
	background-color: #f9f9f9; /* 배경색 설정 */
    border: 1px solid #ddd; /* 테두리 추가 */
    padding: 10px; /* 첨부 목록 내부에 여백 추가 */
}

*:disabled {
	width:80%;
	height:60%;
	background-color: #f9f9f9;
}

.ask, .review {
    flex: 1;
    border-width: 3px 1px 1px 1px;
    background-color: #f9f9f9;
    border-style: solid;
    border-color: #dddddd;
    padding: 10px;
    text-align: center;
}

</style>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>상품</title>
</head>
<body>
		<%@ include file ="/WEB-INF/views/header.jsp" %>
	<!-- 게시글 -->
	<div id="area2">
	
	<div id="itemDetail">
	<sec:authorize access="isAuthenticated() and principal.username == '${itemVO.memberId }'">
	<div>
   	<button onclick="location.href='modify?itemId=${itemVO.itemId }'" class="button">글수정</button>
    <button id="deleteItem" class="button">글 삭제</button>
    </div>
    </sec:authorize>
	
	<div class="imgDiv">
				<!-- 이미지 파일 처리 코드 -->
				<c:forEach var="attachVO" items="${attachVO}">
				    <c:if test="${attachVO.attachExtension eq 'jpg' or 
				    			  attachVO.attachExtension eq 'jpeg' or 
				    			  attachVO.attachExtension eq 'png' or 
				    			  attachVO.attachExtension eq 'gif'}">
				        <div class="image_item">
				        	<a href="../images/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" target="_blank">
					        <img 
					        src="../images/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}"  
					        onerror="this.onerror=null; this.src='../resources/image/imageReady.png';"/></a>
				        </div>
				    </c:if>
				</c:forEach>
		<div class="itemDetailDiv">
		<p class="title">${itemVO.itemName }</p>
			
			<div class="buy">
				<sec:authorize access="isAnonymous()">
					<p>로그인이 필요한 기능입니다</p>
				</sec:authorize>
				
				<sec:authorize access="hasRole('ROLE_MEMBER')">
					<br>
					<div>
					<button class="minusBtn">－</button>
					<input type="text" name="itemAmount" class="itemAmount" value="1" readonly>
					<button class="plusBtn">＋</button>
					</div>
					
					<div>
					<c:choose>
					<c:when test="${itemVO.itemStatus == 2}">
					<input type="button" value="판매가 중단된 상품입니다." disabled />
					</c:when>
					
					<c:when test="${itemVO.itemAmount == 0}">
					<input type="button" value="Sold out" disabled />
					</c:when>
					
					<c:when test="${itemVO.itemAmount > 0}">
					<button id="btnCart" class="button">장바구니 담기</button>
			    	<button type="button" onclick="window.location.href='order?itemId=${itemVO.itemId}&count=' + $('.itemAmount').val()" id="btnBuy" class="button">바로 구매</button>
					</c:when>
					
					</c:choose>
					</div>
				</sec:authorize>
			
		    <input type="hidden" id="memberId" value=<sec:authentication property="name" />>
		    <input type="hidden" id="itemIdInput" name="itemId" value="${itemVO.itemId}">
		    <input type="hidden" name="itemPrice" value="${itemVO.itemPrice}">
		    
			</div>
			<!-- end Buy -->
		
		</div>
		
	</div>
	<!-- end imgDiv -->
	</div>
	
	<div class="itemInfo">
		<span class="price"><fmt:formatNumber value="${itemVO.itemPrice }" pattern="###,###,###" />원</span>
		<span class="itemDate"><fmt:formatDate pattern="yyyy-MM-dd" value="${itemVO.itemDate }" />  |  현재 수량 : ${itemVO.itemAmount }</span>

		<p>판매자 : ${itemVO.memberId } </p>
	<span class="itemContent">${itemVO.itemContent }</span>
	</div>
	<input type="hidden" id="itemId" value="${itemVO.itemId }">
	
    
    <form id="deleteForm" action="delete" method="POST">
        <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
        <input type="hidden" autocomplete="off" class="form-control" id="userName" name="name" value="${session.memberId }">
        <input type="hidden" name="itemId" value="${itemVO.itemId }">
    </form><br>

	<div class="relationArea">
		<%@ include file="relation.jsp"%>
	</div>
	
	<button onclick="location.href='list?keyword=${param.keyword}&type=${param.type}'" class="button" id="listBoard">글 목록</button>
	
	<br><br>
	
	<div class="askArea">
		<div class="ask">상품 문의</div>
	   	<div class="review">상품평</div>
	</div>
	
	
	<div class="askDiv">
		<%@ include file="../product/ask.jsp"%>
	</div>
	<div class="reviewDiv">
		<%@ include file="../product/review.jsp"%>
	</div>
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});	 
	
	$(document).ready(function() {
		$(".askDiv").hide();
		$(".reviewDiv").hide();
		
		$(".ask").on("click", function(){
	        if ($(this).text().trim() === "상품 문의") {
	        	$(".reviewDiv").hide();
	            $(".askDiv").toggle();
	        }
		});
		
		$(".review").on("click", function(){
	        if ($(this).text().trim() === "상품평") {
	        	$(".askDiv").hide();
	            $(".reviewDiv").toggle();
	        }
		});
		
		$('#deleteItem').click(function() {
			// 게시글 삭제 클릭 시
			var itemId = ${itemVO.itemId}
			// 게시글ID 불러오기
			
			console.log("itemId : " + itemId);
			
			 if (confirm('삭제하시겠습니까?')) {
				 $('#deleteForm').submit();
			 }
		});
	});
	
		let quantity = $(".itemAmount").val(); // 현재 수량 가져오기
		let amount = '${itemVO.itemAmount}'
	
		$(".plusBtn").on("click", function() {
		    if (quantity < amount) { 
		        quantity++;
		        $(".itemAmount").val(quantity);  
		        console.log("수량 증가");
		        console.log(quantity);
		    }
		});// end plus_btn
		
	
		$(".minusBtn").on("click", function() {
		    if (quantity > 1) {  
		        quantity--; 
		        $(".itemAmount").val(quantity);
		        console.log("수량 감소");
		        console.log(quantity);
		    }
		}); // end minus_btn
		
		const data = {
				memberId : $('#memberId').val(),
				itemId : ${itemVO.itemId},
				cartAmount : $(".itemAmount").val(),
		}
		// 3개 값을 data로 묶음
		
		$('#btnCart').on("click", function (e){
			data.cartAmount = $(".itemAmount").val()
			
			$.ajax({
				url: '../cart/add',
				type: 'POST',
				data: data,
				// data 장바구니로 전달 (cart Insert 실행)
				success: function(result){
				if (result == '1') {
					alert("장바구니에 넣으셨습니다.");
				} else if(result == '0') {
					alert("이미 장바구니에 존재하는 상품입니다.");
				  } else {
					alert("장바구니 추가 실패");
				  }
				}
			});
			
		}); // end btnCart
	
		$('#btnBuy').on('click', function() {
			data.amount = $(".itemAmount").val();
		    let amount = $('.amount_input').val();
		    $('#amountInput').val(amount);

		    $('#orderForm').submit();
		}); // end btnBuy
		
	</script>
	<!-- 리뷰 -->
	
	 </div><!-- area -->
</body>
</html>