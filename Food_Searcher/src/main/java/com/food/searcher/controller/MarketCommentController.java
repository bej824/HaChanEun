package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
import com.food.searcher.service.MarketCommentService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping(value = "/market")
@Log4j

public class MarketCommentController {
	
	@Autowired
	private MarketCommentService marketCommentService;

	@PostMapping("/commentadd/{marketReplyId}")
	public ResponseEntity<Integer> createReply(@RequestBody MarketCommentVO marketCommentVO) {
		log.info("createComment()");
		log.info(marketCommentVO);
		
		int result = marketCommentService.createComment(marketCommentVO);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);

	} // 대댓 등록
	
	@GetMapping("/commentall/{marketReplyId}")	
	public ResponseEntity<List<MarketCommentVO>> readAllComment(@PathVariable("marketReplyId") int marketReplyId){
		log.info("readAllComment()");
		log.info("marketReplyId = " + marketReplyId);
		
		
		List<MarketCommentVO> list = marketCommentService.getAllComment(marketReplyId);
		return new ResponseEntity<List<MarketCommentVO>>(list, HttpStatus.OK);
	} // 대댓글 출력
	
	// 대댓글 수정, 삭제 메모장에 있음.
	
	@PutMapping("/commentmodify/{marketCommentId}")
	public ResponseEntity<Integer> updateComment(@PathVariable("marketCommentId") int marketCommentId,
			@RequestBody String marketCommentContent) {
		log.info("updateComment()");
		log.info("marketCommentId = " + marketCommentId);
		int result = marketCommentService.updateComment(marketCommentId, marketCommentContent);
		log.info("수정 : " + result);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	} // 대댓글 수정

	@DeleteMapping("/commentdelete/{marketCommentId}/{marketReplyId}")
	public ResponseEntity<Integer> deleteReply(@PathVariable("marketCommentId") int marketCommentId,
			@PathVariable("marketReplyId") int marketReplyId) {
		log.info("deleteComment()");
		log.info("marketCommentId = " + marketCommentId);

		int result = marketCommentService.deleteComment(marketCommentId, marketReplyId);

		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	} // 대댓글 삭제


} // end MarketCommentController
