<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>금액 충전</title>
<%@ include file ="../layout/head.jsp" %>
</head>
<body>
	<h1>금액 충전</h1>
	<p><input type="text" id="amount" value="0" style="text-align: right;">원
	<button id="btn_clear">x</button>
	</p>
	
	<p><button class="amount">1000</button> 
	<button class="amount">10000</button>
	<button class="amount">50000</button>
	</p>
	
	<button id="btn_tolUp">충전</button> <button id="btn_cancle">취소</button>
	
	<script type="text/javascript">
	
	window.statusValue = 2;
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
		
		$('#btn_clear').click(function(){
			$('#amount').val('0');
		})
		
		$('.amount').click(function(){
			let amount = parseInt($(this).text());
			let tolUpAmount = parseInt($('#amount').val());
			let totalAmount = tolUpAmount + amount;
			
			if (!/^[0-9]+$/.test(amount)) {
				return;
			}
			
			$('#amount').val(totalAmount);
		})
		
		$('#amount').change(function(){
			let tolUpAmount = parseInt($('#amount').val());
			
			if (!/^[0-9]+$/.test(tolUpAmount)) {
				$('#amount').val('0');
			}
		})
		
		$('#btn_tolUp').click(function(){
			let amount = parseInt($('#amount').val());
			
			if(amount == 0) {
				return;
			}
			
			tolUp(amount);
		})
		
		$('#btn_cancle').click(function(){
    		window.close();
		})
		
		function tolUp(amount) {
			
			
				$.ajax({
					type: 'POST',
				    url: 'tolUpPOST',
				    data: { amount:amount},
				    success: function(result) {
				    	
				    	if(result == 1) {
				    		window.statusValue = result;
				    		window.close();
				    	} else {
				    		window.statusValue = result;
				    		window.close();
				    	}
				    	
				    }
				    
				})
				
		}
		
	})
	
	</script>
	
	

</body>
</html>