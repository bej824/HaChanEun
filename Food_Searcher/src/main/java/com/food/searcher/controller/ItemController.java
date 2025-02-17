package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.service.DirectOrderService;
import com.food.searcher.service.ItemService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/item")
@Controller
@Log4j


public class ItemController {
	
	@Autowired
	private ItemService itemService;
	
	@Autowired
	private DirectOrderService directOrderService;
	
	@GetMapping("/list")
	public void list(Model model, Integer itemId) {
		log.info("list");
		List<ItemVO> itemList = itemService.getAllItem();
		
		model.addAttribute("itemList", itemList);
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
		
		return "redirect:/item/list";
	}
<<<<<<< HEAD

=======
	
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
	public void purchaseHistory(Model model, Principal principal) {
		log.info("purchaseHistory()");
		List<DirectOrderVO> directOrderVO = directOrderService.getOrder(principal.getName());
		log.info("directOrderVO" + directOrderVO);
		List<DirectOrderVO> allList = directOrderService.getAllOrder();
		model.addAttribute("directOrderVO", directOrderVO);
		model.addAttribute("allList", allList);
	}
	
	@GetMapping("/purchaseInfo")
	public void purchaseInfo(Model model, Integer orderId) {
		DirectOrderVO directOrderVO = directOrderService.getselectOne(orderId);
		log.info("info : " + directOrderVO);
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		model.addAttribute("itemVO", itemVO);
		model.addAttribute("directOrderVO", directOrderVO);
	}
>>>>>>> d34800b247d3e282cbc4c5303800e00293b09676
	
} // end ItemController
