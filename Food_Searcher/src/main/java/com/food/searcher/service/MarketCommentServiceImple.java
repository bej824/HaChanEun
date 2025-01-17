package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.MarketCommentVO;
import com.food.searcher.domain.MarketReplyVO;
import com.food.searcher.domain.MarketVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.persistence.MarketCommentMapper;
import com.food.searcher.persistence.MarketMapper;
import com.food.searcher.persistence.MarketReplyMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j

public class MarketCommentServiceImple implements MarketCommentService {
	
	@Autowired
	private MarketCommentMapper marketCommentMapper;
	
	@Autowired
	private MarketReplyMapper marketReplyMapper;
	
	@Autowired
	private MarketMapper marketMapper;
	
	@Transactional(value = "transactionManager")
	@Override
	public int createComment(MarketCommentVO marketCommentVO) {
		log.info("createComment()");
		
		int insertResult = marketCommentMapper.insert(marketCommentVO);
		MarketReplyVO marketReplyVO = marketReplyMapper.selectOne(marketCommentVO.getMarketReplyId());
		log.info(insertResult + "행 대댓글 추가");
		
		int updateResult = marketMapper
				.updateReplyCount(marketReplyVO.getMarketId(), 1);
		log.info(updateResult + "행 댓글 카운트 증가");
		return insertResult;
	}

	@Override
	public List<MarketCommentVO> getAllComment(int marketReplyId) {
		log.info("getAllComment");
		return marketCommentMapper.selectListByMarketReplyId(marketReplyId);
	}

	@Override
	public int updateComment(int marketCommentId, String marketCommentContent) {
		log.info("updateComment");
		MarketCommentVO marketCommentVO = new MarketCommentVO();
		marketCommentVO.setMarketCommentId(marketCommentId);
		marketCommentVO.setMarketCommentContent(marketCommentContent);
		return marketCommentMapper.update(marketCommentVO);
	}
	
	@Override
	public int deleteComment(int marketCommentId, int marketReplyId) {
		log.info("deleteReply()");
		int deleteResult = marketCommentMapper.delete(marketCommentId);
		log.info("대댓글 " + deleteResult + "행 삭제");
		return 1;
	}

	@Override
	public int deleteCommentByReply(int marketReplyId) {
		log.info("deleteCommentByReply()");
		int deleteCommentByReply = marketCommentMapper.deleteCommentByReply(marketReplyId);
		log.info("댓글에 대한 대댓글 " + deleteCommentByReply + "행 삭제");
		return 1;
	}


} // end MarketCommentServiceImple