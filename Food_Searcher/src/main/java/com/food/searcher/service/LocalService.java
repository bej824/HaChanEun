package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.LocalSpecialityVO;

public interface LocalService {
	
	int createSpeciality(LocalSpecialityVO localSpecialityVO);
	List<LocalSpecialityVO> getAllSpeciality(String localLocal, String localDistrict);
	List<String> getDistrictByLocal(String localLocal);
	List<LocalSpecialityVO> getSpecialityByLocalTitle(String localTitle);
	LocalSpecialityVO getSpecialityByLocalId(String localId);
	int updateSpeciality(LocalSpecialityVO localSpecialityVO);
	int deleteSpeciality(int localId);

}
