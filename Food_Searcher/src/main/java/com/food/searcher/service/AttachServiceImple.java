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
        return attachMapper.insert(attachVO);
    }

    @Override
    public AttachVO getAttachById(int attachId) {
    	return attachMapper.selectByAttachId(attachId);
    }
    
    @Override
    public List<Integer> getAllId() {
    	return attachMapper.selectIdList();
    }

    @Override
    public int updateAttach(AttachVO attachVO) {
        return attachMapper.update(attachVO);
    }

    @Override
    public int deleteAttach(int attachId) {
        return attachMapper.delete(attachId);
    }

	@Override
	public List<AttachVO> getSelectAll() {
		return attachMapper.selectAll();
	}

	@Override
	public List<AttachVO> getBoardById(int boardId) {
        return attachMapper.selectByBoardId(boardId);
	}

	@Override
	public AttachVO getSelectBoardId(int boardId) {
		return attachMapper.selectBoardId(boardId);
	}
}