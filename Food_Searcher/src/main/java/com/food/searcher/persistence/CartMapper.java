package com.food.searcher.persistence;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.CartVO;

@Mapper
public interface CartMapper {
	int insert(CartVO cartVO);
	CartVO selectOne(int cartId);
	int delete(int cartId);
}
