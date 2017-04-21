package tech.zhetengrensheng.webhome.core.util;

import java.util.ArrayList;
import java.util.List;

/**
 * 页数生成器
 * @author Long
 *
 * 2017年2月24日 下午7:49:40
 */
public class PageNumberGenerator {

	/**
	 * 根据当前页数生成该页邻近的页数
	 * @param currentPage
	 * @return
	 */
	public static List<Integer> generator(int currentPage, int maxPageNum) {
		List<Integer> pageNums = new ArrayList<Integer>(Constants.MAX_PAGE_NUM_SIZE);
		
		// 把currentPage当前位于中间的页数，得出它左右两边的页数
		int sideNum = Constants.MAX_PAGE_NUM_SIZE >> 1;
		int leftSideNum = sideNum;
		int rightSideNum = sideNum;
		
		// 左边sideNum个
		for (int i = currentPage - leftSideNum; i < currentPage; i++) {
			if (i >= 1) {
				pageNums.add(i);
			}
		}
		
		// 中间一个
		pageNums.add(currentPage);
		
		// 右边不一定sideNum个
		for (int i = currentPage + 1; i <= currentPage + rightSideNum; i++) {
			// 保证个数不超过Constants.MAX_PAGE_NUM_SIZE
			if (i <= maxPageNum && pageNums.size() < Constants.MAX_PAGE_NUM_SIZE) {
				pageNums.add(i);
			}
		}
		
		return pageNums;
	}
	
}
