package com.food.searcher.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.persistence.RecipeLikesMapper;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeLikesServiceImple implements RecipeLikesService {

	@Autowired
	private RecipeLikesMapper likesMapper;

	@Autowired
	private RecipeMapper recipeMapper;

	@Transactional(value = "transactionManager")
	@Override
	public int createLike(RecipeLikesVO recipeLikesVO) {
		int result = likesMapper.insert(recipeLikesVO);
		if (recipeLikesVO.getMemberLike() == 1) {
			recipeMapper.updateLikesCount(recipeLikesVO.getRecipeId(), 1);
		} else if (recipeLikesVO.getMemberLike() == 2) {
			recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeId(), 1);
		}
		return result;
	}

	@Override
	public RecipeLikesVO getMemberLikes(int recipeId, String memberId) {
		return likesMapper.selectMemberLikes(recipeId, memberId);
	}

	@Override
	public int updateLike(RecipeLikesVO recipeLikesVO) {

		int previousLikeStatus = recipeLikesVO.getPreviousMemberLike();
		int result = likesMapper.update(recipeLikesVO);
		if (recipeLikesVO.getMemberLike() == 0) {
			if (previousLikeStatus == 1) {
				recipeMapper.updateLikesCount(recipeLikesVO.getRecipeId(), -1);
			} else if (previousLikeStatus == 2) {
				recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeId(), -1);
			}
		} else if (recipeLikesVO.getMemberLike() == 1) {
			if (previousLikeStatus == 2) {
				recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeId(), -1);
			}
			recipeMapper.updateLikesCount(recipeLikesVO.getRecipeId(), 1);
		} else if (recipeLikesVO.getMemberLike() == 2) {
			if (previousLikeStatus == 1) {
				recipeMapper.updateLikesCount(recipeLikesVO.getRecipeId(), -1);
			}
			recipeMapper.updateDislikesCount(recipeLikesVO.getRecipeId(), 1);
		}
		return result;
	}

	@Override
	public List<RecipeLikesVO> getSelectAll() {
		return likesMapper.selectAll();
	}

	@Override
	public List<RecipeLikesVO> getPagingBoards(Pagination pagination) {
		return likesMapper.selectListByPagination(pagination).stream().collect(Collectors.toList());
	}

}
