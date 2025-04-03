package com.food.searcher.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.RecipeLikesService;
import com.food.searcher.service.RecipeService;
import com.food.searcher.service.UtilityService;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class RankingController {
	
	@Autowired
	private RecipeLikesService recipeLikesService;
	
	@Autowired
	private RecipeService recipeService;
	
	@Autowired
	private UtilityService utilityService;
	
	@GetMapping("/ranking")
	public void main(Model model, Pagination pagination) {
		log.info(pagination);
		List<RecipeLikesVO> likeList = recipeLikesService.getPagingBoards(pagination);
		List<RecipeVO> recipeList = new ArrayList<RecipeVO>();
		for(RecipeLikesVO like : likeList) {
			RecipeVO recipeVO = recipeService.getBoardById(like.getRecipeId(), utilityService.loginMember());
			recipeList.add(recipeVO);
		}
		model.addAttribute("type", pagination.getType());
		model.addAttribute("keyword", pagination.getKeyword());
		model.addAttribute("recipeList", recipeList);
		model.addAttribute("likeList", likeList);
	}
}
