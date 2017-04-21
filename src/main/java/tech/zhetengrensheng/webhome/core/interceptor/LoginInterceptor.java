package tech.zhetengrensheng.webhome.core.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import tech.zhetengrensheng.webhome.core.util.UrlUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Created by Long on 2017/4/8.
 * 用户登陆验证拦截器
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");

        if (user != null) {
            return true;
        }

        String requestURI = request.getRequestURI();
        request.getSession().setAttribute("requestURI", requestURI);

        // 用户为登录，转发到登录界面
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        // 保存前一个页面
        String fromUri = UrlUtil.getFromUri(request);
        request.getSession().setAttribute("fromUri", fromUri);

        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
