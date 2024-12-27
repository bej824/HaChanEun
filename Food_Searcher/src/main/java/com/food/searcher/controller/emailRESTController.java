package com.food.searcher.controller;

import java.util.Random;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/access")
@Log4j
public class emailRESTController {
	
	@Autowired
	private JavaMailSender mailSender;
	
	private int checkNum = 0;
	
	@GetMapping("registerEmail")
	public void rigisterEmailGET() {
		log.info("registerEmailGET()");
		
	}
	
	@PostMapping("emailConfirm")
	public ResponseEntity<Integer> emailConfirmPOST(String email) {
		log.info("emailConfirmPOST()");
		int result = 0;
		Random random = new Random();
		checkNum = random.nextInt(900000) + 100000;
		log.info("랜덤난수 : " + checkNum);
		
		String subject = "이메일 인증번호";
	    StringBuilder sb = new StringBuilder();
	    sb.append("<h1>이메일 인증번호</h1>");
	    sb.append("<p>인증번호는 다음과 같습니다:</p>");
	    sb.append("<h2>" + checkNum + "</h2>");

	    // 이메일 전송
	    try {
	        sendEmail(email, subject, sb.toString());
	        log.info("인증번호 이메일 전송 성공");
	        result = 1;
	    } catch (Exception e) {
	    	log.info("인증번호 이메일 전송 실패");
	    }
	    return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	private void sendEmail(String to, String subject, String content) throws Exception {
	    SimpleMailMessage message = new SimpleMailMessage();
	    message.setTo(to);
	    message.setSubject(subject);
	    message.setText(content);
	    mailSender.send(message);  // JavaMailSender를 사용하여 이메일 발송
	}
	
	@PostMapping("emailCheck")
	public ResponseEntity<Integer> emailCheckPOST(@RequestParam("emailCheck") int emailCheck) {
		log.info("emailCheckPOST()");
		int result = 0;
		log.info("인증번호 : " + checkNum);
		log.info("입력된 인증번호 : " + emailCheck);
		if(emailCheck == checkNum) {
			result = 1;
		}
		
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

}
