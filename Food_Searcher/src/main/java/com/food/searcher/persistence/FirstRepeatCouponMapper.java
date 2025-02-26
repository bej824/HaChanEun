package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.DiscountCouponVO;

@Mapper
public interface FirstRepeatCouponMapper {
	
	int insertCoupon(DiscountCouponVO discountCouponVO);
	
	List<DiscountCouponVO> selectCouponByItemId(
			  @Param("memberId") String memberId
			, @Param("itemId") int itemId);

}
