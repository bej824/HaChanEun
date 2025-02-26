<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<style>

</style>

<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Base.css">
<link rel="stylesheet" type="text/css"
href="${pageContext.request.contextPath}/resources/css/Cart.css">

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<title>장바구니</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
<div id="area">
<input type="hidden" id="memberId" value=<sec:authentication property="name" />>

<h2>${memberId }님의 장바구니</h2>
<hr>


<table>
    <thead>
        <tr>
            <th style="width: 10%">선택</th>
            <th style="width: 20%">썸네일</th>
            <th style="width: 20%">상품명</th>
            <th style="width: 20%">수량 조정</th>
            <th style="width: 20%">금액</th>
            <th style="width: 10%">삭제</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="CartVO" items="${cartVO }"> 
            <tr>
                <td id="btnCheck">
                <input type="checkbox" class="checkBox" onchange="isChecked(this);">
                </td> <!-- 선택 버튼 -->
                <td>(썸네일)${CartVO.cartChecked }</td>	
                <td>${CartVO.itemName } </td>
                <td>
                    <button class="minusBtn">-</button>
                    <input type="text" style="width: 50px; text-align: center;"
						   name="itemAmount" class="itemAmount" value="${CartVO.cartAmount }" readonly>
                    <button class="plusBtn">+</button>
                </td>
                <td> <div class="itemEachPrice">
                각 <fmt:formatNumber value="${CartVO.itemPrice }" pattern="#,###" />원</div>
                <div class="itemTotalPrice" >
                총 <fmt:formatNumber value="${CartVO.itemPrice * CartVO.cartAmount }" pattern="#,###"/>원</div></td>
                <td><button class="delBtn" >×</button></td>
	            <td style="display: none;">
			           	<input type="hidden" class="cartId" value="${CartVO.cartId }">
			        	<input type="hidden" class="memberId" value="${CartVO.memberId }">
			        	<input type="hidden" class="itemId" value="${CartVO.itemId }">
			        	<input type="hidden" class="itemName" value="${CartVO.itemName }">
			        	<input type="hidden" class="itemPrice" value="${CartVO.itemPrice }">
			        	<input type="hidden" class="cartDate" value="${CartVO.cartDate }">
			        	<input type="hidden" class="itemAmount" value="${CartVO.itemAmount }">
			        	<input type="hidden" class="cartChecked" value="${CartVO.cartChecked }">
	        	</td>
            </tr>
            
        </c:forEach>
    </tbody>
