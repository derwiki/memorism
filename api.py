from __future__ import with_statement

import contextlib
import urllib2
import urllib
import random
import simplejson as json

import bottle
from bottle import route, run, template, view

bottle.debug(True)
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

@route('/term_tuples/:id/:n')
def term_tuples(id, n):
    """Return list of (word, definition tuples for a word set
    Args:
      id    integer
      n        how many words you want (random sampling)
    """
    wordset = enumerate(id)['sets'][0]
    terms = wordset['terms']
    return json.dumps(random.sample([(word, definition) for word, definition, image in terms], int(n)))

@route('/')
def board():
    return template('board')


@route('/js/:filename#.*#')
def javascript_file(filename):
    bottle.send_file(filename, root='js/')

@route('/css/:filename#.*#')
def css_file(filename):
    bottle.send_file(filename, root='css/')


run()


