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
			<tr>
				<td id="itemInfo" style="text-align: center;"></td>
		</tbody>
	</table>
	
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

    <script>
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
    
    <script type="text/javascript">
	    window.onload = function() {
	    	  // URL에서 count 파라미터를 가져오기
	    	  let urlParams = new URLSearchParams(window.location.search);
	    	  let count = urlParams.get('count'); // count 값 추출
	    	  let itemName = '${itemVO.itemName }';
	    	  let itemPrice = ${itemVO.itemPrice};
	    	  
	    	  document.getElementById("itemInfo").innerHTML = "썸네일 영역" + "<br> 제품명 : " + itemName + "<br> 수량 : " + count + "<br> 총 가격 : " + count * itemPrice + "원";
	    };
    </script>
    
    <script>
	  	$(document).ready(function() {
	    // input 필드들에 대해 이벤트 리스너를 설정
		    $("#postcode, #address, #detailaddress").on("input", updateOutput);
		
		    function updateOutput() {
		      // 각 input 필드의 값을 가져오기
		      const value1 = $("#postcode").val();
		      const value2 = $("#address").val();
		      const value3 = $("#detailaddress").val();
		
		      // 결과를 하나의 필드에 합치기
		      $("#deleveryAddress").val(value1 + " - " + value2 + " " + value3);
		    }
  		});
	</script>
    
    <input type="hidden" id="deleveryAddress">
    
    <form action="order" method="POST">
    	
    </form>
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		$('#order').click(function(){
    			let urlParams = new URLSearchParams(window.location.search);
  	    	  	let count = urlParams.get('count');
  	    	  	let itemId = urlParams.get('itemId');
  	    	  	console.log("수량 : " + count);
  	    	  	let itemPrice = ${itemVO.itemPrice};
  	    	  	console.log("아이템 가격 : " + itemPrice);
    			let memberId = '<sec:authentication property="name" />';
    			console.log("memberId : " + memberId);
    			let totalPrice = count * itemPrice;
    			console.log("총 금액 : " + totalPrice);
    			let deliveryAddress = $("#deleveryAddress").val();
    			console.log("주소 : " + deleveryAddress);
    			
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
    			        deliveryAddress : deliveryAddress
    			    }),
    			    success : function(result) {
    			    	console.log(result);
    			            alert('결제 성공');
    			            window.location.href = 'purchaseHistory';
    			    }
    			});
    		});
    	});
    </script>
    
    <button id="order" class="button">구매</button>
    
</body>
</html>