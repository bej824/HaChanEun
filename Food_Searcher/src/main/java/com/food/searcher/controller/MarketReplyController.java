package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.food.searcher.domain.MarketCommentVO;
import com.food.searcher.domain.MarketReplyVO;
import com.food.searcher.service.MarketCommentService;
import com.food.searcher.service.MarketReplyService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping(value = "/market")
@Log4j

public class MarketReplyController {
	
	@Autowired
	private MarketReplyService marketReplyService;
	
	@Autowired MarketCommentService marketCommentService;
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping
	public ResponseEntity<Integer> createReply(@RequestBody MarketReplyVO marketReplyVO) {
		log.info("createReply()");
		log.info(marketReplyVO);
		
		int result = marketReplyService.createReply(marketReplyVO);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
						
	} // 댓글 등록
	
	
	@GetMapping("/all/{marketId}")
	public ResponseEntity<List<MarketReplyVO>> readAllReply(@PathVariable("marketId") int marketId, Model model){
		log.info("readAllReply()");
		log.info("marketId = " + marketId);
		
		List<MarketReplyVO> list = marketReplyService.getAllReply(marketId);
		model.addAttribute("list", list);
		
		log.info(list);
		
		 for (MarketReplyVO marketReply : list) {
		        List<MarketCommentVO> commentList = marketCommentService.getAllComment(marketReply.getMarketReplyId());
		        marketReply.setCommentList(commentList); // 댓글 객체에 대댓글 목록 설정
		        log.info("데이터 : " + commentList);
		        log.info(commentList.size());
		    }
		
		return new ResponseEntity<List<MarketReplyVO>>(list, HttpStatus.OK);
	} // 댓글 출력
	
	 @PutMapping("/{marketReplyId}") 
	   public ResponseEntity<Integer> updateReply(
	         @PathVariable("marketReplyId") int marketReplyId,
	         @RequestBody String marketReplyContent
	         ){
	      log.info("updateReply()");
	      log.info("marketReplyId = " + marketReplyId);
	      int result = marketReplyService.updateReply(marketReplyId, marketReplyContent);
	      log.info("수정 : " + result);
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 수정
	
	 @DeleteMapping("/{marketReplyId}/{marketId}") 
	   public ResponseEntity<Integer> deleteReply(
	         @PathVariable("marketReplyId") int marketReplyId, 
	         @PathVariable("marketId") int marketId) {
		 
	      log.info("deleteReply()");
	      log.info("marketReplyId = " + marketReplyId);
	      
	      int result = marketReplyService.deleteReply(marketReplyId, marketId);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 삭제
	 
	 @DeleteMapping("/deleteReplyByMarket/{marketId}") 
	   public ResponseEntity<Integer> deleteReplyByMarket(
	         @PathVariable("marketId") int marketId) {
	      log.info("deleteReplyByMarket()");
	      log.info("marketId = " + marketId);
	      
	      int result = marketReplyService.deleteReplyByMarket(marketId);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 삭제
	
}
