package tech.zhetengrensheng.webhome.core.controller;

import com.alibaba.fastjson.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import tech.zhetengrensheng.webhome.core.entity.*;
import tech.zhetengrensheng.webhome.core.service.*;
import tech.zhetengrensheng.webhome.core.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.List;

/**
 * Created by Long on 2017/3/26.
 */
@Controller("userController")
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    @Resource
    private TagService tagService;

    @Resource
    private ArticleService articleService;

    @Resource
    private CategoryService categoryService;

    @Resource
    private NodeService nodeService;

    @RequestMapping("/validate.action")
    @ResponseBody
    public String validate(String username) {

        Integer userId = userService.selectId(username);
        JSONObject jo = new JSONObject();

        jo.put("isExisted", "false");

        if (null != userId) {
            jo.put("isExisted", "true");
        }

        return jo.toString();
    }


    @RequestMapping("/getCurrentUserId.action")
    @ResponseBody
    public String getCurrentUserId(HttpServletRequest request) {

        JSONObject jo = new JSONObject();

        try {
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("currentLoginUser");

            jo.put("userId", user.getUserId() + "");

        } catch (Exception e) {
            jo.put("userId", "null");

        }

        return jo.toString();
    }


    @RequestMapping("/toLogin.action")
    public String toLogin(HttpServletRequest request) {

        // 由SpringMVC拦截器来检验用户是否已经登录，已经登录才执行下面的代码，否则直接跳转到登录界面，并且不再执行下面的代码
        String fromUri = UrlUtil.getFromUri(request);

        return "redirect:" + fromUri;

    }

    @RequestMapping("/relogin.action")
    public String relogin(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        session.removeAttribute("currentLoginUser");

        return "forward:/user/toLogin.action";
    }

    @RequestMapping("/login.action")
    public String login(String username, String password, HttpServletRequest request) {

        User user = userService.selectByUniqueField(username);

        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = request.getSession(false);

            String fromUri = (String) session.getAttribute("fromUri");
            String requestURI = (String) session.getAttribute("requestURI");

            String nextUri = fromUri;

            // 点击登录按钮
            if (requestURI != null && !requestURI.contains("Login") && !requestURI.contains("login")) {
                String rootName = "webhome";
                int index = requestURI.indexOf(rootName);

                nextUri = requestURI.substring(index + rootName.length());

            }

            // 已经可以登录了，移除fromUri
            session.removeAttribute("fromUri");
            // 放入session，并设置生命周期
            session.setAttribute("currentLoginUser", user);
            // 一小时
            session.setMaxInactiveInterval(1 * 60 * 60);

            return "redirect:" + nextUri;
        }

        request.setAttribute("errorMsg", "密码错误 ! ");

        return "forward:/login.jsp";
    }

    @RequestMapping("/toMyBackend.action")
    public String toMyBackend(HttpServletRequest request) {

        return "user/user-backend.jsp";
    }

    @RequestMapping("/toMyZheTengLink.action")
    public String toMyZheTengLink(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentLoginUser");

        List<Category> categories = categoryService.selectByUserId(user.getUserId());
        List<Node> nodes = nodeService.selectByUserId(user.getUserId());

        request.setAttribute("categories", categories);
        request.setAttribute("nodes", nodes);

        return "user/backend/zheteng-link.jsp";
    }

    @RequestMapping("/toMyBaseInfo.action")
    public String toMyBaseInfo(HttpServletRequest request) {

        return "user/backend/base-info.jsp";
    }

    @RequestMapping("/toMyAvatar.action")
    public String toMyAvatar(HttpServletRequest request) {

        return "user/backend/avatar.jsp";
    }

    @RequestMapping("/toMyTags.action")
    public String toMyTags(HttpServletRequest request, Integer pageNo) {

        if (pageNo == null || pageNo < 1) {
            pageNo = 1;
        }

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentLoginUser");

        Page<Tag> pageTags = tagService.selectAll(user.getUserId(), pageNo);

        List<Integer> pageNums = PageNumberGenerator.generator(pageTags.getCurrentPage(), pageTags.getTotalPageNum());

        request.setAttribute("pageTags", pageTags);
        request.setAttribute("pageNums", pageNums);

        return "user/backend/tags.jsp";
    }

    @RequestMapping("/toMyArticles.action")
    public String toMyArticles(HttpServletRequest request, Integer pageNo) {

        if (pageNo == null || pageNo < 1) {
            pageNo = 1;
        }

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentLoginUser");

        Page<Article> pageArticles = articleService.selectArticles(user.getUserId(), pageNo);

        List<Integer> pageNums = PageNumberGenerator.generator(pageArticles.getCurrentPage(), pageArticles.getTotalPageNum());

        List<Tag> tags = tagService.queryAll(user.getUserId());

        request.setAttribute("tags", tags);
        request.setAttribute("pageArticles", pageArticles);
        request.setAttribute("pageNums", pageNums);

        return "user/backend/articles.jsp";
    }

    @RequestMapping("/toWriteArticle.action")
    public String toWriteArticle(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentLoginUser");

        List<Tag> tags = tagService.queryAll(user.getUserId());

        request.setAttribute("tags", tags);

        return "user/backend/write-article.jsp";
    }

    @RequestMapping("/toMyComments.action")
    public String toMyComments(HttpServletRequest request) {

        return "user/backend/comments.jsp";
    }

    @RequestMapping("/toMyCollection.action")
    public String toMyCollection(HttpServletRequest request) {

        return "user/backend/collection.jsp";
    }

    @RequestMapping("/toMyFoucs.action")
    public String toMyFoucs(HttpServletRequest request) {

        return "user/backend/focus.jsp";
    }

    @RequestMapping("/showOtherUserInfo.action")
    public String showOtherUserInfo(Integer userId, HttpServletRequest request) {

        if (userId != null) {
            User user = userService.selectByPrimaryKey(userId);

            request.setAttribute("otherUser", user);

        }

        return "user/other-user-info.jsp";
    }

    @RequestMapping("/getZheTengLinkText.action")
    @ResponseBody
    public String getZheTengLinkText(Integer userId, HttpServletRequest request) {

        User user = userService.selectByPrimaryKey(userId);

        JSONObject jo = new JSONObject();

        String latestFileName = user.getLatestFileName();

        if (latestFileName != null) {
            String jsonFileDirectory = request.getSession().getServletContext().getRealPath("/") +
                    Constants.ZHE_TENG_LINK_FILE_DIR + user.getUserId();

            File file = new File(jsonFileDirectory, latestFileName);
            if (file.exists()) {

                String jsonTxt = JsonUtil.readJson(file);

                jo.put("success", jsonTxt);

                return jo.toJSONString();

            }
        }

        jo.put("success", "false");

        return jo.toJSONString();

    }

}
