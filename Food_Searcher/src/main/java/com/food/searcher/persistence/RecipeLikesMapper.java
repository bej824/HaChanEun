package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.util.Pagination;

public interface RecipeLikesMapper {
	List<RecipeLikesVO> selectAll();
	List<RecipeLikesVO> selectListByPagination(Pagination pagination);
	RecipeLikesVO selectMemberLikes(@Param("recipeBoardId") int recipeId, @Param("memberId") String memberId);
	int insert(RecipeLikesVO recipeLikesVO);
	int update(RecipeLikesVO recipeLikesVO);
}
