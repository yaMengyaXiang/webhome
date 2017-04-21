package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.TagDao;
import tech.zhetengrensheng.webhome.core.entity.Tag;
import tech.zhetengrensheng.webhome.core.service.TagService;
import tech.zhetengrensheng.webhome.core.util.Page;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by Long on 2017/4/9.
 */
@Service("tagService")
public class TagServiceImpl implements TagService {

    @Resource(name = "tagDao")
    private TagDao tagDao;

    @Override
    @Transactional
    public int deleteByPrimaryKey(Integer tagId) {
        return tagDao.deleteByPrimaryKey(tagId);
    }

    @Override
    @Transactional
    public int deleteTags(Integer[] tagIds) {
        return tagDao.deleteTags(tagIds);
    }

    @Override
    @Transactional
    public int insert(Tag record) {
        return tagDao.insert(record);
    }

    @Override
    public Tag selectByPrimaryKey(Integer tagId) {
        return tagDao.selectByPrimaryKey(tagId);
    }

    @Override
    @Transactional
    public int update(Tag record) {
        return tagDao.update(record);
    }

    @Override
    public List<Tag> selectAll(Page<Tag> page) {
        return tagDao.selectAll(page);
    }

    @Override
    public List<Tag> queryAll(Integer userId) {
        return tagDao.queryAll(userId);
    }
}
