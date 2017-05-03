package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONWriter;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import tech.zhetengrensheng.webhome.core.entity.Category;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.facade.ZheTengLinkFacade;
import tech.zhetengrensheng.webhome.core.service.CategoryService;
import tech.zhetengrensheng.webhome.core.service.UserService;
import tech.zhetengrensheng.webhome.core.util.Constants;
import tech.zhetengrensheng.webhome.core.util.ZheTengLinkUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
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

    @Resource
    private UserService userService;

    @Resource
    private ZheTengLinkFacade zheTengLinkFacade;

    @RequestMapping("/addOrEditCategory.action")
    public String addOrEditCategory(Category category, HttpServletRequest request) {
        try {
            Integer userId = category.getUserId();

            if (userId != null && !StringUtils.isEmpty(category.getCategoryName())
                    && !StringUtils.isEmpty(category.getCategoryColor())) {

                // 生成json数据文件
                String jsonFileDirectory = request.getSession().getServletContext().getRealPath("/") + Constants.ZHE_TENG_LINK_FILE_DIR;

                zheTengLinkFacade.addOrEditCategory(category, jsonFileDirectory, userId);

                return "/user/backend/link/right.jsp";

            }
        } catch (Exception e) {

        }

        return "/user/backend/link/right.jsp";

    }

    @RequestMapping("/showAllCategories.action")
    public String showAllCategories(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentLoginUser");

        List<Category> categories = categoryService.selectByUserId(user.getUserId());

        request.setAttribute("categories", categories);

        return "/user/backend/link/node.jsp";
    }

    @RequestMapping("/deleteCategory.action")
    public String deleteCategory(Integer categoryId, Integer userId, HttpServletRequest request) {

        try {
            if (categoryId != null && userId != null) {

                // 生成json数据文件
                String jsonFileDirectory = request.getSession().getServletContext().getRealPath("/") + Constants.ZHE_TENG_LINK_FILE_DIR;

                zheTengLinkFacade.deleteCategoryById(categoryId, jsonFileDirectory, userId);

                return "/user/backend/link/right.jsp";
            }
        } catch (Exception e) {

        }

        return "/user/backend/link/right.jsp";
    }

}
