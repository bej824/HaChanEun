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
<title>장바구니 구매</title>
</head>
<body>
	<%@ include file ="/WEB-INF/views/header.jsp" %>
	<p>장바구니 구매</p>
	<table>
		<thead>
			<tr>
				<th>상품 이름</th>
				<th>수량</th>
				<th>가격</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="CartVO" items="${cartVO }"> 
			<tr>
				<td>${CartVO.itemName }</td>
				<td>${CartVO.cartAmount }</td>
				<td>${CartVO.itemPrice * CartVO.cartAmount }</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	
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

    <script type="text/javascript">
    $("#postcode, #address, #detailaddress").on("input", updateOutput);
    
        function openPostcodePopup() {
            new daum.Postcode({
                oncomplete: function(data) {
                    // 선택한 주소 정보를 폼 필드에 입력
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById('address').value = data.address;
                }
            }).open();
        }
        
        function updateOutput() {
		      // 각 input 필드의 값을 가져오기
		      const value1 = $("#postcode").val();
		      const value2 = $("#address").val();
		      const value3 = $("#detailaddress").val();
		
		      // 결과를 하나의 필드에 합치기
		      $("#deleveryAddress").val(value1 + " - " + value2 + " " + value3);
		    }

    	let length = ${cartVOSize };
    	console.log(length);
    	let itemId = '${itemId }';
    	console.log(itemId);
    	let amount = '${amount }';
    	console.log(amount);
    	let itemPrice = '${itemPrice}';
    	console.log(itemPrice);
    	
    	const itemIdSplit = itemId.split('/').filter(item => item !== '');
    	const amountSplit = amount.split('/').filter(item => item !== '');
    	const itemPriceSplit = itemPrice.split('/').filter(item => item !== '');
    	
    	const resultArray = [];
    	
    	for (let i = 0; i < length; i++) {
    		  resultArray.push([itemIdSplit[i], amountSplit[i], itemPriceSplit[i] * amountSplit[i]]);
    		}
    	console.log(resultArray);
    	
    	for (let i = 0; i < length; i++) {
    	    $(document).ready(function() {
    	        $('#order').click(function(){
    	            let memberId = '<sec:authentication property="name" />';
    	            console.log("memberId : " + memberId);
    	            let itemId = itemIdSplit[i];
    	            console.log("itemId : " + itemId);
    	            let totalCount = amountSplit[i];
    	            console.log("구매 수량 : " + totalCount);
    	            let totalPrice = itemPriceSplit[i] * amountSplit[i];
    	            console.log("총 가격 : " + totalPrice);
    	            let deliveryAddress = $("#deleveryAddress").val();
    	            console.log("주소 : " + deliveryAddress);

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
    	                        orderCount : i
    	                    }),
    	                    success: function(result) {
    	                        console.log(result);
    	                        alert('결제 성공');
    	                        window.location.href = 'http://192.168.0.148:8080/searcher/item/list';
    	                    }
    	                });
    	    	console.log(i);
    	        });
    	    });
    	}


    </script>
    <input type="hidden" id="deleveryAddress">
    <button id="order" class="button">구매</button>
</body>
</html>