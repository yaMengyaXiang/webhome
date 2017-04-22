package tech.zhetengrensheng.webhome.core.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 分页
 * 
 * @author Long
 * 
 *         2017年1月16日 上午9:41:17
 */
public class Page<T> {

	private int currentPage; // 当前页
	private int pageSize = Constants.PAGE_SIZE; // 一页显示记录数
	private int totalPageNum; // 总页数
	private int totalResults; // 总记录数
	private int startIndex; // 起始索引

	private List<T> results; // 存放的数据

	private List<Integer> pageNums;	// 分页按钮

	private Map<String, Object> conditions;	// 存放查询的条件，key -- 字段名，value -- 字段值

	public Page(int currentPage) {
		this.currentPage = currentPage;
	}

	public Page(int currentPage, int totalResults) {

		this.currentPage = currentPage;
		countOtherProperties(totalResults);
	}

	public void countOtherProperties(int totalResults) {
		this.totalResults = totalResults;

		if (this.totalResults > 0) {
			if (this.totalResults % pageSize == 0) {
				this.totalPageNum = this.totalResults / pageSize;
			} else {
				this.totalPageNum = this.totalResults / pageSize + 1;
			}

			this.currentPage = this.currentPage > totalPageNum ? totalPageNum : currentPage;

			this.startIndex = (this.currentPage - 1) * pageSize;
		} else {
			this.totalPageNum = 0;
			this.currentPage = 1;
			this.startIndex = 0;
		}
	}

	public List<Integer> getPageNums() {
		return pageNums;
	}

	public void setPageNums(List<Integer> pageNums) {
		this.pageNums = pageNums;
	}

	public Map<String, Object> getConditions() {
		return conditions;
	}

	/**
	 * 设置conditions时，会将该Map里驼峰命名的key转换成数据库表中的字段
	 * @param conditions
	 */
	public void setConditions(Map<String, Object> conditions) {
		Map<String, Object> fieldCondition = new HashMap<String, Object>(conditions.size());

		if (conditions != null && !conditions.isEmpty()) {
			for (Map.Entry entry : conditions.entrySet()) {

				String key = ((String) entry.getKey()).replaceAll("[A-Z]", "_$0").toLowerCase();
				Object value = entry.getValue();

				fieldCondition.put(key, value);

			}
		}

		this.conditions = fieldCondition;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalPageNum() {
		return totalPageNum;
	}

	public void setTotalPageNum(int totalPageNum) {
		this.totalPageNum = totalPageNum;
	}

	public int getTotalResults() {
		return totalResults;
	}

	public void setTotalResults(int totalResults) {
		this.totalResults = totalResults;
	}

	public int getStartIndex() {
		return startIndex;
	}

	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	public List<T> getResults() {
		return results;
	}

	public void setResults(List<T> results) {
		this.results = results;
	}

}
