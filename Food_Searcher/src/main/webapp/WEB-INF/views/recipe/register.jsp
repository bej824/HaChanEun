<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<title>글 작성 페이지</title>
</head>
<body>
	<%session.getAttribute("memberId"); %>
   <h2>글 작성 페이지</h2>
   <form action="register" method="POST">
   <!-- input 태그의 name은 vo의 멤버 변수 이름과 동일하게 작성 -->
      <div>
         <p>제목 : </p>
         <input type="text" name="recipeTitle" 
         placeholder="제목 입력" maxlength="20" required>
      </div>
      <div>
         <p>작성자 : </p>
         <input type="text" name="memberId" value="<%=session.getAttribute("memberId") %>" maxlength="10" required>
      </div>
      <br>
      <div>
      	<label for="recipeFood">음식 :</label><br>
    	<select id="recipeFood" name="recipeFood">
      	<option value="샌드위치">샌드위치</option>
      	<option value="짜장면">짜장면</option>
      	<option value="짬뽕">짬뽕</option>
      	<option value="마라탕">마라탕</option>
      	<option value="동파육">동파육</option>
      	<option value="스파게티">스파게티</option>
      	<option value="유산슬">유산슬</option>
      	<option value="알리오올리오">알리오올리오</option>
      	<option value="찜닭">찜닭</option>
      	<option value="비빔밥">비빔밥</option>
    </select>
      </div>
      <div>
         <p>내용 : </p>
         <textarea rows="20" cols="120" name="recipeContent" 
         placeholder="내용 입력" maxlength="300" required></textarea>
      </div>
      <div>
         <input type="submit" class="button" value="등록">
      </div>
   </form>
</body>
</html>