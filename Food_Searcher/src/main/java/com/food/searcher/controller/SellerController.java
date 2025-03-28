package com.food.searcher.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.service.ItemService;
import com.food.searcher.service.SellerService;
import com.food.searcher.util.PageMaker;
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
	public void authenticateGET(Model model) {
		log.info("authenticateGET()");
		
		model.addAttribute("nowDate", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
	}
	
	@GetMapping("/status")
	public String statusGET(Model model, 
							Principal principal, 
							Pagination pagination) {
		String memberId = principal.getName();
		log.info("사용자 : " + memberId);
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(sellerService.getTotalCount(pagination));
		
		List<ItemVO> itemList = sellerService.select(memberId, pagination);
				
		if(!itemList.isEmpty()) {
			model.addAttribute("itemList", itemList);
		} else {
			return "returnPage";
		}
		
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageMaker", pageMaker);
		
		return "seller/status"; 
	}
	
	@GetMapping("/status/{memberId}")
	public List<ItemVO> listStatusGET(
			@PathVariable("memberId") String memberId,
			  						  Model model,
									  Pagination pagination
									  ) {
		log.info("listStatusGET()");
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(sellerService.sellerTotalCount());
		
		List<ItemVO> itemList = sellerService.select(memberId, pagination);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageMaker", pageMaker);
		
		return itemList;
	}
	
	@ResponseBody
	@PutMapping("/status/{itemId}")
	public ResponseEntity<Integer> updateStatus(@PathVariable("itemId") int itemId, 
												@RequestBody int itemStatus) { 
		log.info("itemId : " + itemId);
		log.info("itemStatus : " + itemStatus);
		return new ResponseEntity<Integer> (sellerService.updateItemStatus(itemId, itemStatus), HttpStatus.OK);
	}
	
	@ResponseBody
	@PatchMapping("/status/{itemId}/{itemAmount}")
	public ResponseEntity<Integer> updateAmount (@PathVariable("itemAmount") int itemAmount, 
												 @PathVariable("itemId") int itemId) { 
		log.info("itemId : " + itemId);
		log.info("itemAmount : " + itemAmount);
		return new ResponseEntity<Integer> (itemService.updateItemAmount(itemId, itemAmount), HttpStatus.OK);
	}
	
	@GetMapping("management")
	public String managementGET(Model model, 
			Principal principal, 
			Pagination pagination) {
		String memberId = principal.getName();
		log.info("사용자 : " + memberId);

		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(sellerService.sellerTotalCount());

		List<ItemVO> itemList = sellerService.selectSellerItem(memberId, pagination);

		if(!itemList.isEmpty()) {
			model.addAttribute("itemList", itemList);
		} else {
			return "returnPage";
		}

		model.addAttribute("itemList", itemList);
		model.addAttribute("pageMaker", pageMaker);
		
		return "seller/management";
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
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(sellerService.totalCount(principal.getName(), pagination));
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("directOrderVO", sellerService.purchaseHistory(principal.getName(), pagination));
	}
	
	@GetMapping("/purchaseInfo")
	public void purchaseInfo(Model model, String orderId) {
		model.addAttribute("directOrderVO", sellerService.purchaseInfo(orderId));
		model.addAttribute("itemVO", sellerService.purchaseItemInfo(orderId));
	}
	
/*	@PatchMapping("/updateAmount")
	public void updateAmount() {
	
	}
*/
}
