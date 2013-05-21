package thepieuvre.core

import redis.clients.jedis.Jedis

class ArticleService {

	static transactional = false

	def redisService 

	private def fetchingGram(Article article, String type) {
		log.info "Redis - Fetching articles"
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
						def artId = art.split(':')[1] 
						if (artId) {
							elem.articles << Article.get(artId as long)
						}
					}
				}
				elem.articles.unique()
				res << elem
			}
		}
		log.info "Redis - Fetched articles"
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

	def metrics(def articles) {
		def metrics = [:]
		long max = 0
		long average = 0
		long sumSq = 0
		long counter = 0
		articles.each {
			// max
			if (it.value > max)
				max = it.value
			// average
			average += it.value
			// Std Dev
			sumSq += it.value * it.value
			counter++
		}
		metrics.max = max
		metrics.average = (counter > 0)?(average/counter):0
		metrics.stdDev = (counter > 0)?((sumSq/counter - (average/counter)**2)**0.5):0
		return metrics
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
		//def unigram = getUniGram(article)
		//def bigram = getBiGram(article)
		def ngram = getNGram(article)
		//def trainedgram = getTrainedGram(article)

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

	def synopsis(Article article) {
		def synopsis = []
		def parts = getTrainedGram(article)
		def keyWords = getNGram(article)
		parts*.name.each { part ->
			keyWords*.name.each { keyWord ->
				def cleaned = part.replaceAll('\\p{Punct}', '')
				if (cleaned.matches("${keyWord.replaceAll('\\p{Punct}', '').split('\\s').join('.*')}")) {
					synopsis.add(cleaned)
				}
			}
		}
		return synopsis.join('<em>[...]</em>')
		//*.name.collect { if (it in articleService.getNGram(article)*.name){"<strong>${it}</strong>"} else {it}}.join('[...]')
	}

	def similars(Article article) {
		log.info "Article Service - Finding similars"
		def all = mergingAll(article)
		def metrics = metrics(all)
		long upper = metrics.max //getMaxScore(all)
		long stdDev = metrics.stdDev//getStdDevScore(all)
		long lower = upper - stdDev
		def res = [:]
		all.each { k, v ->
			if (v <= upper && v >= lower)
				res[k] = v
		}
		res = res.sort { a, b -> b.value <=> a.value}
		log.info "Article Service - Found similars"
		return res
	}

	def related(Article article) {
		def all = mergingAll(article)
		def metrics = metrics(all)
		long dev = metrics.stdDev
		long upper = metrics.max - dev 
		long lower = metrics.average + dev
		def res = [:]
		all.each { k, v ->
			if (v < upper && v >= lower)
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