package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	
	@GetMapping("activeRegister")
	public void activeRegisterGet(
			CouponActiveVO couponActiveVO,
			Model model,
			Principal principal) {
		log.info("activeRegisterGet()");
		
		model.addAttribute("couponActiveVO", couponActiveService.setCouponInfo(couponActiveVO));
		
	}
	
	@ResponseBody
	@PostMapping("activeCreate")
	public int activePOST(CouponActiveVO couponActiveVO) {
		log.info("couponActivePOST()");
		
		return couponActiveService.createCouponActive(couponActiveVO);
		
	}
	
	@ResponseBody
	@PostMapping("memberCouponList")
	public List<CouponActiveVO> memberCouponListPOST(
			@RequestParam("memberId") String memberId){
		log.info("couponListPOST()");
		
		return couponActiveService.selectCouponActive(memberId);
	}
	
}
