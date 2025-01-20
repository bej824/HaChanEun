package com.food.searcher.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.LocalLikesVO;
import com.food.searcher.persistence.LocalLikesMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class LocalLikesServiceImple implements LocalLikesService {
	
	@Autowired
	LocalLikesMapper localLikesMapper;
	
	
	@Override
	public int createLikes(LocalLikesVO localLikesVO) {
		log.info("createLikes()");
		
		return localLikesMapper.insertLocalLikes(localLikesVO);
	}
	
	@Override
	public LocalLikesVO selectLikes(int boardId, int memberId) {
		log.info("selectLikes()");
		
		return selectLikes(boardId, memberId);
	}
	
	@Override
	public int updateLikes(int boardId, int memberId, int memberLike) {
		log.info("updateLikes()");
		
		return updateLikes(boardId, memberId, memberLike);
	}

}
