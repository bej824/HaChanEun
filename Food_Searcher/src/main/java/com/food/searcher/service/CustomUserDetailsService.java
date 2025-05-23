package com.food.searcher.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.food.searcher.domain.CustomUser;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RoleVO;
import com.food.searcher.persistence.MemberMapper;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService { 
	
    @Autowired
    private MemberMapper memberMapper;
   
    // 전송된 username으로 사용자 정보를 조회하고, UserDetails에 저장하여 리턴하는 메서드 
    @Override
    public UserDetails loadUserByUsername(String username) {
    	String memberId = username;
        // 사용자 ID를 이용하여 회원 정보와 권한 정보를 조회
        MemberVO member = memberMapper.selectMemberByMemberId(memberId);
        List<RoleVO> role = memberMapper.selectRoleByMemberId(memberId);
        
        
        // 조회된 회원 정보가 없을 경우 예외 처리
        if (member == null) {
            throw new UsernameNotFoundException("UsernameNotFound");
        }
        
        if (member.getMemberStatus().equals("inactive")) {
        	throw new UsernameNotFoundException("UserInactive");
        }
        	
        // 회원의 역할을 Spring Security의 GrantedAuthority 타입으로 변환하여 리스트에 추가
        List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
        for(int i = 0; i < role.size(); i++) {
        	authorities.add(new SimpleGrantedAuthority(role.get(i).getRoleName()));        	
        }
        
        // UserDetails 객체를 생성하여 회원 정보와 역할 정보를 담아 반환
        UserDetails userDetails = new CustomUser(member, 
								        		authorities);
        return userDetails;
        
        
        
    }

}
