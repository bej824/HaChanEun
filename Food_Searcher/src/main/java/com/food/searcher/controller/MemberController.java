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
	
	// 회원가입 시 이메일 인증 호출
	@GetMapping("/registerEmail")
	public void rigisterEmailGET(@RequestParam(value="select") String select, Model model) {
		log.info("registerEmailGET()");
		model.addAttribute("select", select);
	}

	// register.jsp 페이지 호출
	@PostMapping("/register")
	public void registerPOST(@RequestParam("email") String email, Model model) {
		log.info("registerPOST()");
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String nowDate = now.format(formatter);
		
		model.addAttribute("email", email);
		model.addAttribute("nowDate", nowDate);
	} // end registerPOST()
	
	@ResponseBody
	@PostMapping("/registerClear")
	public int registerPOST(@RequestBody MemberVO memberVO) {
		log.info("registerPOST()");
		log.info(memberVO);
		int result = memberService.createMember(memberVO);
		log.info(result + "행 등록");
		
		return result;
	} // end registerPOST()

	@GetMapping("/idCheck")
	@ResponseBody
	public Boolean idCheckGET(@RequestParam("memberId") String memberId, MemberVO vo) {
		log.info("idCheckGET");
		Boolean result = false;
		try {

			vo = memberService.getMemberById(memberId);

			if (vo != null || memberId == "" || memberId.matches(".*[\\W_].*")) {
				result = true;
			}
		} catch (Exception e) {
			result = false;
		}

		return result;
	}

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

	@GetMapping("/memberPage")
	public String memberPageGET(Model model, MemberVO vo, Principal principal) {
		log.info("memberPageGET()");
		String memberId = principal.getName();
		vo = memberService.getMemberById(memberId);
		log.info(vo);
		model.addAttribute("vo", vo);
		
		return "access/memberPage";
	}

	@PostMapping("/update")
	public String updatePOST(@RequestParam("memberId") String memberId,
			@RequestParam(value = "memberMBTI", required = false) String memberMBTI,
			@RequestParam(value = "emailAgree") String emailAgree, MemberVO vo, Model model) {
		log.info("updatePOST()");

		vo = new MemberVO(memberId, null, null, null, emailAgree, null, null, memberMBTI, null, null);
		int result = memberService.updateMember(vo);
		log.info(result + "행 수정");

		vo = memberService.getMemberById(memberId);
		model.addAttribute("vo", vo);

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
	
	@GetMapping("/idSearch")
	public String idSearchGET() {
		log.info("idSearchGET()");
		return "redirect:registerEmail?select=idSearch";
	}

	@PostMapping("/idSearch")
	public void idSearchPOST(@Param("email") String email, Model model) {
		log.info("idSearchPOST()");
		
		model.addAttribute("email", email);
	}
	
	@ResponseBody
	@PostMapping("/idSearchAjax") // 아이디 찾기
	public MemberVO idSearchAjaxPOST(@RequestParam("memberName") String memberName,
			@Param("email") String email, MemberVO memberVO) {
		log.info("idSearchAjaxPOST()");
		log.info(memberName);
		log.info(email);
		
		memberVO = memberService.searchId(memberName, email);

		return memberVO;
	}
	
	@GetMapping("/pwSearch")
	public String pwSearchGET() {
		log.info("pwSearchGET()");
		return "redirect:registerEmail?select=pwSearch";
	}
	
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
	
	@ResponseBody
	@PostMapping("/pwUpdate")
	public int pwUpdatePOST(@Param("memberId") String memberId, @Param("email") String email,
			@Param("password") String password, Model model, PasswordEncoder passwordEncoder) {
		log.info("pwUpdatePOST()");
		
		int result = 0;
		
		try {
			String encPw = passwordEncoder.encode(password);
			result = memberService.updatePassword(memberId, email, encPw);
			
		} catch (Exception e) {
			
		}
		
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
