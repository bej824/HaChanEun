package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
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
	
	
	@GetMapping("/list/{memberId}")
	public String cartList (@PathVariable("memberId") String memberId, Model model) {
		log.info("cartList()");
		List<CartVO> cartVO = cartService.getCartById(memberId);
		log.info(cartVO);
		model.addAttribute("cartVO", cartVO);
		
		return "cart/list";
	}
	
	@PostMapping("/add")
	@ResponseBody
	public String addCartPOST(CartVO cartVO) {
		int result = cartService.createCart(cartVO);
		return result + "";
	}
	
	@DeleteMapping("/delete/{cartId}")
	public ResponseEntity<Integer> deleteCart(@PathVariable("cartId") int cartId, CartVO cartVO) {
		      log.info("deleteCart()");
		      cartService.deleteCart(cartId);
		      return new ResponseEntity<Integer>(cartService.deleteCart(cartId), HttpStatus.OK);
	}
	
	@PutMapping("/{cartId}/{cartAmount}")
	public int updateAmount(int cartAmount, int cartId) {
		return cartService.updateAmount(cartAmount, cartId);
	}
	
} //end CartController
