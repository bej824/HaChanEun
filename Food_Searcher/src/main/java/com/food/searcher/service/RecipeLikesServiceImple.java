package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.persistence.RecipeLikesMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeLikesServiceImple implements RecipeLikesService{
	
	@Autowired
	private RecipeLikesMapper likesMapper;

	@Override
	public int createLike(RecipeLikesVO recipeLikesVO) {
		log.info("createLike()");
		int result = likesMapper.insert(recipeLikesVO);
		log.info(recipeLikesVO + "행 추가");
		return result;
	}

	@Override
	public RecipeLikesVO getMemberLikes(int recipeId, String memberId) {
		log.info("getMemberLikes()");
		return likesMapper.selectMemberLikes(recipeId, memberId);
	}

	@Override
	public int updateLike(RecipeLikesVO recipeLikesVO) {
		log.info("updateLike()");
		int result = likesMapper.update(recipeLikesVO);
		return result;
	}

}
