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
	DirectOrderVO selectOne(String orderId);
	int insert(DirectOrderVO directOrderVO);
	int cartInsert(DirectOrderVO directOrderVO);
	int cancel(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") String orderId);
	int refundReady(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") String orderId);
	int refund(@Param("deliveryStatus") String deliveryStatus, @Param("refundReason") String refundReason, @Param("refundContent") String refundContent, @Param("orderId") String orderId);
	int refundOK(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") String orderId);
	int deliveryReady(@Param("deliveryStatus") String deliveryStatus, @Param("deliveryCompany") String deliveryCompany, @Param("invoiceNumber") String invoiceNumber, @Param("orderId") String orderId);
	int delivering(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") String orderId);
	int deliveryCompleted(@Param("deliveryStatus") String deliveryStatus, @Param("orderId") String orderId);
}
