package tech.zhetengrensheng.webhome.core.controller;

import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import tech.zhetengrensheng.webhome.core.entity.Node;
import tech.zhetengrensheng.webhome.core.service.NodeService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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

    @RequestMapping("/addNode.action")
    public String addNode(Node node) {

        try {
            if (node != null && node.getUserId() != null && node.getCategoryId() != null &&
                    !StringUtils.isEmpty(node.getNodeName()) &&
                    !StringUtils.isEmpty(node.getNodeColor())) {

                nodeService.insert(node);

                return "/user/backend/link/right.jsp";

            }
        } catch (Exception e) {

        }
        return null;
    }

    @RequestMapping("/showAllNodes.action")
    public String showAllNodes(HttpServletRequest request) {

        List<Node> nodes = nodeService.selectAll();

        request.setAttribute("nodes", nodes);

        return "/user/backend/link/link.jsp";
    }

}
