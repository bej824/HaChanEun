package com.food.searcher.persistence;

import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.food.searcher.config.RootConfig;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.RecipeVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class RecipeMapperTest {
	
	@Autowired RecipeMapper recipeMapper;
	
	@Autowired DirectOrderMapper directOrderMapper;
	
	@org.junit.Test
	public void Test() {
//		insertRecipe();
		insertOrder();
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
	
	private void insertOrder() {
		DirectOrderVO directOrderVO = new DirectOrderVO();
		directOrderVO.setMemberId("future");
		directOrderVO.setTotalPrice(4000);
		directOrderVO.setDeliveryAddress("주소");
		log.info(directOrderVO);
//		int result = directOrderMapper.insert(directOrderVO);
//		log.info(result);
	}

}
