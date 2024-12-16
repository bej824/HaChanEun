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
      <div>
      	<p>음식 : </p>
      	<input type="text" name="recipeFood" maxlength="10" required>
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