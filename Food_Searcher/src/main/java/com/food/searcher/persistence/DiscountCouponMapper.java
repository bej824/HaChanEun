package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.DiscountCouponVO;

@Mapper
public interface DiscountCouponMapper {
	int insertCoupon(DiscountCouponVO discountCouponVO);
	
	List<DiscountCouponVO> selectCoupon(@Param("searchBy") String searchBy, @Param("searchText")String searchText);
	
	DiscountCouponVO selectOneCoupon(int couponId);
	
	int updateCoupon(DiscountCouponVO discountCouponVO);

	int deleteCoupon(int couponId);
	
}
