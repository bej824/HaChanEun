package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;

public interface DirectOrderService {
	List<DirectOrderVO> getAllOrder();
	List<DirectOrderVO> getOrder(String memberId);
	DirectOrderVO getselectOne(int orderId);
	int orderPurchase(DirectOrderVO directOrderVO);
	int changeStatus(String deliveryStatus);
}
