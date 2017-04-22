package tech.zhetengrensheng.webhome.core.service;

import tech.zhetengrensheng.webhome.core.entity.Comment;
import tech.zhetengrensheng.webhome.core.util.Page;

import java.util.List;

/**
 * Created by Long on 2017-04-22.
 */
public interface CommentService {

    int deleteByPrimaryKey(Long commentId);

    int insert(Comment record);

    Comment selectByPrimaryKey(Long commentId);

    List<Comment> selectDirectComments(Page<Comment> page);

    List<Comment> selectSubComments(Page<Comment> page);

    int update(Comment record);

}
