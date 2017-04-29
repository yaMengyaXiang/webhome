package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.NodeDao;
import tech.zhetengrensheng.webhome.core.entity.Node;
import tech.zhetengrensheng.webhome.core.service.NodeService;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Long
 * @create 2017-04-29 22:16
 **/
@Service("nodeService")
public class NodeServiceImpl implements NodeService {

    @Resource
    private NodeDao nodeDao;

    @Override
    @Transactional
    public int deleteByPrimaryKey(Integer nodeId) {
        return nodeDao.deleteByPrimaryKey(nodeId);
    }

    @Override
    @Transactional
    public int insert(Node record) {
        return nodeDao.insert(record);
    }

    @Override
    public Node selectByPrimaryKey(Integer nodeId) {
        return nodeDao.selectByPrimaryKey(nodeId);
    }

    @Override
    public List<Node> selectAll() {
        return nodeDao.selectAll();
    }

    @Override
    @Transactional
    public int update(Node record) {
        return nodeDao.update(record);
    }
}
