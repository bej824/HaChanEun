package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MemberVO;

public interface MemberService {
	
	int createMember(MemberVO memberVO);
	MemberVO getMemberById(String memberId);
	MemberVO searchId(String memberName, String email);
	List<MemberVO> getAllMember();
	int updateMember(MemberVO memberVO);
	int deleteMember(String memberId);

}
