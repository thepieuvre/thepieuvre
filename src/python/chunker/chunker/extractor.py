import json
import nltk
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

# Train and inti the chunker
train_sents = conll2000.chunked_sents('train.txt', chunk_types=['NP'])
test_sents = conll2000.chunked_sents('test.txt', chunk_types=['NP']) 
NPChunker = ChunkParser(train_sents)
NPChunker.evaluate(test_sents)

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

def chunking(tags):
	for sentence in tags:
		# TODO regexp and trained chunker / 3 groups !!
		print '-------------Sentence----------------'	
		print sentence
		print '-------------Unigram----------------'	
		traverse(bigramNP(sentence))
		print '-------------Bigram----------------'	
		traverse(unigramNP(sentence))
		print '-------------gram----------------'	
		traverse(ngramNP(sentence))
		print '-------------Trained----------------'
		traverse(NPChunker.parse(sentence))

def traverse(t):
	# a tree traversal function for extracting NP chunks in the parsed tree
	try:
		t.node
	except AttributeError:
		return
	else:
		if t.node == 'NP':
			print json.dumps(t.leaves()) # TODO return 
		else:
			for child in t:
				traverse(child)


def keywords(chunks):
	# TODO extract the keywords based on frequency
	print 'todo'

def extract_keywords(task):
	rawtext = nltk.clean_html(task)
	print 'Cleaned: %s' % (rawtext)
	sentences = sentence_segmenter(rawtext)
	# print 'Sentences: %s' % (sentences)
	tokens = tokenize(sentences)
	print '------------Freq-----------'
	fdist = FreqDist()
	for word in rawtext.split():
		fdist.inc(word.lower())
	print fdist
	# print 'Tokens: %s' % (tokens)
	tags = pos_tagger(tokens)
	# print 'Tags: %s' % (tags)
	chunking(tags)
	# TODO keywords(chunks)

def redis_mode(redis):
	while True:
		try:
			task = redis.blpop('queue:chunker', 60)
			if task != None:
				raw = json.loads(task[1])
				# print 'JSON: %s' % (raw)
				extract_keywords(raw['contents'])
				#redis.rpush('queue:',processing_task(task[1]))
		except KeyboardInterrupt:
			sys.exit(0)
		except:
			traceback.print_exc()