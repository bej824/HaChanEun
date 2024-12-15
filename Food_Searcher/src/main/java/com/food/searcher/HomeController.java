package com.food.searcher;

import java.text.DateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.service.MemberService;

import lombok.extern.log4j.Log4j;

/**
 * Handles requests for the application home page.
 */
@Controller
@Log4j
public class HomeController {
	
	@Autowired
	private MemberService MemberService;
	
	MemberVO memberVO = null;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@GetMapping("home")
	public String homeGET() {
		log.info("homeGET()");
		return "home";
	}
	
	@PostMapping("/")
	public String homePOST(@RequestParam("memberId") String memberId,
			HttpSession session) {
		log.info("homePOST()");
		session.setAttribute("memberId", memberId);
		return "home";
	}
	
	@PostMapping("home")
	public String registerPOST(@RequestParam("memberId") String memberId, @RequestParam("password") String password,
			@RequestParam(value = "password2", required = false) String password2, @RequestParam(value = "memberName", required = false) String memberName,
			@RequestParam(value = "memberGender", required = false) String memberGender, @RequestParam(value = "birth", required = false) String birth,
			@RequestParam(value = "memberMBTI", required = false) String memberMBTI,
			@RequestParam(value = "email", required = false) String email, @RequestParam(value = "emailAgree", required = false) String emailAgree) {
		log.info("registerPOST()");
		System.out.println(memberId);
		
		String[] birthSplit = birth.split("-");
		String birthYear = birthSplit[0];
		int birthDay = Integer.parseInt(birthSplit[1] + birthSplit[2]);
		String memberConstellation;
		
		LocalDate now = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy");
		String nowYear = now.format(formatter);
		int memberAge = Integer.parseInt(nowYear) - Integer.parseInt(birthYear);

		if (120 <= birthDay && birthDay <= 218) {
			memberConstellation = "물병자리";
		} else if (219 <= birthDay && birthDay <= 320) {
			memberConstellation = "물고기자리";
		} else if (321 <= birthDay && birthDay <= 419) {
			memberConstellation = "양자리";
		} else if (420 <= birthDay && birthDay <= 520) {
			memberConstellation = "황소자리";
		} else if (521 <= birthDay && birthDay <= 621) {
			memberConstellation = "쌍둥이자리";
		} else if (622 <= birthDay && birthDay <= 320) {
			memberConstellation = "게자리";
		} else if (723 <= birthDay && birthDay <= 822) {
			memberConstellation = "사자자리";
		} else if (823 <= birthDay && birthDay <= 922) {
			memberConstellation = "처녀자리";
		} else if (923 <= birthDay && birthDay <= 1022) {
			memberConstellation = "천칭자리";
		} else if (1023 <= birthDay && birthDay <= 1122) {
			memberConstellation = "전갈자리";
		} else if (1123 <= birthDay && birthDay <= 1221) {
			memberConstellation = "궁수자리";
		} else {
			memberConstellation = "염소자리";
		}
		
		memberVO = new MemberVO(memberId, password, memberName, email, emailAgree, 
				memberAge, memberGender, memberMBTI, memberConstellation);
		log.info(memberVO);
		int result = MemberService.createMember(memberVO);
		log.info(result + "행 등록");

		return "home";
	} // end registerPOST()
	
	@GetMapping("logout")
	public String logoutGET(HttpSession session){
		log.info("logoutGET()");
		session.removeAttribute("memberId");
		
		return "home";
	}
	
}
