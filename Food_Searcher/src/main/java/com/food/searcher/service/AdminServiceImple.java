package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	
	@Override
	public int createRole(String memberId, String RoleName) {
	
		return memberService.createRole(memberId, RoleName);
	}
	
	@Override
	public int getTotalCount(Pagination pagination) {
		
		return itemService.getStatusTotalCount(pagination);
	}
	
	@Override
	public List<ItemVO> itemGetAll(Pagination pagination) {
		
		return itemService.getPagingAllItems(pagination);
	}
	
	@Override
	public int updateItemStatus(int itemId, int itemStatus) {
		
		return itemService.updateItemStatus(itemId, itemStatus);
	}

}
