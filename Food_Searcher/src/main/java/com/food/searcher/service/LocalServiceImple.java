package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.persistence.LocalMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class LocalServiceImple implements LocalService {
	
	@Autowired
	private LocalMapper localMapper;
	
	@Override
	public List<LocalSpecialityVO> getAllSpeciality(String localLocal, String localDistrict) {
		log.info("getAllSpeciality()");
		log.info("localLocal : " + localLocal);
		log.info("localDistrict : " + localDistrict);
		return localMapper.selectList(localLocal, localDistrict);
	}
	
	@Override
	public List<LocalSpecialityVO> getDistrictByLocal(String localLocal) {
		log.info("getDistrictByLocal()");
		return localMapper.selectDistrict(localLocal);
	}
	
	@Override
	public LocalSpecialityVO getSpecialityByLocalId(String localId) {
		log.info("getSpecialityByLocalId()");
		return localMapper.selectByLocalId(localId);
	}
	
	@Override
	public int updateSpeciality(LocalSpecialityVO localSpecialityVO) {
		log.info("updateSpeciality()");
		
		return localMapper.update(localSpecialityVO);
	}
	
	@Override
	public int getTotalCount() {
		
			log.info("getTotalCount()");
			return localMapper.selectTotalCount();
	}

}
