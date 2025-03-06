package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.DiscountCouponVO;

public interface DiscountCouponService {
	
	/**
	 * @param couponListVO
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
