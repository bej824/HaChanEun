<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page
	import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*"%>
<!DOCTYPE html>
<html>
<head>

<style type="text/css">
.button {
	background-color: #04AA6D;
	border: none;
	color: white;
	padding: 6px 12px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
}

textarea {
	width: 700px;
	height: 280px;
	padding: 12px 20px;
	box-sizing: border-box;
	border: 2px solid #ccc;
	border-radius: 4px;
	background-color: #f8f8f8;
	font-size: 16px;
	resize: none;
}
</style>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<h2>글 작성 페이지</h2>
	<form action="register" method="POST" enctype="multipart/form-data">

		<div>
			<p>제목 :</p>
			<input type="text" name="marketTitle" placeholder="제목 입력"
				maxlength="20" required>
		</div>

		<div>
			<p>지역 :</p>
			<select name="marketLocal">
				<option value="종로"> 종로</option>
         <option value="서대문구">서대문구</option>
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

		<!-- https://news.seoul.go.kr/economy/archives/66052 -->

		<br>

		<div>



			<p>내용 :</p>
			<div class="addImage" id="imageShow">
				<!-- 이미지 띄울 공간 -->
			</div>
			<input type="file" accept="image/*" onchange="loadFile(this)">

			<br>
			<textarea rows="20" cols="120" name="marketContent"
				placeholder="내용 입력" maxlength="300" required></textarea>
			<br> <input type="submit" value="등록">

			<script>
				// 미리보기
				function loadFile(input) {
					let file = input.files[0]; // 선택파일 가져오기

					let newImage = document.createElement("img"); //새 이미지 태그 생성

					//이미지 source 가져오기
					newImage.src = URL.createObjectURL(file);
					newImage.style.width = "10%";
					newImage.style.height = "10%";
					newImage.style.objectFit = "cover"; // div에 넘치지 않고 들어가게

					//이미지를 imageShow div에 추가
					let container = document.getElementById('imageShow');
					container.appendChild(newImage);
				}
			</script>

		</div>


	</form>
</body>
</html>
