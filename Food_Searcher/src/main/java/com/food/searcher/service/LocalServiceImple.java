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
	
	@Autowired
	private CtgViewsCountService ctgViewsCountService;
	
	@Autowired
	private UtilityService utilityService;
	
	@Transactional
	@Override
	public int createSpeciality (LocalSpecialityVO localSpecialityVO) {
		log.info("createSpeciality()");
		log.info(localSpecialityVO);
		
		return localMapper.insertSepeciality(localSpecialityVO);
	}
	
	@Transactional
	@Override
	public List<LocalSpecialityVO> getAllSpeciality(
			String localLocal,
			String localDistrict,
			String localTitle,
			String mainCtg,
			String subCtg) {
		log.info("getAllSpeciality()");
		
		return localMapper.selectList(localLocal, localDistrict, localTitle, mainCtg, subCtg);
	}
	
	@Transactional
	@Override
	public List<LocalSpecialityVO> getPagingSpeciality(Pagination pagination) {
		log.info("getPagingSpeciality()");
		
		return localMapper.selectListByPagination(pagination);
	}
	
	@Transactional
	@Override
	public List<String> getDistrictByLocal(String localLocal) {
		log.info("getDistrictByLocal()");
		return localMapper.selectDistrict(localLocal);
	}
	
	@Transactional
	@Override
	public LocalSpecialityVO getSpecialityByLocalId(int localId) {
		log.info("getSpecialityByLocalId()");
		
		LocalSpecialityVO localSpecialityVO = localMapper.selectByLocalId(localId);
		specialityViewLog(localSpecialityVO.getMainCtg());
		
		return localSpecialityVO;
	}
	
	@Transactional
	@Override
	public int updateSpeciality(LocalSpecialityVO localSpecialityVO) {
		log.info("updateSpeciality()");
		
		return localMapper.update(localSpecialityVO);
	}
	
	public void specialityViewLog(String mainCtg) {
		log.info("specialityViewLog()");
		
		String memberId = utilityService.loginMember();
		if(memberId != null) {
			ctgViewsCountService.countCtgViewCount(memberId, mainCtg);
		}
	}

}
