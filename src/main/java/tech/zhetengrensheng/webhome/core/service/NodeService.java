package tech.zhetengrensheng.webhome.core.service;/**
 * Created by Long on 2017-04-29.
 */

import tech.zhetengrensheng.webhome.core.entity.Node;

import java.util.List;

/**
 * @author Long
 * @create 2017-04-29 22:12
 **/
public interface NodeService {

    int deleteByPrimaryKey(Integer nodeId);

    int insert(Node record);

    Node selectByPrimaryKey(Integer nodeId);

    List<Node> selectAll();

    int update(Node record);

}
