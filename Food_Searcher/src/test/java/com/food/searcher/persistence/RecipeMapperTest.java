package com.food.searcher.persistence;

import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.food.searcher.config.RootConfig;
import com.food.searcher.domain.RecipeVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class RecipeMapperTest {
	
	@Autowired RecipeMapper recipeMapper;
	
	@org.junit.Test
	public void Test() {
		insertRecipe();
	}

	private void insertRecipe() {
		RecipeVO recipeVO = new RecipeVO();
		recipeVO.setRecipeId(1);
		recipeVO.setRecipeTitle("도전 계란말이");
		recipeVO.setRecipeFood("계란말이");
		recipeVO.setRecipeContent("계란");
		recipeVO.setMemberId("초보요리사");
		int result = recipeMapper.insert(recipeVO);
		log.info(result);
		
	}

}
