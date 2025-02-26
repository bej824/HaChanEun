package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.util.Pagination;

public interface DirectOrderService {
	List<DirectOrderVO> getAllOrder();
	List<DirectOrderVO> getOrder(String memberId);
	List<DirectOrderVO> getPagingBoards(Pagination pagination);
	DirectOrderVO getselectOne(String orderId);
	int orderPurchase(DirectOrderVO directOrderVO);
	int cartPurchase(DirectOrderVO directOrderVO);
	int cancel(String deliveryStatus, String orderId);
	int refundReady(String deliveryStatus, String orderId);
	int refund(String deliveryStatus, String refundReason, String refundContent, String orderId);
	int refundOK(String deliveryStatus, String orderId);
	int deliveryReady(String deliveryStatus, String deliveryCompany, String invoiceNumber, String orderId);
	int delivering(String deliveryStatus, String orderId);
	int deliveryCompleted(String deliveryStatus, String orderId);
}
