package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.food.searcher.domain.MarketReplyVO;
import com.food.searcher.service.MarketReplyService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping(value = "/market")
@Log4j

public class MarketReplyController {
	
	@Autowired
	private MarketReplyService replyService;

	@PostMapping
	public ResponseEntity<Integer> createReply(@RequestBody MarketReplyVO marketReplyVO) {
		log.info("createReply()");
		
		int result = replyService.createReply(marketReplyVO);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
						
	} // 댓글 등록
	
	@GetMapping("/all/{marketId}")
	public ResponseEntity<List<MarketReplyVO>> readAllReply(
			@PathVariable("marketId") int marketId){
		log.info("readAllReply()");
		log.info("marketId = " + marketId);
		
		List<MarketReplyVO> list = replyService.getAllReply(marketId);
		return new ResponseEntity<List<MarketReplyVO>>(list, HttpStatus.OK);
	} // 댓글 출력(선택)
	
	 @PutMapping("/{marketReplyId}") 
	   public ResponseEntity<Integer> updateReply(
	         @PathVariable("marketReplyId") int marketReplyId,
	         @RequestBody String marketReplyContent
	         ){
	      log.info("updateReply()");
	      log.info("marketReplyId = " + marketReplyId);
	      int result = replyService.updateReply(marketReplyId, marketReplyContent);
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 수정
	
	 @DeleteMapping("/{marketReplyId}/{marketId}") 
	   public ResponseEntity<Integer> deleteReply(
	         @PathVariable("marketReplyId") int marketReplyId, 
	         @PathVariable("marketId") int marketId) {
	      log.info("deleteReply()");
	      log.info("marketReplyId = " + marketReplyId);
	      
	      int result = replyService.deleteReply(marketReplyId, marketId);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   } // 댓글 삭제
	
}