package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Link;

public interface LinkDao {

    int deleteByPrimaryKey(Integer linkId);

    int insert(Link record);

    Link selectByPrimaryKey(Integer linkId);

    int update(Link record);

}