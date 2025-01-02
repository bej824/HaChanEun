<%@ page session="false"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style type="text/css">

.search {
    margin: 20px auto; /* 검색 상자의 상단 여백 설정 */
    padding: 20px; /* 내부 여백 설정 */
    width: 100%; /* 전체 너비 설정 */
    text-align: center; /* 내용 중앙 정렬 */
    background-color: #f9f9f9; /* 배경 색상 설정 */
    border-radius: 10px; /* 둥근 테두리 */
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    margin-top: 20px; /* 상단 여백 */
    margin-left: 10px; /* 수평 중앙 정렬 */
    margin-right: auto; /* 수평 중앙 정렬 */
}

/* hover 효과 */
.search-select:hover {
    border-color: #007bff; /* 마우스를 올리면 테두리 색상 변경 */
}

/* focus 시 효과 */
.search-select:focus {
    border-color: #28a745; /* 선택 시 테두리 색상 녹색으로 변환 */
    box-shadow: 0 0 5px rgba(40, 167, 69, 0.5); /* 선택 시 그림자 추가 */
}

/* 테이블 스타일 */
table {
    border-style: solid;
    border-radius: 4px;
    border-width: 1px;
    text-align: center;
    width: 100%; /* 테이블 너비 100%로 설정하여 컨테이너에 맞게 확장 */
    border: 2px solid black; /* 검은색 테두리 추가 */
}

/* 테이블 컨테이너 */
.table-container {
	border-top: 2px solid black;
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
<title>특산품</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<h1>특산품</h1>
	<div class="search">
	상세 검색 :
	<select name="localLocal" id="localLocal"
		onchange="listUpdate(this.value, null)">
		<option value="">전체</option>
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

	<select name="localDistrict" id="localDistrict"
	onchange="listUpdate(document.getElementById('localLocal').value, this.value)">
	<option value="">전체</option>
	</select>
	</div>
	
	<div class="table-container">
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
				<tr onclick="window.location.href='detail?localId=${LocalSpecialityVO.localId }'">
					<td>${LocalSpecialityVO.localLocal }</td>
					<td>${LocalSpecialityVO.localDistrict }</td>
					<td>${LocalSpecialityVO.localTitle }</td>
					<td>${LocalSpecialityVO.replyCount }</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>

	<script type="text/javascript">
		function listUpdate(localLocal, localDistrict) {
			console.log(localLocal, localDistrict);
			let localURL = "localLocal=" + localLocal + "localDistrict=" + localDistrict;
			console.log(localURL);
			
			$.ajax({
				type : 'GET',
				url : 'listDistrict',
				data : {localLocal : localLocal},
				success : function(result) {
					
					let selectOption = $("#localDistrict" );
					selectOption.empty();
					selectOption.append('<option value="">' + 
							    '전체</option>');
					result.forEach(function(districtList){
					let districtOption =
						'<option value="' + districtList + '">' + 
						    districtList + '</option>';
					selectOption.append(districtOption);
					});
					if (localDistrict) {
	                    selectOption.val(localDistrict);  // 선택된 값을 세팅
	                }
				}
			})
			
			$.ajax({
				type : 'GET',
				url : 'localUpdate',
				data : {
					localLocal : localLocal,
					localDistrict : localDistrict
				},
				success : function(result) {

					let tbody = $('table tbody');
					tbody.empty(); // 기존 테이블 내용 비우기

					result.forEach(function(LocalSpecialityVO) {
						let row = '<tr onclick="window.location.href=\'detail?localId=' + LocalSpecialityVO.localId + '\'">' 
				         + '<td>' + LocalSpecialityVO.localLocal + '</td>'
				         + '<td>' + LocalSpecialityVO.localDistrict + '</td>'
				         + '<td>' + LocalSpecialityVO.localTitle + '</td>'
				         + '<td>' + LocalSpecialityVO.replyCount + '</td>'
				         + '</tr>';

						tbody.append(row); // 새로운 데이터 행 추가
					});

				} // end function()
			});
		} // end function localUpdate()
		
	</script>
</body>
</html>
