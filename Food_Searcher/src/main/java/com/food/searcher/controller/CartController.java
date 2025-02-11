package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.CartVO;
import com.food.searcher.service.CartService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/cart")
@Controller
@Log4j
public class CartController {
	
	@Autowired
	private CartService cartService;
	
	@PostMapping("/add")
	@ResponseBody
	public String addCartPOST(CartVO cartVO) {
		int result = cartService.createCart(cartVO);
		return result + "";
	}
	
	@GetMapping("/{memberId}")
	public void detail(Integer cartId, Model model) {
		log.info("detailGET()");
		model.addAttribute("cartInfo", cartService.getCartById(cartId));
		
	}
	
}
