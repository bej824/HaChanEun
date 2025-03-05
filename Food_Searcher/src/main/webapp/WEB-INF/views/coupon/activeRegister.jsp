<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 선택창</title>
<%@ include file ="../layout/head.jsp" %>
</head>
<body>
	
	<p>쿠폰 아이디 : ${couponActiveVO.couponId }</p>
	<p>쿠폰 이름 : ${couponActiveVO.couponName }</p>
	
	<p>쿠폰 발급일 : ${couponActiveVO.couponIssuedDate }</p>
	<p>쿠폰 만료일 : ${couponActiveVO.couponExpireDate }</p>
	
	<input type="text" id="memberId" name="memberId">
	
	<div id="tableContainer" class="table-container" style="display: none;">
	<table>
		<thead>
			<tr>
				<th style="width: 100px"></th>
				<th style="width: 100px">Id</th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
	<button id="btn_idPick" class="button">선택</button>
	</div>
	<div id="idMsg" class="message" style="color: red;">아이디가 존재하지 않습니다. 다시 확인 후 검색해주세요.</div>
	
	<script type="text/javascript">
	
	$(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		xhr.setRequestHeader(header, token);
	});
	
	$(document).ready(function(){
		
		$('#memberId').change(function(){
			let memberId = $(this).val();
			
			idSearch(memberId);
		})
		
		$('#btn_idPick').click(function(){
			let radioButton = $('input[name="memberRadio"]:checked');
			let memberId = radioButton.data('id');
		
			activeCreate(memberId);
		})
		
		function idSearch(memberId){
			let tableContainer = $('#tableContainer');
			let idMsg = $('#idMsg').val();
			
			$.ajax({
			    type: 'POST',
			    url: '../access/idSearchAjax',
			    data: { memberId: memberId
			    	},
			    success: function(result) {
			    			let tbody = $('table tbody');
				            tbody.empty(); // 기존 테이블 내용 비우기
				            
				            result.forEach(function(memberVO) {
				    		 let row = '<tr>'
				    		 	+ '<td><input type="radio" name="memberRadio" data-id="' + memberVO.memberId + '"></td>'
			                    + '<td>' + memberVO.memberId + '</td>'
				    			+ '</tr>';
				    		 tbody.append(row);
				    		 tableContainer.css('display', 'block');
				    	});
			    }
			  });
		}
		
		function activeCreate(memberId) {
			let couponId = '${couponActiveVO.couponId }';
			let couponName = '${couponActiveVO.couponName }';
			
			let couponIssuedDate = '${couponActiveVO.couponIssuedDate }';
			let couponExpireDate = '${couponActiveVO.couponExpireDate }';
			
			let itemId = '${couponActiveVO.itemId }';
			let itemName = '${couponActiveVO.itemName}';
			
			$.ajax({
			    type: 'POST',
			    url: 'activeCreate',
			    data: { memberId : memberId,
			    		couponId : couponId,
			    		couponName : couponName,
			    		couponIssuedDate : couponIssuedDate,
			    		couponExpireDate : couponExpireDate,
			    		itemId : itemId,
			    		itemName : itemName
			    		
			    	},
			    success: function(result) {
			    	alert("쿠폰 증정이 완료되었습니다.");
			    	window.location.href = "list?itemId=" + itemId;
			    }
			  });
		}
		
	})
	
	</script>

</body>
</html>