package com.food.searcher.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CouponActiveVO;
import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.persistence.CouponActiveMapper;
import com.food.searcher.task.MemberCouponTask;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CouponActiveServiceImple implements CouponActiveService {
	
	@Autowired
	CouponActiveMapper couponActiveMapper;
	
	@Autowired
	DiscountCouponService discountCouponService;
	
	@Autowired
	ItemService itemService;
	
	@Transactional
	@Override
	public int createCouponActive(CouponActiveVO couponActiveVO) {
		log.info("createCouponActive()");
		
		if(couponActiveVO.getItemName() == null) {
			couponActiveVO.setItemName("");
		}
		
		return couponActiveMapper.insertCouponActive(couponActiveVO);
	}
	
	/**
	 * 발급 쿠폰 확인(couponActive)
	 * 1. 운영자가 현재 발급된 쿠폰을 모두 확인할 수 있음.
	 * 2. 회원이 확인할 경우 memberId가 자동 입력되어 회원에게 발급된 쿠폰만 확인 가능.
	 * 3. 상품 구매 시 확인할 때는 사용 가능한, 사용처인 곳과 사용처 지정이 되어있지 않은 쿠폰만 확인 가능.
	 * memberId 회원 입장에서의 확인 시 자동 기입.
	 * itemId 상품 구매할 때 사용 가능한 쿠폰 확인 시 자동 기입.
	 */
	@Transactional
	@Override
	public List<CouponActiveVO> selectCouponActive(String memberId, int itemId) {
		log.info("selectCouponActive()");
		
		return couponActiveMapper.selectCouponActive(memberId, itemId);
	}
	
	/**
	 * 쿠폰 사용(couponActiveMapper.updateCouponActiveByOrderId(orderId))
	 * 1. 상품 구매 시 쿠폰이 사용되었다면 couponActiveId를 통해 확인.
	 * 2. couponUseDate, itemId, orderId를 기입.
	 * couponActiveVO couponActiveId, couponUseDate, itemId, orderId가 들어있어야함.
	 */
	@Transactional
	@Override
	public int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO) {
		log.info("updateCouponActiveByCouponActiveId()");
		int result = 0;
		try {
			result = couponActiveMapper.updateCouponActiveByCouponActiveId(couponActiveVO);
		} catch (Exception e) {
			log.info(couponActiveVO.getOrderId() + " 처리 중 에러" + e);
		}
		
		return result;
	}
	
	/**
	 * 쿠폰 환불(couponActive)
	 * 1. 상품 환불 시 쿠폰이 사용되었다면, orderId를 통해 확인.
	 * 2. 쿠폰 만료일이 지나지 않았고, 사용되지 않은 쿠폰임을 확인.
	 * 3. itemName이 있다면 사용처지정쿠폰이므로 itemId는 초가화되지 않음.
	 * 4. itemName이 없다면 사용처지정쿠폰이 아니므로 itemId 초기화.
	 * 5. orderId와 couponUseDate는 null로 초기화.
	 */
	@Override
	public int updateCouponActiveByOrderId(String orderId) {
		log.info("updateCouponActiveByOrderId()");
		int result = 0;
		
		try {
			result = couponActiveMapper.updateCouponActiveByOrderId(orderId);
		} catch (Exception e) {
			log.info(orderId + " 처리 중 에러" + e);
		}
		
		return result;
	}
	
	/**
	 * 1. 쿠폰 발급 시 발급일, 만료일 기입
	 * 2. 사용처 제한을 위해 itemId가 있을 시 itemName 추가 기입
	 * 3. 사용처 제한이 없을 시 itemId = 0으로 기입되며, itemName = null로 기입
	 */
	@Transactional
	@Override
	public CouponActiveVO setCouponInfo(CouponActiveVO couponActiveVO) {
		
		DiscountCouponVO coupon = discountCouponService.selectOneCoupon(couponActiveVO.getCouponId());
		
		if(couponActiveVO.getItemId() > 0) {
			ItemVO item = itemService.getItemById(couponActiveVO.getItemId());
			couponActiveVO.setItemName(item.getItemName());
		}
		
		couponActiveVO.setCouponName(coupon.getCouponName());
		couponActiveVO.setCouponIssuedDate(LocalDate.now());
		couponActiveVO.setCouponExpireDate(LocalDate.now().plusDays(coupon.getCouponExpirationDate()));
		
		return couponActiveVO;
	} // end setCouponInfo()

}
