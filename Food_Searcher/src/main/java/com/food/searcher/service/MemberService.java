package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MemberVO;

public interface MemberService {
	
	int createMember(MemberVO memberVO);
	MemberVO getMemberById(String memberId);
	MemberVO searchId(String memberName, String email);
	int updatePassword(String memberId, String email, String password);
	List<MemberVO> getAllMember();
	int updateMember(MemberVO memberVO);
	int updateMemberStatus(String memberId, String memberStatus);

}
