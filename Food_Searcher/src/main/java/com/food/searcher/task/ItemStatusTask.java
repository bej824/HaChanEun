package com.food.searcher.task;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.food.searcher.domain.CartVO;
import com.food.searcher.persistence.CartMapper;
import com.food.searcher.service.DirectOrderService;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class ItemStatusTask {
	@Autowired
	CartMapper cartMapper;
	
	@Autowired
	DirectOrderService directOrderService;
	
	@Scheduled(cron = "0 38 16 * * *")
	public void StatusChange() {
		directOrderService.orderCancel();
		
		List<CartVO> cartVO = cartMapper.cartAll();
		for(CartVO vo : cartVO) {
			if(vo.getItemStatus() != 100) {
				cartMapper.cartDelete(vo.getCartId());
			}
		}
	}

}
