package com.food.searcher.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.CartVO;
import com.food.searcher.persistence.CartMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j

public class CartServiceImple implements CartService {

	@Autowired
	CartMapper cartMapper;
	
	@Autowired
	UtilityService utilityService;
	
	@Override
	public int createCart(CartVO cartVO) {
		
		int result = 2;
		
		try {
			result = cartMapper.insert(cartVO);
		} catch (Exception e) {
			log.error("장바구니 등록 중 에러 발생", e);
		}
		return result;
	}

	@Override
	public List<CartVO> getCartById(String memberId) {
		log.info("getCartById()");
		log.info("memberId : " + memberId);
		List<CartVO> cartVO = cartMapper.selectOne(memberId);
		
		log.info(cartVO);
		return cartVO;
	}

	@Override
	public int deleteCart(int cartId) {
		
		return cartMapper.delete(cartId);
	}
	
	@Override
	public int deleteOrderCart() {
		String memberId = utilityService.loginMember();
		
		return cartMapper.cartDelete(memberId);
	}

	@Override
	public int updateAmount(int cartId, int cartAmount) {
		log.info("updateAmount()");
		CartVO cartVO = new CartVO();
		cartVO.setCartId(cartId);
		cartVO.setCartAmount(cartAmount);
		
		return cartMapper.updateAmount(cartVO);
	}

	@Override
	public int updateChecked(int cartChecked, int cartId) {
		return cartMapper.updateChecked(cartChecked, cartId);
	}	

}
