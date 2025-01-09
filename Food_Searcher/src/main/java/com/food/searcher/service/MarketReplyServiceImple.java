package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.MarketCommentVO;
import com.food.searcher.domain.MarketReplyVO;
import com.food.searcher.persistence.MarketCommentMapper;
import com.food.searcher.persistence.MarketReplyMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j

public class MarketReplyServiceImple implements MarketReplyService{
	
	@Autowired
	private MarketReplyMapper marketReplyMapper;	
	
	@Autowired
	private MarketCommentMapper marketCommentMapper;
	
	
	@Override
	public int createReply(MarketReplyVO marketReplyVO) {
		log.info("marketReplyVO");
		int insertResult = marketReplyMapper.insert(marketReplyVO);
		log.info(insertResult + "행 삽입");
		return 1;
	}

	@Override
	public List<MarketReplyVO> getAllReply(int marketId) {
		log.info("getAllReply");
		return marketReplyMapper.selectListByMarketId(marketId);
	}

	@Override
	public int updateReply(int marketReplyId, String marketReplyContent) {		
		log.info("updateReply");
		MarketReplyVO marketReplyVO = new MarketReplyVO();
		marketReplyVO.setMarketReplyId(marketReplyId);
		marketReplyVO.setMarketReplyContent(marketReplyContent);
		return marketReplyMapper.update(marketReplyVO);
	}

	@Transactional(value = "transactionManager") 
	@Override
	public int deleteReply(int marketReplyId, int marketId) {
		log.info("deleteReply()");
		int deleteResult = marketReplyMapper.delete(marketReplyId);		
		log.info(deleteResult + "행 댓글 삭제");
		return 1;
	}

	@Override
	public int deleteReplyByMarket(int marketId) {
		log.info("deleteReplyByMarket()");
		int deleteReplyByMarket = marketReplyMapper.deleteReplyByMarket(marketId);
		log.info("게시글에 대한 댓글 " + deleteReplyByMarket + "행 삭제");
		return 1;
	}

	


} // end MarketReplyServiceImple
