package thepieuvre.util.article

public interface Sorter {

	/**
	 * @return sorts the articles.
	 */
	public Map sorting()

	/**
	 * @return the articles sorted from last <code>sorting()</code>'s call, sort the articles else.
	 */
	public Map sorted()

}