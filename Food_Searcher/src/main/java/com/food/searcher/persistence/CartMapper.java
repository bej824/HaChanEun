package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.CartVO;

@Mapper
public interface CartMapper {
	int insert(CartVO cartVO);
	List<CartVO> selectOne(String memberId);
	int delete(int cartId);
	int updateAmount(CartVO cartVO);
}
