package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.User;

import java.util.List;
import java.util.Map;

public interface UserDao {

    /**
     * 通过主键删除
     * @param userId
     * @return
     */
    Integer deleteByPrimaryKey(Integer userId);

    /**
     * 插入记录
     * @param record
     * @return
     */
    Integer insert(User record);

    /**
     * 通过主键查询
     * @param userId
     * @return
     */
    User selectByPrimaryKey(Integer userId);

    /**
     * 更新
     * @param record
     * @return
     */
    Integer update(User record);

    /**
     * 通过值唯一的字段查询对应实体的id
     * @param uniqueField
     * @return
     */
    Integer selectId(String uniqueField);

    /**
     * 多条件查询
     * @param conditions
     * @return
     */
    List<User> selectByConditions(Map<String, Object> conditions);

    /**
     * 通过唯一的字段查询一条记录
     * @param uniqueField
     * @return
     */
    User selectByUniqueField(String uniqueField);

}