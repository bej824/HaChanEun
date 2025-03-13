package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.persistence.RecipeViewMapper;

public class RecipeViewServiceImple implements RecipeViewService{

	@Autowired
	private RecipeViewMapper recipeViewMapper;
	
	@Transactional
	@Override
	public int RecipeViewCount() {
		recipeViewMapper.updateViews();
		recipeViewMapper.insertViews();
		recipeViewMapper.updateCategoryViews();
		recipeViewMapper.insertCategoryViews();
		recipeViewMapper.delete();
		return 1;
	}

}
