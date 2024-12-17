package com.food.searcher.service;

import java.util.List;

import com.food.searcher.domain.LocalSpecialityVO;

public interface LocalService {
	
	List<LocalSpecialityVO> getAllSpeciality();
	LocalSpecialityVO getSpecialityByLocal(String localLocal);
	int updateSpeciality(LocalSpecialityVO localSpecialityVO);
	int getTotalCount();

}
