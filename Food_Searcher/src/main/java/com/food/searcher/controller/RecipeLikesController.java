package com.food.searcher.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.service.RecipeLikesService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping(value = "/likes")
@Log4j
public class RecipeLikesController {
	
	@Autowired
	private RecipeLikesService likesService;
	
	@PostMapping
	public ResponseEntity<Integer> createLikes(@RequestBody RecipeLikesVO recipeLikesVO){
		log.info("createLikes()");
		return new ResponseEntity<Integer>(likesService.createLike(recipeLikesVO), HttpStatus.OK);
	}
	
	@PutMapping("/{boardId}")
	public ResponseEntity<Integer> updateLikes(@PathVariable("boardId") int boardId, @RequestBody RecipeLikesVO recipeLikesVO){
		log.info("updateLikes()");
		return new ResponseEntity<Integer>(likesService.updateLike(recipeLikesVO), HttpStatus.OK);
	}
}
