package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.service.AdminService;
import com.food.searcher.service.ItemService;
import com.food.searcher.service.SellerService;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/seller")
@Log4j
public class SellerController {
	
	@Autowired
	SellerService sellerService;
	
	@Autowired
	ItemService itemService;
		
	@GetMapping("authenticate")
	public void authenticateGET() {
		log.info("authenticateGET()");
		
	}
	
	@GetMapping("/status")
	public String statusGET(Model model, Principal principal) {
		log.info("statusGET()");
		String memberId = principal.getName();
		log.info("접속자 아이디 : " + memberId);
		
		return "seller/status"; 
	}
	
	@ResponseBody
	@GetMapping("/status/{memberId}")
	public List<ItemVO> listStatusGET(@PathVariable("memberId") String memberId) {
		log.info("listStatusGET()");
		
		return sellerService.selectSellerItem(memberId); 
	}
	
	@ResponseBody
	@PutMapping("/status/{itemId}")
	public ResponseEntity<Integer> updateStatus(@PathVariable("itemId") Integer itemId, 
												@RequestBody Integer itemStatus) { 
		log.info("itemId : " + itemId);
		log.info("itemStatus : " + itemStatus);
		int result = itemService.updateStatus(itemId, itemStatus);
		return new ResponseEntity<Integer> (result, HttpStatus.OK);
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
	
	@GetMapping("/purchaseInfo")
	public void purchaseInfo(Model model, String orderId) {
		model.addAttribute("directOrderVO", sellerService.purchaseInfo(orderId));
		model.addAttribute("itemVO", sellerService.purchaseItemInfo(orderId));
	}
}
