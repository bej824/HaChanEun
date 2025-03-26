package com.food.searcher.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RecipeLikesVO;
import com.food.searcher.domain.RecipeReplyVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.domain.RecipeViewListVO;
import com.food.searcher.domain.RecipeViewsVO;
import com.food.searcher.domain.RecommendVO;
import com.food.searcher.persistence.AttachMapper;
import com.food.searcher.persistence.LocalMapper;
import com.food.searcher.persistence.RecipeMapper;
import com.food.searcher.persistence.RecipeViewMapper;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class RecipeServiceImple implements RecipeService {

	@Autowired
	private RecipeMapper recipeMapper;

	@Autowired
	private RecipeReplyService recipeReplyService;

	@Autowired
	private AttachMapper attachMapper;

	@Autowired
	private LocalMapper localMapper;

	@Autowired
	private RecipeViewMapper recipeViewMapper;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private RecipeLikesService likesService;
	
	@Autowired
	private AttachService attachService;

	@Transactional(value = "transactionManager")
	@Override
	public int createBoard(RecipeVO recipeVO) {
		log.info("createBoard()");
		log.info(recipeVO);
		int result = recipeMapper.insert(recipeVO);
		log.info(result + "행 게시글 등록");

		List<AttachVO> attachList = recipeVO.getAttachList();
		log.info(attachList);

		int insertAttachResult = 0;
		for (AttachVO attachVO : attachList) {
			attachVO.setBoardId(getAllBoards().get(0).getRecipeId());
			insertAttachResult += attachMapper.insert(attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		return result;
	}

	@Override
	public List<RecipeVO> getAllBoards() {
		log.info("getAllBoards()");
		return recipeMapper.selectList().stream().collect(Collectors.toList());
	}

	@Transactional(value = "transactionManager")
	@Override
	public RecipeVO getBoardById(int recipeId, String memberId) {
		log.info("getBoardById()");
		log.info("recipeId : " + recipeId);
		RecipeVO recipeVO = recipeMapper.selectOne(recipeId);
		List<AttachVO> list = attachMapper.selectByBoardId(recipeId);

		List<AttachVO> attachList = list.stream().collect(Collectors.toList());
		recipeVO.setAttachList(attachList);

		// memberId가 있을 경우, 조회 기록 삽입
		if (memberId != null && memberId != "nouser") {
			// 조회 기록 리스트를 가져옵니다.
			List<RecipeViewListVO> viewList = recipeViewMapper.selectAll();

			// 삽입할 파라미터를 Map에 저장합니다.
			Map<String, Object> params = new HashMap<>();
			params.put("recipeId", recipeId);
			params.put("memberId", memberId);
			params.put("category", recipeVO.getCategory());
			log.info(params);

			// 데이터가 없으면 바로 insert를 진행
			if (viewList == null || viewList.isEmpty()) {
				// 데이터가 없으면 바로 insert
				int recipeView = recipeViewMapper.insert(params);
				log.info(recipeView + "행 추가");
			} else {
				// 데이터가 있으면 memberId와 recipeId를 비교하여 삽입 여부 결정
				boolean shouldInsert = true; // 기본적으로 insert 해야한다고 가정

				for (RecipeViewListVO vo : viewList) {
					// memberId와 recipeId가 모두 일치하면 삽입하지 않음
					if (vo.getMemberId().equals(memberId) && vo.getRecipeId() == recipeId) {
						shouldInsert = false;
						break; // 일치하는 데이터가 있으면 반복문 종료
					}
				}

				// 일치하는 데이터가 없으면 insert 실행
				if (shouldInsert) {
					int recipeView = recipeViewMapper.insert(params);
					log.info(recipeView + "행 추가");
				}
			}
		}

		return recipeVO;
	}

	@Transactional(value = "transactionManager")
	@Override
	public int updateBoard(RecipeVO recipeVO) {
		log.info("updateBoard()");
		log.info(recipeVO);
		log.info(attachMapper.selectByBoardId(recipeVO.getRecipeId()));
		int updateBoardResult = recipeMapper.update(recipeVO);
		log.info(updateBoardResult + "행 게시글 정보 수정");
		List<AttachVO> attachList = recipeVO.getAttachList();
		log.info("attachList" + attachList);

		int deleteAttachResult = attachMapper.delete(recipeVO.getRecipeId());
		log.info(deleteAttachResult + "행 파일 정보 삭제");

		int insertAttachResult = 0;
		for (AttachVO attachVO : attachList) {
			attachVO.setBoardId(recipeVO.getRecipeId()); // 게시글 번호 적용
			insertAttachResult += attachMapper.insert(attachVO);
			log.info("attachVO" + attachVO);
		}
		log.info(insertAttachResult + "행 파일 정보 등록");
		return updateBoardResult;
	}

	@Transactional(value = "transactionManager")
	@Override
	public int deleteBoard(int recipeId) {
		log.info("deleteBoard()");
		List<RecipeReplyVO> replyList = recipeReplyService.getAllReply(recipeId);
		int deleteAttachResult = attachMapper.delete(recipeId);
		log.info(deleteAttachResult + "행 파일 정보 삭제");
		log.info("댓글 목록 : " + replyList);
		for (RecipeReplyVO reVO : replyList) {
			log.info(reVO);
			int result = recipeReplyService.deleteReply(reVO.getReplyId(), reVO.getBoardId());
			log.info(result + "행 댓글 삭제");
		}
		return recipeMapper.delete(recipeId);
	}

	@Override
	public int getTotalCount(Pagination pagination) {
		log.info("getTotalCount()");
		return recipeMapper.selectTotalCount(pagination);
	}

	@Override
	public List<RecipeVO> getPagingBoards(Pagination pagination) {
		log.info("getPagingBoards()");
		List<RecipeVO> list = recipeMapper.selectListByPagination(pagination);
		for (RecipeVO vo : list) {
			RecipeViewsVO viewsVO = recipeViewMapper.selectOne(vo.getRecipeId());
			if (viewsVO != null) {
				vo.setViewCount(viewsVO.getViews());
			}
		}

		return list.stream().collect(Collectors.toList());
	}

	@Override
	public String localWord() {
		List<LocalSpecialityVO> localList = localMapper.selectAll().stream().collect(Collectors.toList());
		String str = "";
		for (LocalSpecialityVO vo : localList) {
			str += vo.getLocalTitle() + " ";
		}
		return str;
	}

	@Override
	public MemberVO memberInfo(Principal principal) {
		if (principal != null) {
			return memberService.getMemberById(principal.getName());
		}
		return null;
	}

	@Override
	public RecipeLikesVO memberLike(int recipeId, Principal principal) {
		if (principal != null) {
			return likesService.getMemberLikes(recipeId, principal.getName());
		}
		return null;
	}

	@Override
	public List<AttachVO> attachAll() {
		List<AttachVO> attachVO = attachService.getSelectAll();
		
		List<AttachVO> distinctBoardIds = attachVO.stream()
		        .collect(Collectors.toMap(AttachVO::getBoardId, attach -> attach, (existing, replacement) -> existing))
		        .values()
		        .stream()
		        .collect(Collectors.toList());
		
		List<AttachVO> list = new ArrayList<AttachVO>();
		for(AttachVO vo : distinctBoardIds) {
			Path filePath = Paths.get("C:\\upload\\food" + '\\' + vo.getAttachPath(), vo.getAttachChgName());
			if (Files.exists(filePath)) {
				list.add(vo);
	        } else {
	        }
		}
		return list;
		
	}

	@Override
	public List<AttachVO> attachBoardById(int recipeId) {
		return attachService.getBoardById(recipeId);
	}

	@Override
	public List<AttachVO> homeAttach() {
List<AttachVO> attachVO = attachService.getSelectAll();
		
		List<AttachVO> distinctBoardIds = attachVO.stream()
		        .collect(Collectors.toMap(AttachVO::getBoardId, attach -> attach, (existing, replacement) -> existing))
		        .values()
		        .stream()
		        .collect(Collectors.toList());
		
		List<AttachVO> list = new ArrayList<AttachVO>();
		for(AttachVO vo : distinctBoardIds) {
			Path filePath = Paths.get("C:\\upload\\food" + '\\' + vo.getAttachPath(), vo.getAttachChgName());
			if (Files.exists(filePath)) {
				list.add(vo);
	        } else {
	        }
		}
		return list;
	}

	@Override
	public RecommendVO recommend(String memberId) {
		return recipeMapper.recommend(memberId);
	}

	@Override
	public RecipeVO selectRandom() {
		return recipeMapper.selectRandom();
	}

	@Override
	public RecipeVO selectRandomByRecipeId(String food) {
		return recipeMapper.selectRandomByRecipeId(food);
	}

	@Override
	public AttachVO selectBoardId(int recipeId) {
		return attachMapper.selectBoardId(recipeId);
	}

}
