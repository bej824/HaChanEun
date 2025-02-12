<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<html>
<head>
<link rel="stylesheet" href="../resources/css/Base.css">
<style type="text/css">

.search {
    margin: 20px auto; /* 검색 상자의 상단 여백 설정 */
    padding: 20px; /* 내부 여백 설정 */
    text-align: center; /* 내용 중앙 정렬 */
    background-color: #f9f9f9; /* 배경 색상 설정 */
    border-radius: 10px; /* 둥근 테두리 */
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    margin-top: 20px; /* 상단 여백 */
    margin-left: auto; /* 수평 중앙 정렬 */
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
}

/* 테이블 컨테이너 */
.table-container {
	border-top: 2px solid black;
    width: 100%; /* 테이블이 컨테이너의 전체 너비를 차지하게 설정 */
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

a:link, a:visited, a:hover, a:active {
    color: black; /* 링크, 방문된 링크, hover 상태, active 상태 모두 검은색 */
    text-decoration: none; /* 모든 상태에서 밑줄 없애기 */
    transform: none !important; 
    position: static !important;
    margin: 0 !important;
    top: auto !important;
    left: auto !important;
}

</style>
<title>지역 특산품 안내</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<div id="area">
	<h1><a href='map?localLocal=&localDistrict='>지역 특산품 안내</a></h1>
	<div class="search" id = "search">
	상세 검색 : &nbsp;&nbsp;
	<select name="localLocal" id="localLocal">
		<option value="">전체</option>
		<option value="경기도" <c:if test="${localLocal == '경기도'}">selected</c:if>>경기도</option>
		<option value="강원도" <c:if test="${localLocal == '강원도'}">selected</c:if>>강원도</option>
		<option value="충청북도" <c:if test="${localLocal == '충청북도'}">selected</c:if>>충청북도</option>
		<option value="충청남도" <c:if test="${localLocal == '충청남도'}">selected</c:if>>충청남도</option>
		<option value="전라북도" <c:if test="${localLocal == '전라북도'}">selected</c:if>>전라북도</option>
		<option value="전라남도" <c:if test="${localLocal == '전라남도'}">selected</c:if>>전라남도</option>
		<option value="경상북도" <c:if test="${localLocal == '경상북도'}">selected</c:if>>경상북도</option>
		<option value="경상남도" <c:if test="${localLocal == '경상남도'}">selected</c:if>>경상남도</option>
		<option value="제주도" <c:if test="${localLocal == '제주도'}">selected</c:if>>제주도</option>
	</select>
	&nbsp;&nbsp;
	<select name="localDistrict" id="localDistrict">
	<option value="">전체</option>
	</select>
	
	
	&nbsp;&nbsp;&nbsp;
	특산품 명 : <input type="text" name="localTitle" id="localTitle" value="${localTitle }" placeholder="검색어 입력">
	&nbsp;&nbsp;
	<button id="titleSearch" class="button">검색</button>
	<button id="searchClear" class="button">초기화</button>
	</div>
	
	<div class="table-container">
	<table>
		<thead>
			<tr>
				<th style="width: 60px">번호</th>
				<th style="width: 300px">특산품</th>
				<th style="width: 120px">지역</th>
				<th style="width: 40px">댓글수</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	</div>
	
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	<button onclick="insertSpeciality()" class="button">특산품 등록</button>
	</sec:authorize>

	<script type="text/javascript">
	
		$(document).ready(function(){
			let indexLocalLocal = "${localLocal }";
			let indexLocalDistrict = "${localDistrict }";
			let indexLocalTitle = "${localTitle }";
			let localLocal = $('#localLocal').val();
			let localDistrict = $('#localDistrict').val();
			let localTitle = $('#localTitle').val();
			
			
			if(indexLocalLocal == ''){
			listUpdate(localLocal, localDistrict, localTitle);
			} else if(indexLocalLocal != ''){
			listUpdate(indexLocalLocal, '', indexLocalTitle);
			}
			
			// localLocal만 선택되었을 때
			$('#localLocal').change(function(){
				let localLocal = $(this).val();
				let localDistrict = '';
			    listUpdate(localLocal, localDistrict, localTitle);
			});
			
			// localDistrict까지 둘 다 선별되었을 때
			$('#localDistrict').change(function(){
				let localLocal = $('#localLocal').val();
			    let localDistrict = $(this).val();
			    listUpdate(localLocal, localDistrict, localTitle);
			});
			
			$('#titleSearch').click(function(){
				let localLocal = $('#localLocal').val();
			    let localDistrict = $('#localDistrict').val();
				let localTitle = $('#localTitle').val().replace(/\s+/g, '');
				
				listUpdate(localLocal, localDistrict, localTitle);
			});
			
			// 검색어 초기화
			$('#searchClear').click(function(){
				$("#localLocal").val('');
				$('#localTitle').val('');
				
				listUpdate('', '', '');
			});
				
			function listUpdate(localLocal, localDistrict, localTitle) {
			    
			    if(!/^[가-힣]+$/.test(localLocal)) {
			    	localLocal = "";
			    	localDistrict = "";
			    }
			    
			    if(!/^[가-힣]+$/.test(localDistrict)) {
			    	LocalDistrict = "";
			    }
			    
			    // 목록으로 되돌아온 후, 다시 가면 '전체'로 이동되어 이를 방지하기 위한 코드
			    let localDistrictSelect = localDistrict;
			    if(indexLocalDistrict != ""){
			    	localDistrictSelect = indexLocalDistrict;
			    }
			    
			    $.ajax({
			        type: 'GET',
			        url: 'localUpdate',
			        data: {
			            localLocal: localLocal,
			            localDistrict: localDistrict,
			            localTitle: localTitle
			        },
			        success: function(result) {
			            let tbody = $('table tbody');
			            tbody.empty(); // 기존 테이블 내용 비우기
			            
			            // 중복되는 localDistrict 선별을 위한 변수
			            let localDistrict_optionVal = "";
			            let localDistrict_selectOption = $("#localDistrict");
			            
			            if(localDistrict == ''){
			            
			            localDistrict_selectOption.empty();
			            localDistrict_selectOption.append('<option value="">전체</option>');
			            
			            }
			            
			            result.forEach(function(LocalSpecialityVO) {
			            	
			                let row = '<tr onclick="window.location.href=\'detail?localId=' + LocalSpecialityVO.localId +
			                    '&localLocal=' + localLocal + '&localDistrict=' + localDistrictSelect +'\'">'
			                    + '<td>' + LocalSpecialityVO.localId + '</td>'
			                    + '<td>' + LocalSpecialityVO.localTitle + '</td>'
			                    + '<td>' + LocalSpecialityVO.localLocal + " " + LocalSpecialityVO.localDistrict + '</td>'
			                    + '<td>' + LocalSpecialityVO.replyCount + '</td>'
			                    + '</tr>';
			            	if(indexLocalDistrict != '' && indexLocalDistrict == LocalSpecialityVO.localDistrict){
			            	tbody.append(row); // 새로운 데이터 행 추가
			            	} else if(indexLocalDistrict == '') {
			                tbody.append(row); // 새로운 데이터 행 추가
			            	}
			                
			                // 지역 중복 체크 및 옵션 추가
			                if(localLocal != '' && localDistrict_optionVal != LocalSpecialityVO.localDistrict){
			                	localDistrict_optionVal = LocalSpecialityVO.localDistrict;
			                    let districtOption =
			                        '<option value="' + localDistrict_optionVal + '">' + 
			                        localDistrict_optionVal + '</option>';
			                    localDistrict_selectOption.append(districtOption); // 새로운 지역 옵션 추가
			                
			                }
			                
			            });
			            
			         	// 선택된 값을 세팅
			            if (localDistrict) {
			            	localDistrict_selectOption.val(localDistrict);
		                } else if(indexLocalDistrict){ // indexLocalDistrict가 있다면 선택하고 공백으로 초기화
		                	localDistrict_selectOption.val(indexLocalDistrict);
		                	indexLocalDistrict = '';
		                }
			        } // end success function
			    }); // end ajax
			    
			} // end listUpdate
			
			
			}) // end ready
			
			window.onload = function() {
			    // 새로고침이 감지된 경우
			    if (sessionStorage.getItem("reloaded")) {

			        // URL에서 검색어 제거
			        window.history.replaceState({}, document.title, window.location.pathname);

			        // 새로고침 플래그 삭제
			        sessionStorage.removeItem("reloaded");
			    }
			};

			window.addEventListener("beforeunload", function() {
			    sessionStorage.setItem("reloaded", "true");
			});
			
			function insertSpeciality(){
				console.log("insertSpeciality()");
				window.location.href = 'register';
			}
	</script>
	</div>
	
</body>
</html>