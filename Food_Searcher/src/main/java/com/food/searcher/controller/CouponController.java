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
		
	}
	
	@GetMapping("list")
	public void couponListGET(
			@RequestParam(value = "itemId", required = false, defaultValue = "0") int itemId,
			Model model
			) {
		
		model.addAttribute("itemId", itemId);
	}
	
	@GetMapping("detail")
	public void detailGET(
			@RequestParam(value = "itemId", required = false, defaultValue = "0") int itemId,
			@RequestParam(value = "couponId")int couponId,
			Model model) {
		
		model.addAttribute("discountCouponVO", discountCouponService.selectOneCoupon(couponId));
		model.addAttribute("itemId", itemId);
	}
	
	@GetMapping("modify")
	public void modifyGET(
			int couponId,
			Model model) {
		
		model.addAttribute("discountCouponVO", discountCouponService.selectOneCoupon(couponId));
	}
	
	@ResponseBody
	@PostMapping("register")
	public int registerCouponPOST(DiscountCouponVO discountCouponVO, Principal principal) {
		
		return discountCouponService.createCoupon(discountCouponVO);
	}
	
	@ResponseBody
	@GetMapping("getCoupon")
	public List<DiscountCouponVO> getCouponGET(String searchBy,
			@RequestParam(value= "searchText", required = false) String searchText) {
		
		return discountCouponService.selectCoupon(searchBy, searchText);
	}
	
	@ResponseBody
	@PostMapping("update")
	public int updatePOST(DiscountCouponVO discountCouponVO) {
		
		return discountCouponService.updateCoupon(discountCouponVO);
		
	}
	
	@ResponseBody
	@PostMapping("delete")
	public int deletePOST(int couponId) {
		
		return discountCouponService.deleteCoupon(couponId);
	}
	
}
