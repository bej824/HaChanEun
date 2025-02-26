package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CartVO;

@Mapper
public interface CartMapper {
	int insert(CartVO cartVO);
	List<CartVO> selectOne(String memberId);
	List<CartVO> cartOrder(String memberId);
	int delete(int cartId);
	int cartDelete(int cartId);
	int updateChecked(@Param("cartChecked") int cartChecked, @Param("cartId") int cartId);
	int updateAmount(CartVO cartVO);
}
