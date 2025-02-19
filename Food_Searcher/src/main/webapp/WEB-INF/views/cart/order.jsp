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
<title>Insert title here</title>
</head>
<body>
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
				<td>${CartVO.totalPrice }</td>
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
    
    <input type="hidden" id="deleveryAddress">
    
    <script type="text/javascript">
    	let length = ${cartVOSize };
    	console.log(length);
    	for(let i = 0; i < length; i++) {
    		$(document).ready(function() {
    			$('#order').click(function(){
    				let totalPrice = ${CartVO.totalPrice};
      	    	  	console.log("총 가격 : " + totalPrice);
    			});
    		});
    	}
    </script>
    
    <button id="order" class="button">구매</button>
</body>
</html>