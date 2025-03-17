<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>충전 test</title>
</head>
<body>
<%@ include file ="../header.jsp" %>
<input type="text" id="orderId" value="123456789">
<input type="text" id="itemName" value="item">
<input type="text" id="totalPrice" value="10000">
<button id="btn-pay-ready">충전</button>
<script type="text/javascript">
    // 카카오페이 결제 팝업창 연결
    $(document).ready(function(){
        $("#btn-pay-ready").click(function(e) {
        	let orderId = $('#orderId').val();
        	let itemName = $('#itemName').val();
        	let totalPrice = $('#totalPrice').val();
        	console.log(orderId);
        	console.log(itemName);
            // 아래 데이터 외에도 필요한 데이터를 원하는 대로 담고, Controller에서 @RequestBody로 받으면 됨
            let data = {
            	partner_order_id: orderId,
            	item_name: itemName,    // 카카오페이에 보낼 대표 상품명
            	total_amount: totalPrice // 총 결제금액
            };
          	console.log(data);
            $.ajax({
                type: 'POST',
                url: 'ready',
                headers : { // 헤더 정보
					'Content-Type' : 'application/json' // json content-type 설정
				}, 
                data: JSON.stringify(data),
                contentType: 'application/json',
                success: function(response) {
                	console.log(response);
                	location.href = response.next_redirect_pc_url;
                }
            });
        });
    });
</script>
</body>
</html>