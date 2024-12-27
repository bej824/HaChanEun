<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="commentArea">
    <!-- 댓글 목록 -->
    <div class="comment-list-area">
        
        <ul id="commentList">

            <c:forEach items="${board.commentList}" var="comment">

                <!-- 부모 / 자식 댓글 -->
                <li class="comment-row <c:if test='${comment.parentNo != 0}'>child-comment</c:if>">
                    <p class="comment-writer">

                        <!-- 프로필 이미지 -->
                        <c:if test="${empty comment.profileImage}" >
                        <%-- 프로필 이미지가 없을 경우 --%>
                            <img src="/resources/images/user.png">
                        </c:if>

                        <c:if test="${!empty comment.profileImage}" >
                        <%-- 프로필 이미지가 없을 경우 --%>
                            <img src="${comment.profileImage}">
                        </c:if>

                        <!-- 닉네임 -->
                        <span>${comment.memberNickname}</span>
                        <!-- 작성일 -->
                        <span class="comment-date">${comment.commentCreateDate}</span>
                    </p>
                    
                    <!-- 댓글 내용 -->
                    <p class="comment-content">${comment.commentContent}</p>


                    <!-- 버튼 영역 -->
                    <div class="comment-btn-area">
                        <button onclick = "showInsertComment(${comment.commentNo},this)">답글</button>   
                            
                        <!-- 로그인 회원과 댓글 작성자가 같은 경우 -->  
                    <c:if test="${loginMember.memberNo == comment.memberNo}" >
                        <button id="updateBtn">수정</button>
                        <button id="deleteBtn">삭제</button>
                     </c:if>
                    </div>
                </li>                       
            </c:forEach>
        </ul>
    </div>
    

    <!-- 댓글 작성 부분 -->
    <div class="comment-write-area">
        <textarea id="commentContent"></textarea>
        <button id="addComment">
            댓글<br>
            등록
        </button>
 
    </div>
    
    
    <script>

// 댓글 목록 조회
function selectCommentList(){

    fetch("/comment?boardNo="+boardNo) // GET방식은 주소에 파라미터를 담아서 전달 
    .then(response => response.json()) // json (자바스크립트 객체를 문자열로 반환) 응답 객체 ->파싱
    .then(cList => { // cList:댓글 목록 (객체배열)
        console.log(cList);

        // 화면에 출력되어 있는 댓글 목록 삭제
        const commentList = document.getElementById("commentList"); // ul태그
        commentList.innerHTML = "";

        // cList에 저장된 요소를 하나씩 접근
        for(let comment of cList){

            // 행
            const commentRow = document.createElement("li");
            commentRow.classList.add("comment-row");

            // 답글일 경우 child-comment 클래스 추가
            if(comment.parentNo != 0)  commentRow.classList.add("child-comment");


            // 작성자
            const commentWriter = document.createElement("p");
            commentWriter.classList.add("comment-writer");

            // 프로필 이미지
            const profileImage = document.createElement("img");

            if( comment.profileImage != null ){ // 프로필 이미지가 있을 경우
                profileImage.setAttribute("src", comment.profileImage);
            }else{ // 없을 경우 == 기본이미지
                profileImage.setAttribute("src", "/resources/images/user.png");
            }

            // 작성자 닉네임
            const memberNickname = document.createElement("span");
            memberNickname.innerText = comment.memberNickname;
            
            // 작성일
            const commentDate = document.createElement("span");
            commentDate.classList.add("comment-date");
            commentDate.innerText =  "(" + comment.commentCreateDate + ")";

            // 작성자 영역(p)에 프로필,닉네임,작성일 마지막 자식으로(append) 추가
            commentWriter.append(profileImage , memberNickname , commentDate);
            
            

            // 댓글 내용
            const commentContent = document.createElement("p");
            commentContent.classList.add("comment-content");
            commentContent.innerHTML = comment.commentContent;

            // 행에 작성자, 내용 추가
            commentRow.append(commentWriter, commentContent);

            
            // 로그인이 되어있는 경우 답글 버튼 추가
            if(loginMemberNo != ""){
                // 버튼 영역
                const commentBtnArea = document.createElement("div");
                commentBtnArea.classList.add("comment-btn-area");

                // 답글 버튼
                const childCommentBtn = document.createElement("button");
                childCommentBtn.setAttribute("onclick", "showInsertComment("+comment.commentNo+", this)");
                childCommentBtn.innerText = "답글";

                // 버튼 영역에 답글 버튼 추가
                commentBtnArea.append(childCommentBtn);

                // 로그인한 회원번호와 댓글 작성자의 회원번호가 같을 때만 버튼 추가
                if( loginMemberNo == comment.memberNo   ){

                    // 수정 버튼
                    const updateBtn = document.createElement("button");
                    updateBtn.innerText = "수정";

                    // 수정 버튼에 onclick 이벤트 속성 추가
                    updateBtn.setAttribute("onclick", "showUpdateComment("+comment.commentNo+", this)");                        


                    // 삭제 버튼
                    const deleteBtn = document.createElement("button");
                    deleteBtn.innerText = "삭제";
                    // 삭제 버튼에 onclick 이벤트 속성 추가
                    deleteBtn.setAttribute("onclick", "deleteComment("+comment.commentNo+")");                       


                    // 버튼 영역 마지막 자식으로 수정/삭제 버튼 추가
                    commentBtnArea.append(updateBtn, deleteBtn);

                } // if 끝
                

                // 행에 버튼영역 추가
                commentRow.append(commentBtnArea); 
            }
            

            // 댓글 목록(ul)에 행(li)추가
            commentList.append(commentRow);
        }


    })
    .catch(err => console.log(err));

}

