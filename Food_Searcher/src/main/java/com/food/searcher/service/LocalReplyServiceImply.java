package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.LocalReplyVO;
import com.food.searcher.persistence.LocalReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class LocalReplyServiceImply implements LocalReplyService {
	
	@Autowired
	LocalReplyMapper LocalReplyMapper;
	
	@Transactional
	@Override
	public int createReply(int localId, String memberId, String replyContent) {
		log.info("createReply()");
		log.info("localId :" +  localId);
		log.info("memberId : " + memberId);
		log.info("replyContent : " + replyContent);
		int result = LocalReplyMapper.insertLocalReply(localId, memberId, replyContent);
		log.info(result);
		return result;
	}
	
	@Override
	public List<LocalReplyVO> getAllReply(int localId) {
		log.info("getAllReply()");
		return LocalReplyMapper.selectListByLocalId(localId);
	}
	
	@Override
	public LocalReplyVO getReplyById(int localReplyId) {
		log.info("getReplyById()");
		return null;
	}
	
	@Override
	public int updateReply(int replyId, String replyContent) {
		log.info("updateReply()");
		return LocalReplyMapper.update(replyId, replyContent);
	}
	
	@Override
	public int deleteReply(int ReplyId) {
		log.info("deleteReply()");
		return LocalReplyMapper.delete(ReplyId);
	}

}
