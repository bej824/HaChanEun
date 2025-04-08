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
		int result = recipeMapper.insert(recipeVO);

		List<AttachVO> attachList = recipeVO.getAttachList();

		for (AttachVO attachVO : attachList) {
			attachVO.setBoardId(getAllBoards().get(0).getRecipeId());
			attachMapper.insert(attachVO);
		}
		return result;
	}

	@Override
	public List<RecipeVO> getAllBoards() {
		return recipeMapper.selectList().stream().collect(Collectors.toList());
	}

	@Transactional(value = "transactionManager")
	@Override
	public RecipeVO getBoardById(int recipeId, String memberId) {
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

			// 데이터가 없으면 바로 insert를 진행
			if (viewList == null || viewList.isEmpty()) {
				// 데이터가 없으면 바로 insert
				recipeViewMapper.insert(params);
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
					recipeViewMapper.insert(params);
				}
			}
		}

		return recipeVO;
	}

	@Transactional(value = "transactionManager")
	@Override
	public int updateBoard(RecipeVO recipeVO) {
		int updateBoardResult = recipeMapper.update(recipeVO);
		List<AttachVO> attachList = recipeVO.getAttachList();

		attachMapper.delete(recipeVO.getRecipeId());

		for (AttachVO attachVO : attachList) {
			attachVO.setBoardId(recipeVO.getRecipeId()); // 게시글 번호 적용
			attachMapper.insert(attachVO);
		}
		return updateBoardResult;
	}

	@Transactional(value = "transactionManager")
	@Override
	public int deleteBoard(int recipeId) {
		List<RecipeReplyVO> replyList = recipeReplyService.getAllReply(recipeId);
		attachMapper.delete(recipeId);
		for (RecipeReplyVO reVO : replyList) {
			recipeReplyService.deleteReply(reVO.getReplyId(), reVO.getBoardId());
		}
		return recipeMapper.delete(recipeId);
	}

	@Override
	public int getTotalCount(Pagination pagination) {
		return recipeMapper.selectTotalCount(pagination);
	}

	@Override
	public List<RecipeVO> getPagingBoards(Pagination pagination) {
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
		List<AttachVO> attachVO = attachService.getBoardById(recipeId);
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
		
		return recipeMapper.selectRandomByRecipeName(food);
	}

	@Override
	public AttachVO selectBoardId(int recipeId) {
		return attachMapper.selectBoardId(recipeId);
	}

}
