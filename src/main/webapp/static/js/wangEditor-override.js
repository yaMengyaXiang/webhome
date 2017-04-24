/**
 * Created by Long on 2017-04-24.
 */

/**
 * 重写编辑器里面的某些命令，方法
 * @type {Function}
 */
var override = {

    wangEditor : {
        customCommand: function () {

            /**
             * 自定义命令
             * @param e
             * @param commandFn
             * @param callback
             */
            function overrideCustomCommand(e, commandFn, callback) {
                var editor = this;
                var range = editor.currentRange();

                if (!range) {
                    // 目前没有选区，则无法执行命令
                    e && e.preventDefault();
                    return;
                }
                // 记录内容，以便撤销（执行命令之前就要记录）
                editor.undoRecord();

                // 恢复选区（有 range 参数）
                this.restoreSelection(range);

                // 执行命令事件
                commandFn.call(editor);

                // 保存选区（无参数，要从浏览器直接获取range信息）
                this.saveSelection();
                // 重新恢复选区（无参数，要取得刚刚从浏览器得到的range信息）
                this.restoreSelection();

                // 执行 callback
                if (callback && typeof callback === 'function') {
                    callback.call(editor);
                }

                // 最后插入空行
                // editor.txt.insertEmptyP();   // 不插入空行

                // 包裹暴露的img和text
                editor.txt.wrapImgAndText();

                // 更新内容
                editor.updateValue();

                // 更新菜单样式
                editor.updateMenuStyle();

                // 隐藏 dropPanel dropList modal  设置 200ms 间隔
                function hidePanelAndModal() {
                    editor.hideDropPanelAndModal();
                }
                setTimeout(hidePanelAndModal, 200);

                if (e) {
                    e.preventDefault();
                }
            }

            return overrideCustomCommand;
        }
    }

};
