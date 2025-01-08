package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.RecipeCommentVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeServiceImple implements RecipeService{
	
	@Autowired
	private RecipeMapper recipeMapper;
	
	@Autowired
	private RecipeReplyService recipeReplyService;
	
	@Autowired
	private RecipeCommentService recipeCommentService;
	
	@Override
	public int createBoard(RecipeVO recipeVO) {
		log.info("createBoard()");
		int result = recipeMapper.insert(recipeVO);
		return result;
	}

	@Override
	public List<RecipeVO> getAllBoards() {
		log.info("getAllBoards()");
		return recipeMapper.selectList();
	}

	@Override
	public RecipeVO getBoardById(int recipeId) {
		log.info("getBoardById()");
		log.info(recipeId);
		return recipeMapper.selectOne(recipeId);
	}

	@Override
	public int updateBoard(RecipeVO recipeVO) {
		log.info("updateBoard()");
		log.info(recipeVO);
		return recipeMapper.update(recipeVO);
	}

	@Override
	public int deleteBoard(int recipeId) {
		log.info("deleteBoard()");
	      List<RecipeReplyVO> replyList = recipeReplyService.getAllReply(recipeId);
	      log.info("댓글 목록 : " + replyList);
	      for(RecipeReplyVO reVO : replyList) {
	    	  List<RecipeCommentVO> commentList = recipeCommentService.getAllComment(reVO.getReplyId());
	    	  log.info("대댓글 목록 : " + commentList);
	    	  for(RecipeCommentVO coVO : commentList) {
	    		  int result = recipeCommentService.deleteComment(coVO.getRecipeCommentId(), coVO.getRecipeReplyId());
	    		  log.info(coVO);
	    		  log.info(result + "행 대댓글 삭제");
	    	  }
	    	  log.info(reVO);
	    	  int result = recipeReplyService.deleteReply(reVO.getReplyId(), reVO.getBoardId());
	    	  log.info(result + "행 댓글 삭제");
	      }
		return recipeMapper.delete(recipeId);
	}

	@Override
	public List<RecipeVO> getPagingBoards(String recipeTitle, String filterBy, Pagination pagination) {
		log.info("getPagingBoards(ss)");
		pagination.setKeyword(recipeTitle);
		log.info(pagination);
		if(recipeTitle == null) {
			return recipeMapper.selectListByPagination(recipeTitle, filterBy, pagination);			
		} else {
			return recipeMapper.selectListByPagination(pagination);
		}
	}

	@Override
	public int getTotalCount(String recipeTitle, String filterBy) {
		log.info("getTotalCount()");
		if (filterBy == null) {
			log.info("null : " + filterBy);
			log.info("null : " + recipeTitle);
			return recipeMapper.selectTotalCount();
		}
		else if(filterBy.equals("RECIPE_TITLE")) {
			log.info("RECIPE_TITLE : " + filterBy);
			return recipeMapper.titleTotalCount(recipeTitle);
		} else if(filterBy.equals("RECIPE_FOOD")) {
			log.info("RECIPE_FOOD : " + filterBy);
			return recipeMapper.titleTotalCount(recipeTitle);
		} else if(filterBy.equals("RECIPE_CONTENT")) {
			log.info("RECIPE_CONTENT" + filterBy);
			return recipeMapper.contentTotalCount(recipeTitle);
		} else if(filterBy.equals("MEMBER_ID")) {
			log.info("MEMBER_ID" + filterBy);
			return recipeMapper.memberTotalCount(recipeTitle);
		} else {
			log.info("else : " + filterBy);
			log.info("else : " + recipeTitle);
			return recipeMapper.selectTotalCount();
		}
	}

	@Override
	public int getTitleTotalCount(String recipeTitle) {
		log.info("getTitleTotalCount()");
		if(recipeTitle != null) {			
			return recipeMapper.titleTotalCount(recipeTitle);
		} else {
			return recipeMapper.selectTotalCount();
		}
	}

	@Override
	public List<RecipeVO> getPagingBoards(Pagination pagination) {
		log.info("getPagingBoards()");
		log.info(pagination);
		if(pagination.getType() == null) {
			log.info("null : " + pagination.getType());
			return recipeMapper.selectListByPagination(pagination);			
		}
		else if(pagination.getType().equals("RECIPE_TITLE")){
			log.info("RECIPE_TITLE : " + pagination.getType());
			return recipeMapper.selectTitleByPagination(pagination.getKeyword(), pagination);
		} else if(pagination.getType().equals("RECIPE_FOOD")) {
			log.info("RECIPE_FOOD : " + pagination.getType());
			return recipeMapper.selectFoodByPagination(pagination.getKeyword(), pagination);
		} else if(pagination.getType().equals("RECIPE_CONTENT")) {
			log.info("RECIPE_CONTENT : " + pagination.getType());
			return recipeMapper.selectContentByPagination(pagination.getKeyword(), pagination);
		} else if(pagination.getType().equals("MEMBER_ID")) {
			log.info("MEMBER_ID : " + pagination.getType());
			return recipeMapper.selectMemberByPagination(pagination.getKeyword(), pagination);
		} else {
			return recipeMapper.selectListByPagination(pagination);
		}
	}

	@Override
	public List<RecipeVO> getTitleByPagination(Pagination pagination, String recipeTitle) {
		// TODO Auto-generated method stub
		return null;
	}

}
