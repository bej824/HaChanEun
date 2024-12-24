package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.LocalCommentVO;

public interface LocalCommentService {
	
	int createComment(int replyId, String memberId, String commentContent);
	List<LocalCommentVO> getAllComment(int commentId);
	int updateComment(int commentId, String commentContent);
	int deleteComment(int commentId);


}
