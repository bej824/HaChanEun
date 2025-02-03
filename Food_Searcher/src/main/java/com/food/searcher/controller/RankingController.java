package com.food.searcher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.persistence.RecipeLikesMapper;
import com.food.searcher.service.RecipeService;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class RankingController {
	
	@Autowired
	private RecipeLikesMapper recipeLikesMapper;
	
	@Autowired
	private RecipeService recipeService;
	
	@GetMapping("/ranking")
	public void main(Model model, Pagination pagination) {
		List<RecipeLikesVO> likeList = recipeLikesMapper.selectAll();
		List<RecipeVO> recipeList = recipeService.getAllBoards();
		model.addAttribute("recipeList", recipeList);
		model.addAttribute("likeList", likeList);
	}
}
