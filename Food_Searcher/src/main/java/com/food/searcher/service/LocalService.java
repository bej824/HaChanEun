package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.LocalSpecialityVO;

public interface LocalService {
	
	List<LocalSpecialityVO> getAllSpeciality(String localLocal, String localDistrict);
	List<LocalSpecialityVO> getDistrictByLocal(String localLocal);
	LocalSpecialityVO getSpecialityByLocalId(String localId);
	int updateSpeciality(LocalSpecialityVO localSpecialityVO);
	int getTotalCount();

}
