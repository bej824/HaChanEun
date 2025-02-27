package com.food.searcher.service;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.LocalLikesVO;
import com.food.searcher.persistence.LocalLikesMapper;

import lombok.extern.log4j.Log4j;
import oracle.jdbc.driver.parser.Parseable;

@Service
@Log4j
public class LocalLikesServiceImple implements LocalLikesService {
	
	@Autowired
	LocalLikesMapper localLikesMapper;
	
	@Override
	public int createLikes(int localId, String memberId, int memberLike) {
		log.info("createLikes()");
		
		return localLikesMapper.insertLocalLikes(localId, memberId, memberLike);
	}
	
	@Override
	public int memberLikeByMemberId(int localId, String memberId) {
		log.info("memberLikeByMemberId()");
		String result = localLikesMapper.memberLikeByMemberId(localId, memberId);
		
		int intResult;
		if(result == "") {
			intResult = 0;
		} else {
			intResult = Integer.valueOf(result);
		}
		
		return intResult;
	}
	
	@Override
	public Map<String, Object> selectLikesByLocalId(int localId) {
		log.info("selectLikesByLocalId()");
		
		return localLikesMapper.selectLikesBylocalId(localId);
	}
	
	@Override
	public int updateLikes(int localId, String memberId, int memberLike) {
		log.info("updateLikes()");
		
		return localLikesMapper.updateLikesByMemberId(localId, memberId, memberLike);
	}

}
