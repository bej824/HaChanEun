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
	
	@Override
	public int createCart(CartVO cartVO) {
		log.info("createCart()");
		log.info("cartVO : " + cartVO);
		int result = cartMapper.insert(cartVO);
		log.info(result + "행 등록");
		return result;
	}

	@Override
	public List<CartVO> getCartById(String memberId) {
		log.info("getCartById()");
		log.info("memberId : " + memberId);
		List<CartVO> cartVO = cartMapper.selectOne(memberId);
		for(CartVO vo : cartVO) {
			vo.initTotal();
		}
		
		log.info(cartVO);
		return cartVO;
	}

	@Override
	public int deleteCart(int cartId) {
		log.info("deleteCart()");
		return cartMapper.delete(cartId);
	}

	@Override
	public int updateAmount(int cartId, int cartAmount) {
		log.info("updateAmount()");
		CartVO cartVO = new CartVO();
		cartVO.setCartId(cartId);
		cartVO.setCartAmount(cartAmount);
		
		return cartMapper.updateAmount(cartVO);
	}	

}
