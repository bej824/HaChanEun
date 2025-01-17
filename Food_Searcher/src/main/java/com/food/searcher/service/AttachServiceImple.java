package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.persistence.AttachMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class AttachServiceImple implements AttachService {

	@Autowired
    private AttachMapper attachMapper;


    @Override
    public int createAttach(AttachVO attachVO) {
    	log.info("createAttach");
        return attachMapper.insert(attachVO);
    }

    @Override
    public AttachVO getAttachById(int attachId) {
    	log.info("getAttachById()");
        return attachMapper.selectByAttachId(attachId);
    }
    
    @Override
    public List<Integer> getAllId() {
    	log.info("getAllId()");
    	return attachMapper.selectIdList();
    }

    @Override
    public int updateAttach(AttachVO attachVO) {
    	log.info("updateAttach()");
        return attachMapper.update(attachVO);
    }

    @Override
    public int deleteAttach(int attachId) {
    	log.info("deleteAttach()");
        return attachMapper.delete(attachId);
    }

	@Override
	public List<AttachVO> getSelectAll() {
		log.info("getSelectAll()");
		return attachMapper.selectAll();
	}

	@Override
	public List<AttachVO> getBoardById(int boardId) {
		log.info("getAttachById()");
        return attachMapper.selectByBoardId(boardId);
	}
}