package tech.zhetengrensheng.webhome.core.util;

/**
 * 常量接口
 * @author Long
 *
 * 2017年1月16日 上午9:45:18
 */
public interface Constants {

	/**
	 * 一页显示记录数量，10条记录
	 */
	public static final Integer PAGE_SIZE = 5;

	/**
	 * 子分页，一页显示记录数，楼中楼回复中用到子分页
	 */
	public static final Integer SUB_PAGE_SIZE = 5;

	/**
	 * 分页按钮的最多数量，比如10表示10个按钮，第1页，第2页，...，第10页
	 */
	public static final Integer MAX_PAGE_NUM_SIZE = 10;

	/**
	 * 折腾链数据文件的名称前缀
	 */
	public static final String ZHE_TENG_LINK_FILE_PREFIX = "zhetenglink_";

	/**
	 * 折腾链数据文件的目录路径，前面应该还有项目名，由request获取
	 */
	public static final String ZHE_TENG_LINK_FILE_DIR = "/static/data/zhetenglink/";

}
