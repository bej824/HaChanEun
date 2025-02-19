package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface DirectOrderMapper {
	List<DirectOrderVO> selectAll();
	List<DirectOrderVO> selectMember(String memberId);
	List<DirectOrderVO> selectListByPagination(Pagination pagination);
	DirectOrderVO selectOne(int orderId);
	int insert(DirectOrderVO directOrderVO);
	int cancel(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") int orderId);
	int refundReady(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") int orderId);
	int refund(@Param("deliveryStatus") String deliveryStatus, @Param("refundReason") String refundReason, @Param("refundContent") String refundContent, @Param("orderId") int orderId);
	int refundOK(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") int orderId);
	int deliveryReady(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") int orderId);
	int deliveryCompleted(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") int orderId);
}
