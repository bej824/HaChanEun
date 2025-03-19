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
	List<DirectOrderVO> sellerList(@Param("memberId") String memberId, @Param("pagination") Pagination pagination);
	List<DirectOrderVO> selectListByPagination(Pagination pagination);
	List<DirectOrderVO> memberList(@Param("memberId") String memberId, @Param("pagination") Pagination pagination);
	List<DirectOrderVO> orderCancelList();
	List<DirectOrderVO> isEnabled(String memberId); 
	DirectOrderVO selectOne(String orderId);
	int selectTotalCount(Pagination pagination);
	int sellerTotalCount(@Param("memberId") String memberId, @Param("pagination") Pagination pagination);
	int selectMemberTotalCount(@Param("memberId") String memberId, @Param("pagination") Pagination pagination);
	int insert(@Param("orderList") List<DirectOrderVO> orderList);
	int cancel(@Param("orderId") String orderId);
	int refundReady(@Param("orderId") String orderId);
	int refund(@Param("refundReason") String refundReason, @Param("refundContent") String refundContent, @Param("orderId") String orderId);
	int refundOK(@Param("orderId") String orderId);
	int deliveryReady(@Param("deliveryCompany") String deliveryCompany, @Param("invoiceNumber") String invoiceNumber, @Param("orderId") String orderId);
	int delivering(@Param("orderId") String orderId);
	int deliveryCompleted(@Param("orderId") String orderId);
	int orderCancel();
}
