package com.food.searcher.controller;

import java.security.Principal;
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

import com.food.searcher.domain.AnswerVO;
import com.food.searcher.service.AnswerService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/product")
@Log4j
public class AnswerController {
	
	@Autowired
	private AnswerService answerService;
	
	@GetMapping("/answer/{askId}")	
	public ResponseEntity<List<AnswerVO>> answerGET (@PathVariable("askId") long askId){
		return new ResponseEntity<List<AnswerVO>>(answerService.getAnswer(askId), HttpStatus.OK);
	}
	
	@PostMapping("/answer-post/{askId}")
	public ResponseEntity<String> answerPOST(@PathVariable("askId") long askId, @RequestBody AnswerVO answerVO, Principal principal) {
		
		 String memberId = principal.getName();
		 answerVO.setMemberId(memberId); 
		 
		int result = answerService.createAnswer(answerVO);
		
		if(result == 1) {
            return ResponseEntity.ok("답변 등록 완료");
		} else if(result == 2) {		
			return ResponseEntity.badRequest().body("답변은 문의당 한 번만 작성 가능합니다.");
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("답변 등록 중 오류 발생");
		}	
		
	} // 대댓 등록
	
	@PutMapping("/answer-modify/{answerId}")
	public ResponseEntity<Integer> updateAnswer(@PathVariable("answerId") long answerId,
												@RequestBody String answerContent) {
		
		return new ResponseEntity<Integer>(answerService.updateAnswer(answerId, answerContent), HttpStatus.OK);
	}
	
	@DeleteMapping("/answer-delete/{answerId}")
	public ResponseEntity<Integer> deleteAnswer(@PathVariable("answerId") long answerId) {

		int result = answerService.deleteAnswer(answerId);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	} // 대댓글 삭제
	
}

	
