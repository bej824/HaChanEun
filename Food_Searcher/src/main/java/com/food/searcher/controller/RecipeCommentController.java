package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.ReplyVO;
import com.food.searcher.service.RecipeCommentService;
import com.food.searcher.service.ReplyService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping(value="/recipe/list")
@Log4j
public class RecipeCommentController {
	
	@Autowired
	private ReplyService replyService;
	
	@Autowired
	private RecipeCommentService recipeCommentService;
	
	@PostMapping
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
		ReplyVO replyVO = replyService.getReplyById(replyId);
		log.info(replyVO);
		model.addAttribute("replyVO", replyVO);
	}
	
}
