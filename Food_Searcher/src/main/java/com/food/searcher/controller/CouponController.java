package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.service.DiscountCouponService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/coupon")
@Log4j
public class CouponController {
	
	@Autowired
	DiscountCouponService discountCouponService;
	
	@GetMapping("register")
	public void registerCouponGET() {
		log.info("registerCouponGET()");
		
	}
	
	@ResponseBody
	@PostMapping("register")
	public int registerCouponPOST(DiscountCouponVO discountCouponVO, Principal principal) {
		log.info("registerCouponPOST()");
		String memberId = principal.getName();
		discountCouponVO.setCouponIssuer(memberId);
		log.info(discountCouponVO);
		
		return discountCouponService.createCoupon(discountCouponVO);
	}
	
	@ResponseBody
	@GetMapping("couponList")
	public List<DiscountCouponVO> couponListGET() {
		
		return discountCouponService.selectAllCoupon();
	}
	
}
