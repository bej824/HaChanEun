package com.food.searcher.persistence;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AmountHeldMapper {

	int updateMemberAmountHeld(
			 @Param("memberId") String memberId
			,@Param("amountHeld") int amountHeld
			);
	
	int selectMemberAmountHeldByMemberId(
			@Param("memberId") String memberId
			);

}
