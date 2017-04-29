package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Node;

import java.util.List;

public interface NodeDao {

    int deleteByPrimaryKey(Integer nodeId);

    int insert(Node record);

    Node selectByPrimaryKey(Integer nodeId);

    List<Node> selectAll();

    int update(Node record);

}