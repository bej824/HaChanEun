package com.food.searcher.service;

import java.security.Principal;
import java.util.List;

import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.util.Pagination;

public interface RecipeService {
	List<RecipeVO> getAllBoards(); // 전체 게시글 조회
	RecipeVO getBoardById(int recipeId, String memberId); // 특정 게시글 조회
	List<RecipeVO> getPagingBoards(Pagination pagination); // 게시글 페이징 처리 조회
	int createBoard(RecipeVO recipeVO); // 게시글 등록
	int updateBoard(RecipeVO recipeVO); // 특정 게시글 수정
	int deleteBoard(int recipeId); // 특정 게시글 삭제
	int getTotalCount(Pagination pagination);  // 게시글 수 조회
	
	String localWord();
	MemberVO memberInfo(Principal principal);
	
	RecipeLikesVO memberLike(int recipeId, Principal principal);
}
