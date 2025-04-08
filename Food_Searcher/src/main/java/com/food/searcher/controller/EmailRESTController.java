package com.food.searcher.controller;

import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.food.searcher.util.EmailAuthUtil;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/access")
@Log4j
public class EmailRESTController {
	
	@Autowired
	private JavaMailSender mailSender;
	@Autowired
	private EmailAuthUtil emailAuth;
	
	@Transactional
	@PostMapping("/emailConfirm")
	public ResponseEntity<Integer> emailConfirmPOST(String email, HttpServletRequest request) 
			throws ServletException, IOException {
		int result = 0;
		Random random = new Random();
		int checkNum = random.nextInt(900000) + 100000;
		
		String subject = "이메일 인증번호";
	    StringBuilder sb = new StringBuilder();
	    sb.append("이메일 인증번호");
	    sb.append("인증번호는 다음과 같습니다 : ");
	    sb.append(checkNum);

	    // 이메일 전송
	    try {
	        sendEmail(email, subject, sb.toString());
	        result = emailAuth.insertAuth(email, checkNum);
	        
	    } catch (Exception e) {
	    	log.error("인증번호 이메일 전송 실패");
	    }
	    
	    return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@PostMapping("/emailCheck")
	public ResponseEntity<Integer> emailCheckPOST(@RequestParam("email") String email ,
			@RequestParam("emailCheck") int emailCheck)
			throws ServletException, IOException {
		int result = 0;
		
		result = emailAuth.checkAuth(email, emailCheck);
		
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
