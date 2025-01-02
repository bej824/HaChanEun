package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.LocalCommentVO;
import com.food.searcher.persistence.LocalCommentMapper;
import com.food.searcher.persistence.LocalMapper;

import lombok.extern.log4j.Log4j;

@Transactional
@Service
@Log4j
public class LocalCommentServiceImple implements LocalCommentService {
	
	@Autowired
	LocalCommentMapper localCommentMapper;
	
	@Autowired
	LocalMapper localMapper;
	
	@Override
		public int createComment(int localId, int replyId, String memberId, String commentContent) {
		log.info("createComment()");
		localMapper.localReplyCountUp(localId);
			return localCommentMapper.insertLocalComment(replyId, memberId, commentContent);
		}
	
	@Override
	public List<LocalCommentVO> getAllComment(int replyId) {
		log.info("getAllComment()");
		log.info("replyId = " + replyId);
		return localCommentMapper.selectListByCommentId(replyId);
	}
	
	@Override
	public int updateComment(int commentId, String commentContent) {
		log.info("updateComment()");
		return localCommentMapper.update(commentId, commentContent);
	}
	
	@Override
	public int deleteComment(int localId, int commentId) {
		log.info("deleteComment()");
		int replyId = 0;
		int countDown = 1;
		localMapper.localReplyCountDown(localId, countDown);
		
		// 대댓글 댓글id 전체 삭제라면 commentId = 0, replyId로 처리
		// 하나만 삭제할 거라면 replyId = 0, commentId로 처리
		return localCommentMapper.delete(replyId, commentId);
	}

}
