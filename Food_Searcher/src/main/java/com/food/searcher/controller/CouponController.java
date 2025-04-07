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
	
	@GetMapping("list")
	public void couponListGET(
			@RequestParam(value = "itemId", required = false, defaultValue = "0") int itemId,
			Model model
			) {
		log.info("couponListGET()");
		
		model.addAttribute("itemId", itemId);
	}
	
	@GetMapping("detail")
	public void detailGET(
			@RequestParam(value = "itemId", required = false, defaultValue = "0") int itemId,
			@RequestParam(value = "couponId")int couponId,
			Model model) {
		log.info("detailGET()");
		
		model.addAttribute("discountCouponVO", discountCouponService.selectOneCoupon(couponId));
		model.addAttribute("itemId", itemId);
	}
	
	@GetMapping("modify")
	public void modifyGET(
			int couponId,
			Model model) {
		log.info("modifyGET()");
		
		model.addAttribute("discountCouponVO", discountCouponService.selectOneCoupon(couponId));
	}
	
	@ResponseBody
	@PostMapping("register")
	public int registerCouponPOST(DiscountCouponVO discountCouponVO, Principal principal) {
		log.info("registerCouponPOST()");
		
		return discountCouponService.createCoupon(discountCouponVO);
	}
	
	@ResponseBody
	@GetMapping("getCoupon")
	public List<DiscountCouponVO> getCouponGET(String searchBy,
			@RequestParam(value= "searchText", required = false) String searchText) {
		log.info("getCouponGET()");
		
		return discountCouponService.selectCoupon(searchBy, searchText);
	}
	
	@ResponseBody
	@PostMapping("update")
	public int updatePOST(DiscountCouponVO discountCouponVO) {
		log.info("updatePOST()");
		
		return discountCouponService.updateCoupon(discountCouponVO);
		
	}
	
	@ResponseBody
	@PostMapping("delete")
	public int deletePOST(int couponId) {
		log.info("deletePOST()");
		
		return discountCouponService.deleteCoupon(couponId);
	}
	
}
