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
		// TODO shouldn't be word by word but with sentence
		fetchingGram(article, 'trainedgram')
	}

	def relatedbyMaxArticles(Article article) {
		// TODO adding the SCORE !!!!
		// TODO only more than average

		def unigram = getUniGram(article)
		def bigram = getBiGram(article)
		def ngram = getNGram(article)

		def merged = [:]
		unigram.each {
			int score = it.score as int
			it.articles.each { art ->
				if(merged[art]) {
					merged[art] = merged[art] + score
				} else {
					merged[art] = score
				}
			}
		}
		bigram.each {
			int score = it.score as int
			it.articles.each { art ->
				if(merged[art]) {
					merged[art] = merged[art] + score
				} else {
					merged[art] = score
				}
			}
		}
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

		long average = 0
		merged.each { k, v ->
			average += v
		}
		average /= merged.size()

		merged = merged.findAll { it.value > average}
		return merged.sort { a, b -> b.value <=> a.value}
	}
}