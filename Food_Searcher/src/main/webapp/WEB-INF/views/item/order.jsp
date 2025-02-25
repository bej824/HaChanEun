<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<title>상품 구매 페이지</title>
</head>
<body>
	<%@ include file ="/WEB-INF/views/header.jsp" %>
	<h1>구매 페이지</h1>
	<table border="1">
		<thead>
			<tr>
	            <th style="width: 15%">제품 정보</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	
	<br>
	<select name="couponSelect" id="couponSelect">
	</select>
	
	<p>주소 입력</p>
	
	<button onclick="openPostcodePopup()">주소 검색</button>

    <div>
        <label for="postcode">우편번호: </label>
        <input type="text" id="postcode" name="postcode" required>
    </div>

    <div>
        <label for="address">주소: </label>
        <input type="text" style="width: 300px;" id="address" name="address" required>
    </div>
    <div>
    	<label>상세주소 : </label>
    	<input type="text" style="width: 300px;" id="detailaddress" required>
    </div>
    
    <button id="order" class="button">구매</button>
    
    <input type="hidden" id="deleveryAddress">
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		let urlParams = new URLSearchParams(window.location.search);
    		let count = urlParams.get('count'); // count 값 추출
    		let itemId = urlParams.get('itemId');
    		
    		let couponActive = [];
    		let couponSelectOption = 0;
    		let discountPrice = 0;
	    	let itemName = '${itemVO.itemName }';
	    	let itemPrice = ${itemVO.itemPrice};
	    	const totalCost = count * itemPrice;
	    	let totalPrice = totalCost;
    		
    		orderinfo(discountPrice);
    		couponList();
    		
    		// input 필드들에 대해 이벤트 리스너를 설정
		    $("#postcode, #address, #detailaddress").on("input", updateOutput);
		
    		
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
    			orderinfo(discountPrice);
    			couponSelectOption = couponSelect;
    		})
    		
    		$('#order').click(function(){
  	    	  	console.log("수량 : " + count);
  	    	  	let itemPrice = ${itemVO.itemPrice};
  	    	  	console.log("아이템 가격 : " + itemPrice);
    			let memberId = '<sec:authentication property="name" />';
    			console.log("memberId : " + memberId);
    			console.log("총 금액 : " + totalPrice);
    			let deliveryAddress = $("#deleveryAddress").val();
    			console.log("주소 : " + deleveryAddress);
    			let couponSelect = $('#couponSelect').val();
    			let couponActiveId = couponActive[couponSelect].couponActiveId;
    			
    			if (!deliveryAddress) {
                    alert('배송 주소를 입력해주세요.');
                    return;  // 비어 있으면 AJAX 요청을 하지 않음
                }
    			
    			$.ajax({
    			    url : 'order?itemId=' + itemId + '&count=' + count,
    			    type : 'POST',
    			    headers : {
    			        'Content-Type' : 'application/json' // json content-type 설정
    			    }, 
    			    data : JSON.stringify({
    			        memberId : memberId,
    			        itemId : itemId,
    			        totalCount : count,
    			        totalPrice : totalPrice,
    			        deliveryAddress : deliveryAddress,
    			        couponActiveId : couponActiveId
    			    }),
    			    success : function(result) {
    			    	console.log(result);
    			            alert('결제 성공');
    			            window.location.href = 'list';
    			    }
    			});
    		});
    		
    		function orderinfo(discountPrice){
    			totalPrice = totalCost - discountPrice;
    	    	let tbody = $('table tbody');
    	    	tbody.empty(); // 기존 테이블 내용 비우기
    	    	
    	    	let costCasting = "<br> 총 가격 : " + totalCost + "원";
    	    	
    	    	if(discountPrice != 0) {
    	    	 	costCasting = "<br>" + "<s>총 가격 : " + totalCost + "원</s>" 
    	    	 				+ "<br> 쿠폰 할인 : " + totalPrice + "원";
    	    	}
    	    	
    	    	let row = '<tr>'
    	    	+ '<td>' + "썸네일 영역" + "<br> 제품명 : " 
    	    	+ itemName + "<br> 수량 : " 
    	    	+ count
    	    	+ costCasting
    	    	+ '</td>'
    	    	+ '</tr>';
    	    	
    	    	tbody.append(row);
    		}
    		
    		function updateOutput() {
  		      // 각 input 필드의 값을 가져오기
  		      const value1 = $("#postcode").val();
  		      const value2 = $("#address").val();
  		      const value3 = $("#detailaddress").val();
  		
  		      // 결과를 하나의 필드에 합치기
  		      $("#deleveryAddress").val(value1 + " - " + value2 + " " + value3);
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
    			    url: '../coupon/memberCouponList',
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
    		
    	}); // end $(document).ready
    	
    	function openPostcodePopup() {
            new daum.Postcode({
                oncomplete: function(data) {
                    // 선택한 주소 정보를 폼 필드에 입력
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById('address').value = data.address;
                }
            }).open();
        }
        
	    window.onload = function() {
	    	  // URL에서 count 파라미터를 가져오기
	    };
    </script>
    
</body>
</html>