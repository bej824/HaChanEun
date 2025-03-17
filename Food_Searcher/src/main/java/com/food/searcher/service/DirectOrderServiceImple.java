package com.food.searcher.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CartVO;
import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemListVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.CartMapper;
import com.food.searcher.persistence.DirectOrderMapper;
import com.food.searcher.persistence.ItemMapper;
import com.food.searcher.persistence.MemberMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DirectOrderServiceImple implements DirectOrderService {

	@Autowired
	private DirectOrderMapper directOrderMapper;

	@Autowired
	private CouponActiveService couponActiveService;

	@Autowired
	private UtilityService utilityService;

	@Autowired
	private ItemService itemService;

	@Autowired
	private CartService cartService;
	
	@Autowired
	private MemberMapper memberMapper;

	@Override
	public List<DirectOrderVO> getAllOrder() {
		return directOrderMapper.selectAll();
	}

	@Override
	public List<DirectOrderVO> getOrder(String memberId) {
		return directOrderMapper.selectMember(memberId);
	}

	@Override
	public DirectOrderVO getselectOne(String itemId) {
		return directOrderMapper.selectOne(itemId);
	}

	@Transactional
	public int oneOrder(DirectOrderVO directOrderVO) {
		
		directOrderVO.setOrderId(utilityService.now() + String.format("%04d", 0));
		
		List<DirectOrderVO> orderList = new ArrayList<DirectOrderVO>();
		orderList.add(directOrderVO);
		
		return itemSearch(orderList);
	}
	
	public int cartOrder(List<DirectOrderVO> orderList) {
		
		for(int i = 0; i < orderList.size(); i++) {
			orderList.get(i).setOrderId(utilityService.now() + String.format("%04d", i));
		}
		
		return itemSearch(orderList);
	}


	@Override
	public List<DirectOrderVO> sellerList(String memberId, Pagination pagination) {
		log.info("sellerList()");

		return directOrderMapper.sellerList(memberId, pagination);
	}

	@Override
	public int getSellerTotalCount(String memberId, Pagination pagination) {
		return directOrderMapper.sellerTotalCount(memberId, pagination);
	}

	@Transactional(value = "transactionManager")
	@Override
	public int cancel(String orderId) {
		log.info("cancel()");
		int result = directOrderMapper.cancel(orderId);
		log.info(result + "행 업데이트 완료");
		DirectOrderVO directOrderVO = directOrderMapper.selectOne(orderId);
		
		ItemVO itemVO = itemService.getItemById(directOrderVO.getItemId());
		itemService.updateItemAmount(itemVO.getItemAmount() - directOrderVO.getTotalCount(), directOrderVO.getItemId());
		couponActiveService.updateCouponActiveByOrderId(orderId);

		return result;
	}

	@Override
	public int refundReady(String orderId) {
		log.info("환불 하기");
		return directOrderMapper.refundReady(orderId);
	}

	@Override
	public int refund(String refundReason, String refundContent, String orderId) {
		log.info("환불 신청");
		return directOrderMapper.refund(refundReason, refundContent, orderId);
	}

	@Transactional
	@Override
	public int refundOK(String orderId) {
		log.info("환불 승인");

		int result = directOrderMapper.refundOK(orderId);

		if (result == 1) {
			couponActiveService.updateCouponActiveByOrderId(orderId);
		}

		return result;
	}

	@Override
	public int deliveryReady(String deliveryCompany, String invoiceNumber, String orderId) {
		log.info("배송 준비중");
		return directOrderMapper.deliveryReady(deliveryCompany, invoiceNumber, orderId);
	}

	@Override
	public int delivering(String orderId) {
		log.info("배송 중");
		return directOrderMapper.delivering(orderId);
	}

	@Override
	public int deliveryCompleted(String orderId) {
		log.info("배송 완료");
		return directOrderMapper.deliveryCompleted(orderId);
	}

	@Override
	public List<DirectOrderVO> getPagingBoards(Pagination pagination) {
		return directOrderMapper.selectListByPagination(pagination);
	}

	@Override
	public int getTotalCount(Pagination pagination) {
		return directOrderMapper.selectTotalCount(pagination);
	}

	@Override
	public List<DirectOrderVO> getPagingmemberList(String memberId, Pagination pagination) {
		return directOrderMapper.memberList(memberId, pagination);
	}

	@Override
	public int getMemberTotalCount(String memberId, Pagination pagination) {
		return directOrderMapper.selectMemberTotalCount(memberId, pagination);
	}

	public int calculateTotalPrice(
			 List<ItemVO> list
			,Integer discountPrice) {
		
		int totalCost = 0;

		for (int i = 0; i < list.size(); i++) {
			totalCost += list.get(i).getItemPrice() * list.get(i).getItemCount();
		}

		return Math.max(totalCost - discountPrice, 0);
	}

	@Override
	public int orderCancel() {
		List<DirectOrderVO> directOrderVO = directOrderMapper.orderCancelList();
		
		return directOrderMapper.orderCancel();
	}
	
	@Transactional
	public int itemSearch(List<DirectOrderVO> orderList) {
		
		for(int i = 0; i < orderList.size(); i++) {
			
			ItemVO itemVO = itemService.getItemById(orderList.get(i).getItemId());
			
			if(itemVO.getItemAmount() - orderList.get(i).getTotalCount() >= 0) {
				itemService.updateItemAmount(
						itemVO.getItemId()
						,itemVO.getItemAmount() - orderList.get(i).getTotalCount());
				
				orderList.get(i).setTotalPrice(
						itemVO.getItemPrice() * orderList.get(i).getTotalCount());
				
			} else {
				log.warn(itemVO.getItemId() + " " + itemVO.getItemName() + "의 재고가 부족합니다.");
				return 401;
			}
			
			if(itemVO.getItemStatus() != 100) {
				return 402;
			}
			
		}
		return discountPrice(orderList);
	}
	
	@Transactional
	public int discountPrice(List<DirectOrderVO> orderList) {
		
		Integer discountPrice = 0;
		
		if(orderList.get(0).getCouponActiveId() != null) {
			discountPrice = couponActiveService.selectCouponActiveByCouponPrice(
					orderList.get(0).getCouponActiveId());			
		}
		
		if(discountPrice > 0) {
			orderList.get(0).setTotalPrice(
					orderList.get(0).getTotalPrice() - discountPrice);			
		}
		
		if(discountPrice != 0) {
			int couponUseInfo = couponActiveService.applyCoupon (
					 orderList.get(0)
					,LocalDateTime.now()
					,discountPrice);
			
			if(couponUseInfo != 1) {
				return 403;
			}
			
		}
		return priceInfo(orderList);
	}
	
	@Transactional
	public int priceInfo(List<DirectOrderVO> orderList) {
		
		
		int orderTotalPrice = 0;
		
		for(int i = 0; i < orderList.size(); i++) {
			orderTotalPrice += orderList.get(i).getTotalPrice();
		}
		
		orderTotalPrice = Math.max(orderTotalPrice, 0);
		
		return kakao(orderList, orderTotalPrice);
	}
	
	@Transactional
	public int kakao(List<DirectOrderVO> orderList, int orderTotalPrice) {
		
		return acountFinal(orderList);
	}
	
	
	@Transactional
	public int acountFinal(List<DirectOrderVO> orderList) {
		

		directOrderMapper.insert(orderList);
		cartService.deleteOrderCart();
		
		return 1;
	}

}
