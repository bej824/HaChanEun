package com.food.searcher.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

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

import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.service.RecipeCommentService;
import com.food.searcher.service.RecipeReplyService;

import lombok.extern.log4j.Log4j;

// * RESTful url과 의미
// /reply (POST) : 댓글 추가(insert)
// /reply/all/숫자 (GET) : 해당 글 번호(baordId)의 모든 댓글 검색(select)
// /reply/숫자 (PUT) : 해당 댓글 번호(replyId)의 내용을 수정(update)
// /reply/숫자 (DELETE) : 해당 댓글 번호(replyId)의 내용을 삭제(delete)

@RestController
@RequestMapping(value = "/recipe")
@Log4j
public class ReplyRESTController {
	@Autowired
	private RecipeReplyService replyService;
	
	@Autowired
	private RecipeCommentService recipeCommentService;

	@PostMapping // POST : 댓글 입력
	public ResponseEntity<Integer> createReply(@RequestBody RecipeReplyVO replyVO, HttpSession session) {
		log.info("createReply()");
		log.info(replyVO);
		
		int result = replyService.createReply(replyVO);
		
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@GetMapping("/all/{boardId}") // GET : 댓글 선택(all)
	public ResponseEntity<List<RecipeReplyVO>> readAllReply(
			@PathVariable("boardId") int boardId) { 
		// @PathVariable("boardId") : {boardId} 값을 설정된 변수에 저장
		log.info("readAllReply");
		log.info("boardId = " + boardId);

		List<RecipeReplyVO> list = replyService.getAllReply(boardId);
		log.info(list);
		
	    for (RecipeReplyVO reply : list) {
	        List<RecipeCommentVO> comments = recipeCommentService.getAllComment(reply.getReplyId());
	        reply.setComments(comments); // 댓글 객체에 대댓글 목록 설정
	    }
	    
		// ResponseEntity<T> : T의 타입은 프론트 side로 전송될 데이터의 타입으로 선언
		return new ResponseEntity<List<RecipeReplyVO>>(list, HttpStatus.OK);
	}
	
	   @PutMapping("/{replyId}") // PUT : 댓글 수정
	   public ResponseEntity<Integer> updateReply(
	         @PathVariable("replyId") int replyId,
	         @RequestBody String replyContent
	         ){
	      log.info("updateReply()");
	      log.info("replyId = " + replyId);
	      int result = replyService.updateReply(replyId, replyContent);
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   }
	   
	   @DeleteMapping("/{replyId}/{boardId}") // DELETE : 댓글 삭제
	   public ResponseEntity<Integer> deleteReply(
	         @PathVariable("replyId") int replyId, 
	         @PathVariable("boardId") int boardId) {
	      log.info("deleteReply()");
	      log.info("replyId = " + replyId);
	      
	      List<RecipeCommentVO> list = recipeCommentService.getAllComment(replyId);
	      log.info(list);
	      
	      for(RecipeCommentVO vo : list) {
	    	  int commentresult = recipeCommentService.deleteComment(vo.getRecipeCommentId(), vo.getRecipeReplyId());
	    	  log.info(commentresult);
	      }
	      int result = replyService.deleteReply(replyId, boardId);
	      log.info(result);
	      
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   }
	   
	   @PutMapping("/comment/{recipeCommentId}") // PUT : 댓글 수정
	   public ResponseEntity<Integer> updatecommentReply(
	         @PathVariable("recipeCommentId") int recipeCommentId,
	         @RequestBody String commentContent
	         ){
	      log.info("updateCommentReply()");
	      log.info("recipeCommentId = " + recipeCommentId);
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

