package com.food.searcher.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.server.ResponseStatusException;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.service.MemberService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/access")
@Log4j
public class AccessController {
	@Autowired
	private MemberService MemberService;
	
	MemberVO memberVO = null;
	
	// register.jsp 페이지 호출
		@GetMapping("/register")
		public void registerGET() {
			log.info("registerGET()");
		} // end registerGET()

		@GetMapping("/login")
		public void loginGET(@RequestParam(value = "logout", required = false) String logout,
				HttpSession session) {
			log.info("loginGET()");
		} // end loginGET()
		
		@PostMapping("/login")
		public String loginPOST(@RequestParam("memberId") String memberId,
				@RequestParam("password") String password,
				HttpSession session, MemberVO vo) {
			log.info("loginPOST()");
			
			try {
				vo = MemberService.getMemberById(memberId);
				if(vo.getPassword().equals(password)) {
					session.setAttribute("memberId", memberId);
					return "/access/login";

				} else {
					return "/access/login";
				}
				
			} catch (Exception e) {
				return "/access/login";
			}
		}
		
		@GetMapping("/memberPage")
		public String memberPageGET(HttpSession session, HttpServletResponse response,
				Model model, MemberVO vo) {
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
				@RequestParam(value = "emailAgree") String emailAgree,
				MemberVO vo, Model model) {
			log.info("updatePOST()");
			
			vo = new MemberVO(memberId, null, null, null, emailAgree, 0, null, memberMBTI, null);
			int result = MemberService.updateMember(vo);
			log.info(result + "행 수정");
			
			vo = MemberService.getMemberById(memberId);
			model.addAttribute("vo", vo);
			
			return "access/memberPage";
		}
		
		@PostMapping("/delete")
		public String deletePOST(@RequestParam("memberId") String memberId,
				HttpSession session){
			int result = MemberService.deleteMember(memberId);
			log.info(result + "행 삭제");
			session.removeAttribute("memberId");
			return "home";
		}

}
