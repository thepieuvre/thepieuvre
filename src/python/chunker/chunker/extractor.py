import json
import nltk
import traceback

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

# Train and inti the chunker
train_sents = conll2000.chunked_sents('train.txt', chunk_types=['NP'])
test_sents = conll2000.chunked_sents('test.txt', chunk_types=['NP']) 
NPChunker = ChunkParser(train_sents)
NPChunker.evaluate(test_sents)

def pos_tagger(tokens):
	# NLTK POS tagger
	sentences = [nltk.pos_tag(sent) for sent in tokens] 
	return sentences

def tokeninze(sentences):
	# NLTK word tokenizer 
	tokens = [nltk.word_tokenize(sent) for sent in sentences]
	return tokens

def sentence_segmenter(rawtext):
	# NLTK default sentence segmenter
	sentences = nltk.sent_tokenize(rawtext) 
	return sentences

def chunking(tags):
	for sentence in tags:
		print '>>> %s' % (NPChunker.parse(sentence))

def traverse(t):
	# a tree traversal function for extracting NP chunks in the parsed tree
	try:
		t.node
	except AttributeError:
		return
	else:
		if t.node == 'NP':
			print t # TODO JSON
		else:
			for child in t:
				traverse(child)


def keywords(chunks):
	# extract the keywords based on frequency
	traverse(chunks)

def extract_keywords(task):
	rawtext = nltk.clean_html(task)
	print 'Cleaned: %s' % (rawtext)
	sentences = sentence_segmenter(rawtext)
	print 'Sentences: %s' % (sentences)
	tokens = tokeninze(sentences)
	print 'Tokens: %s' % (tokens)
	tags = pos_tagger(tokens)
	print 'Tags: %s' % (tags)
	chunking(tags)
	#keywords(chunks)

def redis_mode(redis):
	while True:
		try:
			task = redis.blpop('queue:chunker', 60)
			if task != None:
				# TODO content to manage
				raw = json.loads(task[1])
				print 'JSON: %s' % (raw)
				extract_keywords(raw['title'])
				#redis.rpush('queue:',processing_task(task[1]))
		except:
			traceback.print_exc()