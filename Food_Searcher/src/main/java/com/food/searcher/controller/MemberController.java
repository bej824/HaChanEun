package com.food.searcher.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.service.MemberService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/access")
@Log4j
public class MemberController {
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@GetMapping("memberCoupon")
	public void memberCouponGET() {
	}
	
	// 이메일 인증 호출
	@GetMapping("/registerEmail")
	public void rigisterEmailGET(
			@RequestParam(value="select") String select,
			Model model) {
		model.addAttribute("select", select);
	}

	// 회원가입 페이지 호출
	@PostMapping("/register")
	public void registerPOST(
			@RequestParam("email") String email,
			Model model) {
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String nowDate = now.format(formatter);
		
		model.addAttribute("nowDate", nowDate);
		model.addAttribute("email", email);
	} // end registerPOST()
	
	// 회원가입 시 아이디 중복 체크
	@ResponseBody
	@GetMapping("/idCheck")
	public int idCheckGET(
			@RequestParam("memberId") String memberId,
			MemberVO memberVO) {
		
		int result = memberService.memberIdCheck(memberId);

		return result;
	}
	
	@ResponseBody
	@PostMapping("/pwCheck")
	public boolean pwCheckPOST(
			@RequestParam("password") String password,
			Principal principal) {
		
		String memberId = principal.getName();
		String encodedPassword = memberService.searchPw(memberId);
		boolean result = passwordEncoder.matches(password, encodedPassword);
		
		return result;
	}
	
	// 회원가입 정보 저장
	@ResponseBody
	@PostMapping("/registerClear")
	public int registerPOST(@RequestBody MemberVO memberVO) {
		
		int result = 0;
		String encPw = passwordEncoder.encode(memberVO.getPassword());
		String memberId = memberVO.getMemberId();
		String roleName = "ROLE_MEMBER";
		memberVO.setPassword(encPw);
		
		memberService.createRole(memberId, roleName);
		
		result = memberService.createMember(memberVO);
		
		return result;
	} // end registerPOST()

	@RequestMapping("/login") // 로그인 후 지정 위치로 ...
	public String login(HttpServletRequest request, HttpServletResponse response) {
		String redirectUrl = request.getParameter("redirect");

		if (redirectUrl != null && !redirectUrl.contains("WEB-INF")) {
			// WEB-INF가 포함된 URL을 제외한 리디렉션
			return "redirect:" + redirectUrl;
		}

		return "redirect:/home";
	}
	
	// 로그인 후 자신의 정보 확인 가능한 페이지
	@GetMapping("/memberPage")
	public void memberPageGET(
			Model model,
			MemberVO memberVO,
			Principal principal) {
		String memberId = principal.getName();
		memberVO = memberService.getMemberById(memberId);
		
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		
		
		model.addAttribute("memberVO", memberVO);
		model.addAttribute("nowDate", now.format(formatter));
	}
	
	// 로그인 후 멤버페이지에서의 정보수정
	@ResponseBody
	@PostMapping("/update")
	public int updatePOST(
			@RequestParam("memberId") String memberId,
			@RequestParam(value = "memberMBTI", required = false) String memberMBTI,
			@RequestParam(value = "emailAgree", required = false) String emailAgree,
			MemberVO memberVO,
			Model model) {

		int result = memberService.updateMember(memberId, memberMBTI, emailAgree);

		return result;
	}
	
	
	// email 변경. 인증 관련 요소이기에 컨트롤러만 별도로 빼놓음
	@ResponseBody
	@PostMapping("/emailUpdate")
	public int emailUpdatePOST(
			@RequestParam("email") String email,
			Principal principal) {
		
		String memberId = principal.getName();
		int result = memberService.updateEmail(memberId, email);
		return result;
	}
	
	// inactive : 비활성화 계정 / active : 활성화 계정
	// 계정 활성, 비활성 관련 요소이기에 컨트롤러만 별도로 빼놓음
	@ResponseBody
	@PostMapping("/statusUpdate")
	public int statusUpdatePOST(
			@RequestParam("memberId") String memberId, 
			@RequestParam("memberStatus") String memberStatus) {
		
		int result = memberService.updateStatus(memberId, memberStatus);
		return result;
		
	}
	
	// ID 찾을 때 GET 루트 방지
	@GetMapping("/idSearch")
	public String idSearchGET() {
		return "redirect:registerEmail?select=idSearch";
	}
	
	// ID 찾기 정규 루트
	@PostMapping("/idSearch")
	public void idSearchPOST(
			@Param("email") String email,
			Model model) {
		model.addAttribute("email", email);
	}
	
	// ID 찾기 확인
	@ResponseBody
	@PostMapping("/idSearchAjax") // 아이디 찾기
	public List<MemberVO> idSearchAjaxPOST(
			@RequestParam(value = "memberId", required=false) String memberId,
			@RequestParam(value = "memberName", required=false) String memberName,
			@RequestParam(value = "email", required=false) String email,
			@RequestParam(value = "memberDateOfBirth", required=false, defaultValue = "0") int memberDateOfBirth,
			@RequestParam(value = "memberMBTI", required=false) String memberMBTI,
			MemberVO memberVO) {
		List<MemberVO> result = memberService.searchId
				(memberId, memberName, email, memberDateOfBirth, memberMBTI);

		return result;
	}
	
	// 비밀번호 찾기 GET 루트 방지
	@GetMapping("/pwSearch")
	public String pwSearchGET() {
		return "redirect:registerEmail?select=pwSearch";
	}
	
	// 비밀번호 찾기 정규 루트
	@PostMapping("/pwSearch")
	public void pwSearchPOST(
			@RequestParam(value="memberId", required=false) String memberId,
			@RequestParam("email") String email,
			Model model) {
		if(memberId == null) {
			memberId = "";
		}
		model.addAttribute("memberId", memberId);
		model.addAttribute("email", email);
	}
	
	// 로그인 상태에서의 비밀번호 찾기
	@GetMapping("/pwUpdate")
	public void pwUpdateGET() {
	}
	
	// 비밀번호 변경
	@ResponseBody
	@PostMapping("/pwUpdate")
	public int pwUpdatePOST(
			@RequestParam(value="memberId", required=false) String memberId,
			@RequestParam(value="email")String email,
			@RequestParam(value="password")String password,
			Principal principal,
			Model model,
			boolean login) {
		int result = 0;
		
		if(memberId == null) {
			memberId = principal.getName();			
		}
		password = passwordEncoder.encode(password);
		result = memberService.updatePassword(memberId, email, password, login);
		
		return result;
		
	}

}
