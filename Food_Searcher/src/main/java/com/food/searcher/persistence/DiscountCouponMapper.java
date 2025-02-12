package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.DiscountCouponVO;

@Mapper
public interface DiscountCouponMapper {
	int insertCoupon(DiscountCouponVO discountCouponVO);
	
	List<DiscountCouponVO> selectAllCoupon();
	
}
