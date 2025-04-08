package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CouponActiveVO;

@Mapper
public interface CouponActiveMapper {
	
	int insertCouponActive(List<CouponActiveVO> list);
	
	List<CouponActiveVO> selectCouponActive(
			 @Param("memberId") String memberId
			);
	
	int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO);

	int updateCouponActiveByOrderId(String orderId);
	
	int deleteCouponActiveByOrderId();
	
	Integer selectCouponPriceByCouponActiveId(
			 @Param("couponActiveId") String couponActiveId
			,@Param("memberId") String memberId);

}
