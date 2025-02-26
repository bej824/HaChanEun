package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.persistence.DiscountCouponMapper;
import com.food.searcher.persistence.FirstRepeatCouponMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DiscountCouponServiceImple implements DiscountCouponService {

	@Autowired
	DiscountCouponMapper discountCouponMapper;

	@Autowired
	FirstRepeatCouponMapper firstRepeatCouponMapper;

	@Transactional
	@Override
	public int createCoupon(DiscountCouponVO discountCouponVO) {
		log.info("createCoupon()");

		if (	discountCouponVO.getCouponEvent().equals("FIRST_ORDER_COUPON")
			||	discountCouponVO.getCouponEvent().equals("REPEAT_ORDER_COUPON")) {

			return createFirstRepeatCoupon(discountCouponVO);
		} else {

			return createOtherCoupon(discountCouponVO);
		}
	}

	@Transactional
	@Override
	public List<DiscountCouponVO> selectCoupon(String searchBy, String searchText) {
		log.info("selectAllCoupon()");

		return discountCouponMapper.selectCoupon(searchBy, searchText);
	}

	@Transactional
	@Override
	public DiscountCouponVO selectOneCoupon(int couponId) {
		log.info("selectOneCoupon()");

		return discountCouponMapper.selectOneCoupon(couponId);
	}
	
	@Transactional
	@Override
	public List<DiscountCouponVO> selectFRCouponBySellerId(String sellerId) {
		
		return firstRepeatCouponMapper.selectCouponBySellerId(sellerId);
	}
	
	@Transactional
	@Override
	public List<DiscountCouponVO> selectFRCouponByitemId(String memberId, int itemId) {
		log.info("selectFRCoupon()");
		
		return firstRepeatCouponMapper.selectCouponByItemId(memberId, itemId);
	}

	@Transactional
	@Override
	public int updateCoupon(DiscountCouponVO discountCouponVO) {
		log.info("updateCoupon()");

		return discountCouponMapper.updateCoupon(discountCouponVO);
	}

	@Transactional
	@Override
	public int deleteCoupon(int couponId) {
		log.info("deleteCoupon()");

		return discountCouponMapper.deleteCoupon(couponId);
	}
	
	@Transactional
	private int createFirstRepeatCoupon(DiscountCouponVO discountCouponVO) {
	    return firstRepeatCouponMapper.insertCoupon(discountCouponVO);
	}
	
	@Transactional
	private int createOtherCoupon(DiscountCouponVO discountCouponVO) {
	    return discountCouponMapper.insertCoupon(discountCouponVO);
	}

}
