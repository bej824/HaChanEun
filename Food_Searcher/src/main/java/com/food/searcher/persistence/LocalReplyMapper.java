package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.LocalReplyVO;

@Mapper
public interface LocalReplyMapper {
	
	int insert(int localId, String memberId, String replyContent);
	List<LocalReplyVO> selectListByLocalId(int localId);
	int update(LocalReplyVO localReplyVO);
	int delete(int localReplyId);

}
