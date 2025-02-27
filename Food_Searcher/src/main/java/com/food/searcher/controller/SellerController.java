package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.service.AdminService;
import com.food.searcher.service.SellerService;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/seller")
@Log4j
public class SellerController {
	
	@Autowired
	SellerService sellerService;
		
	@GetMapping("authenticate")
	public void authenticateGET() {
		log.info("authenticateGET()");
		
	}
	
	@GetMapping("/status")
	public void statusGET() {
		log.info("statusGET()");
	}
	
	@GetMapping("/itemList")
	public List<ItemVO> itemListGET() {
		log.info("itemListGET()");
		
		return null;
	}
	
	@GetMapping("management")
	public void managementGET() {
		log.info("managementGET()");
	}
	
	@ResponseBody
	@PostMapping("roleUpdate")
	public int roleUpdatePOST(Principal principal) {
		log.info("roleUpdatePOST()");
		String memberId = principal.getName();
		
		return sellerService.SellerCreate(memberId);
	}
	
	@ResponseBody
	@GetMapping("sellerCoupon")
	public List<DiscountCouponVO> sellerCouponGET() {
		log.info("sellerCouponGET()");
		
		return sellerService.selectSellerCoupon();
	}
	
	@GetMapping("/purchaseHistory")
	public void purchaseHistoryGET(Model model, Principal principal, Pagination pagination) {
		log.info("purchaseHistoryGET()");
		
		model.addAttribute("directOrderVO", sellerService.purchaseHistory(principal.getName()));
	}
}
