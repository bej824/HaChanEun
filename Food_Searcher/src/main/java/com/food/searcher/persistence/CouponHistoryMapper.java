package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CouponHistoryVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface CouponHistoryMapper {
	
	int insertCouponHistory();
	
	int selectAllCount();
	
	List<CouponHistoryVO> selectCouponHistoryByPagination(@Param("pagination") Pagination pagination);
	
	List<CouponHistoryVO> selectCouponHistoryBySellerId(@Param("sellerId") String sellerId);

}
