package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CouponActiveVO;

@Mapper
public interface CouponActiveMapper {
	
	int insertCouponActive(CouponActiveVO couponActiveVO);
	
	List<CouponActiveVO> selectCouponActive(
			 @Param("memberId") String memberId
			,@Param("itemId") int itemId
			);
	
	int updateCouponActiveByCouponActiveId(CouponActiveVO couponActiveVO);

}
