package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.service.RecipeCommentService;
import com.food.searcher.service.RecipeReplyService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value="/recipe/detail")
@Log4j
public class RecipeCommentController {
	
	@Autowired
	private RecipeReplyService replyService;
	
	@Autowired
	private RecipeCommentService recipeCommentService;

	@PostMapping("/comment")
	public ResponseEntity<Integer> createComment(@RequestBody RecipeCommentVO recipeCommentVO) {
		log.info("createComment()");
		log.info(recipeCommentVO);
		
		int result = recipeCommentService.createComment(recipeCommentVO);
		
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@GetMapping("/comment")
	public void commentGET(Model model, Integer replyId) {
		log.info(replyId);
		log.info("commentGET()");
		RecipeReplyVO recipeReplyVO = replyService.getReplyById(replyId);
		log.info(recipeReplyVO);
		model.addAttribute("replyVO", recipeReplyVO);
	}
	
	@GetMapping("/all/{replyId}") // GET : 댓글 선택(all)
	public ResponseEntity<List<RecipeCommentVO>> readAllReply(
			@PathVariable("replyId") int replyId, Model model) { 
		// @PathVariable("boardId") : {boardId} 값을 설정된 변수에 저장
		log.info("readAllReply");
		log.info("replyId = " + replyId);
		
		RecipeReplyVO recipeReplyVO = replyService.getReplyById(replyId);
		log.info("recipeReplyVO = " + recipeReplyVO);

		model.addAttribute("recipeReplyVO", recipeReplyVO);
		List<RecipeCommentVO> list = recipeCommentService.getAllComment(replyId);
		log.info(list);
		// ResponseEntity<T> : T의 타입은 프론트 side로 전송될 데이터의 타입으로 선언
		return new ResponseEntity<List<RecipeCommentVO>>(list, HttpStatus.OK);
	}
	
	   @PutMapping("/comment/{recipeCommentId}") // PUT : 댓글 수정
	   public ResponseEntity<Integer> updateReply(
	         @PathVariable("recipeCommentId") int recipeCommentId,
	         @RequestBody String commentContent
	         ){
	      log.info("updateCommentReply()");
	      log.info("recipeCommentId = " + recipeCommentId);
	      log.info("commentContent = " + commentContent);
	      int result = recipeCommentService.updateComment(recipeCommentId, commentContent);
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   }
	
	   @DeleteMapping("/comment/{recipeCommentId}/{recipereplyId}") // DELETE : 댓글 삭제
	   public ResponseEntity<Integer> deleteComment(
	         @PathVariable("recipeCommentId") int recipeCommentId, 
	         @PathVariable("recipereplyId") int recipereplyId) {
	      log.info("deleteReply()");
	      log.info("recipeCommentId = " + recipeCommentId);
	      
	      int result = recipeCommentService.deleteComment(recipeCommentId, recipereplyId);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   }
}
