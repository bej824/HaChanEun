<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
	<%@ include file ="../header.jsp" %>
		<p>아이디</p>
		<input type="text" name="memberId" id="memberId" placeholder="아이디 입력"
			required>
		<div id="idMsg" class="message" style="color: red;">아이디를 입력해주세요!</div>
		<br>

		<p>비밀번호</p>
		<input type=password name="password" id="password"
			placeholder="비밀번호 입력" required> <br>
		<div id="pwMsg" class="message" style="color: red;">비밀번호를 입력해주세요.</div>

		<p>비밀번호 재입력</p>
		<input type=password name="password2" id="password2"
			placeholder="비밀번호 입력" required> <br>
		<div id="pw2Msg" class="message" style="color: red;">비밀번호 다시 입력해주세요.</div>

		<p>이름</p>
		<input type=text name="memberName" id="memberName" placeholder="이름을 입력해주세요." required>
		<br>

		<p>성별</p>
		<input type="radio" name="memberGender" value="male">남 <input
			type="radio" name="memberGender" value="female">여

		<p>생일</p>
		<input type="text" name="memberDateOfBirth" id="memberDateOfBirth" placeholder="생년월일 8자리를 입력해주세요." required>
		<div id="birthMsg" class="message" style="color: red;"></div>
		<p>
			MBTI <select name="memberMBTI" id="mbti">
				<!-- MBTI 유형 옵션 -->
				<option value=" "></option>
				<option value="ISFJ">ISFJ</option>
				<option value="ISTJ">ISTJ</option>
				<option value="INFJ">INFJ</option>
				<option value="INTJ">INTJ</option>
				<option value="ISTP">ISTP</option>
				<option value="ISFP">ISFP</option>
				<option value="INFP">INFP</option>
				<option value="INTP">INTP</option>
				<option value="ESTP">ESTP</option>
				<option value="ESFP">ESFP</option>
				<option value="ENFP">ENFP</option>
				<option value="ENTP">ENTP</option>
				<option value="ESTJ">ESTJ</option>
				<option value="ESFJ">ESFJ</option>
				<option value="ENFJ">ENFJ</option>
				<option value="ENTJ">ENTJ</option>
			</select>
		</p>

		<p>이메일 : ${email }</p>

		<p>이메일 광고 수신 동의</p>
		<input type="radio" name="emailAgree" value="yes" checked="checked">예
		<input type="radio" name="emailAgree" value="no">아니오 <br>
		<input type=hidden name=email value="${email}" readonly="readonly"> <br>

	<button class="button" name="insert" id="insert">회원가입</button>

	<script type="text/javascript">
    
    $(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
	
		xhr.setRequestHeader(header, token);
	});
    
    $(document).ready(function(){
    	let idCheck = false;
    	let pwCheck = false;
    	let pw2Check = false;
    	let birthCheck = false;
    	
    	$('#memberId').change(function(){
    		let memberId = $(this).val();
  			idCheck = false;
  		  
  		  	if (/[\W_]/.test(memberId) || memberId == '') {
  				$('#idMsg').html('아이디는 공백이나 특수문자를 사용할 수 없습니다.').css('color', 'red');
  				return;
  			}
  		  
  		  	$.ajax({
  		    	type: 'GET',
  		    	url: '../access/idCheck',
  		    	data: { memberId: memberId },
  		    	success: function(result) {
  		      		if (result == 0) {
  		        	$('#idMsg').html('사용 가능한 아이디입니다.').css('color', 'green');
  		        	idCheck = true;
  		      	} else {
  		        	$('#idMsg').html('사용할 수 없는 아이디입니다.').css('color', 'red');
  		        	idCheck = false;
  		      	}
  		    	}
  		  	});
  		})
  		
  		$('#password').change(function(){
  			pwCheck = false;
  			let password = $(this).val();
  			
  			// 하나의 정규식을 사용하여 8자리 이상 + 영소문자 + 숫자 + 특수기호 포함 여부 체크
  		    let passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W_]).{8,}$/;

  		    if (!passwordRegex.test(password)) {  
  		        $('#pwMsg').html('비밀번호는 8자리 이상, 영대소문자, 숫자, 특수기호를 모두 포함해야 합니다.').css('color', 'red');
  		        return;
  		    } else {
  				$('#pwMsg').html('사용 가능한 비밀번호입니다.').css('color', 'green');
  				pwCheck = true;
  			}
  		})
  		
  		$('#password2').change(function(){
  			pw2Check = false;
  			let password = $('#password').val();
  			let password2 = $(this).val();
  			
  			if(pwCheck == false) {
  				return;
  			}
  			else if (password !== password2) {
  		    	$('#pw2Msg').html('비밀번호와 비밀번호 확인이 일치하지 않습니다.').css('color', 'red');
  		    } else {
  		    	$('#pw2Msg').html('비밀번호가 일치합니다.').css('color', 'green');
  		    	pw2Check = true;
  		    }
  		})
  		
  		$('#memberDateOfBirth').change(function(){
  			birthCheck = false;
  			let memberDateOfBirth = $(this).val();
  			const birthMsg = $('#birthMsg');
  			const nowDate = "${nowDate}";
  			const month31 = new Set([1, 3, 5, 7, 8, 10, 12]);
  		    const month30 = new Set([4, 6, 9, 11]);
  			
  			if(!/^\d+$/.test(memberDateOfBirth) || memberDateOfBirth.length > 8 || memberDateOfBirth.length <= 7) {
  				birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
  			} else {
  				const year = parseInt(memberDateOfBirth.slice(0, 4), 10);
  			   	const month = parseInt(memberDateOfBirth.slice(4, 6), 10);
  			    const day = parseInt(memberDateOfBirth.slice(6, 8), 10);
  			   		
  			    if(year < 1901){
  				    birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
  				} else if(nowDate - memberDateOfBirth < 0){
  					birthMsg.html('아직 태어나지 않은 사람의 가입은 거절됩니다.').css('color', 'red');
  				} else if(month < 1 || month > 12){
  					birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
  				} else if(day < 1 || day > 31){
  					birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
  				} else if(month30.has(month) && day == 31){
  					birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
  				} else if(year % 4 != 0 && month == 2 && day > 28){
  					birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
  				} else if(year % 4 == 0 && month == 2 && day > 29){
  					birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
  				} else {
  					birthMsg.html('지구인입니다.').css('color', 'green');
  					birthCheck = true;
  				}
  			    
  			}
  		})
  		
  		$('#insert').click(function(){
			let memberId = document.getElementById('memberId').value;
			let password = document.getElementById('password').value;
			let password2 = document.getElementById('password2').value;
			let memberName = document.getElementById('memberName').value;
			let memberDateOfBirth = document.getElementById('memberDateOfBirth').value;
		    let memberGender = document.querySelector('input[name="memberGender"]:checked').value;
		    let memberMBTI = document.getElementById('mbti').value;
		    let email = '${email }';
		    let emailAgree = document.querySelector('input[name="emailAgree"]:checked').value;

		    if (memberId === "" || password === "" || password2 === "" || memberName === "" || 
		    		memberDateOfBirth == "" || !memberGender || email === "") {
		      alert("모든 필드를 올바르게 입력해주세요.");
		      return;
		    }
		    
		 // 비밀번호와 비밀번호 재입력이 일치하는지 확인
		    if (password !== password2) {
		      alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		      return;
		    }
		    else if (idCheck === true && pwCheck === true && pw2Check === true && birthCheck === true){
		    	insert();
		    }
  			
		function insert() {
			
				let obj = {
						'memberId' : memberId,
						'password' : password,
						'memberName' : memberName,
						'memberDateOfBirth' : memberDateOfBirth,
						'memberGender' : memberGender,
						'memberMBTI' : memberMBTI,
						'email' : email,
						'emailAgree' : emailAgree
				}
				console.log(obj);
			$.ajax({
				type : 'POST', // 메서드 타입
				url : 'registerClear', // url
				headers : { // 헤더 정보
					'Content-Type' : 'application/json' // json content-type 설정
				}, 
				data : JSON.stringify(obj), // JSON으로 변환
				success : function(result) { // 전송 성공 시 서버에서 result 값 전송
					console.log(result);
					if(result == 1) {
						alert('회원가입에 성공하셨습니다.');
						window.location.href = "/searcher/auth/login";
					}
				}
			});
		}
  		})
  		
    })
		
		</script>

</body>
</html>