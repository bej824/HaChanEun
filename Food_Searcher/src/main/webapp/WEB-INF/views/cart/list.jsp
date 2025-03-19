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
                <td>
                <c:forEach var="attachVO" items="${attachVO}">
                	<c:if test="${CartVO.itemId eq attachVO.itemId }">
                		<a href="../../images/get?attachId=${attachVO.attachId }&attachChgName=${attachVO.attachChgName}" target="_blank">
					        <img width="150px" height="150px" 
					        src="../../images/get?attachId=${attachVO.attachId }&attachExtension=${attachVO.attachExtension}" /></a>
                	</c:if>
                </c:forEach>
                </td>	
                <td>${CartVO.itemName } </td>
                <td>
                    <button class="minusBtn">-</button>
                    <input type="text" style="width: 50px; text-align: center;" id="itemAmount"
						   name="itemAmount" class="itemAmount" value="${CartVO.cartAmount }">
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
	<p>총합 가격 : <span id="totalCost"></span> 원</p>
	<p>할인 가격 : -<span id="discountPrice"></span> 원</p>
	<p>합계 : <span id="totalPrice"></span> 원</p>
	
	<select name="couponSelect" id="couponSelect">
	</select>
	
	<p>주소 입력</p>
	
	<button onclick="openPostcodePopup()">주소 검색</button>

    <div>
        <label for="postcode">우편번호: </label>
        <input type="text" id="postcode" name="postcode" maxlength="15" required readonly>
    </div>

    <div>
        <label for="address">주소: </label>
        <input type="text" style="width: 300px;" id="address" name="address" maxlength="35" required readonly>
    </div>
    <div>
    	<label>상세주소 : </label>
    	<input type="text" style="width: 300px;" id="detailaddress" maxlength="25" required>
    </div>
    <input type="hidden" id="deleveryAddress">
    
	<button id="order" class="button">구매</button>

	<script>
		let couponActive = [];
	
	$(document).ready(function () {
		let couponSelectOption = 0;
		let discountPrice = 0;
		let totalCost = 0;
		let totalPrice = 0; // 주문 가격 합계
		
		setTotalPrice(); // 페이지 로드 시 실행
		
		couponList();
		
		$("#postcode, #address, #detailaddress").on("input", updateOutput);
		
		$(".plusBtn").on("click", function () {
		    let row = $(this).closest("tr"); // 현재 버튼이 속한 tr
		    let quantity = parseInt(row.find(".itemAmount").val()); // 현재 수량
		    let cartId = row.find(".cartId").val();
		    let itemPrice = parseInt(row.find(".itemPrice").val());
	
		    quantity += 1;
		    cartinfo(row, quantity, cartId, itemPrice);
		});
		
		$(".minusBtn").on("click", function () {
		    let row = $(this).closest("tr"); // 현재 버튼이 속한 tr
		    let quantity = parseInt(row.find(".itemAmount").val()); // 현재 수량
		    let cartId = row.find(".cartId").val();
		    let itemPrice = parseInt(row.find(".itemPrice").val());
	
		    quantity -= 1;
		    cartinfo(row, quantity, cartId, itemPrice);
		});
		
		$(".itemAmount").on("change", function(){
			let row = $(this).closest("tr");
			let quantity = parseInt(row.find(".itemAmount").val());
			let cartId = row.find(".cartId").val();
		    let itemPrice = parseInt(row.find(".itemPrice").val());
		    
		    cartinfo(row, quantity, cartId, itemPrice);
		})

	    $('.delBtn').on('click', function(){
			 let cartId =  $(this).closest('tr').find('.cartId').val();
			 let memberId = $(this).closest('tr').find('.memberId').val(); // 같은 행에서 memberId 가져오기
			 let deleteConfirm = confirm('정말로 삭제하시겠습니까?');
			 
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
	    
			$(".checkBox, .plusBtn, .itemAmount, .minusBtn, .delBtn").on("change click", setTotalPrice); // 체크박스 및 수량 변경 시 업데이트
	    	
			function cartinfo(row, quantity, cartId, itemPrice){
				
				if(quantity <= 0) {
					alert("0개 이하로 구매 불가능합니다.");
					return;
				}

				row.find(".itemAmount").val(quantity); // 변경된 수량 업데이트
		
			    let itemTotalPrice = itemPrice * quantity;
			    let cartAmount = quantity.toString();
		
			    $.ajax({
			        type: "PUT",
			        url: "../update/" + cartId,
			        headers: {
			            "Content-Type": "application/json",
			        },
			        data: cartAmount,
			        success: function (result) {
			            console.log(result);
			            if (result == 1) {
			                let textContent = "총 " + itemTotalPrice.toLocaleString() + "원";
			                row.find(".itemTotalPrice").text(textContent);
			                row.find(".itemTotalPrice").val(itemTotalPrice);
			            } else {
			                alert("변경 실패");
			            }
			        },
			    }); // end ajax
			}
			
			function updateOutput() {
			      // 각 input 필드의 값을 가져오기
			      const value1 = $("#postcode").val();
			      const value2 = $("#address").val();
			      const value3 = $("#detailaddress").val();
			
			      // 결과를 하나의 필드에 합치기
			      $("#deleveryAddress").val(value1 + " - " + value2 + " " + value3);
			    }
			
			$('#couponSelect').change(function(){
    			let couponSelect = $(this).val();
    			
    			if(isNaN(couponSelect) || couponActive.length <= couponSelect || couponSelect < 0){
    				couponList();
    				return;
    			}
    			
    			if(totalCost < couponActive[couponSelect].couponUseCondition) {
    				alert("사용 조건이 충족되지 않은 쿠폰입니다.");
    				$(this).val(couponSelectOption).change();
    				return;
    			};
    			
    			if(couponSelect == 0) {
    				discountPrice = '0';
    			} else {
    				discountPrice = couponActive[couponSelect].couponPrice;
    			}
    			
    			setTotalPrice();
    			couponSelectOption = couponSelect;
    		})
	     
	     function setTotalPrice() {
	    	 	totalCost = 0;
	    	    
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
	    	          totalCost += price * amount;
	    	        }
	    	      } 
	
	    	      // 체크박스 상태 변경 (cartChecked 값에 따라)
	    	      $(this).find(".checkBox").prop("checked", isChecked);
	    	    });
	    	    
	    	    // 총 가격을 화면에 표시
	    	   	totalPrice = totalCost - discountPrice; // 총 가격 계산
	    	    $("#totalCost").text(totalCost);
	    	   	$("#discountPrice").text(discountPrice);
	    	    $("#totalPrice").text(totalPrice.toLocaleString());
	    	  }
	     
	     function couponList() {
 			let memberId = '<sec:authentication property="name" />';
 			let itemId = '${param.itemId}';
 			let couponSelect = $('#couponSelect');
 			let couponSelectOption = [];
 			let listCount = 1;
 			
 			couponSelect.empty();
 			couponSelectOption.push('<option value="'+ 0 +'">'
 	    			+ "쿠폰 선택 안함" +'</option>')
 	    	couponActive.push(0);
 			
 			$.ajax({
 			    type: 'POST',
 			    url: '../../coupon/memberCouponList',
 			    data: {	memberId: memberId,
 			    		itemId: itemId},
 			    success: function(result) {
 			    	result.forEach(function(CouponActiveVO) {
 			    		
 			    		let	couponUseCondition = "";
 			    		
 			    		let year = CouponActiveVO.couponExpireDate[0];
 			    		let month = CouponActiveVO.couponExpireDate[1];
 			    		let day = CouponActiveVO.couponExpireDate[2];
 			    		let couponExpireDate = year + "년 " + month + "월 " + day + "일까지";
 			    		
 			    		if(CouponActiveVO.couponUseCondition != 0) {
 			    			couponUseCondition = CouponActiveVO.couponUseCondition + "원 이상 구매 시";
 			    		}
 			    		
 			    		if(CouponActiveVO.couponUsedDate != null) {
 			    			
 			    		} else {
 			    			let option = '<option value="'+ listCount +'">'
 			    			+ CouponActiveVO.couponName + " : " 
 			    			+ couponUseCondition + " "
 			    			+ CouponActiveVO.couponPrice + "원 할인\. "
 			    			+ couponExpireDate +'</option>';
 			    			
 			    			couponSelectOption.push(option);
 			    			couponActive.push(CouponActiveVO);
 			    			listCount++;
 			    			
 			    		}
 			    		
 			    	})
 			    	couponSelect.append(couponSelectOption);
 			    }
 			    	
 			})
 		}
	     
	}); // document
	
	let hasCheckedAddress = false;
	    
	$('#order').click(function() {
	    // tr 태그 내의 데이터들을 배열로 수집
	    let orderData = [];
	    let deliveryAddress = $("#deleveryAddress").val();
	    let couponSelect = $('#couponSelect').val();
	    
	    let couponActiveId = 0;
	    if(couponSelect != 0) {
	    	couponActiveId = couponActive[couponSelect].couponActiveId;
	    }
	    
	    let memberPrice = 0;

	    // 주소가 비어 있으면 경고
	    if (!deliveryAddress && !hasCheckedAddress) {
	        alert('배송 주소를 입력해주세요.');
	        hasCheckedAddress = true;
	        return;
	    }

	    $('tbody tr').each(function(index) {
	        let memberId = $(this).find('.memberId').val();
	        let itemId = $(this).find('.itemId').val();
	        let totalCount = $(this).find('.itemAmount').val();
	        let itemPrice = $(this).find('.itemPrice').val();
	        let totalPrice = itemPrice * totalCount;
	        let checked = $(this).find('.cartChecked').val();

	        // 체크된 아이템만 배열에 추가
	        if (checked == 1) {
	            orderData.push({
	                memberId: memberId,
	                itemId: itemId,
	                totalCount: totalCount,
	                totalPrice: totalPrice,
	                deliveryAddress: deliveryAddress,
	                couponActiveId: couponActiveId
	            });
	            memberPrice += totalPrice;
	            couponActiveId = 0;
	        }
	        
	    });

	    // 배열이 비어 있으면 종료
	    if (orderData.length === 0) {
	        return;
	    }

	    // 데이터 한 번에 전송
	    $.ajax({
	        url: '',
	        type: 'POST',
	        headers: {
	            'Content-Type': 'application/json' // json content-type 설정
	        },
	        data: JSON.stringify(orderData),// 배열을 JSON으로 변환하여 전송
	        success: function(result) {
	        	location.href = result;
	        }
	    });
	});

	    
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