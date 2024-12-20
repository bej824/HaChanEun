package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.LocalReplyVO;


public interface LocalReplyService {
	
	int createReply(int localId, String memberId, String replyContent);
	List<LocalReplyVO> getAllReply(int localId);
	int updateReply(LocalReplyVO LocalReplyVO);
	int deleteReply(int localReplyId, int localId);
	LocalReplyVO getReplyById(int localReplyId);

}