//댓글 등록
const addComment = document.getElementById("addComment");
const commentContent = document.getElementById("commentContent");

addComment.addEventListener("click", e => { // 댓글 등록 버튼이 클릭이 되었을 때

    // 1) 로그인이 되어있나? -> 전역변수 memberNo 이용
    if(loginMemberNo == ""){ // 로그인 X
        alert("로그인 후 이용해주세요.");
        return;
    }

    // 2) 댓글 내용이 작성되어있나?
    if(commentContent.value.trim().length == 0){ // 미작성인 경우
        alert("댓글을 작성한 후 버튼을 클릭해주세요.");

        commentContent.value = ""; // 띄어쓰기, 개행문자 제거
        commentContent.focus();
        return;
    }

    // 3) AJAX를 이용해서 댓글 내용 DB에 저장(INSERT)

    const data = {"commentContent" : commentContent.value,
                  "memberNo" :loginMemberNo,
                  "boardNo" : boardNo}; // JS 객체 

    fetch("/comment",{
        method:"POST",
        headers: { "Content-Type" : "application/json"},
        body :  JSON.stringify(data)// JS 객체 -> json 파싱 
    })
    .then(resp => resp.text())
    .then(result => {
        if(result > 0){ // 등록 성공
            alert("댓글이 등록되었습니다.");

            commentContent.value = ""; // 작성했던 댓글 삭제

            selectCommentList(); // 비동기 댓글 목록 조회 함수 호출
            // -> 새로운 댓글이 추가되어짐

        } else { // 실패
            alert("댓글 등록에 실패했습니다...");
        }
    })
    .catch(err => console.log(err));
});


commentContent.value = ""; // 띄어쓰기, 개행문자 제거
commentContent.focus();
return;
}

// 3) AJAX를 이용해서 댓글 내용 DB에 저장(INSERT)

const data = {"commentContent" : commentContent.value,
          "memberNo" :loginMemberNo,
          "boardNo" : boardNo}; // JS 객체 

fetch("/comment",{
method:"POST",
headers: { "Content-Type" : "application/json"},
body :  JSON.stringify(data)// JS 객체 -> json 파싱 
})
.then(resp => resp.text())
.then(result => {
if(result > 0){ // 등록 성공
    alert("댓글이 등록되었습니다.");

    commentContent.value = ""; // 작성했던 댓글 삭제

    selectCommentList(); // 비동기 댓글 목록 조회 함수 호출
    // -> 새로운 댓글이 추가되어짐

} else { // 실패
    alert("댓글 등록에 실패했습니다...");
}
})
.catch(err => console.log(err));
});


//-----------------------------------------------------------------------------------
//댓글 삭제
function deleteComment(commentNo){

if( confirm("정말로 삭제 하시겠습니까?") ){

fetch()
.then()
.then(result => {
    if(result > 0){
        alert("삭제되었습니다");
        selectCommentList(); // 목록을 다시 조회해서 삭제된 글을 제거
    }else{
        alert("삭제 실패");
    }
})
.catch(err => console.log(err));

}
}


</script>
	
</div>
</body>
</html>