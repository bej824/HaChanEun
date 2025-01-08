package com.food.searcher.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
	private MemberService MemberService;
	
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
		model.addAttribute("email", email);
	} // end registerPOST()

	@GetMapping("/idCheck")
	@ResponseBody
	public Boolean idCheckGET(@RequestParam("memberId") String memberId, MemberVO vo) {
		log.info("idCheckGET");
		Boolean result = false;
		try {

			vo = MemberService.getMemberById(memberId);

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

	@GetMapping("/login")
	public void loginGET() {
		log.info("loginGET()");
	} // end loginGET()

	@PostMapping("/login")
	public String loginPOST(@RequestParam("memberId") String memberId, @RequestParam("password") String password,
			HttpSession session, MemberVO vo, Model model) {
		log.info("loginPOST()");
		String alertMsg;

		try {
			vo = MemberService.getMemberById(memberId);
			log.info(vo);
			if (vo.getPassword().equals(password)) {
				if(vo.getMemberStatus().equals("비활성")) {
					alertMsg = vo.getMemberStatus() + "된 계정입니다.";
					log.info(alertMsg);
					model.addAttribute("alertMsg", alertMsg);
					return "/access/login";
				} else {
					session.setAttribute("memberId", memberId);
					log.info("Session memberId: " + session.getAttribute("memberId"));
				}
			} else {
				log.info("로그인 실패");
			}

		} catch (Exception e) {
			
		}
		return "redirect:../home";
	}
	
	@GetMapping("logout")
	public String logoutGET(HttpSession session){
		log.info("logoutGET()");
		session.removeAttribute("memberId");
		
		return "redirect:/home";
	}

	@GetMapping("/memberPage")
	public String memberPageGET(HttpSession session, HttpServletResponse response, Model model, MemberVO vo) {
		log.info("memberPageGET()");
		String memberId = (String) session.getAttribute("memberId");
		vo = MemberService.getMemberById(memberId);
		log.info(vo);
		model.addAttribute("vo", vo);
		
		return "access/memberPage";
	}

	@PostMapping("/update")
	public String updatePOST(@RequestParam("memberId") String memberId,
			@RequestParam(value = "memberMBTI", required = false) String memberMBTI,
			@RequestParam(value = "emailAgree") String emailAgree, MemberVO vo, Model model) {
		log.info("updatePOST()");

		vo = new MemberVO(memberId, null, null, null, emailAgree, 0, null, memberMBTI, null, null);
		int result = MemberService.updateMember(vo);
		log.info(result + "행 수정");

		vo = MemberService.getMemberById(memberId);
		model.addAttribute("vo", vo);

		return "access/memberPage";
	}

	@PostMapping("/delete")
	public String deletePOST(@RequestParam("memberId") String memberId, HttpSession session) {
		int result = MemberService.deleteMember(memberId);
		log.info(result + "행 삭제");
		session.removeAttribute("memberId");
		return "home";
	}

	@GetMapping("/ID")
	public String ID(Model model) {
		log.info("ID");
		return "access/ID";
	}

	@PostMapping("/ID") // 아이디 찾기
	public String findId(@RequestParam(value = "memberName", required = false) String memberName,
			Model model) {
		String email = "admin@test.com";
		// 파라미터가 null인 경우 에러 처리
		if (memberName == null || email == null) {
			log.error("Missing required parameters: memberName or email");
			model.addAttribute("error", "Both memberName and email are required.");
			return "access/ID"; // 에러 메시지를 사용자에게 전달
		}

		log.info("Member Name: " + memberName);
		log.info("Email: " + email);

		// MemberService에서 ID 찾기
		MemberVO memberVO = MemberService.searchId(memberName, email);
		log.info(memberVO);

		// 검색 결과가 없으면, 에러 메시지 전달
		if (memberVO == null) {
			log.error("No member found with the given memberName and email.");
			model.addAttribute("error", "No member found with the provided details.");
			return "access/ID";
		}

		log.info("Returned MemberVO: " + memberVO);

        model.addAttribute("memberName", memberName);
        model.addAttribute("email", email);
		// 결과를 모델에 추가하여 뷰에서 사용하도록 설정
		model.addAttribute("memberVO", memberVO);

		return "access/ID"; // 결과 페이지로 이동
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
		
		int result = MemberService.updatePassword(memberId, email, password);
		String alertMsg;
		
		try {
		if(result == 1) {
			if(session.getAttribute("memberId") != null) {
				alertMsg = "비밀번호 변경에 성공하였습니다.\n보안을 강화하기 위해 자동으로 로그아웃 처리되었습니다.\n다시 로그인 해주세요.";
				session.removeAttribute("memberId");
			} else {
				alertMsg = "비밀번호 변경에 성공하였습니다.";
			}
		} else {
			alertMsg = "아이디 또는 이메일이 맞지 않습니다.\n아이디 찾기를 먼저 진행해주세요.";
		}
		} catch (Exception e) {
			alertMsg = "아이디가 존재하지 않습니다.\n아이디 찾기를 먼저 진행해주세요.";
		}
		model.addAttribute("alertMsg", alertMsg);
		return "/access/login";
		
	}

}
