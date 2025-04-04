package com.food.searcher.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.food.searcher.domain.CtgVO;
import com.food.searcher.domain.DirectOrderVO;
import com.food.searcher.domain.ItemVO;
import com.food.searcher.util.Pagination;

@Mapper
public interface ItemMapper {
	int itemInsert(ItemVO itemVO);
	int itemCtgInsert(ItemVO itemVO);
	
	List<ItemVO> selectAllByPagination(
			 	@Param("pagination") Pagination pagination); // 전체 게시글 페이징 처리
	
	int selectAllCount(Pagination pagination);
	
	List<ItemVO> selectCategoryList(@Param("subCtg") String subCtg, @Param("itemId") int itemId, @Param("pagination") Pagination pagination);
	
	List<ItemVO> selectAllList();
	
	int selectTotalCount(
				@Param("pagination") Pagination pagination,
				@Param("itemStatus") int itemStatus);
	
	ItemVO selectOne(int itemId);
	
	List<ItemVO> selectStatusByPagination(
		 	@Param("pagination") Pagination pagination); // 전체 게시글 페이징 처리
	
	List<ItemVO> selectSellerItem (
			 @Param("pagination") Pagination pagination
			,@Param("memberId") String memberId
			
			);
	
	List<ItemVO> select(@Param("pagination") Pagination pagination,
						@Param("memberId") String memberId);
	
	int sellerTotalCount(@Param("memberId") String memberId
						);

	List<CtgVO> mainCtgList();
	
	int update(ItemVO itemVO);
	int ctgUpdate(ItemVO itemVO);
	
	int updateItemAmount(
			@Param("itemId") int itemId,
			@Param("itemAmount") int itemAmount);
	
	int returnItemAmount(
			List<DirectOrderVO> orderList);
	
	
	int updateStatus(
			@Param("itemId") int itemId,
			@Param("itemStatus") int itemStatus);
	
	int delete(int itemId);
}
