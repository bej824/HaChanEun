package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DiscountCouponVO;

public interface DiscountCouponService {
	
	/**
	 * @param couponListVO
	 * if(couponEvent.equal("FIRST_ORDER_COUPON" || "REPEAT_ORDER_COUPON")
	 * @return firstRepeatCouponMapper.insertCoupon(discountCouponVO)
	 * else
	 * @return discountCouponMapper.insertCoupon(discountCouponVO)
	 */
	int createCoupon(DiscountCouponVO couponListVO);
	
	/**
	 * @param searchBy 검색 키워드
	 * 					(COUPON_ID
						,COUPON_NAME
						,COUPON_ISSUER
						,COUPON_CONTENT
						,COUPON_PRICE
						,COUPON_USE_CONDITION
						,COUPON_EVENT
						,COUPON_EXPIRATION_DATE)
	 * @param searchText 검색할 값
	 * @return 조건에 맞는 List<DiscountCouponVO> 목록
	 */
	List<DiscountCouponVO> selectCoupon(String searchBy, String searchText);
	
	/**
	 * @param couponId 정보가 필요한 couponId
	 * @return couponId의 상세한 정보값
	 */
	DiscountCouponVO selectOneCoupon(int couponId);
	
	/**
	 * @param sellerId 판매자 아이디
	 * @return 판매자가 관리 가능한 쿠폰
	 */
	List<DiscountCouponVO> selectFRCouponBySellerId(String sellerId);
	
	/**
	 * @param memberId 로그인한 사람의 아이디
	 * @param itemId 현재 존재하는 상품칸
	 * @return 첫구매 혹은 재구매 쿠폰
	 */
	List<DiscountCouponVO> selectFRCouponByitemId(String memberId, int itemId);
	
	/**
	 * @param 수정하고 싶은 정보가 담긴 discountCouponVO
	 * @return 성공 1, 실패 0
	 */
	int updateCoupon(DiscountCouponVO discountCouponVO);

	/**
	 * @param 삭제하고 싶은 couponId
	 * @return 성공 1, 실패 0
	 */
	int deleteCoupon(int couponId);

}
