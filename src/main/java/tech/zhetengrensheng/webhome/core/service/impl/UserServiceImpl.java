package tech.zhetengrensheng.webhome.core.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.zhetengrensheng.webhome.core.dao.UserDao;
import tech.zhetengrensheng.webhome.core.entity.User;
import tech.zhetengrensheng.webhome.core.service.UserService;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by Long on 2017/3/26.
 */
@Service("userService")
public class UserServiceImpl implements UserService {

    @Resource(name = "userDao")
    private UserDao userDao;

    @Override
    @Transactional
    public Integer deleteByPrimaryKey(Integer userId) {
        return userDao.deleteByPrimaryKey(userId);
    }

    @Override
    @Transactional
    public Integer insert(User record) {
        return userDao.insert(record);
    }

    @Override
    public User selectByPrimaryKey(Integer userId) {
        return userDao.selectByPrimaryKey(userId);
    }

    @Override
    @Transactional
    public Integer update(User record) {
        return userDao.update(record);
    }

    @Override
    public Integer selectId(String uniqueField) {
        return userDao.selectId(uniqueField);
    }

    @Override
    public List<User> selectByConditions(Map<String, Object> conditions) {
        return userDao.selectByConditions(conditions);
    }

    @Override
    public User selectByUniqueField(String uniqueField) {
        return userDao.selectByUniqueField(uniqueField);
    }
}
