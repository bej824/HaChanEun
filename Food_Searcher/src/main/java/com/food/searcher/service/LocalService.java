package com.food.searcher.service;

import java.util.List;
import java.util.Map;

import com.food.searcher.domain.LocalSpecialityVO;

public interface LocalService {
	
	int createSpeciality(LocalSpecialityVO localSpecialityVO);
	List<LocalSpecialityVO> getAllSpeciality(String localLocal, String localDistrict, String localTitle);
	List<String> getDistrictByLocal(String localLocal);
	LocalSpecialityVO getSpecialityByLocalId(int localId);
	int updateSpeciality(LocalSpecialityVO localSpecialityVO);
	int deleteSpeciality(int localId);

}
