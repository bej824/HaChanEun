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
	List<RecipeVO> selectSearch(String recipeTitle);
	List<RecipeVO> selectId(String memberId);
	List<RecipeVO> selectContent(String recipeContent);
	List<RecipeVO> selectFood(String recipeFood);
	int update(RecipeVO recipeVO); // 상세 게시글 수정
	int delete(int recipeId); // 상세 게시글 삭제
	int updateReplyCount(@Param("recipeId") int recipeId, @Param("amount") int amount); // 댓글 수 변경
	// @Param : 자바 객체의 속성을 mapper에 매핑
	List<RecipeVO> selectListByPagination(Pagination pagination);
	List<RecipeVO> selectTitleByPagination(Pagination pagination, String recipeTitle);
	int selectTotalCount();
	int titleTotalCount();
}
