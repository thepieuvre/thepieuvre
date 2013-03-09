package thepieuvre.core

import grails.converters.JSON
import redis.clients.jedis.Jedis

class QueuesService {

	static transactional = true

	def redisService

	static final Map queues = [
		'thepieuvre.core.Feed' : 'feeder',
		'Python: feeder' : 'feedparser'
	]

	def enqueue(def task) {
		def queue = queues[task.class.getName()]
		log.debug "Queue found is $queue"
		if (queue) {
			redisService.withRedis { Jedis redis ->
				log.info "Adding $task to queue $queue"
				return redis.rpush("queue:${queue}", (task as JSON).toString())
			}
		} else {
			log.error "No queue binded for class ${task.class.getName()}"
			return false
		}
		
	}

	def create(String queueName) {
		redisService.withRedis { Jedis redis ->
			if(redis.sadd('queues', queueName)) {
				log.info "$queueName added to queues"
			}
		}
	}

	def clear(String queueName) {
		redisService.withRedis { Jedis redis ->
			redis.del('queues', "queue:$queueName")
		}
		log.info "$queueName cleared"
		return true
	}

	def clearAll() {
		queues.each { k, v ->
			clear(v)
		}
		return true
	}

	def destroy(String queueName) {
		clear(queueName)
		redisService.withRedis { Jedis redis ->
			redis.srem("queues", "queue:${queueName}")
		}
		log.info "$queueName destroyed"
		return true
	}

	def length(String queueName) {
		redisService.withRedis { Jedis redis ->
			return redis.llen("queue:${queueName}")
		}
	}

}