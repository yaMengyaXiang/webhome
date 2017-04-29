package tech.zhetengrensheng.webhome.core.entity;

/**
 * 折腾链的节点
 */
public class Node {

    private Integer nodeId;

    private String nodeName;

    private String nodeDescription;

    private Integer userId;

    private Integer categoryId;

    private String nodeColor;

    public Integer getNodeId() {
        return nodeId;
    }

    public void setNodeId(Integer nodeId) {
        this.nodeId = nodeId;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName == null ? null : nodeName.trim();
    }

    public String getNodeDescription() {
        return nodeDescription;
    }

    public void setNodeDescription(String nodeDescription) {
        this.nodeDescription = nodeDescription == null ? null : nodeDescription.trim();
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getNodeColor() {
        return nodeColor;
    }

    public void setNodeColor(String nodeColor) {
        this.nodeColor = nodeColor == null ? null : nodeColor.trim();
    }
}