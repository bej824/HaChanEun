package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.CouponHistoryVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class AdminServiceImple implements AdminService {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	ItemService itemService;
	
	@Autowired
	DirectOrderService directOrderService;
	
	@Autowired
	CouponHistoryService couponHistoryService;
	
	@Override
	public int createRole(String memberId, String RoleName) {
	
		return memberService.createRole(memberId, RoleName);
	}
	
	@Override
	public int getTotalCount(Pagination pagination) {
		
		return itemService.getTotalCount(pagination);
	}
	
	@Override
	public int totalCount(Pagination pagination) {
		return directOrderService.getTotalCount(pagination);
	}
	
	@Override
	public List<ItemVO> itemGetAll(Pagination pagination) {
		
		return itemService.getPagingAllItems(pagination);
	}
	
	@Override
	public ItemVO getItemById(int itemId) {
		return itemService.getItemById(itemId);
		
	}
	
	@Override
	public DirectOrderVO getselectOne(String orderId) {
		return directOrderService.getselectOne(orderId);
	}
	
	@Override
	public int couponHistoryCount() {
		
		return couponHistoryService.couponHistoryCount();
	}
	
	@Override
	public List<CouponHistoryVO> couponHistoryGet(Pagination pagination) {
		
		return couponHistoryService.couponHistoryGet(pagination);
	}
	
	@Override
	public List<CouponHistoryVO> couponHistoryBySellerId(String SellerId) {
		
		return couponHistoryService.couponHistoryBySellerId(SellerId);
	}
	
	@Override
	public int updateItemStatus(int itemId, int itemStatus) {
		
		return itemService.updateItemStatus(itemId, itemStatus);
	}

	@Override
	public List<DirectOrderVO> orderList(Pagination pagination) {
		return directOrderService.getPagingBoards(pagination);
	}

}
