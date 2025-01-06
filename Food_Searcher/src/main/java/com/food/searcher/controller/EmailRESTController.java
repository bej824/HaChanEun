package com.food.searcher.controller;

import java.io.IOException;
import java.net.http.HttpRequest;
import java.util.Random;
import java.util.UUID;

<<<<<<< HEAD
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;
=======
import javax.mail.internet.HeaderTokenizer.Token;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
>>>>>>> 3632708bc283457b152d50bb23dfb258f96fd781

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.food.searcher.domain.EmailAuthVO;
import com.food.searcher.util.EmailAuthUtil;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/access")
@Log4j
public class EmailRESTController {
	
	@Autowired
	private JavaMailSender mailSender;
	
<<<<<<< HEAD
	@Autowired
	private EmailAuthUtil emailAuth;
	
=======
>>>>>>> 3632708bc283457b152d50bb23dfb258f96fd781
	@GetMapping("/registerEmail")
	public void rigisterEmailGET() {
		log.info("registerEmailGET()");
		
	}
	
	@PostMapping("/emailConfirm")
<<<<<<< HEAD
	public ResponseEntity<Integer> emailConfirmPOST(String email, HttpSession session) {
=======
	public ResponseEntity<Integer> emailConfirmPOST(String email, HttpServletRequest request) 
			throws ServletException, IOException {
>>>>>>> 3632708bc283457b152d50bb23dfb258f96fd781
		log.info("emailConfirmPOST()");
		int result = 0;
		Random random = new Random();
		int checkNum = random.nextInt(900000) + 100000;
		log.info("랜덤난수 : " + checkNum);
		
		String subject = "이메일 인증번호";
	    StringBuilder sb = new StringBuilder();
	    sb.append("이메일 인증번호");
<<<<<<< HEAD
	    sb.append("인증번호는 다음과 같습니다 : ");
=======
	    sb.append("인증번호는 다음과 같습니다:");
>>>>>>> 3632708bc283457b152d50bb23dfb258f96fd781
	    sb.append(checkNum);

	    // 이메일 전송
	    try {
	        sendEmail(email, subject, sb.toString());
	        log.info("인증번호 이메일 전송 성공");
<<<<<<< HEAD
	        
	        emailAuth.insertAuth(email, checkNum);
	        
=======
	        request.setAttribute("checkNum", checkNum);
>>>>>>> 3632708bc283457b152d50bb23dfb258f96fd781
	        result = 1;
	        
	    } catch (Exception e) {
	    	log.info("인증번호 이메일 전송 실패");
	    }
	    
	    return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@PostMapping("/emailCheck")
	public ResponseEntity<Integer> emailCheckPOST(@RequestParam("emailCheck") String emailCheck,
			@RequestHeader("Authorization") String authorizationHeader)
			throws ServletException, IOException {
		log.info("emailCheckPOST()");
		int result = 0;
<<<<<<< HEAD
=======
		
		// Authorization 헤더에서 토큰 추출

>>>>>>> 3632708bc283457b152d50bb23dfb258f96fd781
		//log.info("인증번호 : " + checkNum);
		log.info("입력된 인증번호 : " + emailCheck);
		//if(emailCheck == checkNum) {
		//	result = 1;
		//}
		
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

	private void sendEmail(String to, String subject, String content) throws Exception {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(to);
		message.setSubject(subject);
		message.setText(content);
		mailSender.send(message);  // JavaMailSender를 사용하여 이메일 발송
	}
	
}
