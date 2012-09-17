#!/usr/bin/env python

'''
Abbott speech scraping routine
'''

import os
import lxml.html
import sha
import time
import datetime
import csv

# Tony Abbott's speech archive
url_base = "http://www.tonyabbott.com.au/LatestNews/Speeches/"
url_base = url_base + "tabid/88/CategoryID/2/currentpage/%d/Default.aspx"

def get_speech(url):
    '''Scrape the speech and metadata from url and return in dictionary 
    '''

    page = lxml.html.parse(url).getroot()
    speech = page.find(".//div[@class='articleListing clear']")
    text = [e.text_content() for e in speech[2:]]

    results = {'url': url, 'title': speech.findtext("h2").strip()}
    posted = speech.xpath("div[@class='articleInfo']/p/child::text()")[0]
    posted_str = posted.split("Posted on ")[1]
    results['posted'] = posted_str
    try:
	posted_time = time.strptime(posted_str, '%A, %d %B %Y')
	posted_date = datetime.date(*posted_time[:3])
	results['date'] = posted_date.strftime('%Y-%m-%d')
    except ValueError:
	results['date'] = 'NA'       

    speech_text = ' '.join(text).encode('utf-8')
    speech_text = speech_text.replace('[ends]','')
    results['text'] =  speech_text
    m = sha.new(speech_text)

    results['digest'] = m.hexdigest()
    results['speech'] = speech
    return(results)

def get_links(url):
    page = lxml.html.parse(url)
    return [e.get('href') for e in page.xpath('//h2/a')]

def get_speeches(urls):
    ''' Loop through list of speech urlsl, call get_speech()
    '''

    speeches = {}
    for speech_url in urls:
        speech = get_speech(speech_url)
        filename = speech['date'] + "-" + speech['digest'][:5]
        speeches[filename] = speech
        log_speech(speech)
    return speeches

def log_speech(speech):
    print
    print 'TITLE: ' + speech['title']
    print 'DATE: ' + speech['posted']
    print 'DATE (conv): ' + speech['date']
    print 'TEXT: %d' % len(speech['text'])

def save_speeches(speeches, dirname='abbott'):
    for filename, speech in speeches.items():
        speech_file = open(os.path.join(dirname, filename), 'w')
        speech_file.write(speech['text'])
        speech_file.write("\n")
        speech_file.close()

if __name__ == '__main__':
    urls = get_links(url_base % 0)
    speeches = get_speeches(urls)
    save_speeches(speeches)

    with open('speeches.csv', 'wb') as csvfile:
        cw = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
        cw.writerow(['filename', 'title', 'date', 'url', 'digest'])
        for key in speeches:
            speech = speeches[key]
            cw.writerow([key, speech['title'].encode('utf-8'), 
                speech['date'], speech['url'], speech['digest']])

