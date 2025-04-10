package com.food.searcher.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.food.searcher.domain.AnswerVO;
import com.food.searcher.domain.AskVO;
import com.food.searcher.persistence.AskMapper;

import lombok.extern.log4j.Log4j;

@Repository
@Service
@Log4j
public class AskServiceImple implements AskService {
	
	@Autowired
	AskMapper askMapper;
	
	@Autowired
	AnswerService answerService;
	
	@Override
	public int createAsk(AskVO askVO) {
		 if (!canWriteAsk(askVO.getMemberId(), askVO.getItemId())) {
	            throw new IllegalStateException("하루에 한 번만 문의를 작성할 수 있습니다.");
	        }else {
	        	return askMapper.insert(askVO);
	        }
	}
	
	@Override
	public List<AskVO> getAsk(long itemId) {
		List<AskVO> askVO = askMapper.select(itemId);
		return askVO;
	}

	@Override
	public int updateAsk(long askId, String askContent) {
 		AskVO askVO = new AskVO();
 		askVO.setAskContent(askContent);
 		askVO.setAskId(askId);
 		
 		int result = askMapper.countSelect(askId);
 		if(result==0) {
 			return askMapper.update(askVO);
 		} else {
 			return 0;
 		}
	}

	@Override
	public int deleteAsk(long askId) {
		List<AnswerVO> list = answerService.getAnswer(askId);
		
		for(AnswerVO vo : list) {
			answerService.deleteAnswer(vo.getAskId());
		}
		return askMapper.delete(askId);
	}
	
	@Override
	public boolean canWriteAsk(String memberId, long itemId) {
	        // 오늘 작성된 댓글이 있는지 확인
			AskVO askVO = new AskVO();
			askVO.setMemberId(memberId);
			askVO.setItemId(itemId);
	        int result = askMapper.countTodayAsk(askVO);
	        return result == 0; // 0이면 작성 가능, 1 이상이면 불가능
	    }

	
}
