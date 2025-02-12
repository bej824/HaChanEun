package com.food.searcher.persistence;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.CouponActiveVO;

@Mapper
public interface CouponActiveMapper {
	
	int insertCouponActive(CouponActiveVO couponActiveVO);

}
