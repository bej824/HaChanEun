package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

import com.food.searcher.service.KakaoPayService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/kakaoPay")
@Log4j
public class KakaoPayController {

    @Autowired
    private KakaoPayService kakaoPayService;

    // 카카오페이 결제 페이지로 리디렉션
    @GetMapping("/prepare")
    public RedirectView preparePayment() {
    	log.info("prepare");
        // 결제 준비 API 호출
        String redirectUrl = kakaoPayService.preparePayment();
        log.info(redirectUrl);

        // 결제 페이지로 리디렉션
        return new RedirectView(redirectUrl);
    }
    
    @GetMapping("/success")
    public String success(@RequestParam String pg_token) {
        // 결제 승인 처리 API 호출
        String approvalResult = kakaoPayService.approvePayment(pg_token);
        
        // 결제 승인 결과 반환
        return approvalResult;
    }
}

