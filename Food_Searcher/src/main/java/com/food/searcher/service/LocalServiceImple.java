package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.CtgVO;
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
	private UtilityService utilityService;
	
	@Transactional
	@Override
	public int createSpeciality (LocalSpecialityVO localSpecialityVO) {
		
		return localMapper.insertSepeciality(localSpecialityVO);
	}
	
	@Transactional
	@Override
	public List<LocalSpecialityVO> getAllSpeciality(
			LocalSpecialityVO localSpecialityVO) {
		
		return localMapper.selectList(localSpecialityVO);
	}
	
	@Transactional
	@Override
	public List<LocalSpecialityVO> getPagingSpeciality(Pagination pagination) {
		
		return localMapper.selectListByPagination(pagination);
	}
	
	@Transactional
	@Override
	public List<String> getDistrictByLocal(String localLocal) {
		return localMapper.selectDistrict(localLocal);
	}
	
	@Transactional
	@Override
	public LocalSpecialityVO getSpecialityByLocalId(int localId) {
		
		LocalSpecialityVO localSpecialityVO = localMapper.selectByLocalId(localId);
		specialityViewLog(localId);
		
		return localSpecialityVO;
	}
	
	@Transactional
	@Override
	public List<CtgVO> getViews() {
		
		return localMapper.selectViews();
	}
	
	@Transactional
	@Override
	public int updateSpeciality(LocalSpecialityVO localSpecialityVO) {
		
		return localMapper.update(localSpecialityVO);
	}
	
	@Override
	public int deleteView() {
		
		return localMapper.deleteView();
	}
	
	public void specialityViewLog(int localId) {
		
		String memberId = utilityService.loginMember();
		if(memberId != null) {
			localMapper.insertViews(memberId, localId);
		}
	}
}
