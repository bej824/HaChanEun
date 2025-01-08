package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.MemberVO;
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
	public int deleteMember(String memberId) {
		log.info("deleteMember()");
		return memberMapper.deleteMemberByMemberId(memberId);
	}

	@Override
	public List<MemberVO> getAllMember() {
		log.info("getAllMember()");
		return memberMapper.selectList();
	}

	@Override
	public MemberVO searchId(String memberName, String email) {
		return memberMapper.searchId(memberName, email);
	}

}
