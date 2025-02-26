package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.ItemAttachVO;
import com.food.searcher.persistence.ItemAttachMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ItemAttachServiceImple implements ItemAttachService {

	@Autowired
    private ItemAttachMapper attachMapper;


    @Override
    public int createAttach(ItemAttachVO attachVO) {
    	log.info("createAttach");
        return attachMapper.insert(attachVO);
    }

    @Override
    public ItemAttachVO getAttachById(int attachId) {
    	log.info("getAttachById()");
        return attachMapper.selectByAttachId(attachId);
    }
    
    @Override
    public List<ItemAttachVO> getAllId() {
    	log.info("getAllId()");
    	return attachMapper.selectIdList();
    }

    @Override
    public int updateAttach(ItemAttachVO attachVO) {
    	log.info("updateAttach()");
        return attachMapper.update(attachVO);
    }

    @Override
    public int deleteAttach(int attachId) {
    	log.info("deleteAttach()");
        return attachMapper.delete(attachId);
    }

	@Override
	public List<ItemAttachVO> getSelectAll() {
		log.info("getSelectAll()");
		return attachMapper.selectAll();
	}

	@Override
	public List<ItemAttachVO> getItemById(int itemId) {
		log.info("getAttachById()");
        return attachMapper.selectByItemId(itemId);
	}
}