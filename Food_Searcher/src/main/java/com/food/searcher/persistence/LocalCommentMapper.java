package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.LocalCommentVO;

@Mapper
public interface LocalCommentMapper {
	
	int insertLocalComment(@Param("replyId") int replyId, @Param("memberId") String memberId, 
			@Param("commentContent") String commentContent);
	List<LocalCommentVO> selectListByCommentId(@Param("replyId") int replyId);
	int update(@Param("commentId") int commentId, @Param("commentContent") String commentContent);
	int delete(int commentId);

}
