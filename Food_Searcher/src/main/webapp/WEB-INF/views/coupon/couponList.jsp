<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta name="authenticatedUser" content="${authentication.name}">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="../resources/css/Base.css">
<style>
/* 테이블 컨테이너 */
.table-container {
    width: 50%; /* 테이블이 컨테이너의 전체 너비를 차지하게 설정 */
    height: 455px; /* 원하는 높이 설정 */
    overflow-y: auto; /* 수직 방향으로 스크롤 추가 */
    margin-left: 10; /* 자동 왼쪽 여백 설정 */
    margin-right: auto; /* 자동 오른쪽 여백 설정 */
    border-radius: 10px; /* 테두리를 둥글게 설정 */
}

/* 테이블 헤더 고정 */
thead {
    position: sticky;
    top: 0;
    background-color: #f1f1f1; /* 헤더 배경색 */
    z-index: 1; /* 헤더가 내용 위에 표시되게 */
    
}

/* 테이블 셀에 대한 스타일 */
th, td {
    border-style: outset;
    border-width: 1px;
    text-align: center;
    padding: 8px; /* 셀 내부 여백 */
}

/* 목록 스타일 */
ul {
    list-style-type: none;
    text-align: center;
}

/* 목록 항목 스타일 */
li {
    display: inline-block;
}
</style>
<title>쿠폰 목록</title>
</head>
<body>

	<h1>쿠폰 목록</h1>
	
	<select id="searchBy" name="searchBy">
		<option value="0">쿠폰 이름</option>
		<option value="1">발급자</option>
		<option value="2">쿠폰 가격</option>
		<option value="3">쿠폰 제한</option>
	</select>
	<input id="searchText"> <button id="btn_search" class="button">검색</button>
	<button id="btn_clear" class="button">검색어 지우기</button>

	<table>
		<thead>
			<tr>
				<th style="width: 40px"></th>
				<th style="width: 100px">쿠폰 이름</th>
				<th style="width: 100px">발급자</th>
				<th style="width: 120px">쿠폰 가격</th>
				<th style="width: 120px">쿠폰 제한</th>
				<th style="width: 100px">쿠폰 발급조건</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<button id="btn_create" class="button">쿠폰 생성</button>
	
	<button id="btn_issue" class="button">쿠폰 발급</button>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		let inputCheck = false;
		
		couponManagement('', '');
		
		$(document).on('click', 'input[name="couponRadio"]', function() {
			inputCheck = true;	
			
		});
		
		$('#btn_issue').click(function(){
			if(inputCheck == false){
				alert("발급할 쿠폰을 선택해주세요");
				return;
			}
			let radioButton = document.querySelector('input[name="couponRadio"]:checked');
			let couponId = radioButton.getAttribute('dataId');
			let couponName = radioButton.getAttribute('dataName');
				
			console.log("쿠폰 아이디 : " + couponId);
			
			let result = confirm(couponName + "를 발급하시겠습니까?");
			if(result) {
				window.location.href="active";
			}
				
		})
		
		$('#btn_create').click(function(){
			window.location.href = "register";
		})
		
		$('#btn_search').click(function(){
			let searchBy = $('#searchBy').val();
			let searchText = $('#searchText').val().trim();
			let searchByList = ["COUPON_NAME", "COUPON_ISSUER", "COUPON_PRICE", "COUPON_USE_CONDITION"];
			
			if(searchText == '') {
				couponManagement('', '');
				return;
			}
			
			searchBy = searchByList[searchBy] ?? '';
			console.log(searchBy);
			
			if(searchBy == "COUPON_PRICE" || searchBy == "COUPON_USE_CONDITION") {
				if(!/^\d+$/.test(searchText)){
					alert("해당 검색 필터로는 숫자만 입력 가능합니다!");
					return;
				}
			}
			
			if(searchBy == '') {
				couponManagement('', '');
			} else {
				couponManagement(searchBy, searchText);
			}
			
		})
		
		$('#btn_clear').click(function(){
			$('#searchText').val('');
			couponManagement('', '');
		})
		
		function couponManagement(searchBy, searchText){
			let event = "";
			
			$.ajax({
			    type: 'GET',
			    url: 'getCoupon',
			    data: {searchBy: searchBy,
			    	searchText: searchText},
			    success: function(result) {
			    	  let tbody = $('table tbody');
			          tbody.empty(); // 기존 테이블 내용 비우기
			    	  result.forEach(function(DiscountCouponVO) {
			    		  if(DiscountCouponVO.couponEvent == 'memberDateOfBirth') {
			    			  event = "생일";
			    		  } else if(DiscountCouponVO.couponEvent == 'oneTime') {
			    			  event = "프로모션";
			    		  } else if(DiscountCouponVO.couponEvent == 'memberMBTI') {
			    			  event = "MBTI";
			    		  } else {
			    			  event = DiscountCouponVO.couponEvent;
			    		  }
			            	
			                let row = 
			                	'<tr>'
			                	+ '<td><input type="radio" id="couponRadio" name="couponRadio" dataId="'
			                	+ DiscountCouponVO.couponId + '" dataName="' + DiscountCouponVO.couponName + '"></td>'
			                    + '<td onclick="window.location.href=\'detail?couponId='
		                		+ DiscountCouponVO.couponId + '\'">' + DiscountCouponVO.couponName + '</td>'
			                    + '<td onclick="window.location.href=\'detail?couponId='
		                		+ DiscountCouponVO.couponId + '\'">' + DiscountCouponVO.couponIssuer + '</td>'
			                    + '<td onclick="window.location.href=\'detail?couponId='
		                		+ DiscountCouponVO.couponId + '\'">' + DiscountCouponVO.couponPrice + "원" + '</td>'
			                    + '<td onclick="window.location.href=\'detail?couponId='
		                		+ DiscountCouponVO.couponId + '\'">' + DiscountCouponVO.couponUseCondition + "원" + '</td>'
			                    + '<td onclick="window.location.href=\'detail?couponId='
		                		+ DiscountCouponVO.couponId + '\'">' + event + '</td>'
			                    + '</tr>';
			                    
			          		tbody.append(row); // 새로운 데이터 행 추가
			      		})
			    }
			    
			  });
			
		}
		
	})
		
	
	</script>

</body>
</html>