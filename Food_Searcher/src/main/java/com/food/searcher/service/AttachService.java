package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.AttachVO;

public interface AttachService {
	
    int createAttach(AttachVO attachVO);
    List<AttachVO> getAttachById(int attachId);
    List<Integer> getAllId();
    int updateAttach(AttachVO attachVO);
    int deleteAttach(int attachId);

}