package com.food.searcher.persistence;

import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.RecipeLikesVO;

public interface RecipeLikesMapper {
	int insert(RecipeLikesVO recipeLikesVO);
	RecipeLikesVO selectMemberLikes(@Param("recipeBoardId") int recipeId, @Param("memberId") String memberId);
	int update(RecipeLikesVO recipeLikesVO);
}
