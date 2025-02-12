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
		log.info(discountCouponVO);
		
		return discountCouponService.createCoupon(discountCouponVO);
	}
	
	@GetMapping("couponList")
	public void couponListGET() {
		log.info("couponListGET()");
		
	}
	
	@ResponseBody
	@GetMapping("getCoupon")
	public List<DiscountCouponVO> getCouponGET(String searchBy,
			@RequestParam(value= "searchText", required = false) String searchText) {
		log.info("getCouponGET()");
		log.info(searchBy + "검색할 텍스트" + searchText);
		
		List<DiscountCouponVO> couponList = discountCouponService.selectCoupon(searchBy, searchText);
		log.info(couponList);
		
		return couponList;
	}
	
	@GetMapping("detail")
	public void detailGET(int couponId, Model model) {
		log.info("detailGET()");
		
		DiscountCouponVO discountCouponVO = discountCouponService.selectOneCoupon(couponId);
		
		model.addAttribute("discountCouponVO", discountCouponVO);
	}
	
	@GetMapping("modify")
	public void modifyGET(int couponId, Model model) {
		log.info("modifyGET()");
		
		DiscountCouponVO discountCouponVO = discountCouponService.selectOneCoupon(couponId);
		
		model.addAttribute("discountCouponVO", discountCouponVO);
	}
	
	@ResponseBody
	@PostMapping("update")
	public int updatePOST(DiscountCouponVO discountCouponVO) {
		log.info("updatePOST()");
		
		int result = discountCouponService.updateCoupon(discountCouponVO);
		
		return result;
		
	}
	
	@ResponseBody
	@PostMapping("delete")
	public int deletePOST(int couponId) {
		log.info("deletePOST()");
		
		int result = discountCouponService.deleteCoupon(couponId);
		
		return result;
	}
	
}
