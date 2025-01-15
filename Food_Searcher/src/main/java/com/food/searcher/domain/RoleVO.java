package com.food.searcher.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

// memberVO와 별개인 이유는 시큐리티 구조 자체가 회원 권한을 여러개로 만들 수 있게 설정해놨음.
// 한명의 memberId가 여러개의 권한을 가질 수 있음. 즉 하나로 만들면 구조적으로 에러가 발생.
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class RoleVO {
	private int roleId;
	private String memberId;
	private String roleName;

}
