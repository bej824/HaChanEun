package com.food.searcher.task;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.food.searcher.domain.CartVO;
import com.food.searcher.persistence.CartMapper;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class CartStatusTask {
	@Autowired
	CartMapper cartMapper;
	
	@Scheduled(cron = "0 0 12 * * *")
	public void cartDelete() {
		List<CartVO> cartVO = cartMapper.cartAll();
		for(CartVO vo : cartVO) {
			if(vo.getItemStatus() != 100) {
				cartMapper.cartDelete(vo.getCartId());
			}
		}
	}

}
