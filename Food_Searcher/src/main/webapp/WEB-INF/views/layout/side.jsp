<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file ="head.jsp" %>
<meta charset="UTF-8">

<style>

#boardArea {
 	box-sizing: border-box;
	width: 150px;
    height: 100vh;
    font-family: "나눔고딕";
    line-height: 2.1;
    border-radius: 8px;
    border: 1px solid #dcdcdc;
    text-decoration: none;
 	float: left;
 	margin-right: 100px;
	margin-left: 100px;
}

li {
    font-size: 13px;
    color: black;
    display: inline-block;
    margin-right: 10px;
    margin-left: 10px;
}

.mainCtg {
      all: unset; /* 모든 기본 스타일 제거 */
      display: inline; /* 텍스트처럼 보이게 */
      cursor: pointer; /* 마우스를 올리면 클릭할 수 있는 커서로 변경 */
      color: black; /* 기본 글자색을 검정색으로 설정 */
      text-decoration: none; /* 기본 링크 밑줄 없애기 */
    }

    /* 클릭했을 때 글자 색이 파란색으로 바뀌게 */
    .mainCtg:active {
      color: blue;
    }

    /* 마우스를 올려도 배경색이 변경되지 않도록 */
    .mainCtg:hover {
      background-color: transparent; /* 배경색을 투명하게 설정 */
      color: black; /* 마우스 올려도 글씨 색은 유지 */
    }

</style>

</head>
<body>

	<div id="boardArea">
		<ul id="checkBox_ctg">
        </ul>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function(){
			
			ctgCheck();
			
			$('#checkBox_ctg').on('click', '.mainCtg', function() {
				var mainCtg = $(this).text();
				console.log(mainCtg);
			});
			
			function ctgCheck(){
				let boardArea = $('#boardArea');
				let checkBox_ctg = boardArea.find('#checkBox_ctg');
				
				checkBox_ctg.empty();
				checkBox_ctg.html('<h5>카테고리</h5>');
            
				
				$.ajax({
					type: 'GET',
			        url: '../ctg/ctgGet',
			        data: {},
			        success: function(result) {
			        	result.forEach(function(ctg) {
			        		
			                let low = '<button class="mainCtg">' + ctg.mainCtg + '</button>'
			                		+ '<br>';
			                
			                if(ctg.mainCtg != '기타') {
			                checkBox_ctg.append(low);
			                }
			            });
			        	
			        }
				})
			}
			
		})
	
	</script>

</body>
</html>