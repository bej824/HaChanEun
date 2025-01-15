package com.food.searcher.domain;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import lombok.Getter;

// MemberVO로 해서 같이 쓰지 않는 이유는 User을 상속받아야되기 때문.
// 다형성을 위해서.
@Getter
public class CustomUser extends User { // User 클래스 상속

	private static final long serialVersionUID = 1L;
	
	private MemberVO member;
	public CustomUser(MemberVO member, 
					 Collection<? extends GrantedAuthority> authorities) {
		// Collection<? extends GrantedAuthority> authorities : 
		//  권한 정보를 저장하는 Collection
		
		// User 클래스 생성자에 username, password, authorities를 적용
		// 인증 및 권한 확인에 필요한 정보
		super(member.getMemberId(), member.getPassword(), authorities);
		
		// 전송된 member 객체 적용
		this.member = member;
	}

}
