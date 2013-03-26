package thepieuvre.core

import redis.clients.jedis.Jedis

class ArticleService {

	static transactional = false

	def redisService 

	private def fetchingGram(Article article, String type) {
		def res = []
		redisService.withRedis { Jedis redis ->
			String key = "article:$article.id:$type"
			long end = redis.zcard(key)
			redis.zrevrangeWithScores(key, 0, end). each {
				def elem = [:]
				elem.name = it.getElement()
				elem.score = it.getScore()
				elem.articles = []
				String chunk = ""
				long last = redis.llen("chunk:$type:$elem.name")
				redis.lrange("chunk:$type:$elem.name", 0, last) .each { art ->
					if (art != "article:$article.id") {
						elem.articles << Article.get(art.split(':')[1] as long)
					}
				}
				elem.articles.unique()
				res << elem
			}
		}
		return res
	}

	def getUniGram(Article article) {
		fetchingGram(article, 'unigram')
	}

	def getBiGram(Article article) {
		fetchingGram(article, 'bigram')
	}

	def getNGram(Article article) {
		fetchingGram(article, 'ngram')
	}

	def getTrainedGram(Article article) {
		fetchingGram(article, 'trainedgram')
	}

	long getMaxScore(def articles) {
		long max = 0
		articles.each {
			if (it.value > max)
				max = it.value
		}
		return max
	}

	long getAvgScore(def articles) {
		long average = 0
		articles.each {
			average += it.value
		}
		if (articles.size() > 0) {
			average /= articles.size()
		}
		return average
	}

	long getStdDevScore(def articles) {
		long sum = 0
		long sumSq = 0
		long counter = 0
		articles.each {
			sum += it.value
			sumSq += it.value * it.value
			counter++
		}
		if (counter > 0) {
			return (sumSq/counter - (sum/counter)**2)**0.5
		} else {
				return 0
		}
	}

	private def mergingAll(Article article) {
		def unigram = getUniGram(article)
		def bigram = getBiGram(article)
		def ngram = getNGram(article)
		def trainedgram = getTrainedGram(article)

		def merged = [:]
		// unigram.each {
		// 	int score = it.score as int
		// 	it.articles.each { art ->
		// 		if(merged[art]) {
		// 			merged[art] = merged[art] + score
		// 		} else {
		// 			merged[art] = score
		// 		}
		// 	}
		// }
		// bigram.each {
		// 	int score = it.score as int
		// 	it.articles.each { art ->
		// 		if(merged[art]) {
		// 			merged[art] = merged[art] + score
		// 		} else {
		// 			merged[art] = score
		// 		}
		// 	}
		// }
		ngram.each {
			int score = it.score as int
			it.articles.each { art ->
				if(merged[art]) {
					merged[art] = merged[art] + score
				} else {
					merged[art] = score
				}
			}
		}
		// trainedgram.each {
		// 	int score = it.score as int
		// 	it.articles.each { art ->
		// 		if(merged[art]) {
		// 			merged[art] = merged[art] + score
		// 		} else {
		// 			merged[art] = score
		// 		}
		// 	}
		// }

		return merged
	}

	def similars(Article article) {
		def all = mergingAll(article)
		long upper = getMaxScore(all)
		long stdDev = getStdDevScore(all)
		long lower = upper - stdDev
		def res = [:]
		all.each { k, v ->
			if (v <= upper && v >= lower)
				res[k] = v
		}
		return res.sort { a, b -> b.value <=> a.value}
	}

	def related(Article article) {
		def all = mergingAll(article)
		long dev = getStdDevScore(all)
		long upper = getMaxScore(all) - dev 
		long lower = getAvgScore(all) + dev
		def res = [:]
		all.each { k, v ->
			if (v <= upper && v >= lower)
				res[k] = v
		}
		return res.sort { a, b -> b.value <=> a.value}
	}

	def relatedbyMaxArticles(Article article) {
		// TODO adding the SCORE !!!!
		// TODO only more than average

		def merged = mergingAll(article)

		//long average = 0
		//merged.each { k, v ->
		//	average += v
		//}
		//if (merged.size() > 0) {
		//	average /= merged.size()
		//}
		//merged = merged.findAll { it.value > average}
		return merged.sort { a, b -> b.value <=> a.value}
	}

	def getArticleFromNGram(String ngram) {
		def res = []
		redisService.withRedis { Jedis redis ->
			String key = "chunk:ngram:$ngram"
			long last = redis.llen(key)
			redis.lrange(key, 0, last) .each { art ->
				res.add(Article.get(art.split(':')[1] as long))
			}
		}
		return res.unique()
	}
}