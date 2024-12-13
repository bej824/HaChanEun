package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ReplyVO;


public interface ReplyService {
	int createReply(ReplyVO replyVO);
	List<ReplyVO> getAllReply(int boardId);
	int updateReply(int replyId, String replyContent);
	int deleteReply(int replyId, int boardId);
}
