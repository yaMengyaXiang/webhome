package tech.zhetengrensheng.webhome.core.entity;

/**
 * 折腾链
 */
public class Link {

    private Integer linkId;

    private Integer sourceNodeId;

    private Integer targetNodeId;

    private Integer userId;

    public Integer getLinkId() {
        return linkId;
    }

    public void setLinkId(Integer linkId) {
        this.linkId = linkId;
    }

    public Integer getSourceNodeId() {
        return sourceNodeId;
    }

    public void setSourceNodeId(Integer sourceNodeId) {
        this.sourceNodeId = sourceNodeId;
    }

    public Integer getTargetNodeId() {
        return targetNodeId;
    }

    public void setTargetNodeId(Integer targetNodeId) {
        this.targetNodeId = targetNodeId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}