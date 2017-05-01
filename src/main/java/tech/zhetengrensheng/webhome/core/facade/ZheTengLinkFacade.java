package tech.zhetengrensheng.webhome.core.facade;

import org.springframework.stereotype.Component;
import tech.zhetengrensheng.webhome.core.entity.Category;
import tech.zhetengrensheng.webhome.core.entity.Link;
import tech.zhetengrensheng.webhome.core.entity.Node;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.CategoryService;
import tech.zhetengrensheng.webhome.core.service.LinkService;
import tech.zhetengrensheng.webhome.core.service.NodeService;
import tech.zhetengrensheng.webhome.core.service.UserService;
import tech.zhetengrensheng.webhome.core.util.ZheTengLinkUtil;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 折腾链操作的一个门面，降低折腾链的相关service的耦合性
 *
 * @author Long
 * @create 2017-05-01 16:55
 **/
@Component("zheTengLinkFacade")
public class ZheTengLinkFacade {

    @Resource
    private CategoryService categoryService;

    @Resource
    private NodeService nodeService;

    @Resource
    private LinkService linkService;

    @Resource
    private UserService userService;

    public void addOrEditCategory(Category category, String jsonDataDir, Integer userId) throws Exception {

        List<Category> categories;

        boolean flag = category.getCategoryId() != null;
        if (flag) {
            // update
            categoryService.update(category);

            // 重新查询出来
            categories = categoryService.selectByUserId(userId);

        } else {
            // save
            categoryService.insert(category);

            // 不重新查询，直接添加
            categories = new ArrayList<Category>();
            categories.add(category);
        }

        ZheTengLinkUtil.register(jsonDataDir, userId);

        // 根据flag的值决定是要把内容清空再添加，还是直接追加，true表示清空再添加
        ZheTengLinkUtil.writeCategories(categories, flag);
        String latestFileName = ZheTengLinkUtil.writeJson();

        User user = new User();
        user.setUserId(userId);
        user.setLatestFileName(latestFileName);
        userService.update(user);

    }

    public void addOrEditNode(Node node, String jsonDataDir, Integer userId) throws Exception {

        List<Node> nodes;

        boolean flag = node.getNodeId() != null;
        if (flag) {
            // update
            nodeService.update(node);

            // 重新查询出来
            nodes = nodeService.selectByUserId(userId);

        } else {
            // save
            nodeService.insert(node);

            // 不重新查询，直接添加
            nodes = new ArrayList<Node>();
            nodes.add(node);
        }

        // 生成json数据文件
        ZheTengLinkUtil.register(jsonDataDir, userId);
        // 根据flag的值决定是要把内容清空再添加，还是直接追加，true表示清空再添加
        ZheTengLinkUtil.writeNodes(nodes, flag);
        String latestFileName = ZheTengLinkUtil.writeJson();

        User user = new User();
        user.setUserId(userId);
        user.setLatestFileName(latestFileName);
        userService.update(user);

    }

    public void addOrEditLink(Link link, String jsonDataDir, Integer userId) throws Exception {

        List<Link> links;

        boolean flag = link.getLinkId() != null;
        if (flag) {
            // update
            linkService.update(link);

            // 重新查询出来
            links = linkService.selectByUserId(userId);

        } else {
            // save
            linkService.insert(link);

            // 不重新查询，直接添加
            links = new ArrayList<Link>();
            links.add(link);
        }

        // 生成json数据文件
        ZheTengLinkUtil.register(jsonDataDir, userId);
        ZheTengLinkUtil.writeLinks(links, flag);
        String latestFileName = ZheTengLinkUtil.writeJson();

        User user = new User();
        user.setUserId(userId);
        user.setLatestFileName(latestFileName);
        userService.update(user);

    }


    public void deleteCategoryById(Integer categoryId, String jsonDataDir, Integer userId) throws Exception {

        categoryService.deleteByPrimaryKey(categoryId);

        List<Category> categories = categoryService.selectByUserId(userId);

        // 生成json数据文件
        ZheTengLinkUtil.register(jsonDataDir, userId);
        // 根据flag的值决定是要把内容清空再添加，还是直接追加，true表示清空再添加
        ZheTengLinkUtil.writeCategories(categories, true);
        String latestFileName = ZheTengLinkUtil.writeJson();

        User user = new User();
        user.setUserId(userId);
        user.setLatestFileName(latestFileName);
        userService.update(user);

    }

    /**
     * 删除节点时把相应的链也删除掉
     * @param nodeId
     * @param jsonDataDir
     * @param userId
     * @throws Exception
     */
    public void deleteNodeById(Integer nodeId, String jsonDataDir, Integer userId) throws Exception {

        linkService.deleteByNodeId(nodeId);

        nodeService.deleteByPrimaryKey(nodeId);

        List<Node> nodes = nodeService.selectByUserId(userId);
        List<Link> links = linkService.selectByUserId(userId);

        // 生成json数据文件
        ZheTengLinkUtil.register(jsonDataDir, userId);
        // 根据flag的值决定是要把内容清空再添加，还是直接追加，true表示清空再添加
        ZheTengLinkUtil.writeNodes(nodes, true);
        ZheTengLinkUtil.writeLinks(links, true);
        String latestFileName = ZheTengLinkUtil.writeJson();

        User user = new User();
        user.setUserId(userId);
        user.setLatestFileName(latestFileName);
        userService.update(user);

    }

    public void deleteLinkById(Integer linkId, String jsonDataDir, Integer userId) throws Exception {

        linkService.deleteByPrimaryKey(linkId);

        List<Link> links = linkService.selectByUserId(userId);

        // 生成json数据文件
        ZheTengLinkUtil.register(jsonDataDir, userId);
        // 根据flag的值决定是要把内容清空再添加，还是直接追加，true表示清空再添加
        ZheTengLinkUtil.writeLinks(links, true);
        String latestFileName = ZheTengLinkUtil.writeJson();

        User user = new User();
        user.setUserId(userId);
        user.setLatestFileName(latestFileName);
        userService.update(user);

    }

}
