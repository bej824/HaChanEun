package com.food.searcher.persistence;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.food.searcher.config.RootConfig;
import com.food.searcher.domain.RecipeCommentVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {RootConfig.class})
@Log4j
public class RecipeCommentMapperTest {

	@Autowired RecipeCommentMapper recipeCommentMapper;
	
	@Test
	public void Test() {
		testBoardUpdate();
	}

	private void testBoardUpdate() {
		RecipeCommentVO recipeCommentVO = new RecipeCommentVO(8, 6, "test", "수정", null);
		int result = recipeCommentMapper.update(recipeCommentVO);
		log.info(result);
	}
}
