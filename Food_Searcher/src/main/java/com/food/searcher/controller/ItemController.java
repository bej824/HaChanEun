package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.service.ItemService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/item")
@Controller
@Log4j


public class ItemController {
	
	@Autowired
	private ItemService itemService;
	
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
	public String itemPOST (ItemVO itemVO) {
		log.info("registerPost()");
		log.info("itemVO = " + itemVO.toString());
		
		int result = itemService.createItem(itemVO);
		log.info(result + "행 등록");
		return "redirect:/item/list";		
	}
	
	@GetMapping("/detail")
	public void detail(Model model, Integer itemId) {
		log.info("detail()");
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
	
	@GetMapping("/order")
	public void orderGet (Model model) {
		log.info("orderGET()");
	}
	
} // end ItemController
