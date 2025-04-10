package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.persistence.RecipeReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeReplyServiceImple implements RecipeReplyService {

	@Autowired
	private RecipeReplyMapper replyMapper;

	@Autowired
	private RecipeMapper recipeMapper;

	@Autowired
	private RecipeCommentService recipeCommentService;

	@Transactional(value = "transactionManager") // transactionManager가 관리
	@Override
	public int createReply(RecipeReplyVO replyVO) {
		// 댓글을 추가하면
		// REPLY 테이블에 댓글이 등록되고,
		// BOARD 테이블에 댓글 수(REPLY_COUNT)가 수정된다.
		replyMapper.insert(replyVO);
		recipeMapper.updateReplyCount(replyVO.getBoardId(), 1);
		return 1;
	}

	@Override
	public List<RecipeReplyVO> getAllReply(int boardId) {
		return replyMapper.selectListByBoardId(boardId);
	}

	@Override
	public RecipeReplyVO getReplyById(int replyId) {
		return replyMapper.selectOne(replyId);
	}

	@Override
	public int updateReply(int replyId, String replyContent) {
		RecipeReplyVO replyVO = new RecipeReplyVO();
		replyVO.setReplyId(replyId);
		replyVO.setReplyContent(replyContent);
		return replyMapper.update(replyVO);
	}

	@Transactional(value = "transactionManager") // transactionManager가 관리
	@Override
	public int deleteReply(int replyId, int boardId) {

		List<RecipeCommentVO> list = recipeCommentService.getAllComment(replyId);

		for (RecipeCommentVO vo : list) {
			recipeCommentService.deleteComment(vo.getRecipeCommentId(), vo.getRecipeReplyId());
			recipeMapper.updateReplyCount(boardId, -1);
		}

		replyMapper.delete(replyId);
		recipeMapper.updateReplyCount(boardId, -1);
		return 1;
	}

}
