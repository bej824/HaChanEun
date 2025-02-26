package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ItemVO;

public interface AdminService {
	
	int createRole(String memberId, String RoleName);
	
	List<ItemVO> itemGetAll();

}
