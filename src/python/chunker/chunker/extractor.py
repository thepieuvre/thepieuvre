import json
import nltk
import sys
import traceback

from nltk import FreqDist
from nltk.chunk.util import conlltags2tree
from nltk.corpus import conll2000


class ChunkParser(nltk.ChunkParserI): 
	def __init__(self, train_sents):
		train_data = [[(t,c) for w,t,c in nltk.chunk.tree2conlltags(sent)]\
			for sent in train_sents]
		self.tagger = nltk.TrigramTagger(train_data)

	def parse(self, sentence):
		pos_tags = [pos for (word,pos) in sentence]
		tagged_pos_tags = self.tagger.tag(pos_tags)
		chunktags = [chunktag for (pos, chunktag) in tagged_pos_tags]
		conlltags = [(word, pos, chunktag) for ((word,pos),chunktag)\
			in zip(sentence, chunktags)]
		return conlltags2tree(conlltags)

# Train and init the chunker
print '-- init and training chunker --'
train_sents = conll2000.chunked_sents('train.txt', chunk_types=['NP'])
test_sents = conll2000.chunked_sents('test.txt', chunk_types=['NP']) 
NPChunker = ChunkParser(train_sents)
NPChunker.evaluate(test_sents)
print '-- Done --'

def pos_tagger(tokens):
	# NLTK POS tagger
	sentences = [nltk.pos_tag(sent) for sent in tokens] 
	return sentences

def tokenize(sentences):
	# NLTK word tokenizer 
	tokens = [nltk.word_tokenize(sent) for sent in sentences]
	return tokens

def sentence_segmenter(rawtext):
	# NLTK default sentence segmenter
	sentences = nltk.sent_tokenize(rawtext) 
	return sentences

def unigramNP(sentence):
	pattern = "NP: {<NN>+}"
	unigramNPChunker = nltk.RegexpParser(pattern)
	return unigramNPChunker.parse(sentence)

def bigramNP(sentence):
	pattern = "NP: {<JJ>*<NN>}"
	bigramNPChunker = nltk.RegexpParser(pattern)
	return bigramNPChunker.parse(sentence)

def ngramNP(sentence):
	pattern = "NP: {<NNP>+}"
	bigramNPChunker = nltk.RegexpParser(pattern)
	return bigramNPChunker.parse(sentence)

def populate(leaves, articleId, redis, gram):
	article = 'article:%s'%(articleId)
	redis.sadd(article, '%s:%s'%(article, gram))
	redis.sadd('chunks', 'chunk:%s'%(gram))
	for leave in leaves:
		word = '%s'%(leave[0])
		typed = '%s'%(leave[1])
		#print 'Word %s - %s' %(word, typed)
		res = redis.zincrby('%s:%s'%(article, gram), word, 1)
		if res != 1.0:
			redis.sadd('chunk:%s'%(gram), 'chunk:%s:%s'%(gram,word))
			redis.lpush('chunk:%s:%s'%(gram, word), article)
			redis.sadd('words', 'word:%s'%(word))
			redis.hsetnx('word:%s'%(word), 'type', typed)

def populateUnigram(leaves, articleId, redis):
	print 'Unigram / Leaves: %s - Article: %s' % (leaves, articleId)
	populate(leaves, articleId, redis, 'unigram')

def populateBigram(leaves, articleId, redis):
	print 'Bigram / Leaves: %s - Article: %s' % (leaves, articleId)
	populate(leaves, articleId, redis, 'bigram')

def populateNgram(leaves, articleId, redis):
	print 'Ngram / Leaves: %s - Article: %s' % (leaves, articleId)
	populate(leaves, articleId, redis, 'ngram')

def populateTrainedgram(leaves, articleId, redis):
	print 'Trainedgram / Leaves: %s - Article: %s' % (leaves, articleId)
	populate(leaves, articleId, redis, 'trainedgram')

def chunking(tags, articleId, redis):
	for sentence in tags:
		# print '-------------Sentence----------------'	
		# print sentence
		traverse(unigramNP(sentence), articleId, redis, 'unigram')
		traverse(bigramNP(sentence), articleId, redis, 'bigram')
		traverse(ngramNP(sentence), articleId, redis, 'ngram')
		# TODO traverse(NPChunker.parse(sentence), articleId, redis, 'trainedgram')

def traverse(t, articleId, redis, chunk):
	# a tree traversal function for extracting NP chunks in the parsed tree
	try:
		t.node
	except AttributeError:
		return
	else:
		if t.node == 'NP':
			cleaned = json.loads(json.dumps(t.leaves()))
			if chunk == 'unigram':
				populateUnigram(cleaned, articleId, redis)
			elif chunk == 'bigram':
				populateBigram(cleaned, articleId, redis)
			elif chunk == 'ngram':
				populateNgram(cleaned, articleId, redis)
			elif chunk == 'trainedgram':
				populateTrainedgram(cleaned, articleId, redis)

		else:
			for child in t:
				traverse(child, articleId, redis, chunk)

def extract_keywords(task, redis):
	articleId = task['id']
	rawtext = nltk.clean_html(task['contents'])
	# print 'Cleaned: %s' % (rawtext)
	sentences = sentence_segmenter(rawtext)
	# print 'Sentences: %s' % (sentences)
	tokens = tokenize(sentences)
	#print '------------Freq-----------'
	#fdist = FreqDist()
	#for word in rawtext.split():
	#	fdist.inc(word.lower())
	#print fdist
	# print 'Tokens: %s' % (tokens)
	tags = pos_tagger(tokens)
	# print 'Tags: %s' % (tags)
	chunking(tags, articleId, redis)

def redis_mode(redis):
	while True:
		try:
			task = redis.blpop('queue:chunker', 60)
			if task != None:
				raw = json.loads(task[1])
				# print 'JSON: %s' % (raw)
				redis.sadd('articles', "article:%s" %(raw['id']))
				extract_keywords(raw, redis)
		except KeyboardInterrupt:
			sys.exit(0)
		except:
			traceback.print_exc()