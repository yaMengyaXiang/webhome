package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.TagDao;
import tech.zhetengrensheng.webhome.core.entity.Tag;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.TagService;
import tech.zhetengrensheng.webhome.core.util.Page;
import tech.zhetengrensheng.webhome.core.util.PageNumberGenerator;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public Page<Tag> selectAll(Integer userId, Integer pageNo) {

        Page<Tag> pageTags = new Page<Tag>(pageNo);

        Map<String, Object> conditions = new HashMap<String, Object>(1);
        conditions.put("userId", userId);

        pageTags.setConditions(conditions);

        List<Tag> tags = tagDao.selectAll(pageTags);

        pageTags.setResults(tags);

        return pageTags;
    }

    @Override
    public List<Tag> queryAll(Integer userId) {
        return tagDao.queryAll(userId);
    }
}
