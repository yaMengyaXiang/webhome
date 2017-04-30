package tech.zhetengrensheng.webhome.core.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import tech.zhetengrensheng.webhome.core.entity.Link;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.LinkService;
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
 * @create 2017-04-30 11:53
 **/
@Controller("linkController")
@RequestMapping("/link")
public class LinkController {

    @Resource
    private LinkService linkService;

    @Resource
    private UserService userService;

    @RequestMapping("/addLink.action")
    public String addLink(Link link, HttpServletRequest request) {

        try {
            Integer userId = link.getUserId();

            if (link != null && link.getSourceNodeId() != null &&
                    link.getTargetNodeId() != null && userId != null) {

                linkService.insert(link);

                List<Link> links = new ArrayList<Link>();
                links.add(link);

                // 生成json数据文件
                String jsonFileDirectory = request.getSession().getServletContext().getRealPath("/") + Constants.ZHE_TENG_LINK_FILE_DIR;
                ZheTengLinkUtil.writeLinks(jsonFileDirectory, userId, links);
                String latestFileName = ZheTengLinkUtil.writeJson(jsonFileDirectory, userId);

                User user = userService.selectByPrimaryKey(userId);
                user.setLatestFileName(latestFileName);
                userService.update(user);

                HttpSession session = request.getSession();
                session.setAttribute("currentLoginUser", user);

                return "/user/backend/link/right.jsp";

            }
        } catch (Exception e) {

        }

        return null;
    }

}
