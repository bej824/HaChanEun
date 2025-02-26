package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;

public interface CouponActiveService {
	
	int createCouponActive(CouponActiveVO couponActiveVO);
	
	/**
	 * 발급 쿠폰 확인(couponActive)
	 * @param memberId 회원 입장에서의 확인 시 자동 기입.
	 * @param itemId 상품 구매할 때 사용 가능한 쿠폰 확인 시 자동 기입.
	 * 1. 운영자가 현재 발급된 쿠폰을 모두 확인할 수 있음.
	 * 2. 회원이 확인할 경우 memberId가 자동 입력되어 회원에게 발급된 쿠폰만 확인 가능.
	 * 3. 상품 구매 시 확인할 때는 사용 가능한, 사용처인 곳과 사용처 지정이 되어있지 않은 쿠폰만 확인 가능.
	 */
	List<CouponActiveVO> selectCouponActive(String memberId, int itemId);
	
	/**
	 * @param couponActiveVO
	 * 쿠폰 사용(couponActiveMapper.updateCouponActiveByOrderId(orderId))
	 * 1. 상품 구매 시 쿠폰이 사용되었다면 couponActiveId를 통해 확인.
	 * 2. couponUseDate, itemId, orderId를 기입.
	 * couponActiveVO couponActiveId, couponUseDate, itemId, orderId가 들어있어야함.
	 */
	int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO);
	
	/**
	 * @param orderId
	 * 쿠폰 환불(couponActive)
	 * 1. 상품 환불 시 쿠폰이 사용되었다면, orderId를 통해 확인.
	 * 2. 쿠폰 만료일이 지나지 않았고, 사용되지 않은 쿠폰임을 확인.
	 * 3. itemName이 있다면 사용처지정쿠폰이므로 itemId는 초가화되지 않음.
	 * 4. itemName이 없다면 사용처지정쿠폰이 아니므로 itemId 초기화.
	 * 5. orderId와 couponUseDate는 null로 초기화.
	 */
	int updateCouponActiveByOrderId(String orderId);
	
	/**
	 * @param couponActiveVO
	 * 1. 쿠폰 발급 시 발급일, 만료일 기입
	 * 2. 사용처 제한을 위해 itemId가 있을 시 itemName 추가 기입
	 * 3. 사용처 제한이 없을 시 itemId = 0으로 기입되며, itemName = null로 기입
	 */
	CouponActiveVO setCouponInfo(CouponActiveVO couponActiveVO);
	
	

}
