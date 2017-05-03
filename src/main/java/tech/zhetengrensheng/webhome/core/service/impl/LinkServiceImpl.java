package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.LinkDao;
import tech.zhetengrensheng.webhome.core.entity.Link;
import tech.zhetengrensheng.webhome.core.service.LinkService;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author Long
 * @create 2017-04-29 22:12
 **/
@Service("linkService")
public class LinkServiceImpl implements LinkService{

    @Resource
    private LinkDao linkDao;

    @Override
    @Transactional
    public int deleteByPrimaryKey(Integer linkId) {
        return linkDao.deleteByPrimaryKey(linkId);
    }

    @Override
    public int deleteByNodeId(Integer nodeId) {
        return linkDao.deleteByNodeId(nodeId);
    }

    @Override
    @Transactional
    public int insert(Link record) {
        return linkDao.insert(record);
    }

    @Override
    public Link selectByPrimaryKey(Integer linkId) {
        return linkDao.selectByPrimaryKey(linkId);
    }

    @Override
    public List<Link> selectByUserId(Integer userId) {
        return linkDao.selectByUserId(userId);
    }

    @Override
    public List<Link> selectCheckForInsert(Map<String, Integer> map) {
        return linkDao.selectCheckForInsert(map);
    }

    @Override
    @Transactional
    public int update(Link record) {
        return linkDao.update(record);
    }
}
