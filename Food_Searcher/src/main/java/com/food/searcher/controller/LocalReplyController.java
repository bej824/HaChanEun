package com.food.searcher.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.food.searcher.domain.HeaderReplyVO;
import com.food.searcher.domain.LocalReplyVO;
import com.food.searcher.service.LocalReplyService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/local")
@Log4j
public class LocalReplyController {
	
	@Autowired
	LocalReplyService localReplyService;
	
	@Transactional
	@ResponseBody
	@PostMapping("/replyAdd")
	public int replyAddPOST(@RequestBody HeaderReplyVO headerReplyVO,
			Principal principal)
			throws ServletException, IOException {
		log.info("replyAddPOST()");
		String memberId = principal.getName();
		int localId = headerReplyVO.getLocalId();
		String replyContent = headerReplyVO.getHeaderReplyContent();
		
		return localReplyService.createReply(localId, memberId, replyContent);
		
	}
	
	@ResponseBody
	@GetMapping("/replyAll/{localId}")
	public List<LocalReplyVO> replyAllGET(@PathVariable("localId") int localId) {
		log.info("replyAllGET()");
		
		List<LocalReplyVO> list = localReplyService.getAllReply(localId);
		log.info(list);
		
		return list;
	}
	
	@Transactional
	@PutMapping("/updateReply/{replyId}") // PUT : 댓글 수정
	   public ResponseEntity<Integer> updateReply(
	         @PathVariable("replyId") int replyId,
	         @RequestBody String replyContent
	         ){
	      log.info("updateReply()");
	      int result = localReplyService.updateReply(replyId, replyContent);
	      return new ResponseEntity<Integer>(result, HttpStatus.OK);
	   }
	
	@Transactional
	@PutMapping("/deleteReply/{localId}/{replyId}")
		public ResponseEntity<Integer> deleteReply(
				@PathVariable("localId") int localId,
				@PathVariable("replyId") int replyId){
		 log.info("updateReply()");

	     int result = localReplyService.deleteReply(localId, replyId);
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

}
