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
body {
	font-family: 'Noto Sans KR', Arial, sans-serif !important;
}

 #itemDetail {
    display: flex;
    justify-content: center;
    gap: 15px;
    border: 1px solid #ddd;
    background-color: #fff;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 1000px;
    border-radius: 12px;
    flex-direction: row;
        
    margin: 20px auto;
    padding: 20px;
    border-radius: 12px;
    }

    /* 이미지 영역 */
    .imgDiv {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-wrap: wrap;
        gap: 20px;
    }

    .image_item img {
        width: 100%;
        max-width: 400px;
        height: auto;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    /* 제목 */
    .title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 10px;
        word-break: break-all;
    }

    /* 가격과 수량 */
    .itemInfo {
        flex-direction: column;
        gap: 5px;
        font-size: 18px;
    }

    .price {
        font-size: 22px;
        font-weight: bold;
        color: #e74c3c;
    }

    /* 버튼 영역 */
    .button-container {
        display: flex;
        gap: 10px;
        justify-content: center;
        margin-top: 10px;
    }

    .button {
        padding: 10px 15px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        transition: background 0.3s ease;
    }

    .button:hover {
        opacity: 0.8;
    }

    .delete-btn {
        background-color: #e74c3c;
        color: white;
    }

    .modify-btn {
        background-color: #3498db;
        color: white;
    }

    #btnCart {
        background-color: #3CA03C	;
        color: white;
    }

    #btnBuy {
        background-color: #3CA03C	;
        color: white;
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

    .ask:hover, .review:hover {
        background-color: #ddd;
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
	
	<div class="imgDiv">
				<!-- 이미지 파일 처리 코드 -->
				<c:forEach var="attachVO" items="${attachVO}">
				<c:set var="imageFound" value="false"/>
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
				        <c:set var="imageFound" value="true"/>
				    </c:if>
				</c:forEach>
				<c:if test="${!imageFound}">
		            <div class="image_item">
		                <img 
		                     src="../resources/image/imageReady.png"/>
		            </div>
		        </c:if>
		</div> <!-- imgDiv -->
		
		<div class="itemDetailDiv">
		<p class="title">${itemVO.itemName }</p>
		
			<div class="buy">
				
				<br>
		<div class="itemInfo">
		<span class="price"><fmt:formatNumber value="${itemVO.itemPrice }" pattern="###,###,###" />원</span>
		<span class="itemDate"><fmt:formatDate pattern="yyyy-MM-dd" value="${itemVO.itemDate }" /> </span>

		<p>판매자 : ${itemVO.memberId } </p>
		<span class="itemContent">${itemVO.itemContent }</span>
		</div>
		<input type="hidden" id="itemId" value="${itemVO.itemId }">		
			
		    <input type="hidden" id="memberId" value=<sec:authentication property="name" />>
		    <input type="hidden" id="itemIdInput" name="itemId" value="${itemVO.itemId}">
		    <input type="hidden" name="itemPrice" value="${itemVO.itemPrice}">
		    
			</div>
			<!-- end Buy -->
		
		</div>
	<!-- end imgDiv -->
	
	
	</div>
    
    <form id="deleteForm" action="delete" method="POST">
        <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
        <input type="hidden" autocomplete="off" class="form-control" id="userName" name="name" value="${session.memberId }">
        <input type="hidden" name="itemId" value="${itemVO.itemId }">
    </form><br>
	
	<br><br>
	
	
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		console.log("ajaxSend");
		
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
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