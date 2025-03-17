package com.food.searcher.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemAttachVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.service.DirectOrderService;
import com.food.searcher.service.ItemAttachService;
import com.food.searcher.service.ItemService;
import com.food.searcher.service.MemberService;
import com.food.searcher.service.OrderStepService;
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
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private OrderStepService orderStepService;
	
	@GetMapping("/list")
	public String list(Model model, Pagination pagination) {
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(itemService.getStatusTotalCount(pagination));
		
		List<ItemVO> itemList = itemService.getPagingStatusItems(pagination);
		
		List<ItemAttachVO> attachVO = attachService.getSelectAll();
		model.addAttribute("attachVO", attachVO);
		model.addAttribute("itemList", itemList);
	    model.addAttribute("pageMaker", pageMaker);
	    
	    return "/item/list";
	}
	
	@GetMapping("/register")
	public void register(Model model) {
	}
	
	@PostMapping("/register")	
	public String itemPOST (
			ItemVO itemVO,
			Principal principal) {
		
		itemVO.setMemberId(principal.getName());
		int result = itemService.createItem(itemVO);
		log.info(result);
		
		return "redirect:/item/list";		
	}
	
	@GetMapping("/detail")
	public void detail(
			Model model,
			Integer itemId,
			Pagination pagination) {
		
		
		ItemVO itemVO = itemService.getItemById(itemId);
		log.info(itemVO);
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(itemService.getSelectCategoryList(itemVO.getSubCtg(), itemVO.getItemId(), pagination).size());
		pageMaker.setPageCount(1);
		
		pagination.setPageSize(5);
		List<ItemVO> itemList = itemService.getSelectCategoryList(itemVO.getSubCtg(), itemVO.getItemId(), pagination);
		log.info("itemList : " + itemList);
		model.addAttribute("itemList", itemList);
		model.addAttribute(pageMaker);
		log.info("pageMaker : " + pageMaker);
		
		model.addAttribute("itemVO", itemVO);
		if(itemId.equals(itemVO.getItemId())) {
			List<ItemAttachVO> attachVO = attachService.getItemById(itemVO.getItemId());
			model.addAttribute("attachVO", attachVO);
		}
		List<ItemAttachVO> attachAll = attachService.getSelectAll();
		model.addAttribute("attachAll", attachAll);
	}
	
	@GetMapping("/modify")
	public void modifyGET(
			Model model,
			Integer itemId) {
		ItemVO itemVO = itemService.getItemById(itemId);
		
		if(itemId.equals(itemVO.getItemId())) {
			model.addAttribute("itemVO", itemVO);
			List<ItemAttachVO> attachVO = attachService.getItemById(itemId);
			if (attachVO != null && !attachVO.isEmpty()) {
				model.addAttribute("idList", attachVO);
			}
		}
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
	public void orderGet (
			Model model,
			Integer itemId, Principal principal) {
		log.info("orderGET()");
		MemberVO member = memberService.getMemberById(principal.getName());
		model.addAttribute("member", member);
		ItemVO itemVO = itemService.getItemById(itemId);
		model.addAttribute("itemVO", itemVO);
		if(itemId.equals(itemVO.getItemId())) {
			List<ItemAttachVO> attachVO = attachService.getItemById(itemId);
			model.addAttribute("attachVO", attachVO);
		}
	}
	
	@ResponseBody
	@PostMapping("/order")
	public int order (@RequestBody DirectOrderVO directOrderVO, Principal principal) {
		log.info(directOrderVO);
		
		directOrderVO.setMemberId(principal.getName());
		int result = orderStepService.oneOrder(directOrderVO);
		log.info(result);
		return result;
	}
	
	@GetMapping("/purchaseHistory")
	public void purchaseHistory(
			Model model,
			Principal principal,
			Pagination pagination) {
		log.info("purchaseHistory()");
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(directOrderService.getMemberTotalCount(principal.getName(), pagination));
		log.info(pageMaker);
		List<DirectOrderVO> directOrderVO = directOrderService.getPagingmemberList(principal.getName(), pagination);
		log.info("directOrderVO" + directOrderVO);
		
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("directOrderVO", directOrderVO);
	}
	
	@GetMapping("/purchaseInfo")
	public void purchaseInfo(
			Model model,
			String orderId) {
		DirectOrderVO directOrderVO = directOrderService.getselectOne(orderId);
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		model.addAttribute("itemVO", itemVO);
		List<ItemAttachVO> attachVO = attachService.getItemById(itemVO.getItemId());
		model.addAttribute("attachVO", attachVO);
		model.addAttribute("directOrderVO", directOrderVO);
	}
	
} // end ItemController
