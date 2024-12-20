package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.MarketCommentVO;
import com.food.searcher.persistence.MarketCommentMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j

public class MarketCommentServiceImple implements MarketCommentService {

	@Autowired
	private MarketCommentMapper marketCommentMapper;
	
	@Override
	public int createComment(MarketCommentVO marketCommentVO) {
		log.info("createReply()");
		int insertResult = marketCommentMapper.insert(marketCommentVO);
		log.info(insertResult + "행 댓글 추가");
		
		return insertResult;
	}

	@Override
	public List<MarketCommentVO> getAllComment(int marketReplyId) {
		log.info("getAllComment");
		return marketCommentMapper.selectListByMarketId(marketReplyId);
	}
	

	@Override
	public MarketCommentVO getCommentById(int marketCommentId) {
		return null;
	}

	@Override
	public int updateComment(int marketCommentId, String commentContent) {
		log.info("updateReply");
		MarketCommentVO marketCommentVO = new MarketCommentVO();
		marketCommentVO.setMarketCommentId(marketCommentId);
		// ?
		marketCommentVO.setCommentContent(commentContent);
		return marketCommentMapper.update(marketCommentVO);
	}

	@Override
	public int deleteComment(int marketCommentId, int marketReplyId) {
		log.info("deleteReply()");
		int deleteResult = marketCommentMapper.delete(marketCommentId);
		log.info(deleteResult + "행 댓글 삭제");
		return deleteResult;
	}

}
