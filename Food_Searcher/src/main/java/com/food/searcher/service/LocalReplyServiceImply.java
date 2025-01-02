package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.LocalReplyVO;
import com.food.searcher.persistence.LocalCommentMapper;
import com.food.searcher.persistence.LocalMapper;
import com.food.searcher.persistence.LocalReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class LocalReplyServiceImply implements LocalReplyService {
	
	@Autowired
	LocalMapper localMapper;

	@Autowired
	LocalReplyMapper localReplyMapper;
	
	@Autowired
	LocalCommentMapper localCommentMapper;
	
	@Transactional
	@Override
	public int createReply(int localId, String memberId, String replyContent) {
		int result = 0;
		log.info("createReply()");
		log.info("localId : " +  localId);
		log.info("memberId : " + memberId);
		log.info("replyContent : " + replyContent);
		
		result = localReplyMapper.insertLocalReply(localId, memberId, replyContent);
		localMapper.localReplyCountUp(localId);
		log.info(result);
		return result;
	}
	
	@Transactional
	@Override
	public List<LocalReplyVO> getAllReply(int localId) {
		log.info("getAllReply()");
		return localReplyMapper.selectListByLocalId(localId);
	}
	
	@Transactional
	@Override
	public int updateReply(int replyId, String replyContent) {
		log.info("updateReply()");
		return localReplyMapper.update(replyId, replyContent);
	}
	
	@Transactional
	@Override
	public int deleteReply(int localId, int replyId) {
		log.info("deleteReply()");
		int result = 0;
		int commentId = 0;
		
		// 대댓글 댓글id 전체 삭제라면 commentId = 0, replyId로 처리
		// 하나만 삭제할 거라면 replyId = 0, commentId로 처리
		int countDown = 1 + localCommentMapper.delete(replyId, commentId);
		localMapper.localReplyCountDown(localId, countDown);
		result = localReplyMapper.delete(replyId);
	
		return result;
	}

}
