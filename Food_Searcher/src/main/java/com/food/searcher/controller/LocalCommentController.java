package com.food.searcher.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.LocalCommentVO;
import com.food.searcher.service.LocalCommentService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/local")
@Log4j
public class LocalCommentController {
	
	@Autowired
	LocalCommentService localCommentService;
	
	@ResponseBody
	@PostMapping("/commentAdd")
	public int commentAddPOST(@RequestBody LocalCommentVO localCommentVO,
			HttpSession session)
			throws ServletException, IOException {
		log.info("replyAddPOST()");
		log.info(localCommentVO);
		String memberId = (String) session.getAttribute("memberId");
		int replyId = localCommentVO.getReplyId();
		String commentContent = localCommentVO.getCommentContent();
		
		return localCommentService.createComment(replyId, memberId, commentContent);
		
	}
	
	@ResponseBody
	@PutMapping("/commentAll/{replyId}")
	public ResponseEntity<List<LocalCommentVO>> commentAllPUT(@PathVariable("replyId") int replyId) {
	    log.info("replyAllPUT()");
	    
	    List<LocalCommentVO> list = localCommentService.getAllComment(replyId);

	    return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@PutMapping("/updateComment/{commentId}") // PUT : 댓글 수정
	   public ResponseEntity<Integer> updateComment(
	         @PathVariable("commentId") int commentId,
	         @RequestBody String commentContent
	         ){
	      log.info("updateComment()");
	      log.info("commentId = " + commentId);
	      int result = localCommentService.updateComment(commentId, commentContent);
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   }
	
	@PutMapping("/deleteComment/{replyId}")
		public ResponseEntity<Integer> deleteComment(@PathVariable("commentId") int commentId){
		 log.info("deleteComment()");
	     log.info("commentId = " + commentId);
	     
	     int result = localCommentService.deleteComment(commentId);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

}
