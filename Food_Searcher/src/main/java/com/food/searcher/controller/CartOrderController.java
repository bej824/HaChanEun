package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.CartVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.persistence.CartMapper;
import com.food.searcher.service.DirectOrderService;

import lombok.extern.log4j.Log4j;

@RequestMapping("/cart")
@Controller
@Log4j
public class CartOrderController {

	@Autowired
	private CartMapper cartMapper;
	
	@Autowired
	private DirectOrderService directOrderService;
	
	@GetMapping("/list/{memberId}/order")
	public String cartList (Model model, @PathVariable("memberId") String memberId) {
		List<CartVO> cartVO = cartMapper.cartOrder(memberId);
		int cartVOSize = cartVO.size();
		String itemId = "";
		String amount = "";
		String itemPrice = "";
		for(CartVO vo : cartVO) {
			itemId += vo.getItemId() + "/";
			amount += vo.getCartAmount() + "/";
			itemPrice += vo.getItemPrice() + "/";
		}
		model.addAttribute("itemId", itemId);
		model.addAttribute("amount", amount);
		model.addAttribute("itemPrice", itemPrice);
		model.addAttribute("cartVOSize", cartVOSize);
		model.addAttribute("cartVO", cartVO);
		
		return "cart/order";
	}
	
	@PostMapping("/list/{memberId}/order")
	public String cartOrder(@RequestBody List<DirectOrderVO> directOrderVO) {
		directOrderService.cartOrder(directOrderVO);
		return "redirect:../../../item/purchaseHistory";
	}
}
