package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.util.Pagination;

public interface LocalService {
	
	int createSpeciality(
			LocalSpecialityVO localSpecialityVO);
	
	List<LocalSpecialityVO> getAllSpeciality(
			String localLocal,
			String localDistrict,
			String localTitle,
			String mainCtg,
			String subCtg);
	
	List<LocalSpecialityVO> getPagingSpeciality(
			Pagination pagination);
	
	List<String> getDistrictByLocal(
			String localLocal);
	
	LocalSpecialityVO getSpecialityByLocalId(
			int localId);
	
	List<CtgVO> getViews();
	
	int updateSpeciality(
			LocalSpecialityVO localSpecialityVO);
	
	int deleteView();

}
