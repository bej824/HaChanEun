<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
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
<meta charset="UTF-8">
<title>ID 찾기</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
	
	<h1>ID 찾기</h1>
	<form id="idSearchForm" action="pwSearch" method="POST">
	회원 이름 : <input type="text" id="memberName" name="memberName" placeholder="이름을 입력해주세요." required>
	<br> <br>
	email : <input type="text" name="email" id ="email" value="${email }" readonly="readonly">
	
	<input type="hidden" name="memberId" id = "memberId">
	<!-- CSRF 토큰 -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	</form>
	<br> <br>
	<button id="btn_search" class="button">ID 찾기</button>
	<button id="btn_emailUpdate" name="btn_emailUpdate" class="button">이메일 변경</button>
	
	<hr>
	
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
	<input type="hidden" id="memberStatus">
	<button id="btn_idPick" class="button">선택</button>
	</div>

	<script type="text/javascript">
	
		$(document).ajaxSend(function(e, xhr, opt){
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");

			xhr.setRequestHeader(header, token);
		});
		
		$(document).ready(function(){
		let activeFlg = false;
			
		$('#btn_search').click(function(){
			let memberName = document.getElementById('memberName').value;
			let email = "${email }"
			idSearch(memberName, email);
		});
		
		$('#btn_emailUpdate').click(function(){
			let result = confirm("이메일을 수정하시려면 다시 인증해야합니다.\n이메일 인증으로 돌아가시겠습니까?");
	    	if (result) {
	    		window.location.href="registerEmail?select=idSearch";
	    	}
		});
		
		$('#btn_idPick').click(function(){
		let radioButton = document.querySelector('input[name="memberRadio"]:checked');
		let memberId = radioButton.getAttribute('dataId');
		let memberStatus = radioButton.getAttribute('dataStatus');
		
			if(memberStatus == 'active') {
				activeFlg = true;
			} else if(memberStatus == "inactive" && activeFlg == false) {
				activeFlg = false;
			}
			
			let email = '${email }';
			
			console.log(memberId);
			console.log(memberStatus);
			
			if(activeFlg == true) {
	    		
		    	let pwSearch = confirm(memberId + "계정을 선택하셨습니다. \n 패스워드찾기로 이동하시겠습니까?");
		    	if (pwSearch) {
		    		let idSearchForm = document.getElementById("idSearchForm");
		    		idSearchForm.memberId.value = memberId;
		    		idSearchForm.email.value=email;
		    		idSearchForm.submit();
		    	}
		    		
		    } else if(activeFlg == false) {
		    	
		    	let result = confirm(memberId + "계정을 선택하셨습니다. \n 현재 비활성화 되어있습니다. 활성화하시겠습니까?");		    			
		    		
		    	if (result) {
		    		active(memberId);
		    		activeFlg = true;
		    	}
		    	
		    }
			
		})
		
		function idSearch(memberName, email){
			let tableContainer = document.getElementById("tableContainer");
			
			$.ajax({
			    type: 'POST',
			    url: 'idSearchAjax',
			    data: { memberName: memberName,
			    	email: email},
			    success: function(result) {
			    		console.log("검색된 계정 : ", result.length);
			    		if(result.length == 0){
					    	tableContainer.style.display = 'none';
					    	let register = confirm("회원님의 계정이 존재하지 않습니다. 회원가입창으로 이동하시겠습니까?");
					    	if(register){
					    		window.location.href="registerEmail?select=register";
					    	}
			    		} else {
			    			
			    		let tbody = $('table tbody');
			            tbody.empty(); // 기존 테이블 내용 비우기
			            
			            result.forEach(function(memberVO) {
			    		 let row = '<tr>'
			    		 	+ '<td><input type="radio" name="memberRadio" dataId="'+ memberVO.memberId +'" dataStatus="' + memberVO.memberStatus + '"></td>'
		                    + '<td>' + memberVO.memberId + '</td>'
			    			+ '</tr>';
			    		
			    		 tbody.append(row);
			    		 tableContainer.style.display = '';
			    	});
			            }
			    }
			  });
		}
	
		function active(memberId){
			let memberStatus = 'active';
			
			console.log(status);
			
			$.ajax({
			    type: 'POST',
			    url: 'statusUpdate',
			    data: { memberId: memberId,
			    	memberStatus: memberStatus},
			    success: function(result) {
			    	console.log(result);
			      if (result == 1) {
			    	alert("활성화되었습니다.");
			    	let pwSearch = confirm("패스워드찾기로 이동하시겠습니까?");
				    if (pwSearch) {
				    	let idSearchForm = document.getElementById("idSearchForm");
				    	idSearchForm.memberId.value = memberId;
				    	idSearchForm.email.value=email;
				    	idSearchForm.submit();
				    }
			      } else {
			    	  alert("다시 시도해주세요.");
			      }
			    }
			  });
			
		}
		
		})
	</script>


</body>
</html>