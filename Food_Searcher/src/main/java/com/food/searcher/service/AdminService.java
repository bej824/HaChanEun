package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

public interface AdminService {
	
	/**
	 * @param memberId
	 * @param RoleName
	 * @return 성공 1, 실패 0
	 */
	int createRole(String memberId, String RoleName);
	
	/**
	 * @param pagination
	 * @return 사이트에 올라온 상품 총 갯수
	 */
	int getTotalCount(Pagination pagination);
	
	/**
	 * @return 현재 사이트에서 판매되고 있는 모든 상품
	 */
	List<ItemVO> itemGetAll(Pagination pagination);
	
	int updateItemStatus(int itemId, int itemStatus);

}
