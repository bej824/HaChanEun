package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.RecipeReplyVO;


@Mapper
public interface RecipeReplyMapper {
	int insert(RecipeReplyVO replyVO);
	List<RecipeReplyVO> selectListByBoardId(int boardId);
	RecipeReplyVO selectOne(int replyId);
	int update(RecipeReplyVO replyVO);
	int delete(int replyId);
}
