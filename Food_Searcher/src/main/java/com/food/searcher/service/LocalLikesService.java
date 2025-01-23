package com.food.searcher.service;

import java.util.List;
import java.util.Map;

import com.food.searcher.domain.LocalLikesVO;

public interface LocalLikesService {
	
	// 회원이 게시물에 처음 들어갈 때 db 작성
	int createLikes(int localId, String memberId);
	
	// 회원이 게시물에 들어갈 때의 db 확인
	int countLikes(int localId, String memberId);
	
	// 게시물에 존재하는 좋아요, 싫어요의 갯수 확인
	Map<String, Object> selectLikesByLocalId(int localId);
	
	// 회원이 좋아요, 싫어요를 변경 시 db 업데이트
	int updateLikes(int localId, String memberId, int memberLike);

}
