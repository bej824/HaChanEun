package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.DiscountCouponVO;
import com.food.searcher.persistence.DiscountCouponMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DiscountCouponServiceImple implements DiscountCouponService {

	@Autowired
	DiscountCouponMapper discountCouponMapper;

	@Transactional
	@Override
	public int createCoupon(DiscountCouponVO discountCouponVO) {

			return discountCouponMapper.insertCoupon(discountCouponVO);
	}

	@Transactional
	@Override
	public List<DiscountCouponVO> selectCoupon(String searchBy, String searchText) {

		return discountCouponMapper.selectCoupon(searchBy, searchText);
	}

	@Transactional
	@Override
	public DiscountCouponVO selectOneCoupon(int couponId) {

		return discountCouponMapper.selectOneCoupon(couponId);
	}

	@Transactional
	@Override
	public int updateCoupon(DiscountCouponVO discountCouponVO) {

		return discountCouponMapper.updateCoupon(discountCouponVO);
	}

	@Transactional
	@Override
	public int deleteCoupon(int couponId) {

		return discountCouponMapper.deleteCoupon(couponId);
	}

}
