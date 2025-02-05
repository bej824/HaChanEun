package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.food.searcher.domain.MarketAttachVO;

@Mapper
public interface MarketAttachMapper {
    int insert(MarketAttachVO attachVO);
    List<MarketAttachVO> selectByMarketId(int marketId);
    MarketAttachVO selectByAttachId(int attachId);
    int insertModify(MarketAttachVO attach);
    int delete(int marketId);
    List<MarketAttachVO> selectOldList();
}
