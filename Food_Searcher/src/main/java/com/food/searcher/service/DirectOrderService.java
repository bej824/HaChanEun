package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;

public interface DirectOrderService {
	List<DirectOrderVO> getAllOrder();
	DirectOrderVO getOrder(String deliveryStatus);
	int orderPurchase(DirectOrderVO directOrderVO);
	int changeStatus(String deliveryStatus);
}
