package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.ApproveResponse;
import com.food.searcher.domain.ReadyResponse;
import com.food.searcher.service.KakaoPayService;
import com.food.searcher.util.SessionUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/pay")
@Log4j
public class KakaoPayController {

    @Autowired
    private KakaoPayService kakaoPayService;
    
    @GetMapping("/prepare")
    public void main() {
    	
    }
    
    @GetMapping("/ready")
    public void ready() {
    	
    }

    // 카카오페이 결제 페이지로 리디렉션
    @ResponseBody
    @PostMapping("/ready")
    public ReadyResponse preparePayment(@RequestBody ApproveResponse approve, Model model) {
    	log.info("ready()");
        // 결제 준비 API 호출
    	
    	String orderId = approve.getPartner_order_id();
    	String itemName = approve.getItem_name();
    	int totalPrice = approve.getTotal_amount();
    	
    	// 카카오 결제 준비하기
    	ReadyResponse readyResponse = kakaoPayService.payReady(orderId, itemName, totalPrice);
    	// 세션에 결제 고유번호(tid) 저장
        SessionUtils.addAttribute("tid", readyResponse.getTid());
        SessionUtils.addAttribute("partner_order_id", orderId);
        model.addAttribute("response", readyResponse);
        
        readyResponse.getNext_redirect_pc_url();

        // 결제 페이지로 리디렉션
        return readyResponse;
    }
    
    @GetMapping("/completed")
    public String completed(@RequestParam("pg_token") String pg_token, Model model) {
    	String tid = SessionUtils.getStringAttributeValue("tid");
    	String orderId = SessionUtils.getStringAttributeValue("partner_order_id");
        // 결제 승인 처리 API 호출
        ApproveResponse approvalResult = kakaoPayService.payApprove(tid, pg_token, orderId);
        
        model.addAttribute("response", approvalResult);
        
        // 결제 승인 결과 반환
        return "redirect:/pay/approve?pg_token="+pg_token;
    }
    
    @GetMapping("/cancel")
    public void cancel() {
    	
    }
    
    @GetMapping("/fail")
    public void fail() {
    	
    }
    
    @GetMapping("/approve")
    public void approve() {
    	
    }
}