</table>

	<p>합계 : <span id="totalPrice"></span> 원</p>
	
	<p>주소 입력</p>
	
	<button onclick="openPostcodePopup()">주소 검색</button>

    <div>
        <label for="postcode">우편번호: </label>
        <input type="text" id="postcode" name="postcode" maxlength="15" required>
    </div>

    <div>
        <label for="address">주소: </label>
        <input type="text" style="width: 300px;" id="address" name="address" maxlength="35" required>
    </div>
    <div>
    	<label>상세주소 : </label>
    	<input type="text" style="width: 300px;" id="detailaddress" maxlength="25" required>
    </div>
    <input type="hidden" id="deleveryAddress">
    
	<button id="order" class="button">구매</button>

	<script>
			
			$(document).ready(function () {
		 	  setTotalPrice(); // 페이지 로드 시 실행
		  	  $(".checkBox, .plusBtn, .minusBtn, .delBtn").on("change click", setTotalPrice); // 체크박스 및 수량 변경 시 업데이트

				$(".plusBtn").on("click", function() {
					let $row = $(this).closest('tr'); // 현재 버튼이 속한 tr
					let quantity = parseInt($row.find(".itemAmount").val()); // tr에 있는 itemAmount 찾기
					let cartId = $row.find(".cartId").val();
					let itemPrice = parseInt($row.find(".itemPrice").val());
					let itemAmount = $row.find("itemAmount").val();
					 
					 // 수량 증가
						 quantity += 1;
						 parseInt($row.find(".itemAmount").val(quantity));
						 
						 let itemTotalPrice = itemPrice * quantity;
						 let cartAmount = quantity.toString(); 
						 
					 $.ajax({
							type : 'PUT',
							url : '../update/' + cartId,
							headers : {
								'Content-Type' : 'application/json'
							}, 
							data : cartAmount,
							success : function(result) {
								console.log(result);
									if(result == 1) {
										let textContent = "총 " + itemTotalPrice.toLocaleString() + "원";
										$row.find(".itemTotalPrice").text(textContent);
										$row.find(".itemTotalPrice").val(itemTotalPrice);
										alert("수량 증가됨");
									} else {
										alert("증가 실패");
									}
								}
						}); // end ajax
				}); // end plus_btn
				
			
				$(".minusBtn").on("click", function(){
					let $row = $(this).closest('tr'); // 현재 버튼이 속한 tr
					let quantity = parseInt($row.find(".itemAmount").val()); // tr에 있는 itemAmount 찾기
					let cartId = $row.find(".cartId").val();
					let itemPrice = parseInt($row.find(".itemPrice").val());

				 // 수량 감소
				 if (quantity > 1) {
					 quantity -= 1;
					 parseInt($row.find(".itemAmount").val(quantity));
					 console.log("quantity : " + quantity, "cartId : " + cartId, "itemPrice : " + itemPrice);
					 
					 let itemTotalPrice = itemPrice * quantity;
					 let cartAmount = quantity.toString(); 
					 console.log("상품 가격 합계 : " + itemTotalPrice);
					 
						 $.ajax({
							type : 'PUT',
							url : '../update/' + cartId,
							headers : {
								'Content-Type' : 'application/json'
							}, 
							data : cartAmount,
							success : function(result) {
								console.log("result = " + result);
									if(result == 1) {
										let textContent ="총 " + itemTotalPrice.toLocaleString() + "원";
										$row.find(".itemTotalPrice").text(textContent);
										$row.find(".itemTotalPrice").val(itemTotalPrice);
										alert("수량 감소됨");
										} else {
											alert("감소 실패");
										}
									}
								}); // end ajax
						 } else {
							 alert("최소 수량입니다.");
						 }
					}); 
			    
			    $('.delBtn').on('click', function(){
					 let cartId =  $(this).closest('tr').find('.cartId').val();
					 let memberId = $(this).closest('tr').find('.memberId').val(); // 같은 행에서 memberId 가져오기
					 let deleteConfirm = confirm('정말로 삭제하시겠습니까?');
					 console.log("cartId : " + cartId, "memberId : " + memberId);
					 
					 if(deleteConfirm) {
						 $.ajax({
							 type : 'DELETE',
							 url : '../delete/' + cartId,
							 headers : {
									'Content-Type' : 'application/json'
								}, 
							 success : function(result){
								 console.log(result);
								 if(result == 1) {
									 alert('삭제 완료');
									 location.reload(true);
								 } else {
									alert('삭제 실패');
									location.reload(true);
								 }
				                }
				            });
				        }
				    });

				});
			
					
	 $("#postcode, #address, #detailaddress").on("input", updateOutput);
     function updateOutput() {
		      // 각 input 필드의 값을 가져오기
		      const value1 = $("#postcode").val();
		      const value2 = $("#address").val();
		      const value3 = $("#detailaddress").val();
		
		      // 결과를 하나의 필드에 합치기
		      $("#deleveryAddress").val(value1 + " - " + value2 + " " + value3);
		    }
     
     function isChecked(checkbox) {
    	    if (checkbox.checked) {
    	      let memberId = $(checkbox).closest('tr').find('.memberId').val();
    	      let cartId = $(checkbox).closest('tr').find('.cartId').val();
    	      let cartChecked = 0;  // 체크된 상태는 1
    	      console.log(cartChecked);
    	      
    	      // AJAX PUT 요청
    	      $.ajax({
    	        type: 'PUT',
    	        url: memberId + '/' + 'checked',
    	        headers: {
    	          'Content-Type': 'application/json'
    	        },
    	        data: JSON.stringify({
    	          cartId: cartId,
    	          cartChecked: cartChecked
    	        }),
    	        success: function(result) {
    	          // 성공적으로 요청이 처리되었을 때 처리할 내용
    	          console.log(result);
    	          location.reload();
    	        }
    	      });
    	    } else {
    	      let memberId = $(checkbox).closest('tr').find('.memberId').val();
    	      let cartId = $(checkbox).closest('tr').find('.cartId').val();
    	      let cartChecked = 1;  // 체크 해제된 상태는 0
    	      console.log(cartChecked);
    	      
    	      // AJAX PUT 요청
    	      $.ajax({
    	        type: 'PUT',
    	        url: memberId + '/' + 'checked',
    	        headers: {
    	          'Content-Type': 'application/json'
    	        },
    	        data: JSON.stringify({
    	          cartId: cartId,
    	          cartChecked: cartChecked
    	        }),
    	        success: function(result) {
    	          // 성공적으로 요청이 처리되었을 때 처리할 내용
    	          console.log(result);
    	          location.reload();
    	        }
    	      });
    	    }
    	  }
     
		
     $(document).ready(function() {
    	    $('#order').click(function() {
    	        $('tbody tr').each(function(index) {
    	            // 각 tr 태그 내의 hidden input 값들을 가져옴
    	            let memberId = $(this).find('.memberId').val();
    	            console.log("memberId : " + memberId);

    	            let itemId = $(this).find('.itemId').val();
    	            console.log("itemId : " + itemId);

    	            let totalCount = $(this).find('.itemAmount').val();
    	            console.log("구매 수량 : " + totalCount);

    	            let itemPrice = $(this).find('.itemPrice').val();
    	            console.log("아이템 가격 : " + itemPrice);

    	            let totalPrice = $(this).find('.itemPrice').val() * totalCount;
    	            console.log("총 가격 : " + totalPrice);

    	            let deliveryAddress = $("#deleveryAddress").val();
    	            console.log("주소 : " + deliveryAddress);
    	            
    	            let orderCount = index;
    	            console.log(orderCount);
    	            
    	            let checked = $(this).find('.cartChecked').val();
    	            console.log("cartChecked : " + checked);
    	            if(checked == 1) {
    	            $.ajax({
	                    url: 'order',
	                    type: 'POST',
	                    headers: {
	                        'Content-Type': 'application/json' // json content-type 설정
	                    },
	                    data: JSON.stringify({
	                        memberId: memberId,
	                        itemId: itemId,
	                        totalCount: totalCount,
	                        totalPrice: totalPrice,
	                        deliveryAddress: deliveryAddress,
	                        orderCount : orderCount
	                    }),
	                    success: function(result) {
	                        console.log(result);
	                        alert('결제 성공');
	                        window.location.href = 'http://localhost:8080/searcher/item/list';
	                    }
	                });
    	            }
    	        });
    	    });
    	});
     
     function setTotalPrice() {
    	    let totalPrice = 0; // 주문 가격 합계
    	    
    	    $("tr").each(function () {  // 테이블 순회
    	      // .cartChecked의 값을 가져와 체크 여부를 확인
    	      let checked = $(this).find('.cartChecked').val();
    	      
    	      // cartChecked 값이 '1'이면 체크, 아니면 체크 해제
    	      let isChecked = (checked === "1");
    	      
    	      // 체크된 항목만 처리
    	      if (isChecked) {
    	        let price = parseInt($(this).find(".itemPrice").val(), 10);
    	        let amount = parseInt($(this).find(".itemAmount").val(), 10);
    	        
    	        if (!isNaN(price) && !isNaN(amount)) {
    	          totalPrice += price * amount; // 총 가격 계산
    	        }
    	      } 

    	      // 체크박스 상태 변경 (cartChecked 값에 따라)
    	      $(this).find(".checkBox").prop("checked", isChecked);
    	    });
    	    
    	    // 총 가격을 화면에 표시
    	    $("#totalPrice").text(totalPrice.toLocaleString());
    	  }

    	  // 체크박스를 클릭할 때마다 총 가격을 재계산
    	  $(document).ready(function() {
    	    $('.checkBox').change(function() {
    	      setTotalPrice();  // 체크박스 상태 변경 시 총 가격 계산
    	    });
    	  });

     function openPostcodePopup() {
         new daum.Postcode({
             oncomplete: function(data) {
                 // 선택한 주소 정보를 폼 필드에 입력
                 document.getElementById('postcode').value = data.zonecode;
                 document.getElementById('address').value = data.address;
             }
         }).open();
     }
	
</script>
</div> <!-- area -->
</body>
</html>