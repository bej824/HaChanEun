package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.LocalSpecialityVO;

@Mapper
public interface LocalMapper {
	List<LocalSpecialityVO> selectList(@Param("localLocal") String localLocal, @Param("localDistrict") String localDistrict); // 전체 특산품 조회
	List<LocalSpecialityVO> selectDistrict(@Param("localLocal") String localLocal); // 상세 지역 조회
	LocalSpecialityVO selectByLocalId(@Param("localId") String localId);// 상세 특산품 조회
	int update(LocalSpecialityVO localSpecialityVO); // 상세 특산품 수정
	int delete(@Param("localId") int localId);
	int selectTotalCount();
	void localReplyCountUp(@Param("localId") int localId); // 댓글 카운트 업
	void localReplyCountDown(@Param("localId") int localId, @Param("countDown") int countDown); // 댓글 카운트 다운
}
