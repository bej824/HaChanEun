package com.food.searcher.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RoleVO;
import com.food.searcher.persistence.MemberMapper;

import lombok.extern.log4j.Log4j;

@Service // @Component : Spring이 관리하는 객체
@Log4j
@Transactional
public class MemberServiceImple implements MemberService {
	
	@Autowired
	private MemberMapper memberMapper;
	
	// 회원가입
	@Override
	public int createMember(MemberVO memberVO) {
		log.info("createBoard()");
		int result = memberMapper.insertMember(memberVO);
		return result;
	}
	
	// id 중복 체크
	@Override
	public int memberIdCheck(String memberId) {
		log.info("MemberCheck()");
		
		return memberMapper.countMemberById(memberId);
	}
	
	// 멤버 페이지에서의 회원 정보 확인 및 아이디 확인
	@Override
	public MemberVO getMemberById(String memberId) {
		log.info("getMemberById()");
		MemberVO memberVO = memberMapper.selectMemberByMemberId(memberId);
		return memberVO;
	}
	
	// 회원 정보 수정
	@Override
	public int updateMember(MemberVO memberVO) {
		log.info("updateMember()");
		int result = memberMapper.updateMemberByMemberId(memberVO);
		return result;
	}
	
	// 회원 비밀번호 변경
	@Override
	public int updatePassword(String memberId, String email, String password) {
		log.info("updatePassword()");
		
		return memberMapper.updatePasswordByMemberId(memberId, email, password);
	}
	
	@Override
	public List<MemberVO> searchId(String memberName, String email) {
		log.info("searchId()");
		
		return memberMapper.searchId(memberName, email);
	}
	
	// 멤버 권한 관련
	// 권한 부여
	@Override
	public int insertRole(String memberId) {
		log.info("insertRole()");
		return memberMapper.insertRole(memberId);
	}
	
	// 권한 확인
	@Override
	public RoleVO selectRole(String memberId) {
		log.info("selectRole()");
		return memberMapper.selectRoleByMemberId(memberId);
	}
	
	// 권한 업데이트
	@Override
	public int updateRole(String memberId, String roleName) {
		log.info("updateRole");
		return memberMapper.updateRoleByMemberId(memberId, roleName);
	}

}
