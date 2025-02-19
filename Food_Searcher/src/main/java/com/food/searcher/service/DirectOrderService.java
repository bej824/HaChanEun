package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.util.Pagination;

public interface DirectOrderService {
	List<DirectOrderVO> getAllOrder();
	List<DirectOrderVO> getOrder(String memberId);
	List<DirectOrderVO> getPagingBoards(Pagination pagination);
	DirectOrderVO getselectOne(int orderId);
	int orderPurchase(DirectOrderVO directOrderVO);
	int cancel(String deliveryStatus, int orderId);
	int refundReady(String deliveryStatus, int orderId);
	int refund(String deliveryStatus, String refundReason, String refundContent, int orderId);
	int refundOK(String deliveryStatus, int orderId);
	int deliveryReady(String deliveryStatus, int orderId);
	int deliveryCompleted(String deliveryStatus, int orderId);
}
