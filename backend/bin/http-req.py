#!/usr/bin/env python3
import os
import sys
import subprocess
import http.client
import json

token = os.environ['T']

def pp(data):
    print(json.dumps(data, indent=2, sort_keys=True))

def api(method, url, data):
    conn = http.client.HTTPConnection('localhost:4000')
    conn.request(method, url, json.dumps(data) if data else None, {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ' + token
    })
    response = conn.getresponse()

    print("{} {}".format(response.status, response.reason))
    if response.status >= 200 and response.status <= 300:
        data = json.loads(response.read().decode())
        print()
        pp(data)
        return data

def GET(url):
    return api('GET', url, None)

def POST(url, data):
    return api('POST', url, data)

def get_arg(index, name):
    try:
        return sys.argv[index]
    except IndexError:
        print("{} argument is missing".format(name))
        print()
        print("{} <method> <url> [data]".format(sys.argv[0]))
        sys.exit(1)

def full_url(url):
    return url

if __name__ == "__main__":
    method = get_arg(1, 'method')
    url = get_arg(2, 'url')
    data = None
    if method != 'GET':
        data = json.loads(get_arg(3, 'data'))

    api(method, url, data)
