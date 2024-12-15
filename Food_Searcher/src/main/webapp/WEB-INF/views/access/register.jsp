<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
		<form action="../home" method="POST">
		<p>아이디</p>
		<input type=text name="memberId" placeholder = "아이디 입력" required> <br>
		
		<p>비밀번호</p>
		<input type=password name="password" placeholder ="비밀번호를 입력" required> <br>
		
		<p>비밀번호 재입력</p>
		<input type=password name="password2" placeholder ="비밀번호를 입력" required> <br>
		
		<p>이름</p>
		<input type=text name="memberName" placeholder ="이름을 입력해주세요." required> <br>
		
		<p>성별</p>
		<input type="radio" name="memberGender" value="male">남
		<input type="radio" name="memberGender" value="female">여
		
		<p>생일</p>
		<input type=date name="birth" required> <br>
		
		<p>MBTI
		<select name="memberMBTI" id="mbti">
            <!-- MBTI 유형 옵션 -->
            <option value="ISTJ"></option>
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
		
		<p>이메일</p>
		<input type=text name=email placeholder="이메일을 입력해주세요."> <br>
		
		<p>이메일 광고 수신 동의</p>
		<input type="radio" name="emailAgree" value="yes" checked="checked">예
		<input type="radio" name="emailAgree" value="no">아니오 <br>
		
		<button name = "insert" value="회원가입">회원가입</button>
		</form>
		
</body>
</html>