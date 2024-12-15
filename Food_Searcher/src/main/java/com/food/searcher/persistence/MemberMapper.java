package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.MemberVO;

@Mapper
public interface MemberMapper {
	
	int insertMember(MemberVO memberVO);
	MemberVO selectMemberByMemberId(String memberId);
	int updateMemberByMemberId(MemberVO memberVO);
	int deleteMemberByMemberId(String memberId);

}
