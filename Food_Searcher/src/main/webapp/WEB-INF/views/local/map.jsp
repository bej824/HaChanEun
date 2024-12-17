<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style type="text/css">
table {
	border-style: solid;
	border-radius: 4px;
	border-width: 1px;
	text-align: center;
}

th, td {
	border-style: outset;
	border-width: 1px;
	text-align: center;
}

ul {
	list-style-type: none;
	text-align: center;
}

li {
	display: inline-block;
}

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
</style>
<title>특산품</title>
</head>
<body>
	상세 검색 :
	<select name="localLocal" id="localLocal" onchange="checkLocal(this.value)">
		<option value=" "></option>
		<option value="경기도">경기도</option>
		<option value="강원도">강원도</option>
		<option value="충청북도">충청북도</option>
		<option value="충청남도">충청남도</option>
		<option value="전라북도">전라북도</option>
		<option value="전라남도">전라남도</option>
		<option value="경상북도">경상북도</option>
		<option value="경상남도">경상남도</option>
		<option value="제주도">제주도</option>
	</select>
	<div id="localCheck" class="message"></div>
	<br>
	
	<table>
		<thead>
			<tr>
				<th style="width: 100px">지역</th>
				<th style="width: 100px">상세</th>
				<th style="width: 150px">특산품</th>
				<th style="width: 100px">댓글수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="LocalSpecialityVO" items="${SpecialityList }">
			<tr>
			<td>${LocalSpecialityVO.localLocal }</td>
			<td>${LocalSpecialityVO.localDistrict }</td>
			<td>${LocalSpecialityVO.localTitle }</td>
			<td>${LocalSpecialityVO.replyCount }</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	<ul>
		<!-- 이전 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isPrev() }">
			<li><a href="list?pageNum=${pageMaker.startNum - 1}">이전</a></li>
		</c:if>
		<!-- 반복문으로 시작 번호부터 끝 번호까지 생성 -->
		<c:forEach begin="${pageMaker.startNum }" end="${pageMaker.endNum }"
			var="num">
			<li><a href="list?pageNum=${num }" class="button">${num }</a></li>
		</c:forEach>
		<!-- 다음 버튼 생성을 위한 조건문 -->
		<c:if test="${pageMaker.isNext() }">
			<li><a href="list?pageNum=${pageMaker.endNum + 1}">다음</a></li>
		</c:if>
	</ul>

	<script type="text/javascript">
	function checkLocal(local) {
	    console.log(local);
	    
	    $.ajax({
		    type: 'GET',
		    url: 'checkLocal',
		    data: { local: local },
		    success: function(result) {
		        $('#localCheck').html(result);
		    }
		  });
	}
	</script>
		</body>
		</html>
	