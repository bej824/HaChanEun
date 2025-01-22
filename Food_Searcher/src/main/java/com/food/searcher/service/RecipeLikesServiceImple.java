package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.persistence.RecipeLikesMapper;
import com.food.searcher.persistence.RecipeMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeLikesServiceImple implements RecipeLikesService{
	
	@Autowired
	private RecipeLikesMapper likesMapper;
	
	@Autowired
	private RecipeMapper recipeMapper;

	@Transactional(value = "transactionManager")
	@Override
	public int createLike(RecipeLikesVO recipeLikesVO) {
		log.info("createLike()");
		log.info("recipeLikesVO : " + recipeLikesVO);
		int result = likesMapper.insert(recipeLikesVO);
		log.info(result + "행 추가");
		if(recipeLikesVO.getMemberLike() == 1) {
		int updateResult = recipeMapper.updateLikesCount(recipeLikesVO.getRecipeBoardId(), 1);
		log.info(updateResult + "행 좋아요 카운트 증가");
		} else if(recipeLikesVO.getMemberLike() == 2) {
			int updateResult = recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeBoardId(), 1);
			log.info(updateResult + "행 싫어요 카운트 증가");
		}
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
		log.info("impleLikes : " + recipeLikesVO);
		
		int previousLikeStatus = recipeLikesVO.getPreviousMemberLike();
		log.info("previousLikeStatus : " + previousLikeStatus);
		int result = likesMapper.update(recipeLikesVO);
		log.info(result + "행 업데이트 완료");
		if(recipeLikesVO.getMemberLike() == 0) {
		log.info("0 : " + recipeLikesVO.getMemberLike());
		if(previousLikeStatus == 1) {
		int updateResult = recipeMapper.updateLikesCount(recipeLikesVO.getRecipeBoardId(), -1);
		log.info(updateResult + "행 좋아요 카운트 감소");
		} else if(previousLikeStatus == 2) {
			int updateResult = recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeBoardId(), -1);
			log.info(updateResult + "행 싫어요 카운트 감소");
		}
		} else if(recipeLikesVO.getMemberLike() == 1) {
			log.info("1 : " + recipeLikesVO.getMemberLike());
			if(previousLikeStatus == 2) {
				int updateResult = recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeBoardId(), -1);
				log.info(updateResult + "행 싫어요 카운트 감소");
			}
			int updateResult = recipeMapper.updateLikesCount(recipeLikesVO.getRecipeBoardId(), 1);
			log.info(updateResult + "행 좋아요 카운트 증가");
		} else if(recipeLikesVO.getMemberLike() == 2) {
			log.info("2 : " + recipeLikesVO.getMemberLike());
			if(previousLikeStatus == 1) {
				int updateResult = recipeMapper.updateLikesCount(recipeLikesVO.getRecipeBoardId(), -1);
				log.info(updateResult + "행 좋아요 카운트 감소");
			}
			int updateResult = recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeBoardId(), 1);
			log.info(updateResult + "행 싫어요 카운트 증가");
		}
		return result;
	}

}
