package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RoleVO;

public interface MemberService {
	
	int createMember(MemberVO memberVO); // 계정 생성
	int memberIdCheck(String memberId); // 아이디 중복 확인
	MemberVO getMemberById(String memberId); // 멤버페이지 자기정보 확인
	
	List<MemberVO> searchId(String memberName, String email); // id찾기
	String searchPw(String memberId);
	
	int updatePassword(String memberId, String email, String password, boolean login); // 비밀번호 업데이트
	int updateEmail(String memberId, String email); // 이메일 업데이트
	int updateStatus(String memberId, String memberStatus); // 회원 활성/비활성
	int updateMember(String memberId, String memberMBTI, String emailAgree); // 회원 정보 수정
	
	
	int createRole(String memberId, String roleName);
	List<RoleVO> selectRole(String memberId);
	int updateRole(String memberId, String roleName);

}
