package com.food.searcher.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/seller")
@Log4j
public class SellerController {
	
	@Autowired
	private DirectOrderMapper directOrderMapper;
	
	@GetMapping("sellerManagement")
	public void main() {
		log.info("get");
	}
	
	@GetMapping("/purchaseHistory")
	public void purchaseHistory(Model model, Principal principal, Pagination pagination) {
		List<DirectOrderVO> directOrderVO = directOrderMapper.sellerList(principal.getName());
		model.addAttribute("directOrderVO", directOrderVO);
	}
}
