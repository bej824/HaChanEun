package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemAttachVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.service.DirectOrderService;
import com.food.searcher.service.ItemAttachService;
import com.food.searcher.service.ItemService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@RequestMapping("/item")
@Controller
@Log4j


public class ItemController {
	
	@Autowired
	private ItemService itemService;
	
	@Autowired
	private DirectOrderService directOrderService;
	
	@Autowired
	private ItemAttachService attachService;
	
	@GetMapping("/list")
	public void list(Model model, Integer itemStatus, Pagination pagination) {
		log.info("list");
		log.info("pagination : " + pagination);
		List<ItemVO> itemList = itemService.getPagingItems(pagination);
		log.info(itemList);
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(itemService.getTotalCount(pagination));
		log.info(pageMaker);
		
		log.info(itemList.size());
		
		List<ItemAttachVO> attachVO = attachService.getSelectAll();
		log.info("이미지 : " + attachVO);
		model.addAttribute("attachVO", attachVO);
		model.addAttribute("itemList", itemList);
		model.addAttribute("pageMaker", pageMaker);
	}
	
	@GetMapping("/register")
	public void register() {
		log.info("registerGET()");
	}
	
	@PostMapping("/register")	
	public String itemPOST (ItemVO itemVO, Principal principal) {
		log.info("registerPost()");
		log.info("itemVO = " + itemVO.toString());
		log.info("principal = " + principal.getName());
		
		itemVO.setMemberId(principal.getName());
		int result = itemService.createItem(itemVO);
		
		log.info(result + "행 등록");
		return "redirect:/item/list";		
	}
	
	@GetMapping("/detail")
	public void detail(Model model, Integer itemId) {
		log.info("itemId = " + itemId);
		
		ItemVO itemVO = itemService.getItemById(itemId);
		log.info("ItemVO = " + itemVO);
		
		model.addAttribute("itemVO", itemVO);
		if(itemId.equals(itemVO.getItemId())) {
			List<ItemAttachVO> attachVO = attachService.getItemById(itemId);
			model.addAttribute("attachVO", attachVO);
		}
	}
	
	@GetMapping("/modify")
	public void modifyGET(Model model, Integer itemId) {
		log.info("modifyGET()");
		log.info("itemId = " + itemId);
		ItemVO itemVO = itemService.getItemById(itemId);
		model.addAttribute("itemVO", itemVO);
	}
	
	@PostMapping("/modify")
	public String modifyPOST(ItemVO itemVO) {
		log.info("modifyPOST()");
		int result = itemService.updateItem(itemVO);
		log.info(itemVO);
		log.info(result + "행 수정");
		
		return "redirect:/item/list";
	}
	
	@PostMapping("/delete")
	public String delete(Integer itemId) {
		log.info("delete()");
		int result = itemService.deleteItem(itemId);
		log.info(result + "행 삭제");
		log.info("itemId : " + itemId);
		
		return "redirect:/item/list";
	}

	@GetMapping("/order")
	public void orderGet (Model model, Integer itemId) {
		log.info("orderGET()");
		ItemVO itemVO = itemService.getItemById(itemId);
		model.addAttribute("itemVO", itemVO);
	}
	
	@PostMapping("/order")
	public String order (@RequestBody DirectOrderVO directOrderVO) {
		log.info(directOrderVO);
		int result = directOrderService.orderPurchase(directOrderVO);
		log.info(result);
		return "redirect:/item/purchaseHistory";
	}
	
	@GetMapping("/purchaseHistory")
	public void purchaseHistory(Model model, Principal principal, Pagination pagination) {
		log.info("purchaseHistory()");
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(directOrderService.getMemberTotalCount(principal.getName()));
		log.info(pageMaker);
		List<DirectOrderVO> directOrderVO = directOrderService.getPagingmemberList(principal.getName(), pagination);
		log.info("directOrderVO" + directOrderVO);
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("directOrderVO", directOrderVO);
	}
	
	@GetMapping("/purchaseInfo")
	public void purchaseInfo(Model model, String orderId) {
		DirectOrderVO directOrderVO = directOrderService.getselectOne(orderId);
		log.info("info : " + directOrderVO);
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		model.addAttribute("itemVO", itemVO);
		model.addAttribute("directOrderVO", directOrderVO);
	}
	
} // end ItemController
