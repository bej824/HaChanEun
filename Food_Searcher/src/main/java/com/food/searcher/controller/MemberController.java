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
	
	
	// 이메일 인증 호출
	@GetMapping("/registerEmail")
	public void rigisterEmailGET(@RequestParam(value="select") String select, Model model) {
		log.info("registerEmailGET()");
		model.addAttribute("select", select);
	}

	// 회원가입 페이지 호출
	@PostMapping("/register")
	public void registerPOST(@RequestParam("email") String email, Model model) {
		log.info("registerPOST()");
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String nowDate = now.format(formatter);
		
		model.addAttribute("email", email);
		model.addAttribute("nowDate", nowDate);
	} // end registerPOST()
	
	// 회원가입 시 아이디 중복 체크
	@ResponseBody
	@GetMapping("/idCheck")
	public int idCheckGET(@RequestParam("memberId") String memberId, MemberVO memberVO) {
		log.info("idCheckGET");
		
		int result = memberService.memberIdCheck(memberId);

		return result;
	}
	
	// 회원가입 정보 db 저장
	@ResponseBody
	@PostMapping("/registerClear")
	public int registerPOST(@RequestBody MemberVO memberVO) {
		log.info("registerPOST()");
		
		int result = 0;
		String encPw = passwordEncoder.encode(memberVO.getPassword());
		memberVO.setPassword(encPw);
		log.info("회원가입 정보 등록 : " + memberVO);
		
		result = memberService.createMember(memberVO);
		
		return result;
	} // end registerPOST()

	@RequestMapping("/login") // 로그인 후 지정 위치로 ...
	public String login(HttpServletRequest request, HttpServletResponse response) {
		log.info("loginRequest()");
		String redirectUrl = request.getParameter("redirect");

		if (redirectUrl != null && !redirectUrl.contains("WEB-INF")) {
			// WEB-INF가 포함된 URL을 제외한 리디렉션
			return "redirect:" + redirectUrl;
		}

		return "redirect:/home";
	}
	
	// 로그인 후 자신의 정보 확인 가능한 페이지
	@GetMapping("/memberPage")
	public String memberPageGET(Model model, MemberVO memberVO, Principal principal) {
		log.info("memberPageGET()");
		String memberId = principal.getName();
		memberVO = memberService.getMemberById(memberId);
		log.info(memberVO);
		model.addAttribute("vo", memberVO);
		
		return "access/memberPage";
	}
	
	// 로그인 후 멤버페이지에서의 정보수정
	@PostMapping("/update")
	public String updatePOST(@RequestParam("memberId") String memberId,
			@RequestParam(value = "memberMBTI", required = false) String memberMBTI,
			@RequestParam(value = "emailAgree") String emailAgree, MemberVO memberVO, Model model) {
		log.info("updatePOST()");

		memberVO = new MemberVO(memberId, null, null, null, emailAgree, null, null, memberMBTI, null, null);
		int result = memberService.updateMember(memberVO);
		log.info(result + "행 수정");

		memberVO = memberService.getMemberById(memberId);
		model.addAttribute("memberVO", memberVO);

		return "access/memberPage";
	}
	
	// 이후 수정
	// inactive : 비활성화 계정 / active : 활성화 계정
	@ResponseBody
	@PostMapping("/statusUpdate")
	public int statusUpdatePOST(@RequestParam("memberId") String memberId, 
			@RequestParam("memberStatus") String memberStatus) {
		log.info("statusUpdatePOST()");
		log.info(memberId + " : " + memberStatus);
		int result = 0;
		
		result = memberService.updateMemberStatus(memberId, memberStatus);
		
		log.info(result + "행 수정");
		
		return result;
		
	}
	
	// ID 찾을 때 GET 루트 방지
	@GetMapping("/idSearch")
	public String idSearchGET() {
		log.info("idSearchGET()");
		return "redirect:registerEmail?select=idSearch";
	}
	
	// ID 찾기 정규 루트
	@PostMapping("/idSearch")
	public void idSearchPOST(@Param("email") String email, Model model) {
		log.info("idSearchPOST()");
		
		model.addAttribute("email", email);
	}
	
	// ID 찾기 확인
	@ResponseBody
	@PostMapping("/idSearchAjax") // 아이디 찾기
	public List<MemberVO> idSearchAjaxPOST(@RequestParam("memberName") String memberName,
			@Param("email") String email, MemberVO memberVO) {
		log.info("idSearchAjaxPOST()");
		log.info(memberName);
		log.info(email);
		
		List<MemberVO> result = memberService.searchId(memberName, email);

		return result;
	}
	
	// 비밀번호 찾기 GET 루트 방지
	@GetMapping("/pwSearch")
	public String pwSearchGET() {
		log.info("pwSearchGET()");
		return "redirect:registerEmail?select=pwSearch";
	}
	
	// 비밀번호 찾기 정규 루트
	@PostMapping("/pwSearch")
	public void pwSearchPOST(@RequestParam(value="memberId", required=false) String memberId,
			@RequestParam("email") String email, Model model) {
		log.info("pwSearchPOST()");
		
		if(memberId == null) {
			memberId = "";
		}
		model.addAttribute("memberId", memberId);
		model.addAttribute("email", email);
	}
	
	// 비밀번호 찾기 이후 초기화
	@ResponseBody
	@PostMapping("/pwUpdate")
	public int pwUpdatePOST(@Param("memberId") String memberId, @Param("email") String email,
			@Param("password") String password, Model model) {
		log.info("pwUpdatePOST()");
		int result = 0;
		
		String encPw = passwordEncoder.encode(password);
		result = memberService.updatePassword(memberId, email, encPw);
		
		return result;
		
	}
	
	@GetMapping("/admin")
	public void adminGET(Model model) {
		log.info("adminGET()");

	} // end adminGET()
	
	@PostMapping("/roleUpdate")
	public String roleUpdatePOST(@RequestParam("memberId") String memberId) {
		log.info("roleUpdate");
		String roleName = "ROLE_ADMIN";
		int result = memberService.updateRole(memberId, roleName);
		log.info(result + "행 수정");
		
		return "../home";
	} // end roleUpdatePOST

}
