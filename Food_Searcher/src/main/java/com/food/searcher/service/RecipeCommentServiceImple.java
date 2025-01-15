package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.persistence.RecipeCommentMapper;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.persistence.RecipeReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeCommentServiceImple implements RecipeCommentService{
	
	@Autowired
	private RecipeCommentMapper recipeCommentMapper;
	
	@Autowired
	private RecipeMapper recipeMapper;
	
	@Autowired
	private RecipeReplyMapper replyMapper;
	
	@Override
	public int createComment(RecipeCommentVO recipeCommentVO) {
		log.info("createReply()");
		int insertResult = recipeCommentMapper.insert(recipeCommentVO);
		log.info(insertResult + "행 대댓글 추가");
		RecipeReplyVO replyVO = replyMapper.selectOne(recipeCommentVO.getRecipeReplyId());
		int updateResult = recipeMapper
				.updateReplyCount(replyVO.getBoardId(), 1);
		log.info(updateResult + "행 댓글 카운트 증가");
		return insertResult;
	}

	@Override
	public List<RecipeCommentVO> getAllComment(int replyId) {
		log.info("getAllReply()");
		return recipeCommentMapper.selectListByBoardId(replyId);
	}

	@Override
	public int updateComment(int recipeCommentId, String commentContent) {
		log.info("updateReply");
		RecipeCommentVO recipeCommentVO = new RecipeCommentVO();
		recipeCommentVO.setRecipeCommentId(recipeCommentId);
		recipeCommentVO.setCommentContent(commentContent);
		return recipeCommentMapper.update(recipeCommentVO);
	}

	@Override
	public int deleteComment(int recipeCommentId, int replyId) {
		log.info("deleteReply()");
		int deleteResult = recipeCommentMapper.delete(recipeCommentId);
		log.info(deleteResult + "행 대댓글 삭제");
		return deleteResult;
	}

}
