package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.RecipeVO;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeServiceImple implements RecipeService{
	
	@Autowired
	private RecipeMapper recipeMapper;
	
	@Override
	public int createBoard(RecipeVO recipeVO) {
		log.info("createBoard()");
		int result = recipeMapper.insert(recipeVO);
		return result;
	}

	@Override
	public List<RecipeVO> getAllBoards() {
		log.info("getAllBoards()");
		return recipeMapper.selectList();
	}

	@Override
	public RecipeVO getBoardById(int recipeId) {
		log.info("getBoardById()");
		log.info(recipeId);
		return recipeMapper.selectOne(recipeId);
	}

	@Override
	public int updateBoard(RecipeVO recipeVO) {
		log.info("updateBoard()");
		log.info(recipeVO);
		return recipeMapper.update(recipeVO);
	}

	@Override
	public int deleteBoard(int recipeId) {
		log.info("deleteBoard()");
		return recipeMapper.delete(recipeId);
	}

	@Override
	public List<RecipeVO> getPagingBoards(Pagination pagination) {
		log.info("getPagingBoards()");
		log.info(pagination);
		return recipeMapper.selectListByPagination(pagination);
	}

	@Override
	public int getTotalCount() {
		log.info("getTotalCount()");
		return recipeMapper.selectTotalCount();
	}

	@Override
	public List<RecipeVO> getselectSearch(String recipeTitle) {
		log.info("getselectSearch()");
		return recipeMapper.selectSearch(recipeTitle);
	}

	@Override
	public List<RecipeVO> getSelectId(String memberId) {
		log.info("getSelectId");
		return recipeMapper.selectId(memberId);
	}

	@Override
	public List<RecipeVO> getSelectContent(String recipeContent) {
		log.info("getSelectContent");
		return recipeMapper.selectContent(recipeContent);
	}

	@Override
	public List<RecipeVO> getSelectFood(String recipeFood) {
		log.info("getSelectFood");
		return recipeMapper.selectFood(recipeFood);
	}

	@Override
	public int getTitleTotalCount() {
		log.info("getTitleTotalCount()");
		return recipeMapper.titleTotalCount();
	}

	@Override
	public List<RecipeVO> getTitleByPagination(Pagination pagination, String recipeTitle) {
		log.info("getTitleByPagination()");
		return recipeMapper.selectTitleByPagination(pagination, recipeTitle);
	}

}
