package tech.zhetengrensheng.webhome.core.controller.admin;/**
 * Created by Long on 2017-04-28.
 */

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 处理系统的一些请求的Controller
 *
 * @author Long
 * @create 2017-04-28 23:40
 **/
@Controller("systemController")
public class SystemController {

    @RequestMapping("/tmp.jsp")
    public String toIndex() {

        System.out.println("to Index");

        return "forward:/index.jsp";
    }

}
