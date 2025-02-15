package com.food.searcher.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.MarketAttachVO;
import com.food.searcher.domain.MarketCommentVO;
import com.food.searcher.domain.MarketReplyVO;
import com.food.searcher.domain.MarketVO;
import com.food.searcher.persistence.MarketAttachMapper;
import com.food.searcher.persistence.MarketMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j

public class MarketServiceImple implements MarketService {

	@Autowired
	MarketMapper marketMapper;
	
	@Autowired
	MarketReplyService marketReplyService;
	
	@Autowired
	MarketCommentService marketCommentService;

	@Autowired
	private MarketAttachMapper attachMapper;
	
	@Transactional(value = "transactionManager")
	@Override
	public int createMarket(MarketVO marketVO) {
		log.info("createMarket()");
		log.info("marketVO : " + marketVO);
		int marketResult = marketMapper.insert(marketVO);
		log.info(marketResult + " 행 게시글 등록");
		
		List<MarketAttachVO> attachList = marketVO.getAttachList();
		log.info("이미지 파일 정보 : " + attachList);
		
		int insertAttachResult = 0;
	        for (MarketAttachVO attachVO : attachList) {
	        	// attachlist에서 객체를 차례대로 꺼내서 VO에 넣는다
	            insertAttachResult += attachMapper.insert(attachVO);
	            
	        }
		log.info(insertAttachResult + "행 파일 정보 등록");
		
		return 1;
	}

	@Override
	public List<MarketVO> getAllMarket() {
		log.info("getAllMarket()");
		List<MarketVO> list = marketMapper.selectList();
		log.info(list);
		
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public MarketVO getMarketById(int marketId) {
		log.info("getMarketById()");
		log.info("marketId : " + marketId);
		MarketVO marketVO = marketMapper.selectOne(marketId);
		return marketVO;
	}

	@Override
	public int updateMarket(MarketVO marketVO) {
		log.info("updateMarket()");
		return marketMapper.update(marketVO);
	}
	
	@Transactional(value = "transactionManager") 
	@Override
	public int deleteMarket(int marketId) {
		log.info("deleteMarket()");
	      List<MarketReplyVO> replyList = marketReplyService.getAllReply(marketId);
	      log.info("댓글 목록 : " + replyList);
	      // 게시글에 달린 댓글 목록을 불러온다
	      
	      for(MarketReplyVO replyVO : replyList) {
	    	  // 불러온 댓글 목록을 전부 돌 때까지
	    	  List<MarketCommentVO> commentList = marketCommentService.getAllComment(replyVO.getMarketReplyId());
	    	  log.info("대댓글 목록 : " + commentList);
	    	  // 댓글에 있는 대댓글을 불러온다
	    	  // => 게시글에 달린 댓글을 불러오고, 불러온 댓글에 달린 대댓글을 다 불러온다
	    	  
	    	  for(MarketCommentVO commentVO : commentList) {
	    		  int result = marketCommentService.deleteComment(commentVO.getMarketCommentId(), commentVO.getMarketReplyId());
	    		  // 불러온 대댓글을 전부 돌 때까지, 대댓글 삭제
	    		  log.info(commentVO);
	    		  log.info(result + "행 대댓글 삭제");
	    	  }
	    	  log.info(replyVO);
	    	  int result = marketReplyService.deleteReply(replyVO.getMarketReplyId(), replyVO.getMarketId());
	    	  log.info(result + "행 댓글 삭제");
	    	  // 아까 불러온 댓글을 전부 돌 때까지 댓글 삭제
	      }
		return marketMapper.delete(marketId);
		// 마지막으로 게시글 삭제
	}

	@Override
	public List<MarketVO> getPagingMarkets(Pagination pagination) {
		log.info("getPagingMarkets()");
		List<MarketVO> list = marketMapper.selectListByPagination(pagination);
		
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public int getTotalCount(Pagination pagination) {
		log.info("getTotalCount()");
		return marketMapper.selectTotalCount(pagination);
	}
	

}
