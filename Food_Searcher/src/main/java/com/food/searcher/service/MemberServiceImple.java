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
	
	@Override
	public int createMember(MemberVO memberVO) {
		log.info("createBoard()");
		int result = memberMapper.insertMember(memberVO);
		return result;
	}
	
	@Override
	public MemberVO getMemberById(String memberId) {
		log.info("getMemberById()");
		MemberVO vo = memberMapper.selectMemberByMemberId(memberId);
		return vo;
	}
	
	@Override
	public int updateMember(MemberVO memberVO) {
		log.info("updateMember()");
		int result = memberMapper.updateMemberByMemberId(memberVO);
		return result;
	}
	
	@Override
	public int updatePassword(String memberId, String email, String password) {
		log.info("updatePassword()");
		
		return memberMapper.updatePasswordByMemberId(memberId, email, password);
	}
	
	@Override
	public int updateMemberStatus(@Param("memberId") String memberId, @Param("memberStatus") String memberStatus) {
		log.info("updateMemberStatus()");
		log.info(memberId);
		log.info(memberStatus);
		
		return memberMapper.updateMemberStatusByMemberId(memberId, memberStatus);
	}

	@Override
	public List<MemberVO> getAllMember() {
		log.info("getAllMember()");
		return memberMapper.selectList();
	}

	@Override
	public List<MemberVO> searchId(String memberName, String email) {
		log.info("searchId()");
		
		return memberMapper.searchId(memberName, email);
	}
	
	@Override
	public int insertRole(String memberId) {
		log.info("insertRole()");
		return memberMapper.insertRole(memberId);
	}
	
	@Override
	public RoleVO selectRole(String memberId) {
		log.info("selectRole()");
		return memberMapper.selectRoleByMemberId(memberId);
	}
	
	@Override
	public int updateRole(String memberId, String roleName) {
		log.info("updateRole");
		return memberMapper.updateRoleByMemberId(memberId, roleName);
	}

}
