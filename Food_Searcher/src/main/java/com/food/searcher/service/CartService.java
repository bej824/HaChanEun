package com.food.searcher.service;

import com.food.searcher.domain.CartVO;

public interface CartService {
	int createCart(CartVO cartVO);
	CartVO getCartById(int cartId);
	int deleteCart(int cartId);
}
