package com.food.searcher.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.persistence.AttachMapper;
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
	private AttachMapper attachMapper;
	
	@Transactional(value = "transactionManager") 
	@Override
	public int createBoard(RecipeVO recipeVO) {
		log.info("createBoard()");
		log.info(recipeVO);
		int result = recipeMapper.insert(recipeVO);
		log.info(result + "행 게시글 등록");
		
		List<AttachVO> attachList = recipeVO.getAttachList();
		log.info(attachList);
		
		int insertAttachResult = 0;
		for(AttachVO attachVO : attachList) {
			insertAttachResult += attachMapper.insert(attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		return result;
	}

	@Override
	public List<RecipeVO> getAllBoards() {
		log.info("getAllBoards()");
		List<RecipeVO> list = recipeMapper.selectList();
		log.info("list : " + list);
		return list.stream().collect(Collectors.toList());
	}

	@Override
	public RecipeVO getBoardById(int recipeId) {
		log.info("getBoardById()");
		log.info("recipeId : " + recipeId);
		RecipeVO recipeVO = recipeMapper.selectOne(recipeId);
		log.info("recipeVO : " + recipeVO);
		List<AttachVO> list = attachMapper.selectByBoardId(recipeId);
		log.info("list" + list);
		
		List<AttachVO> attachList = list.stream().collect(Collectors.toList());
		log.info("attachList : " + attachList);
		recipeVO.setAttachList(attachList);
		log.info("attachList 추가 recipeVO : " + recipeVO);
		return recipeVO;
	}

	@Transactional(value = "transactionManager")
	@Override
	public int updateBoard(RecipeVO recipeVO) {
		log.info("updateBoard()");
		log.info(recipeVO);
		log.info(attachMapper.selectByBoardId(recipeVO.getRecipeId()));
		int updateBoardResult = recipeMapper.update(recipeVO);
		log.info(updateBoardResult + "행 게시글 정보 수정");
		List<AttachVO> attachList = recipeVO.getAttachList();
		log.info("attachList" + attachList);

		int deleteAttachResult = attachMapper.delete(recipeVO.getRecipeId());
		log.info(deleteAttachResult + "행 파일 정보 삭제");
		
		int insertAttachResult = 0;
		for(AttachVO attachVO : attachList) {
			attachVO.setBoardId(recipeVO.getRecipeId()); // 게시글 번호 적용
			insertAttachResult += attachMapper.insert(attachVO);
			log.info("attachVO" + attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		return updateBoardResult;
	}

	@Transactional(value = "transactionManager")
	@Override
	public int deleteBoard(int recipeId) {
		log.info("deleteBoard()");
	      List<RecipeReplyVO> replyList = recipeReplyService.getAllReply(recipeId);
	      int deleteAttachResult = attachMapper.delete(recipeId);
	      log.info(deleteAttachResult + "행 파일 정보 삭제");
	      log.info("댓글 목록 : " + replyList);
	      for(RecipeReplyVO reVO : replyList) {
	    	  log.info(reVO);
	    	  int result = recipeReplyService.deleteReply(reVO.getReplyId(), reVO.getBoardId());
	    	  log.info(result + "행 댓글 삭제");
	      }
		return recipeMapper.delete(recipeId);
	}

	@Override
	public int getTotalCount(Pagination pagination) {
		log.info("getTotalCount()");
		return recipeMapper.selectTotalCount(pagination);
	}

	@Override
	public List<RecipeVO> getPagingBoards(Pagination pagination) {
		log.info("getPagingBoards()");
		List<RecipeVO> list = recipeMapper.selectListByPagination(pagination);
		
		return list.stream().collect(Collectors.toList());
	}

}
