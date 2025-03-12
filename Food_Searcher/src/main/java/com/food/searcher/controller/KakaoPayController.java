package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

import com.food.searcher.domain.ApproveResponse;
import com.food.searcher.domain.ReadyResponse;
import com.food.searcher.service.KakaoPayService;
import com.food.searcher.util.SessionUtils;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/pay")
@Log4j
public class KakaoPayController {

    @Autowired
    private KakaoPayService kakaoPayService;

    // 카카오페이 결제 페이지로 리디렉션
    @GetMapping("/prepare")
    public ReadyResponse preparePayment(int orderId, String itemName, int totalPrice) {
    	log.info("prepare");
        // 결제 준비 API 호출
    	ReadyResponse readyResponse = kakaoPayService.payReady(orderId, itemName, totalPrice);
        log.info(readyResponse);

        // 결제 페이지로 리디렉션
        return readyResponse;
    }
    
    @GetMapping("/success")
    public String success(@RequestParam String pg_token, int orderId) {
    	
    	String tid = SessionUtils.getStringAttributeValue("tid");
        // 결제 승인 처리 API 호출
        ApproveResponse approvalResult = kakaoPayService.payApprove(tid, pg_token, orderId);
        log.info(approvalResult);
        
        // 결제 승인 결과 반환
        return "redirect:/pay/completed";
    }
}

