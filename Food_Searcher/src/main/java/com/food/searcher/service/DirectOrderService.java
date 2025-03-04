package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.util.Pagination;

public interface DirectOrderService {
	List<DirectOrderVO> getAllOrder();
	List<DirectOrderVO> sellerList(String memberId, Pagination pagination);
	List<DirectOrderVO> getOrder(String memberId);
	List<DirectOrderVO> getPagingBoards(Pagination pagination);
	List<DirectOrderVO> getPagingmemberList(String memberId, Pagination pagination);
	DirectOrderVO getselectOne(String orderId);
	int getTotalCount(Pagination pagination);
	int getSellerTotalCount(String memberId, Pagination pagination);
	int getMemberTotalCount(String memberId);
	int orderPurchase(DirectOrderVO directOrderVO);
	int cartPurchase(DirectOrderVO directOrderVO);
	int cancel(String orderId);
	int refundReady(String orderId);
	int refund(String refundReason, String refundContent, String orderId);
	int refundOK(String orderId);
	int deliveryReady(String deliveryCompany, String invoiceNumber, String orderId);
	int delivering(String orderId);
	
	/** 배송 완료
	 * @param deliveryStatus
	 * @param orderId
	 * @return
	 */
	int deliveryCompleted(String orderId);
}
