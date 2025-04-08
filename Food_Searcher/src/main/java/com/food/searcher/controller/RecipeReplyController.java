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

@RestController
@RequestMapping(value = "/recipe")
@Log4j
public class RecipeReplyController {
	@Autowired
	private RecipeReplyService replyService;

	@Autowired
	private RecipeCommentService recipeCommentService;

	@PostMapping // POST : 댓글 입력
	public ResponseEntity<Integer> createReply(@RequestBody RecipeReplyVO replyVO, HttpSession session) {
		return new ResponseEntity<Integer>(replyService.createReply(replyVO), HttpStatus.OK);
	}

	@GetMapping("/all/{boardId}") // GET : 댓글 선택(all)
	public ResponseEntity<List<RecipeReplyVO>> readAllReply(@PathVariable("boardId") int boardId) {
		// @PathVariable("boardId") : {boardId} 값을 설정된 변수에 저장
		List<RecipeReplyVO> list = replyService.getAllReply(boardId);

		for (RecipeReplyVO reply : list) {
			List<RecipeCommentVO> comments = recipeCommentService.getAllComment(reply.getReplyId());
			reply.setComments(comments); // 댓글 객체에 대댓글 목록 설정
		}

		// ResponseEntity<T> : T의 타입은 프론트 side로 전송될 데이터의 타입으로 선언
		return new ResponseEntity<List<RecipeReplyVO>>(list, HttpStatus.OK);
	}

	@PutMapping("/{replyId}") // PUT : 댓글 수정
	public ResponseEntity<Integer> updateReply(@PathVariable("replyId") int replyId, @RequestBody String replyContent) {
		return new ResponseEntity<Integer>(replyService.updateReply(replyId, replyContent), HttpStatus.OK);
	}

	@DeleteMapping("/{replyId}/{boardId}") // DELETE : 댓글 삭제
	public ResponseEntity<Integer> deleteReply(@PathVariable("replyId") int replyId,
			@PathVariable("boardId") int boardId) {

		return new ResponseEntity<Integer>(replyService.deleteReply(replyId, boardId), HttpStatus.OK);
	}

}
