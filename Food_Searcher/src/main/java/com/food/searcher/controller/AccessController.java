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
import com.food.searcher.domain.RoleVO;
import com.food.searcher.service.MemberService;
import com.food.searcher.service.RoleService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/access")
@Log4j
public class AccessController {
	@Autowired
	private MemberService MemberService;

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
		String redirectUrl = request.getParameter("redirect");

		if (redirectUrl != null && !redirectUrl.contains("WEB-INF")) {
			// WEB-INF가 포함된 URL을 제외한 리디렉션
			return "redirect:" + redirectUrl;
		}

		return "redirect:/home";
	}

	@GetMapping("/login")
	public void loginGET(@RequestParam(value = "logout", required = false) String logout, HttpSession session) {
		log.info("loginGET()");
	} // end loginGET()

	@PostMapping("/login")
	public String loginPOST(@RequestParam("memberId") String memberId, @RequestParam("password") String password,
			HttpSession session, MemberVO vo) {
		log.info("loginPOST()");

		try {
			vo = MemberService.getMemberById(memberId);
			if (vo.getPassword().equals(password)) {
				session.setAttribute("memberId", memberId);
			} else {
			}

		} catch (Exception e) {
		}
		return "/access/login";
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

	@PostMapping("/ID") // 아이디 찾기 ...
	public String findId(@RequestParam(value = "memberName", required = false) String memberName,
			@RequestParam(value = "email", required = false) String email, Model model) {
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

}
