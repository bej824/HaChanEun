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
		log.info("createReply()");
		int insertResult = replyMapper.insert(replyVO);
		log.info(insertResult + "행 댓글 추가");
		int updateResult = recipeMapper.updateReplyCount(replyVO.getBoardId(), 1);
		log.info(updateResult + "행 댓글 카운트 증가");
		return 1;
	}

	@Override
	public List<RecipeReplyVO> getAllReply(int boardId) {
		log.info("getAllReply()");
		return replyMapper.selectListByBoardId(boardId);
	}

	@Override
	public RecipeReplyVO getReplyById(int replyId) {
		log.info("getReplyById()");
		return replyMapper.selectOne(replyId);
	}

	@Override
	public int updateReply(int replyId, String replyContent) {
		log.info("updateReply");
		RecipeReplyVO replyVO = new RecipeReplyVO();
		replyVO.setReplyId(replyId);
		replyVO.setReplyContent(replyContent);
		return replyMapper.update(replyVO);
	}

	@Transactional(value = "transactionManager") // transactionManager가 관리
	@Override
	public int deleteReply(int replyId, int boardId) {
		log.info("deleteReply()");

		List<RecipeCommentVO> list = recipeCommentService.getAllComment(replyId);
		log.info(list);

		for (RecipeCommentVO vo : list) {
			int commentresult = recipeCommentService.deleteComment(vo.getRecipeCommentId(), vo.getRecipeReplyId());
			log.info(commentresult);
			int updateResult = recipeMapper.updateReplyCount(boardId, -1);
			log.info("대댓글 삭제" + updateResult);
		}

		int deleteResult = replyMapper.delete(replyId);
		log.info(deleteResult + "행 댓글 삭제");
		int updateResult = recipeMapper.updateReplyCount(boardId, -1);
		log.info(updateResult + "행 댓글 카운트 삭제");
		return 1;
	}

}
