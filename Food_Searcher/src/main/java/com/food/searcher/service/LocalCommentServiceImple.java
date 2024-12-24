package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.LocalCommentVO;
import com.food.searcher.persistence.LocalCommentMapper;

import lombok.extern.log4j.Log4j;

@Transactional
@Service
@Log4j
public class LocalCommentServiceImple implements LocalCommentService {
	
	@Autowired
	LocalCommentMapper localCommentMapper;
	
	@Override
		public int createComment(int replyId, String memberId, String commentContent) {
		log.info("createComment()");
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
	public int deleteComment(int commentId) {
		log.info("deleteComment()");
		return localCommentMapper.delete(commentId);
	}

}
