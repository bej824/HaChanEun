package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.DirectOrderVO;

@Mapper
public interface DirectOrderMapper {
	List<DirectOrderVO> selectAll();
	List<DirectOrderVO> selectMember(String memberId);
	DirectOrderVO selectOne(int orderId);
	int insert(DirectOrderVO directOrderVO);
	int changeStatus(String deliveryStatus);
}
