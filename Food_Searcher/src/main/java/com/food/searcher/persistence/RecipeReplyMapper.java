package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.ReplyVO;


@Mapper
public interface ReplyMapper {
	int insert(ReplyVO replyVO);
	List<ReplyVO> selectListByBoardId(int boardId);
	ReplyVO selectOne(int replyId);
	int update(ReplyVO replyVO);
	int delete(int replyId);
}
