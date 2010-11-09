from __future__ import with_statement

import contextlib
import urllib2
import urllib
import simplejson as json


DEV_KEY = 'bcsge1z85nkg4cg8'

def _make_call(**kwargs):
	url = 'http://quizlet.com/api/1.0/sets?dev_key=%s&' % DEV_KEY
	req = urllib2.Request(url=url + urllib.urlencode(kwargs))
	with contextlib.closing(urllib2.urlopen(req)) as url_handle:
		resp = ''.join(url_handle.readlines())
		return json.loads(resp)

def search(query):
	return _make_call(q=query)

def enumerate(id):
	return _make_call(
		extended='on',
		q='ids:%s' % id,
	)

def term_tuples(id):
	wordset = enumerate(id)['sets'][0]
	terms = wordset['terms']
	return [(word, definition) for word, definition, image in terms]
