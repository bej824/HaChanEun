<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	
	<select name="couponSelect" id="couponSelect">
	</select>
	
	<script type="text/javascript">
	
$(document).ready(function(){
		let couponSelectOption = [];
		
		couponList();
		
		function couponList() {
			let memberId = '<sec:authentication property="name" />';
			let itemId = '${param.itemId}';
			let couponSelect = $('#couponSelect');
			
			couponSelect.empty();
			couponSelectOption.push('<option value="'+ 0 +'">'
	    			+ "쿠폰 선택 안함" +'</option>')
			
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
			    			let option = '<option value="'+ CouponActiveVO.couponPrice +'">'
			    			+ CouponActiveVO.couponName + " : " 
			    			+ couponUseCondition + " "
			    			+ CouponActiveVO.couponPrice + "원 할인\. " 
			    			+ couponExpireDate +'</option>';
			    			
			    			couponSelectOption.push(option);
			    			
			    		}
			    		
			    	})
			    			couponSelect.append(couponSelectOption);
			    }
			    	
			})
		}
		
	})
	
	</script>

</body>
</html>