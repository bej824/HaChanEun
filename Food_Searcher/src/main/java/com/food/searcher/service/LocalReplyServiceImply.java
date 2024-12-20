package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.LocalReplyVO;
import com.food.searcher.persistence.LocalReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class LocalReplyServiceImply implements LocalReplyService {
	
	@Autowired
	LocalReplyMapper LocalReplyMapper;
	
	@Override
	public int createReply(int localId, String memberId, String replyContent) {
		log.info("createReply()");
		return LocalReplyMapper.insert(localId, replyContent, replyContent);
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
	public int updateReply(LocalReplyVO LocalReplyVO) {
		log.info("updateReply()");
		return LocalReplyMapper.update(LocalReplyVO);
	}
	
	@Override
	public int deleteReply(int localReplyId, int localId) {
		log.info("deleteReply()");
		return LocalReplyMapper.delete(localReplyId);
	}

}
