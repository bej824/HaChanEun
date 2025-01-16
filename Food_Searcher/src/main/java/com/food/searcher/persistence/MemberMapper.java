package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RoleVO;

@Mapper
public interface MemberMapper {
	
	// 멤버 관리
	int insertMember(MemberVO memberVO);
	MemberVO selectMemberByMemberId(String memberId);
	List<MemberVO> searchId(@Param("memberName") String memberName, @Param("email") String email);
	int updatePasswordByMemberId(@Param("memberId") String memberId, @Param("email") String email, @Param("password") String password);
	List<MemberVO> selectList();
	int updateMemberByMemberId(MemberVO memberVO);
	int updateMemberStatusByMemberId(@Param("memberId") String memberId, @Param("memberStatus") String memberStatus);
	
	// 멤버 권한
	int insertRole(@RequestParam("memberId") String memberId);
	RoleVO selectRoleByMemberId(@RequestParam("memberId") String memberId);
	int updateRoleByMemberId(@RequestParam("memberId") String memberId, @RequestParam("roleName") String roleName);

}
