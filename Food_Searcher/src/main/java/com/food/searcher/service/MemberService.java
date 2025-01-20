package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RoleVO;

public interface MemberService {
	
	int createMember(MemberVO memberVO);
	int memberIdCheck(String memberId);
	MemberVO getMemberById(String memberId);
	List<MemberVO> searchId(String memberName, String email);
	int updatePassword(String memberId, String email, String password);
	int updateMember(MemberVO memberVO);
	
	int insertRole(String memberId);
	RoleVO selectRole(String memberId);
	int updateRole(String memberId, String roleName);

}
