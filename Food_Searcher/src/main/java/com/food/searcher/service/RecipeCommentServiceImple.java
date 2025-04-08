package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.persistence.RecipeCommentMapper;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.persistence.RecipeReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeCommentServiceImple implements RecipeCommentService {

	@Autowired
	private RecipeCommentMapper recipeCommentMapper;

	@Autowired
	private RecipeMapper recipeMapper;

	@Autowired
	private RecipeReplyMapper replyMapper;
	
	@Transactional
	@Override
	public int createComment(RecipeCommentVO recipeCommentVO) {
		int replyId = recipeCommentVO.getRecipeReplyId();
		int boardId = replyMapper.selectOne(replyId).getBoardId();
		recipeMapper.updateReplyCount(boardId, 1);
		return recipeCommentMapper.insert(recipeCommentVO);
	}
	
	@Transactional
	@Override
	public List<RecipeCommentVO> getAllComment(int replyId) {
		return recipeCommentMapper.selectListByBoardId(replyId);
	}

	@Override
	public int updateComment(int recipeCommentId, String commentContent) {
		RecipeCommentVO recipeCommentVO = new RecipeCommentVO();
		recipeCommentVO.setRecipeCommentId(recipeCommentId);
		recipeCommentVO.setCommentContent(commentContent);
		return recipeCommentMapper.update(recipeCommentVO);
	}

	@Override
	public int deleteComment(int recipeCommentId, int replyId) {
		return recipeCommentMapper.delete(recipeCommentId);
	}

}
