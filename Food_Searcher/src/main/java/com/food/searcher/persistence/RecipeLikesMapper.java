package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.RecipeLikesVO;

public interface RecipeLikesMapper {
	int insert(RecipeLikesVO recipeLikesVO);
	List<RecipeLikesVO> selectAll();
	RecipeLikesVO selectMemberLikes(@Param("recipeBoardId") int recipeId, @Param("memberId") String memberId);
	int update(RecipeLikesVO recipeLikesVO);
}
