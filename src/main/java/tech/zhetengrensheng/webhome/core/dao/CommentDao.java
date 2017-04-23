package tech.zhetengrensheng.webhome.core.dao;

import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.util.Page;

import java.util.List;

public interface CommentDao {

    int deleteByPrimaryKey(Long commentId);

    int insert(Comment record);

    Comment selectByPrimaryKey(Long commentId);

    /**
     * 获取直接的楼层回复
     * @param page
     * @return
     */
    List<Comment> selectDirectComments(Page<Comment> page);

    /**
     * 获取楼中楼回复
     * @param page
     * @return
     */
    List<Comment> selectSubComments(Page<Comment> page);

    /**
     * 获取楼中楼回复的数量，
     * @param commentParentId 表示某个回复的id
     * @return
     */
    Integer selectSubCommentsCount(Long commentParentId);

    /**
     * 查询该回复处于哪一楼
     * @param commentId
     * @return
     */
    String selectCommentNum(Long commentId);

    int update(Comment record);

}