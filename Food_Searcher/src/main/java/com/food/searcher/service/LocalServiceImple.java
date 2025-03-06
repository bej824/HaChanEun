package com.food.searcher.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.persistence.LocalMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class LocalServiceImple implements LocalService {
	
	@Autowired
	private LocalMapper localMapper;
	
	@Transactional
	@Override
	public int createSpeciality (LocalSpecialityVO localSpecialityVO) {
		log.info("createSpeciality()");
		log.info(localSpecialityVO);
		
		return localMapper.insertSepeciality(localSpecialityVO);
	}
	
	@Override
	public List<LocalSpecialityVO> getAllSpeciality(String localLocal, String localDistrict, String localTitle) {
		log.info("getAllSpeciality()");
		
		return localMapper.selectList(localLocal, localDistrict, localTitle);
	}
	
	@Override
	public List<LocalSpecialityVO> getPagingSpeciality(Pagination pagination) {
		log.info("getPagingSpeciality()");
		
		return localMapper.selectListByPagination(pagination);
	}
	
	@Override
	public List<String> getDistrictByLocal(String localLocal) {
		log.info("getDistrictByLocal()");
		return localMapper.selectDistrict(localLocal);
	}
	
	@Override
	public LocalSpecialityVO getSpecialityByLocalId(int localId) {
		log.info("getSpecialityByLocalId()");
				
		LocalSpecialityVO localSpecialityVO = localMapper.selectByLocalId(localId);
		
		return localSpecialityVO;
	}
	
	@Transactional
	@Override
	public int updateSpeciality(LocalSpecialityVO localSpecialityVO) {
		log.info("updateSpeciality()");
		
		return localMapper.update(localSpecialityVO);
	}


}
