package com.food.searcher.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.LocalCommentVO;
import com.food.searcher.persistence.LocalMapper;
import com.food.searcher.service.LocalCommentService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/local")
@Log4j
public class LocalCommentController {
	
	@Autowired
	LocalCommentService localCommentService;
	
	@Transactional
	@ResponseBody
	@PostMapping("/commentAdd/{localId}")
	public int commentAddPOST(@PathVariable("localId") int localId, @RequestBody LocalCommentVO localCommentVO,
			Principal prrincipal)
			throws ServletException, IOException {
		log.info("replyAddPOST()");
		log.info(localCommentVO);
		String memberId = prrincipal.getName();
		int replyId = localCommentVO.getReplyId();
		String commentContent = localCommentVO.getCommentContent();
		return localCommentService.createComment(localId, replyId, memberId, commentContent);
		
	}
	
	@ResponseBody
	@GetMapping("/commentAll/{replyId}")
	public ResponseEntity<List<LocalCommentVO>> commentAllPUT(@PathVariable("replyId") int replyId) {
	    log.info("replyAllPUT()");
	    
	    List<LocalCommentVO> list = localCommentService.getAllComment(replyId);

	    return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@Transactional
	@PutMapping("/updateComment/{commentId}") // PUT : 댓글 수정
	   public ResponseEntity<Integer> updateComment(
	         @PathVariable("commentId") int commentId,
	         @RequestBody String commentContent
	         ){
	      log.info("updateComment()");
	      int result = localCommentService.updateComment(commentId, commentContent);
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   }
	
	@Transactional
	@PutMapping("/deleteComment/{localId}/{commentId}")
		public ResponseEntity<Integer> deleteComment(@PathVariable("localId") int localId,
				@PathVariable("commentId") int commentId){
		 log.info("deleteComment()");
	     log.info("commentId = " + commentId);
	     
	     int result = localCommentService.deleteComment(localId, commentId);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

}
