package tech.zhetengrensheng.webhome.core.controller;

import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import tech.zhetengrensheng.webhome.core.entity.Node;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.facade.ZheTengLinkFacade;
import tech.zhetengrensheng.webhome.core.service.NodeService;
import tech.zhetengrensheng.webhome.core.service.UserService;
import tech.zhetengrensheng.webhome.core.util.Constants;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @author Long
 * @create 2017-04-30 1:06
 **/
@Controller("nodeController")
@RequestMapping("/node")
public class NodeController {

    @Resource
    private NodeService nodeService;

    @Resource
    private UserService userService;

    @Resource
    private ZheTengLinkFacade zheTengLinkFacade;

    @RequestMapping("/addOrEditNode.action")
    public String addOrEditNode(Node node, HttpServletRequest request) {

        try {
            Integer userId = node.getUserId();

            if (userId != null && !StringUtils.isEmpty(node.getNodeName())
                    && !StringUtils.isEmpty(node.getNodeColor())) {

                // 生成json数据文件
                String jsonFileDirectory = request.getSession().getServletContext().getRealPath("/") + Constants.ZHE_TENG_LINK_FILE_DIR;

                zheTengLinkFacade.addOrEditNode(node, jsonFileDirectory, userId);

                return "/user/backend/link/right.jsp";

            }
        } catch (Exception e) {

        }
        return "/user/backend/link/right.jsp";
    }

    @RequestMapping("/showAllNodes.action")
    public String showAllNodes(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentLoginUser");

        List<Node> nodes = nodeService.selectByUserId(user.getUserId());

        request.setAttribute("nodes", nodes);

        return "/user/backend/link/link.jsp";
    }

    @RequestMapping("/deleteNode.action")
    public String deleteNode(Integer nodeId, HttpServletRequest request) {

        try {
            if (nodeId != null) {

                // 生成json数据文件
                String jsonFileDirectory = request.getSession().getServletContext().getRealPath("/") + Constants.ZHE_TENG_LINK_FILE_DIR;

                HttpSession session = request.getSession(false);
                User user = (User) session.getAttribute("currentLoginUser");

                zheTengLinkFacade.deleteNodeById(nodeId, jsonFileDirectory, user.getUserId());

            }

            return "/user/backend/link/right.jsp";

        } catch (Exception e) {
        }

        return "/user/backend/link/right.jsp";

    }

}
