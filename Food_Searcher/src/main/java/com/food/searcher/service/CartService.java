package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CartVO;

public interface CartService {
	int createCart(CartVO cartVO);
	List<CartVO> getCartById(String memberId);
	int deleteCart(int cartId);
	int updateAmount(int cartAmount, int cartId);
}
