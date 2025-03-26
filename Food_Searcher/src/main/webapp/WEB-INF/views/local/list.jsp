<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<html>
<head>
<link rel="stylesheet" 
	href="${pageContext.request.contextPath }/resources/css/Base.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/List.css">
<style type="text/css">


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
    font-family: 'Noto Sans KR', sans-serif;
}

/* 테이블 헤더 고정 */
thead {
    position: sticky;
    top: 0;
    background-color: #f1f1f1; /* 헤더 배경색 */
    z-index: 1; /* 헤더가 내용 위에 표시되게 */
    font-family: 'Noto Sans KR', sans-serif;
    
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
    font-family: 'Noto Sans KR', sans-serif;
}

/* 목록 항목 스타일 */
li {
    display: inline-block;
    font-family: 'Noto Sans KR', sans-serif;
}

</style>
<title>지역 특산품 안내</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	<%@ include file ="../layout/side.jsp" %>
	<div id="area">
	<div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
	<h1>지역 특산품 안내</h1>
	<div style="display: flex; align-items: center; justify-content: flex-end;">
	<span id="ctg" style="margin-right: 20px; font-weight: bold;"></span>지역 검색 : &nbsp;&nbsp;
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
	<button id="searchClear" class="button">초기화</button>
	</div>
	</div>
	
	<div class="table-container">
	<table>
		<thead>
			<tr>
				<th style="width: 20%">번호</th>
				<th style="width: 30%">지역</th>
				<th style="width: 50%">특산품</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	</div>

	<script type="text/javascript">
	
		$(document).ready(function(){
			let indexLocalLocal = "${localLocal }";
			let indexLocalDistrict = "${localDistrict }";
			let indexLocalTitle = "${localTitle }";
			let indexmainCtg = "${mainCtg}";
			let localLocal = $('#localLocal').val();
			let localDistrict = $('#localDistrict').val();
			let localTitle = $('#localTitle').val();
			let mainCtg;
			
			
			if(indexLocalLocal == ''){
			listUpdate(localLocal, localDistrict, localTitle, indexmainCtg);
			} else if(indexLocalLocal != ''){
			listUpdate(indexLocalLocal, '', indexLocalTitle, indexmainCtg);
			}
			
			// localLocal만 선택되었을 때
			$('#localLocal').change(function(){
				let localLocal = $(this).val();
				let localDistrict = '';
				let localTitle = $('#localTitle').val().replace(/\s+/g, '');
			    listUpdate(localLocal, localDistrict, localTitle, mainCtg);
			});
			
			// localDistrict까지 둘 다 선별되었을 때
			$('#localDistrict').change(function(){
				let localLocal = $('#localLocal').val();
			    let localDistrict = $(this).val();
			    let localTitle = $('#localTitle').val().replace(/\s+/g, '');
			    listUpdate(localLocal, localDistrict, localTitle, mainCtg);
			});
			
			$('#localTitle').change(function(){
				let localLocal = $('#localLocal').val();
			    let localDistrict = $('#localDistrict').val();
				let localTitle = $('#localTitle').val().replace(/\s+/g, '');
				
				listUpdate(localLocal, localDistrict, localTitle, mainCtg);
			});
			
			$('#checkBox_ctg').on('click', '.mainCtg', function() {
				let localLocal = $('#localLocal').val();
			    let localDistrict = $('#localDistrict').val();
				let localTitle = $('#localTitle').val().replace(/\s+/g, '');
				
				if(mainCtg != $(this).text()) {
					mainCtg = $(this).text();
					listUpdate('', '', '', mainCtg);					
				} else {
					listUpdate(localLocal, localDistrict, localTitle, '');
				}
			});
			
			// 검색어 초기화
			$('#searchClear').click(function(){
				$("#localLocal").val('');
				$('#localTitle').val('');
				
				listUpdate('', '', '');
			});
				
			function listUpdate(localLocal, localDistrict, localTitle, mainCtg) {
			    
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
			            localTitle: localTitle,
			            mainCtg: mainCtg
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
			            	
			                let row = '<tr onclick="window.location.href=\'detail?localId=' + LocalSpecialityVO.localId 
			                	+ '&localLocal=' + localLocal 
			                    + '&localDistrict=' + localDistrictSelect 
			                    + '&localTitle=' + localTitle 
			                    + '&mainCtg=' + mainCtg + '\'">'
			                    + '<td>' + LocalSpecialityVO.localId + '</td>'
			                    + '<td>' + LocalSpecialityVO.localLocal + " " 
			                    + LocalSpecialityVO.localDistrict + '</td>'
			                    + '<td>' + LocalSpecialityVO.localTitle + '</td>'
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
			                
			                if (mainCtg != null && mainCtg !== '') {
	                             $('#ctg').text(mainCtg + ' > ');
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