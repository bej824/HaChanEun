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
	@Transactional
	@Override
	public int createMember(MemberVO memberVO) {
		log.info("createMember()");
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
		
		return memberMapper.selectMemberByMemberId(memberId);
	}
	
	// 아이디 찾기
	@Override
	public List<MemberVO> searchId
		(String memberId, String memberName, String email, int memberDateOfBirth, String memberMBTI) {
		log.info("searchId()");
		
		return memberMapper.searchId(memberId, memberName, email, memberDateOfBirth, memberMBTI);
	}
	
	@Override
	public String searchPw(String memberId) {
		log.info("searchPw()");
		
		return memberMapper.searchPw(memberId);
	}
	
	// 회원 비밀번호 변경
	@Override
	public int updatePassword(String memberId, String email, String password, boolean login) {
		log.info("updatePassword()");
		
		return memberMapper.updatePasswordByMemberId(memberId, email, password, login);
	}
	
	@Override
	public int updateEmail(String memberId, String email) {
		log.info("updateEmail()");
		
		return memberMapper.updateEmailByMemberId(memberId, email);
	}
	
	@Override
	public int updateStatus(String memberId, String memberStatus) {
		log.info("updateStatus()");
		
		return memberMapper.updateStatusByMemberId(memberId, memberStatus);
	}
	
	// 회원 정보 수정
	@Override
	public int updateMember(String memberId, String memberMBTI, String emailAgree) {
		log.info("updateMember()");
		
		return memberMapper.updateMemberByMemberId(memberId, memberMBTI, emailAgree);
	}
	
	// 멤버 권한 관련
	// 권한 부여
	@Override
	public int createRole(String memberId, String roleName) {
		log.info("createRole()");
		int result = 0;
		
		try {
			result = memberMapper.insertRole(memberId, roleName);
		} catch (Exception e) {
			
		}
		
		return result;
	}
	
	// 권한 확인
	@Override
	public List<RoleVO> selectRole(String memberId) {
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
