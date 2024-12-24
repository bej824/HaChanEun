package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.LocalReplyVO;


public interface LocalReplyService {
	
	int createReply(int localId, String memberId, String replyContent);
	List<LocalReplyVO> getAllReply(int localId);
	int updateReply(int replyId, String replyContent);
	int deleteReply(int ReplyId);

}
