<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 선택창</title>
</head>
<body>
	
	<p>쿠폰 이름</p>
		<input type="text" id="couponName" name="couponName" placeholder="쿠폰 이름 입력">
		<div id="nameMsg" class="message" style="color: red;">쿠폰 이름을 입력해주세요!</div>
		<br>
		
		<p>발급 주체</p>
		<select id="couponIssuer" name="couponIssuer">
			<option value="">발급 제한 없음</option>
			<option value="ROLE_ADMIN">사이트</option>
			<option value="ROLE_SELLER">판매자</option>
		</select>

		<p>할인 가격</p>
		<input type="text" id="couponPrice" name="couponPrice" placeholder="할인가격을 입력해주세요.">원
		<div id="priceMsg" class="message" style="color: red;">할인 가격을 입력해주세요!</div>
		<br>
		
		<p>쿠폰 발급 주기</p>
		<select id="couponEvent" name="couponEvent">
			<option value="oneTime">프로모션용</option>
			<option value="memberDateOfBirth">생일</option>
			<option value="memberMBTI">MBTI</option>
		</select>

		<p>쿠폰 가격 제한</p>
		<input type="text" id="couponUseCondition" name="couponUseCondition" placeholder="가격 제한을 걸어주세요.">원
		<div id="conditionMsg" class="message" style="color: red;">가격 제한을 걸어주세요!</div>
		
		<p>쿠폰 사용 기한</p>
		<input type="text" id="couponExpirationDate" name="couponExpirationDate" placeholder="날짜 제한을 걸어주세요.">일
		<div id="expirationMsg" class="message" style="color: red;">날짜 제한을 걸어주세요!</div>

		<p>쿠폰 정보</p>
		<textarea id="couponContent" name="couponContent"></textarea> <br>
		

		<button class="button" name="btn_insert" id="btn_insert">쿠폰 등록</button>
		<button class="button" name="btn_cancel" id="btn_cancel">취소</button>
	
	

</body>
</html>