package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

public interface SellerService {
	
	/**
	 * 인증이 완료된 판매자에게 'ROLE_SELLER' 권한을 주기 위한 코드
	 * @param memberId 로그인한 회원의 계정 id
	 * @return 성공 1, 실패 0
	 */
	int SellerCreate(String memberId);
	
	List<DiscountCouponVO> selectSellerCoupon();
	
	List<DirectOrderVO> purchaseHistory(String memberId, Pagination pagination);
	
	int totalCount(String memberId, Pagination pagination);
	
	int sellerTotalCount();
	
	int updateItemStatus(int itemId, int itemStatus);
	
	DirectOrderVO purchaseInfo(String orderId);
	
	ItemVO purchaseItemInfo(String orderId);
	
	/**
	 * @param pagination
	 * @return 사이트에 올라온 상품 총 갯수
	 */
	int getTotalCount(Pagination pagination);

//	List<ItemVO> selectStatusByPagination(int itemStatus, Pagination pagination);

	List<ItemVO> selectSellerItem(String memberId, Pagination pagination);
	
	List<ItemVO> select(String memberId, Pagination pagination);
	
	int sellerTotalCount(String memberId, Pagination pagination);
	
}
