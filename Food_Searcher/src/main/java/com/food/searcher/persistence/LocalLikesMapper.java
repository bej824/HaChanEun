package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.LocalLikesVO;

@Mapper
public interface LocalLikesMapper {
	
	int insertLocalLikes(LocalLikesVO localLikesVO);
	
	List<LocalLikesVO> selectMemberLikes(int boardId, int memberId);
	
	int updateMemberLikes(int boardId, int memberId, int memberLikes);

}
