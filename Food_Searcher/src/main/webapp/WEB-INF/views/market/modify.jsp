<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.food.searcher.domain.MarketVO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${marketVO.marketTitle }</title>
</head>
<body>
<%@ include file ="/WEB-INF/views/header.jsp" %>
	<h2>글 수정 페이지</h2>
	<form action="modify" method="POST">
	
	<!-- http://localhost:8080/searcher/market/modify?marketId=94 -->
		
		<sec:authorize access="hasRole('ROLE_MEMBER')">
			<script type="text/javascript">
				alert('관리자만 접근이 가능합니다.');
				window.history.back();
			</script>
		</sec:authorize>
		
		<sec:authorize access="isAnonymous()">
			<script type="text/javascript">
				alert('로그인이 필요합니다.');
				window.history.back();
			</script>
		</sec:authorize>
			
		<div>
			<p>제목 :</p>
			<input type="text" name="marketTitle" placeholder="제목 입력"
				maxlength="30" value="${marketVO.marketTitle }" required>
		</div>


		 <div>
         <p>지역 : </p>
         <select name="marketLocal">
         <option value="jongro"> 종로</option>
         <option value="seodamun">서대문구</option>
         <option value="dobong">도봉구</option>
         <option value="yangcheon">양천구</option>
         <option value="seondong">성동구</option>
         <option value="nowon">노원구</option>
         <option value="jung">중구</option>
         <option value="junglang">중랑구</option>
         <option value="yongsan">용산구</option>
         <option value="gwangjin">광진구</option>
         <option value="mapo">마포구</option>
         <option value="kwanak">관악구</option>
         <option value="kumcheon">금천구</option>
         <option value="gangseo">강서구</option>
         <option value="gangdong">강동구</option>
         <option value="eunpyeong">은평구</option>
         <option value="seongbuk">성북구</option>
         <option value="dongdaemun">동대문구</option>
         <option value="gangbuk">강북구</option>
         <option value="gangnam">강남구</option>
         <option value="yeongduengpo">영등포구</option>
 
         </select>
      </div>
            
            

		<div>
			<p>내용 :</p>
			<textarea rows="20" cols="120" name="marketContent"
				placeholder="내용 입력" maxlength="300" required>${marketVO.marketContent }</textarea>
		</div>

		<!-- 사진 파일 수정은 어떻게...? -->

		<div>
			<input type="submit" value="등록">
		</div>
	</form>
</body>
</html>