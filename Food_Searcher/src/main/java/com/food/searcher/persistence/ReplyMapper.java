package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.ReplyVO;


@Mapper
public interface ReplyMapper {
	int insert(ReplyVO replyVO);
	List<ReplyVO> selectListByBoardId(int boardId);
	int update(ReplyVO replyVO);
	int delete(int replyId);
}
