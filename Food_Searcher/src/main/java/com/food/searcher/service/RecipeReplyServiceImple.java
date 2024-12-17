package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.ReplyVO;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.persistence.ReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImple implements ReplyService{
	
	@Autowired
	private ReplyMapper replyMapper;
	
	@Autowired
	private RecipeMapper recipeMapper;
	
	@Transactional(value = "transactionManager") // transactionManager가 관리
	@Override
	public int createReply(ReplyVO replyVO) {
		// 댓글을 추가하면 
		// REPLY 테이블에 댓글이 등록되고,
		// BOARD 테이블에 댓글 수(REPLY_COUNT)가 수정된다.
		log.info("createReply()");
		int insertResult = replyMapper.insert(replyVO);
		log.info(insertResult + "행 댓글 추가");
		int updateResult = recipeMapper
				.updateReplyCount(replyVO.getBoardId(), 1);
		log.info(updateResult + "행 게시판 수정");
		return 1;
	}

	@Override
	public List<ReplyVO> getAllReply(int boardId) {
		log.info("getAllReply()");
		return replyMapper.selectListByBoardId(boardId);
	}

	@Override
	public int updateReply(int replyId, String replyContent) {
		log.info("updateReply");
		ReplyVO replyVO = new ReplyVO();
		replyVO.setReplyId(replyId);
		replyVO.setReplyContent(replyContent);
		return replyMapper.update(replyVO);
	}

	@Transactional(value = "transactionManager") // transactionManager가 관리
	@Override
	public int deleteReply(int replyId, int boardId) {
		log.info("deleteReply()");
		int deleteResult = replyMapper.delete(replyId);
		log.info(deleteResult + "행 댓글 삭제");
		int updateResult = recipeMapper
				.updateReplyCount(boardId, -1);
		log.info(updateResult + "행 게시판 삭제");
		return 1;
	}

	@Override
	public ReplyVO getReplyById(int replyId) {
		log.info("getReplyById()");
		log.info(replyId);
		log.info(replyMapper.selectOne(replyId));
		return replyMapper.selectOne(replyId);
	}

}
