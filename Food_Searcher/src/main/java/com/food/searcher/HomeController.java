package com.food.searcher;

import java.security.Principal;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.food.searcher.domain.MemberVO;
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
	
	
	MemberVO memberVO = null;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@GetMapping("/home")
	public void main(Model model, Pagination pagination, Principal principal, HttpServletRequest request) {
		
		PageMaker pageMaker = new PageMaker();
		pagination.setPageSize(5);
		pageMaker.setPagination(pagination);
		pageMaker.setTotalCount(recipeService.getTotalCount(pagination));
		
		String referer = request.getHeader("Referer");
		if (referer != null && referer.contains("/searcher/auth/login")) {
			model.addAttribute("referer", referer);
		}
		

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
		
		
		model.addAttribute("attachVO", recipeService.homeAttach());
	}
	
}
