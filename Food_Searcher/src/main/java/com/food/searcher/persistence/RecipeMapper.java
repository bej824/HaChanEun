package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.RecipeVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface RecipeMapper {
	List<RecipeVO> selectList(); // 전체 게시글 조회
	RecipeVO selectOne(int recipeId); // 상세 게시글 조회
	List<RecipeVO> selectListByPagination(Pagination pagination); // 전체 게시글 페이징 처리
	int insert(RecipeVO recipeVO); // 게시글 등록
	int update(RecipeVO recipeVO); // 상세 게시글 수정
	int delete(int recipeId); // 상세 게시글 삭제
	int updateReplyCount(@Param("recipeId") int recipeId, @Param("amount") int amount); // 댓글 수 변경
	int selectTotalCount(Pagination pagination); // 게시글 수 조회
	// @Param : 자바 객체의 속성을 mapper에 매핑
	int updateLikesCount(@Param("recipeId") int recipeId, @Param("amount") int amount); // 좋아요 수 변경
	int updateDislikesCount(@Param("recipeId") int recipeId, @Param("amount") int amount); // 싫어요 수 변경
}
