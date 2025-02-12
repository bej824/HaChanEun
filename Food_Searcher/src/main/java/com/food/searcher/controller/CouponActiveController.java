package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.service.CouponActiveService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/coupon")
@Log4j
public class CouponActiveController {
	
	@Autowired
	CouponActiveService couponActiveService;
	
	@GetMapping("active")
	public void activeGET(CouponActiveVO couponActiveVO) {
		log.info("activeGET()");
	}
	
	@ResponseBody
	@PostMapping("active")
	public int activePOST(CouponActiveVO couponActiveVO) {
		log.info("couponActivePOST()");
		
		int result = couponActiveService.createCouponActive(couponActiveVO);
		
		return result;
		
	}
}
