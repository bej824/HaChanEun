<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>

	<script type="text/javascript">
	
	let memberDateOfBirth = "${memberVO.memberDateOfBirth}";
	
	$(document).ready(function(){
	birth();
	
	function birth(){
		let age = document.getElementById("age");
		let constellation = document.getElementById("constellation");
		let nowDate = "${nowDate}";
		const nowyear = parseInt(nowDate.slice(0, 4), 10);
		
		const year = parseInt(memberDateOfBirth.slice(0, 4), 10);
		const monthDay = parseInt(memberDateOfBirth.slice(4, 8), 10);
		
		age.innerHTML = nowyear - year;
		   		
		if (120 <= monthDay && monthDay <= 218) {
			constellation.innerHTML = "물병자리";
		} else if (219 <= monthDay && monthDay <= 320) {
			constellation.innerHTML = "물고기자리";
		} else if (321 <= monthDay && monthDay <= 419) {
			constellation.innerHTML = "양자리";
		} else if (420 <= monthDay && monthDay <= 520) {
			constellation.innerHTML = "황소자리";
		} else if (521 <= monthDay && monthDay <= 621) {
			constellation.innerHTML = "쌍둥이자리";
		} else if (622 <= monthDay && monthDay <= 320) {
			constellation.innerHTML = "게자리";
		} else if (723 <= monthDay && monthDay <= 822) {
			constellation.innerHTML = "사자자리";
		} else if (823 <= monthDay && monthDay <= 922) {
			constellation.innerHTML = "처녀자리";
		} else if (923 <= monthDay && monthDay <= 1022) {
			constellation.innerHTML = "천칭자리";
		} else if (1023 <= monthDay && monthDay <= 1122) {
			constellation.innerHTML = "전갈자리";
		} else if (1123 <= monthDay && monthDay <= 1221) {
			constellation.innerHTML = "궁수자리";
		} else {
			constellation.innerHTML = "염소자리";
		}
			
	} // end birth
	
	})
	
	</script>

</body>
</html>