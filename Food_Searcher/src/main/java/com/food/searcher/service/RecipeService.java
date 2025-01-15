package com.food.searcher.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.RecipeVO;
import com.food.searcher.util.Pagination;

public interface RecipeService {
	int createBoard(RecipeVO recipeVO); // 게시글 등록
	List<RecipeVO> getAllBoards(); // 전체 게시글 조회
	RecipeVO getBoardById(int recipeId); // 특정 게시글 조회
	int updateBoard(RecipeVO recipeVO); // 특정 게시글 수정
	int deleteBoard(int recipeId); // 특정 게시글 삭제
	List<RecipeVO> getPagingBoards(Pagination pagination); // 게시글 페이징 처리 조회
	int getTotalCount(@Param("recipeTitle") String recipeTitle, @Param("filterBy") String filterBy);  // 게시글 수 조회
}
