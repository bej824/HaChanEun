package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.CartVO;
import com.food.searcher.service.CartService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/cart")
@Controller
@Log4j
public class CartOrderController {
	
	@Autowired
	private CartService cartService;
	
	@GetMapping("/list/{memberId}/order")
	public String cartList (Model model, @PathVariable("memberId") String memberId) {
		log.info("orderList()");
		List<CartVO> cartVO = cartService.getCartById(memberId);
		log.info(cartVO);
		int cartVOSize = cartVO.size();
		model.addAttribute("cartVOSize", cartVOSize);
		model.addAttribute("cartVO", cartVO);
		
		return "cart/order";
	}
}
