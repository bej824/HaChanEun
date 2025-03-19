package com.food.searcher.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Supplier;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.persistence.CtgMapper;

@Service
public class CtgServiceImple implements CtgService {
	
	@Autowired
	CtgMapper ctgMapper;
	
	@Autowired
	UtilityService utilityService;
	
	@Override
	public int createCtg(CtgVO foodCtgVO) {
		
		return ctgMapper.insertCtg(foodCtgVO);
	}
	
	@Override
	public List<CtgVO> selectCtg(String url) {
		
		Map<String, Supplier<List<CtgVO>>> urlToMethodMap = new HashMap<>();
	    urlToMethodMap.put("local", ctgMapper::selectSpecialityMainCtg);
	    urlToMethodMap.put("item", ctgMapper::selectItemMainCtg);
	    urlToMethodMap.put("recipe", ctgMapper::selectRecipeMainCtg);
	    urlToMethodMap.put("default", ctgMapper::selectCtgMainCtg);

	    return urlToMethodMap.getOrDefault(url, urlToMethodMap.get("default")).get();
	}

}
