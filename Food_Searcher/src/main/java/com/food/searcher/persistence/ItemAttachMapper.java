package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.ItemAttachVO;

@Mapper
public interface ItemAttachMapper {
    int insert(ItemAttachVO attach);
    List<ItemAttachVO> selectByItemId(int itemId);
    ItemAttachVO selectByAttachId(int attachId);
    List<ItemAttachVO> selectAll();
    List<ItemAttachVO> selectIdList();
    int update(ItemAttachVO attach);
    int delete(int itemId);
}