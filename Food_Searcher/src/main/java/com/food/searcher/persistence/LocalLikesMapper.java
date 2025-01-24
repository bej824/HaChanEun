package com.food.searcher.persistence;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface LocalLikesMapper {
	
	int insertLocalLikes(@Param("localId") int localId, @Param("memberId") String memberId);
	
	int memberLikeByMemberId(@Param("localId") int localId, @Param("memberId") String memberId);
	
	Map<String, Object> selectLikesBylocalId(@Param("localId") int localId);
	
	int updateLikesByMemberId(@Param("localId") int localId, @Param("memberId") String memberId, @Param("memberLike") int memberLike);

}
