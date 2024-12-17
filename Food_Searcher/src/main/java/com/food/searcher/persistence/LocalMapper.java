package com.food.searcher.persistence;

import java.util.List;

import com.food.searcher.domain.LocalSpecialityVO;

public interface LocalMapper {
	List<LocalSpecialityVO> selectList(); // 전체 특산품 조회
	LocalSpecialityVO selectOne(String localLocal); // 상세 특산품 조회
	int update(LocalSpecialityVO localSpecialityVO); // 상세 특산품 수정
	int selectTotalCount();
}
