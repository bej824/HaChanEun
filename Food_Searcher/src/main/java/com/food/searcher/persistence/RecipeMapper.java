package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.RecipeVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface RecipeMapper {
	// 메소드 이름은 BoardMapper.xml에서 SQL 쿼리 정의 태그의 id 값과 동일
	// 매개변수는 BoardMapper.xml에서 #{변수명}과 동일(클래스 타입은 각 멤버변수명과 매칭)
	int insert(RecipeVO recipeVO); // 게시글 등록
	List<RecipeVO> selectList(); // 전체 게시글 조회
	RecipeVO selectOne(int recipeId); // 상세 게시글 조회
	int update(RecipeVO recipeVO); // 상세 게시글 수정
	int delete(int recipeId); // 상세 게시글 삭제
	int updateReplyCount(@Param("recipeId") int recipeId, @Param("amount") int amount); // 댓글 수 변경
	// @Param : 자바 객체의 속성을 mapper에 매핑
	List<RecipeVO> selectListByPagination(Pagination pagination); // 전체 게시글 페이징 처리
	List<RecipeVO> selectListByPagination(String recipeTitle, String filterBy, Pagination pagination);
	List<RecipeVO> selectTitleByPagination(@Param("keyword") String keyword, @Param("pagination") Pagination pagination);
	List<RecipeVO> selectFoodByPagination(@Param("keyword") String keyword, @Param("pagination") Pagination pagination);
	List<RecipeVO> selectContentByPagination(@Param("keyword") String keyword, @Param("pagination") Pagination pagination);
	List<RecipeVO> selectMemberByPagination(@Param("keyword") String keyword, @Param("pagination") Pagination pagination);
	int selectTotalCount(); // 게시글 수 조회
	int titleTotalCount(@Param("recipeTitle") String recipeTitle);
	int foodTotalCount(@Param("recipeTitle") String recipeTitle);
	int contentTotalCount(@Param("recipeTitle") String recipeTitle);
	int memberTotalCount(@Param("recipeTitle") String recipeTitle);
}
