package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface LocalMapper {
	
	int insertSepeciality(LocalSpecialityVO localSpecialityVO); // 특산품 등록
	List<LocalSpecialityVO> selectList(@Param("localLocal") String localLocal,
			@Param("localDistrict") String localDistrict,
			@Param("localTitle") String localTitle); // 특산품 조회
	List<LocalSpecialityVO> selectListByPagination(Pagination pagination);
	List<String> selectDistrict(@Param("localLocal") String localLocal); // 지역 조회
	LocalSpecialityVO selectByLocalId(@Param("localId") int localId);// 특산품 상세 정보
	int update(LocalSpecialityVO localSpecialityVO); // 특산품 수정
	int delete(@Param("localId") int localId); // 특산품 삭제
	void localReplyCountUp(@Param("localId") int localId); // 댓글 카운트 업
	void localReplyCountDown(@Param("localId") int localId, @Param("countDown") int countDown); // 댓글 카운트 다운
}
