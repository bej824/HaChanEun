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
	int countMemberById(String memberId);
	MemberVO selectMemberByMemberId(String memberId);
	
	// 아이디 찾기
	List<MemberVO> searchId(@Param("memberName") String memberName, @Param("email") String email, @Param("memberDateOfBirth") int memberDateOfBirth, @Param("memberMBTI") String memberMBTI);
	
	// 비밀번호 확인
	String searchPw(@Param("memberId") String memberId);
	
	// 비밀번호 초기화
	int updatePasswordByMemberId(@Param("memberId") String memberId, @Param("email") String email, @Param("password") String password, @Param("login") boolean login);
	
	// 회원 정보 수정
	int updateMemberByMemberId(@Param("memberId") String memberId, @Param("memberMBTI") String memberMBTI, @Param("emailAgree") String emailAgree);
	// 계정 활성 비활성 업데이트
	int updateStatusByMemberId(@Param("memberId") String memberId, @Param("memberStatus") String memberStatus);
	// email 업데이트
	int updateEmailByMemberId(@Param("memberId") String memberId, @Param("email") String email);
	
	// 멤버 권한
	int insertRole(@Param("memberId") String memberId, @Param("roleName") String roleName);
	List<RoleVO> selectRoleByMemberId(@Param("memberId") String memberId);
	int updateRoleByMemberId(@Param("memberId") String memberId, @Param("roleName") String roleName);

}
