package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ItemVO;

public interface AdminService {
	
	/**
	 * @param memberId 권한이 부여될 계정id
	 * @param RoleName 권한 이름
	 * @return 성공 1, 실패 0
	 */
	int createRole(String memberId, String RoleName);
	
	/**
	 * @return 현재 사이트에서 판매되고 있는 모든 상품
	 */
	List<ItemVO> itemGetAll();

}
