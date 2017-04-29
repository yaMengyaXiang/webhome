package tech.zhetengrensheng.webhome.core.controller;

import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import tech.zhetengrensheng.webhome.core.entity.Category;
import tech.zhetengrensheng.webhome.core.service.CategoryService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @author Long
 * @create 2017-04-30 0:48
 **/
@Controller("categoryController")
@RequestMapping("/category")
public class CategoryController {

    @Resource
    private CategoryService categoryService;

    @RequestMapping("/addCategory.action")
    public String addCategory(Category category) {
        try {
            if (category != null && category.getUserId() != null &&
                    !StringUtils.isEmpty(category.getCategoryName()) &&
                    !StringUtils.isEmpty(category.getCategoryName())) {

                categoryService.insert(category);

                return "/user/backend/link/right.jsp";

            }
        } catch (Exception e) {

        }

        return "redirect:/login.jsp";

    }

    @RequestMapping("/showAllCategories.action")
    public String showAllCategories(HttpServletRequest request) {

        List<Category> categories = categoryService.selectAll();

        request.setAttribute("categories", categories);

        return "/user/backend/link/node.jsp";
    }

}
