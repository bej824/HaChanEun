package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CtgVO;

@Mapper
public interface CtgMapper {
	
	int insertCtg(CtgVO foodctgVO);
	
	List<CtgVO> selectCtg(
			 @Param("mainCtg") String mainCtg);

}
