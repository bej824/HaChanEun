package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.ItemAttachVO;

public interface ItemAttachService {
	
    int createAttach(ItemAttachVO attachVO);
    List<ItemAttachVO> getItemById(int itemId);
    ItemAttachVO getAttachById(int attachId);
    List<ItemAttachVO> getSelectAll();
    List<ItemAttachVO> getAllId();
    int updateAttach(ItemAttachVO attachVO);
    int deleteAttach(int attachId);

}