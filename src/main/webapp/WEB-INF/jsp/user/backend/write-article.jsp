<%--
  Created by IntelliJ IDEA.
  User: Long
  Date: 2017/4/8
  Time: 12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script type="text/javascript">
    $(function() {

        $(document).foundation();

    });

    function publishArticle(btnObj) {

        var url = $(btnObj).attr("url");

        var title = $("#title").val();
        if (title == "") {
            alert("请填写标题！");
            return;
        }

        var tagId = $("#tagId option:selected").attr("value");
        if (tagId == "") {
            alert("请选择标签！");
            return;
        }

        var keyword = $("#keyword").val();

        // 获取编辑器区域完整html代码
        var articleContent = editor.$txt.html();
        if (articleContent == "") {
            alert("亲，内容还空着呢^_^");
            return;
        }

        var param = {
            "title": title,
            "tagId": tagId,
            "keyword": keyword,
            "articleContent": articleContent,
            "summary": articleContent.substr(0,200)
        };

        $.post(url, param, function (data) {
            var json = jQuery.parseJSON(data);
            if ("false" == json.success) {
                alert("发表文章失败！");
            } else {
                alert("发表文章成功！");
                resetValue();
            }
        });

    }

    function resetValue() {
        $("#title").val("");
        $("#tagId").prop('selectedIndex', 0);
        $("#keyword").val("");

        // 不能传入空字符串，必须传入以下内容
        editor.$txt.html('<p><br></p>');
    }

</script>


<ul class="accordion" data-accordion data-allow-all-closed="true">
    <li class="accordion-item is-active" data-accordion-item>

        <a href="javascript:void(0);" class="accordion-title bg-light-blue">
            <i class="fa fa-pencil-square-o"></i>
            撰写文章
        </a>

        <div class="accordion-content" data-tab-content>

            <div class="row">
                <div class="medium-12 large-6 small-12 columns">
                    <label>
                        标题：<input id="title" type="text" name="title">
                    </label>
                </div>
                <div class="medium-12 large-6 small-12 columns">
                    <label>
                        标签：
                        <select id="tagId" name="tagId">
                            <option value="">请选择...</option>
                            <c:forEach items="${tags}" var="tag">
                                <option title="${tag.description}" value="${tag.tagId}">${tag.tagName}</option>
                            </c:forEach>
                        </select>
                    </label>
                </div>
            </div>

            <div class="row row-margin-bottom-10">
                <div class="medium-12 large-12 small-12 columns">
                    <label>内容：</label>
                    <div class="padding-10-div" id="wang-editor" style="min-height: 200px;">
                    </div>
                    <script type="text/javascript">
                        var editor = new wangEditor("wang-editor");

                        editor.config.menus = [
                            'source',
                            '|',
                            'bold',
                            'underline',
                            'italic',
                            'strikethrough',
                            'eraser',
                            'forecolor',
                            'bgcolor',
                            '|',
                            'quote',
                            'fontfamily',
                            'fontsize',
                            'head',
                            'unorderlist',
                            'orderlist',
                            'alignleft',
                            'aligncenter',
                            'alignright',
                            '|',
                            'link',
                            'unlink',
                            'table',
                            'emotion',
                            '|',
                            'img',
                            'video',
                            'insertcode',
                            '|',
                            'undo',
                            'redo',
                            'fullscreen'
                        ];

                        // 关闭菜单栏fixed
                        editor.config.menuFixed = false;

                        // 上传图片
                        editor.config.uploadImgUrl = '/upload';

                        editor.config.emotions = {
                            'default': {
                                title: '默认',
                                data: '${pageContext.request.contextPath}/static/emotions/emotions.data'
                            }
                        };

                        editor.create();

                        editor.$txt.html('<p><br></p>');

                        // 自定义命令
                        editor.customCommand = override.wangEditor.customCommand();
                    </script>
                </div>
            </div>

            <div class="row">
                <div class="medium-12 large-6 small-12 columns">
                    <label>
                        关键字：( 多个关键字以空格隔开 )
                        <input id="keyword" type="text" name="keyword">
                    </label>
                </div>
                <div class="medium-12 large-6 small-12 columns">
                    <button url="${pageContext.request.contextPath}/article/saveOrUpdateArticle.action"
                            class="button" onclick="publishArticle(this)" style="margin-top: 24px;">发表文章</button>
                </div>
            </div>

        </div>
    </li>
</ul>
