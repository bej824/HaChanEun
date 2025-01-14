package com.food.searcher.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class MemberVO {
	private String memberId; // 아이디
	private String password; // 비밀번호
	private String memberName; // 이름
	private String email; // 이메일
	private String emailAgree; // 이메일 광고 수신 여부
	private String memberAge; // 나이
	private String memberGender; // 성별
	private String memberMBTI; // MBTI
	private String memberConstellation; // 별자리
	private String memberStatus; // 멤버 상태

}
