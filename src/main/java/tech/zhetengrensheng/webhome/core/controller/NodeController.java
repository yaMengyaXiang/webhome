package tech.zhetengrensheng.webhome.core.controller;

import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import tech.zhetengrensheng.webhome.core.entity.Node;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.NodeService;
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
 * @create 2017-04-30 1:06
 **/
@Controller("nodeController")
@RequestMapping("/node")
public class NodeController {

    @Resource
    private NodeService nodeService;

    @Resource
    private UserService userService;

    @RequestMapping("/addOrEditNode.action")
    public String addOrEditNode(Node node, HttpServletRequest request) {

        try {
            Integer userId = node.getUserId();

            if (node != null && userId != null && node.getCategoryId() != null &&
                    !StringUtils.isEmpty(node.getNodeName()) &&
                    !StringUtils.isEmpty(node.getNodeColor())) {

                nodeService.insert(node);

                List<Node> nodes = new ArrayList<Node>();
                nodes.add(node);

                // 生成json数据文件
                String jsonFileDirectory = request.getSession().getServletContext().getRealPath("/") + Constants.ZHE_TENG_LINK_FILE_DIR;
                ZheTengLinkUtil.writeNodes(jsonFileDirectory, userId, nodes);
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

    @RequestMapping("/showAllNodes.action")
    public String showAllNodes(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentLoginUser");

        List<Node> nodes = nodeService.selectByUserId(user.getUserId());

        request.setAttribute("nodes", nodes);

        return "/user/backend/link/link.jsp";
    }

    @RequestMapping("/deleteNode.action")
    public String deleteNode(Integer nodeId) {

        try {
            if (nodeId != null) {
                nodeService.deleteByPrimaryKey(nodeId);
            }

            return "/user/backend/link/right.jsp";

        } catch (Exception e) {
        }

        return "/user/backend/link/right.jsp";

    }

}
