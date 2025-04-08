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
        return attachMapper.insert(attachVO);
    }

    @Override
    public ItemAttachVO getAttachById(int attachId) {
        return attachMapper.selectByAttachId(attachId);
    }
    
    @Override
    public List<ItemAttachVO> getAllId() {
    	return attachMapper.selectIdList();
    }

    @Override
    public int updateAttach(ItemAttachVO attachVO) {
        return attachMapper.update(attachVO);
    }

    @Override
    public int deleteAttach(int attachId) {
        return attachMapper.delete(attachId);
    }

	@Override
	public List<ItemAttachVO> getSelectAll() {
		return attachMapper.selectAll();
	}

	@Override
	public List<ItemAttachVO> getItemById(int itemId) {
        return attachMapper.selectByItemId(itemId);
	}
}