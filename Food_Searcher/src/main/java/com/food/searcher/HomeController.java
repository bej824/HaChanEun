package com.food.searcher;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.food.searcher.domain.AttachVO;
import com.food.searcher.domain.LocalSpecialityVO;
import com.food.searcher.domain.MemberVO;
import com.food.searcher.domain.RecipeVO;
import com.food.searcher.service.AttachService;
import com.food.searcher.service.LocalService;
import com.food.searcher.service.MemberService;
import com.food.searcher.service.RecipeService;
import com.food.searcher.util.PageMaker;
import com.food.searcher.util.Pagination;

import lombok.extern.log4j.Log4j;

/**
 * Handles requests for the application home page.
 */
@Controller
@Log4j
public class HomeController {
	
	@Autowired
	private RecipeService recipeService;
	
	@Autowired
	private LocalService localService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private AttachService attachService;
	
	@Autowired
	private String uploadPath;
	
	MemberVO memberVO = null;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@GetMapping("/home")
	public void main(Model model, Pagination pagination, Principal principal) {
		log.info("home()");
		
		PageMaker pageMaker = new PageMaker();
		pagination.setPageSize(5);
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(recipeService.getTotalCount(pagination));
		

		pagination.getType().add(0, "CATEGORY");
		pagination.getKeyword().add(0, "한식");
		model.addAttribute("koreanList", recipeService.getPagingBoards(pagination));
		
		pagination.getKeyword().set(0, "중식");
		model.addAttribute("chinaList", recipeService.getPagingBoards(pagination));
		
		pagination.getKeyword().set(0, "일식");
		model.addAttribute("japanList", recipeService.getPagingBoards(pagination));
		
		pagination.getKeyword().set(0, "동남아식");
		model.addAttribute("SoutheastList", recipeService.getPagingBoards(pagination));
		
		pagination.getKeyword().set(0, "양식");
		model.addAttribute("westernList", recipeService.getPagingBoards(pagination));
		
		List<AttachVO> attachVO = attachService.getSelectAll();
		List<AttachVO> list = new ArrayList<AttachVO>();
		for(AttachVO vo : attachVO) {
			Path filePath = Paths.get(uploadPath + '\\' + vo.getAttachPath(), vo.getAttachChgName());
			if (Files.exists(filePath)) {
				list.add(vo);
	        } else {
	        }
		}
		
		model.addAttribute("attachVO", list);
	}
	
}
