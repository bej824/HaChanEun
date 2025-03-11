package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface LocalMapper {
	
	int insertSepeciality(
			LocalSpecialityVO localSpecialityVO
			); // 특산품 등록
	
	int insertViews(
			@Param("memberId") String memberId,
			@Param("localId") int localId
			);
	
	List<LocalSpecialityVO> selectList(
			@Param("localLocal") String localLocal,
			@Param("localDistrict") String localDistrict,
			@Param("localTitle") String localTitle,
			@Param("mainCtg") String mainCtg,
			@Param("subCtg") String subCtg
			); // 특산품 조회
	
	List<LocalSpecialityVO> selectAll();
	
	List<LocalSpecialityVO> selectListByPagination(
			Pagination pagination
			);
	
	List<String> selectDistrict(
			@Param("localLocal") String localLocal
			); // 지역 조회
	
	LocalSpecialityVO selectByLocalId(
			@Param("localId") int localId
			);// 특산품 상세 정보
	
	List<CtgVO> selectViews();
	
	int update(
			LocalSpecialityVO localSpecialityVO
			); // 특산품 수정
	
	int delete(
			@Param("localId") int localId
			); // 특산품 삭제
	}
