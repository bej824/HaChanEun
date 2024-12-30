package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.LocalReplyVO;
import com.food.searcher.persistence.LocalMapper;
import com.food.searcher.persistence.LocalReplyMapper;

import lombok.extern.log4j.Log4j;

@Transactional
@Service
@Log4j
public class LocalReplyServiceImply implements LocalReplyService {
	
	@Autowired
	LocalReplyMapper localReplyMapper;
	
	@Autowired
	LocalMapper localMapper;
	
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
	
	@Override
	public List<LocalReplyVO> getAllReply(int localId) {
		log.info("getAllReply()");
		return localReplyMapper.selectListByLocalId(localId);
	}
	
	
	@Override
	public int updateReply(int replyId, String replyContent) {
		log.info("updateReply()");
		return localReplyMapper.update(replyId, replyContent);
	}
	
	@Transactional
	@Override
	public int deleteReply(int localId, int ReplyId) {
		int result = 0;
		log.info("deleteReply()");
		result = localReplyMapper.delete(ReplyId);
		localMapper.localReplyCountDown(localId);
			
		return result;
	}

}
