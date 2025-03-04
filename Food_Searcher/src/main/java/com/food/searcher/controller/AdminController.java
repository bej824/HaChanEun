package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.CartVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.service.AdminService;
import com.food.searcher.service.DirectOrderService;
import com.food.searcher.service.ItemService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/admin")
@Log4j
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	private DirectOrderService directOrderService;
	
	@Autowired
	private ItemService itemService;
	
	@GetMapping("/adminPage")
	public void adminPageGET() {

	}
	
	@GetMapping("/itemManagement")
	public void itemManagementGET() {
	}
	
	@ResponseBody
	@GetMapping("/itemList")
	public List<ItemVO> itemListGET(
			Pagination pagination,
			Model model) {
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		adminService.getTotalCount(pagination);
		
		model.addAttribute("pageMaker", pageMaker);
		
		return adminService.itemGetAll(pagination);
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
		pageMaker.setTotalCount(directOrderService.getTotalCount(pagination));
		List<DirectOrderVO> allList = directOrderService.getPagingBoards(pagination);
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("allList", allList);
	}
	
	@GetMapping("/purchaseInfo")
	public void purchaseInfo(Model model, String orderId) {
		DirectOrderVO directOrderVO = directOrderService.getselectOne(orderId);
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		model.addAttribute("itemVO", itemVO);
		model.addAttribute("directOrderVO", directOrderVO);
	}
	
	@PutMapping("/updateStatus/{itemId}")
	public ResponseEntity<Integer> updateStatus(@PathVariable("itemId") Integer itemId, 
												@RequestBody Integer itemStatus) {
		
		return new ResponseEntity<Integer> (adminService.updateItemStatus(itemId, itemStatus), HttpStatus.OK);
	}

}
