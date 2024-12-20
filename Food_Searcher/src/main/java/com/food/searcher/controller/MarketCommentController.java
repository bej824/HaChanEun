package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.MarketCommentVO;
import com.food.searcher.domain.MarketReplyVO;
import com.food.searcher.service.MarketCommentService;
import com.food.searcher.service.MarketReplyService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value="/market/detail")
@Log4j

public class MarketCommentController {
	
	@Autowired
	private MarketReplyService marketReplyService;
	
	@Autowired
	private MarketCommentService marketCommentService;
	
	@PostMapping
	public ResponseEntity<Integer> createComment(@RequestBody MarketCommentVO marketCommentVO) {
		log.info("createComment()");
		log.info(marketCommentVO);
		
		int result = marketCommentService.createComment(marketCommentVO);
		
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@GetMapping("/comment")
	public void commentGET(Model model, Integer marketReplyId) {
		log.info(marketReplyId);
		log.info("commentGET()");
		MarketReplyVO marketReplyVO = marketReplyService.getReplyById(marketReplyId);
		log.info(marketReplyVO);
		model.addAttribute("marketReplyVO", marketReplyVO);
	}
	
	@GetMapping("/all/{replyId}") // GET : 댓글 선택(all)
	public ResponseEntity<List<MarketCommentVO>> readAllReply(
			@PathVariable("marketReplyId") int marketReplyId) { 
		// @PathVariable("boardId") : {boardId} 값을 설정된 변수에 저장
		log.info("readAllReply");
		log.info("marketReplyId = " + marketReplyId);

		List<MarketCommentVO> list = marketCommentService.getAllComment(marketReplyId);
		log.info(list);
		// ResponseEntity<T> : T의 타입은 프론트 side로 전송될 데이터의 타입으로 선언
		return new ResponseEntity<List<MarketCommentVO>>(list, HttpStatus.OK);
	}
	
	
}
