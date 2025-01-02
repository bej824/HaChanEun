package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.LocalReplyVO;

@Mapper

public interface LocalReplyMapper {
	
	int insertLocalReply(@Param("localId") int localId, @Param("memberId") String memberId, 
			@Param("replyContent") String replyContent);
	List<LocalReplyVO> selectListByLocalId(@Param("localId") int localId);
	int countByLocalIdReply(@Param("localId") int localId);
	int update(@Param("replyId") int replyId, @Param("replyContent") String replyContent);
	int delete(int replyId);
	

}
