package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RoleVO;

public interface MemberService {
	
	/**
	 * @param memberVO db에 저장할 회원 정보
	 * @return 성공 1, 실패 0
	 */
	int createMember(MemberVO memberVO); // 계정 생성
	
	/**
	 * @param memberId 회원가입 시 중복 확인하기 위해 입력한 id
	 * @return 사용 불가 1, 사용 가능 0
	 */
	int memberIdCheck(String memberId); // 아이디 중복 확인
	
	/**
	 * @param memberId 현재 로그인한 회원 스스로의 id
	 * @return 회원 정보
	 */
	MemberVO getMemberById(String memberId); // 멤버페이지 자기정보 확인
	
	/**
	 * 쿠폰 증정을 위한, 혹은 자신의 계정 id를 찾기 위해 사용되는 코드
	 * @param memberId 계정 검색을 위해 입력받은 id(쿠폰 증정용)
	 * @param memberName 계정 검색을 위해 입력받은 회원 이름.(email과 중복 체크)
	 * @param email 계정 검색을 위해 입력받은 email.(memberName과 중복 체크)
	 * @param memberDateOfBirth 계정 검색을 위해 입력받은 생년월일(쿠폰 증정용)
	 * @param memberMBTI 계정 검색을 위해 입력받은 MBTI(쿠폰 증정용)
	 * @return
	 */
	List<MemberVO> searchId
		(String memberId
		,String memberName
		,String email
		,int memberDateOfBirth
		,String memberMBTI); // id찾기
	
	/**
	 * 로그인한 상황에서, 현재 password 재확인하기 위한 코드
	 * @param memberId password 재확인이 필요한 계정id
	 * @return 암호화된 password
	 */
	String searchPw(String memberId);
	
	int updatePassword
		(String memberId
		,String email
		,String password
		,boolean login); // 비밀번호 업데이트
	
	/**
	 * @param memberId email을 수정하려는 계정 id
	 * @param email 수정하려는, 인증이 완료된 email
	 * @return
	 */
	int updateEmail
		(String memberId
		,String email); // 이메일 업데이트
	
	/**
	 * @param memberId 현재 상태를 수정하려는 계정 id
	 * @param memberStatus 수정될 상황(비활성화 0, 활성 1)
	 * @return 성공 1, 실패 0
	 */
	int updateStatus
		(String memberId
		,String memberStatus); // 회원 활성/비활성
	
	/**
	 * @param memberId
	 * @param memberMBTI
	 * @param emailAgree
	 * @return
	 */
	int updateMember
		(String memberId
		,String memberMBTI
		,String emailAgree); // 회원 정보 수정
	
	
	/**
	 * @param memberId 권한이 부여될 계정 id
	 * @param roleName 부여될 권한의 이름
	 * @return 성공 1, 실패 0
	 */
	int createRole
		(String memberId
		,String roleName);
	
	/**
	 * @param memberId 권한 확인이 필요한 계정 id
	 * @return memberId가 가지고 있는 권한 이름
	 */
	List<RoleVO> selectRole(String memberId);
	
	/**
	 * @param memberId 권한이 변경될 계정 id
	 * @param roleName 변경될 권한 이름
	 * @return 성공 1, 실패 0
	 */
	int updateRole
		(String memberId
		,String roleName);
	
	int selectAmountHeld();
	int updateAmountHeld(int totalPrice, int amountHeld);

}
