package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	private DirectOrderService directOrderService;
	
	@Override
	public int createRole(String memberId, String RoleName) {
	
		return memberService.createRole(memberId, RoleName);
	}
	
	@Override
	public int getTotalCount(Pagination pagination) {
		
		return itemService.getTotalCount(pagination);
	}
	
	@Override
	public List<ItemVO> itemGetAll(Pagination pagination) {
		
		return itemService.getPagingAllItems(pagination);
	}
	
	@Override
	public int updateItemStatus(int itemId, int itemStatus) {
		
		return itemService.updateItemStatus(itemId, itemStatus);
	}

	@Override
	public ItemVO getItemById(int itemId) {
		return itemService.getItemById(itemId);
	}

	@Override
	public int totalCount(Pagination pagination) {
		return directOrderService.getTotalCount(pagination);
	}

	@Override
	public List<DirectOrderVO> orderList(Pagination pagination) {
		return directOrderService.getPagingBoards(pagination);
	}

	@Override
	public DirectOrderVO getselectOne(String orderId) {
		return directOrderService.getselectOne(orderId);
	}

}
