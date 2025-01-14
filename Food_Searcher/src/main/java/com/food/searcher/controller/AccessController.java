package com.food.searcher.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
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
public class AccessController {
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
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
	
	@GetMapping("logout")
	public String logoutGET(HttpSession session){
		log.info("logoutGET()");
		session.removeAttribute("memberId");
		
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
	
	// inactive : 비활성화 계정 / active : 활성화 계정
	@ResponseBody
	@PostMapping("/statusUpdate")
	public int statusUpdatePOST(@RequestParam("memberId") String memberId, @RequestParam("memberStatus") String memberStatus,
			HttpSession session) {
		log.info("statusUpdatePOST()");
		log.info(memberId + " : " + memberStatus);
		int result = 0;
		
		result = memberService.updateMemberStatus(memberId, memberStatus);
		
		log.info(result + "행 수정");
		session.removeAttribute("memberId");
		
		return result;
		
	}

	@GetMapping("/idSearch")
	public String ID(Model model) {
		log.info("ID");
		return "access/idSearch";
	}

	@PostMapping("/idSearch") // 아이디 찾기
	public String findId(@RequestParam(value = "memberName", required = false) String memberName,
			@Param("email") String email, Model model) {
		
		log.info("Member Name: " + memberName);
		log.info("Email: " + email);
		model.addAttribute("email", email);
		
		// 파라미터가 null인 경우 에러 처리
		if (memberName == null) {
			log.error("Missing required parameters: memberName or email");
			model.addAttribute("error", "Both memberName and email are required.");
			return "access/idSearch"; // 에러 메시지를 사용자에게 전달
		}

		// MemberService에서 ID 찾기
		MemberVO memberVO = memberService.searchId(memberName, email);
		log.info(memberVO);

		// 검색 결과가 없으면, 에러 메시지 전달
		if (memberVO == null) {
			log.error("No member found with the given memberName and email.");
			model.addAttribute("error", "No member found with the provided details.");
			return "access/idSearch";
		}

		log.info("Returned MemberVO: " + memberVO);

        model.addAttribute("memberName", memberName);
        model.addAttribute("email", email);
		// 결과를 모델에 추가하여 뷰에서 사용하도록 설정
		model.addAttribute("memberVO", memberVO);

		return "access/idSearch"; // 결과 페이지로 이동
	}
	
	@GetMapping("/pwSearch")
	public String pwSearchGET() {
		log.info("pwSearchGET()");
		return "redirect:registerEmail?select=pwSearch";
	}
	
	@PostMapping("/pwSearch")
	public void pwSearchPOST(@Param("email") String email, Model model) {
		log.info("pwSearchPOST()");
		model.addAttribute("email", email);
	}
	
	@PostMapping("/pwUpdate")
	public String pwUpdatePOST(@Param("memberId") String memberId, @Param("email") String email,
			@Param("password") String password, HttpSession session, Model model) {
		log.info("pwUpdatePOST()");
		
		String encPw = passwordEncoder.encode(password);
		
		int result = memberService.updatePassword(memberId, email, encPw);
		String alertMsg;
		
		try {
		if(result == 1) {
			if(session.getAttribute("memberId") != null) {
				log.info("로그인 비밀번호 변경");
				alertMsg = "비밀번호 변경에 성공하였습니다. 보안을 강화하기 위해 자동으로 로그아웃 처리되었습니다. 다시 로그인 해주세요.";
				session.removeAttribute("memberId");
			} else {
				log.info("로그아웃 비밀번호 변경");
				alertMsg = "비밀번호 변경에 성공하였습니다.";
			}
		} else {
			alertMsg = "아이디 또는 이메일이 맞지 않습니다.\n아이디 찾기를 먼저 진행해주세요.";
		}
		} catch (Exception e) {
			alertMsg = "아이디가 존재하지 않습니다.\n아이디 찾기를 먼저 진행해주세요.";
		}
		model.addAttribute("alertMsg", alertMsg);
		return "/auth/login";
		
	}
	
	@GetMapping("/admin")
	public void adminGET(HttpSession session, Model model) {
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
