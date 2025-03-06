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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.CouponHistoryVO;
import com.food.searcher.service.AdminService;
import com.food.searcher.service.CouponHistoryService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/admin")
@Log4j
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@GetMapping("/adminPage")
	public void adminPageGET() {

	}
	
	@GetMapping("/itemManagement")
	public void itemManagementGET(Pagination pagination,
			Model model) {
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(adminService.getTotalCount(pagination));
		
		model.addAttribute("itemList", adminService.itemGetAll(pagination));
		model.addAttribute("pageMaker", pageMaker);
	}
	
	@GetMapping("/financialManagement")
	public void financialManagementGET(
			@RequestParam(required = false) String sellerId
			,@RequestParam(required = false) String type
			,@RequestParam(required = false) String keyword
			,@RequestParam(value="pageNum", defaultValue = "1") int pageNum
		    ,Pagination pagination
		    ,Model model) {
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		List<CouponHistoryVO> list = adminService.couponHistoryBySellerId(sellerId);
		pageMaker.setTotalCount(list.size());
		
		model.addAttribute("couponHistory", adminService.couponHistoryGet(pagination));
		model.addAttribute("selltedList", list);
		model.addAttribute("pageMaker", pageMaker);
		
	}
	
	@ResponseBody
	@PutMapping("/couponHistory")
	public List<CouponHistoryVO> couponHistoryPUT(String sellerId){
		
		return adminService.couponHistoryBySellerId(sellerId);
	}
	
	@ResponseBody
	@PostMapping("/roleUpdate")
	public int roleUpdatePOST(
					 @RequestParam("memberId") String memberId
					,@RequestParam("roleName") String roleName) {
		
		return adminService.createRole(memberId, roleName);
	} // end roleUpdatePOST
	
	@GetMapping("/purchaseHistory")
	public void purchaseHistory(Model model, Principal principal, Pagination pagination) {
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(adminService.totalCount(pagination));
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("allList", adminService.orderList(pagination));
	}
	
	@GetMapping("/purchaseInfo")
	public void purchaseInfo(Model model, String orderId) {
		model.addAttribute("itemVO", adminService.getItemById(adminService.getselectOne(orderId).getItemId()));
		model.addAttribute("directOrderVO", adminService.getselectOne(orderId));
	}
	
	@PutMapping("/updateStatus/{itemId}")
	public ResponseEntity<Integer> updateStatus(@PathVariable("itemId") Integer itemId, 
												@RequestBody Integer itemStatus) {
		return new ResponseEntity<Integer> (adminService.updateItemStatus(itemId, itemStatus), HttpStatus.OK);
	}

}
