package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.LocalReplyVO;
import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.persistence.LocalCommentMapper;
import com.food.searcher.persistence.LocalMapper;
import com.food.searcher.persistence.LocalReplyMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class LocalServiceImple implements LocalService {
	
	@Autowired
	private LocalMapper localMapper;
	
	@Autowired
	private LocalReplyMapper localReplyMapper;
	
	@Autowired
	private LocalCommentMapper localCommentMapper;
	
	@Transactional
	@Override
	public List<LocalSpecialityVO> getAllSpeciality(String localLocal, String localDistrict) {
		log.info("getAllSpeciality()");
		log.info("localLocal : " + localLocal);
		log.info("localDistrict : " + localDistrict);
		return localMapper.selectList(localLocal, localDistrict);
	}
	
	@Transactional
	@Override
	public List<LocalSpecialityVO> getDistrictByLocal(String localLocal) {
		log.info("getDistrictByLocal()");
		return localMapper.selectDistrict(localLocal);
	}
	
	@Transactional
	@Override
	public LocalSpecialityVO getSpecialityByLocalId(String localId) {
		log.info("getSpecialityByLocalId()");
		return localMapper.selectByLocalId(localId);
	}
	
	@Transactional
	@Override
	public int updateSpeciality(LocalSpecialityVO localSpecialityVO) {
		log.info("updateSpeciality()");
		
		return localMapper.update(localSpecialityVO);
	}
	
	@Transactional
	@Override
	public int deleteSpeciality(int localId) {
		log.info("deleteSpeciality()");
		int commentId = 0;
		List<LocalReplyVO> list = localReplyMapper.selectListByLocalId(localId);
		for(int i = 0; i < list.size(); i++) {
			int replyId = list.get(i).getReplyId();
			log.info(replyId);
			
			// 대댓글 댓글id 전체 삭제라면 commentId = 0, replyId로 처리
			// 하나만 삭제할 거라면 replyId = 0, commentId로 처리
			localCommentMapper.delete(replyId, commentId);
			localReplyMapper.delete(replyId);
		}
		
		
		return localMapper.delete(localId);
	}
	
	@Transactional
	@Override
	public int getTotalCount() {
		log.info("getTotalCount()");
		
		return localMapper.selectTotalCount();
	}

}
