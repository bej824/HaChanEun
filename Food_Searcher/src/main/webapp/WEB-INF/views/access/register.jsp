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
			required onblur="checkId(this.value)">
		<div id="idMsg" class="message" style="color: red;">아이디를 입력해주세요!</div>
		<br>

		<p>비밀번호</p>
		<input type=password name="password" id="password"
			placeholder="비밀번호 입력" required> <br>

		<p>비밀번호 재입력</p>
		<input type=password name="password2" id="password2"
			placeholder="비밀번호 입력" required> <br>

		<p>이름</p>
		<input type=text name="memberName" id="memberName" placeholder="이름을 입력해주세요." required>
		<br>

		<p>성별</p>
		<input type="radio" name="memberGender" value="male">남 <input
			type="radio" name="memberGender" value="female">여

		<p>생일</p>
		<input type="text" name="birthday" placeholder="생년월일을 입력해주세요."
		onblur="birth(this.value)" required>
		<div id="birthMsg" class="message" style="color: red;"></div>
		<input type="hidden" name="memberAge">
		<input type="hidden" name="memberConstellation">
		<p>
			MBTI <select name="memberMBTI" id="mbti">
				<!-- MBTI 유형 옵션 -->
				<option value=" "></option>
				<option value="ISFJ">ISFJ</option>
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

	<button class="button" name="insert" onclick="insert()">회원가입</button>

	<script type="text/javascript">
	let memberAge = "";
    let memberConstellation = "";
    
    $(document).ajaxSend(function(e, xhr, opt){
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
	
		xhr.setRequestHeader(header, token);
	});
	
	function birth(birthday){
		const birthMsg = $('#birthMsg');
		const nowDate = "${nowDate}";
		const nowyear = parseInt(nowDate.slice(0, 4), 10);
		const month31 = new Set([1, 3, 5, 7, 8, 10, 12]);
	    const month30 = new Set([4, 6, 9, 11]);
		
		if(!/^\d+$/.test(birthday) || birthday.length > 8 || birthday.length <= 7) {
			birthMsg.html('생년월일을 확인해주세요.');
			birthCheck = false;
		} else {
			const year = parseInt(birthday.slice(0, 4), 10);
		   	const month = parseInt(birthday.slice(4, 6), 10);
		    const day = parseInt(birthday.slice(6, 8), 10);
		    const monthDay = month * 100 + day;
		   	
			console.log("오늘 : ", nowDate);
		   		
		    if(year < 1901){
			    birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
				birthCheck = false;
			} else if(nowDate - birthday < 0){
				birthMsg.html('아직 태어나지 않은 사람의 가입은 거절됩니다.').css('color', 'red');
				birthCheck = false;
			} else if(month < 1 || month > 12){
				birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
				birthCheck = false;
			} else if(day < 1 || day > 31){
				birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
				birthCheck = false;
			} else if(month30.has(month) && day == 31){
				birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
				birthCheck = false;
			} else if(year % 4 != 0 && month == 2 && day > 28){
				birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
				birthCheck = false;
			} else if(year % 4 == 0 && month == 2 && day > 29){
				birthMsg.html('생년월일을 확인해주세요.').css('color', 'red');
				birthCheck = false;
			} else {
				let age = parseInt(nowyear) - parseInt(year);
				let birth = year + '.' + month + '.' + day;
				let constellation = "";
				birthMsg.html('지구인입니다.').css('color', 'green');
				
				if (120 <= monthDay && monthDay <= 218) {
					constellation = "물병자리";
				} else if (219 <= monthDay && monthDay <= 320) {
					constellation = "물고기자리";
				} else if (321 <= monthDay && monthDay <= 419) {
					constellation = "양자리";
				} else if (420 <= monthDay && monthDay <= 520) {
					constellation = "황소자리";
				} else if (521 <= monthDay && monthDay <= 621) {
					constellation = "쌍둥이자리";
				} else if (622 <= monthDay && monthDay <= 320) {
					constellation = "게자리";
				} else if (723 <= monthDay && monthDay <= 822) {
					constellation = "사자자리";
				} else if (823 <= monthDay && monthDay <= 922) {
					constellation = "처녀자리";
				} else if (923 <= monthDay && monthDay <= 1022) {
					constellation = "천칭자리";
				} else if (1023 <= monthDay && monthDay <= 1122) {
					constellation = "전갈자리";
				} else if (1123 <= monthDay && monthDay <= 1221) {
					constellation = "궁수자리";
				} else {
					constellation = "염소자리";
				}
				
				memberAge = age;
				memberConstellation = constellation;
				birthCheck = true;
				console.log("나이 : ", age, ", 별자리 : " + constellation);
			}
		    
		}
		
	} // end birth

	function checkId(memberId) {
		  console.log("memberId :", memberId);
		  idCheck = false;
		  
		  if (/[\W_]/.test(memberId)) {
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
		}
		
		function insert() {
			const token = $("meta[name='_csrf']").attr("content");
			const header = $("meta[name='_csrf_header']").attr("content");
			
			let memberId = document.getElementById('memberId').value;
			let password = document.getElementById('password').value;
			let password2 = document.getElementById('password2').value;
			let memberName = document.getElementById('memberName').value;
		    let memberGender = document.querySelector('input[name="memberGender"]:checked').value;
		    let memberMBTI = document.getElementById('mbti').value;
		    let email = '${email }';
		    let emailAgree = document.querySelector('input[name="emailAgree"]:checked').value;
		    
		    console.log(memberId);
		    console.log(password);
		    console.log(memberName);
		    console.log(memberGender);
		    console.log(memberMBTI);
		    console.log(memberAge);
		    console.log(memberConstellation);
		    console.log(email);
		    console.log(emailAgree);

		    if (memberId === "" || password === "" || password2 === "" || memberName === "" || 
		    		!memberGender || memberAge === "" || memberConstellation ==="" || email === "") {
		      alert("모든 필드를 올바르게 입력해주세요.");
		      return;
		    }

		    // 비밀번호와 비밀번호 재입력이 일치하는지 확인
		    if (password !== password2) {
		      alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		      return;
		    }
			
			if (idCheck === true && birthCheck === true){
				
				let obj = {
						'memberId' : memberId,
						'password' : password,
						'memberName' : memberName,
						'memberGender' : memberGender,
						'memberMBTI' : memberMBTI,
						'memberAge' : memberAge,
						'memberConstellation' : memberConstellation,
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
			
			} else {
				return;
			}
		}
		</script>

</body>
</html>