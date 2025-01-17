package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.AttachVO;

@Mapper
public interface AttachMapper {
    int insert(AttachVO attach);
    List<AttachVO> selectByBoardId(int boardId);
    AttachVO selectByAttachId(int attachId);
    List<AttachVO> selectAll();
    List<Integer> selectIdList();
    int update(AttachVO attach);
    int delete(int boardId);
}