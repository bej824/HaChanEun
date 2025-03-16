package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CartVO;

public interface CartService {
	int createCart(CartVO cartVO);
	List<CartVO> getCartById(String memberId);
	int updateChecked(int cartChecked, int itemId);
	int updateAmount(int cartId, int cartAmount);
	
	/**
	 * 장바구내 내 삭제
	 * @param cartId
	 * @return
	 */
	int deleteCart(int cartId);
	
	/**
	 * 구매로 인한 삭제
	 * @param itemId
	 * @return
	 */
	int deleteOrderCart();
}
