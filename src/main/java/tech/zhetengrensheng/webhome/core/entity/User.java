package tech.zhetengrensheng.webhome.core.entity;

import java.io.Serializable;

/**
 * 用户实体
 * Created by Long on 2017/3/26.
 */
public class User implements Serializable {

    private Integer userId;     // 用户编号
    private String username;    // 用户名唯一
    private String password;    // 数据库密码加密
    private String mailbox;     // 邮箱地址
    private String description; // 个人描述
    private String signature;   // 个性签名

    public User() {
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMailbox() {
        return mailbox;
    }

    public void setMailbox(String mailbox) {
        this.mailbox = mailbox;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", mailbox='" + mailbox + '\'' +
                ", description='" + description + '\'' +
                ", signature='" + signature + '\'' +
                '}';
    }
}
