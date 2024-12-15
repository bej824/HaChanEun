package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MemberVO;

public interface MemberService {
	
	int createMember(MemberVO memberVO);
	MemberVO getMemberById(String memberId);
	int updateMember(MemberVO memberVO);
	int deleteMember(String memberId);

}
