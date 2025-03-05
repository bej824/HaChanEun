package com.food.searcher.persistence;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CouponHistoryMapper {
	
	int insertCouponHistory();

}
