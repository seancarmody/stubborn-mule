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
	results['date'] = posted_date
    except ValueError:
	results['date'] = 'NA'       

    speech_text = ' '.join(text).encode('utf-8')
    speech_text = speech_text.replace('[ends]','')
    results['text'] =  speech_text
    m = sha.new(speech_text)

    results['digest'] = m.hexdigest()
    results['speech'] = speech
    return(results)

def get_pages(page_range):
    ''' Loop through list of speeches, grab the url and call get_speech()
    '''

    summary = {}
    for p in page_range:
    	print 'PROCOESSING PAGE %d' % p
	print
        url = url_base % p
	print 'PAGE URL: ' + url
	print
        page = lxml.html.parse(url)
        for speech_url in [e.get('href') for e in page.xpath('//h2/a')]:
            results = get_speech(speech_url)
	    date_str = results['date'].strftime('%Y-%m-%d')
            print
            print 'TITLE: ' + results['title']
            print 'DATE: ' + results['posted']
	    print 'DATE (conv): ' + date_str
            print 'TEXT: %d' % len(results['text'])
            filename = date_str + "-" + results['digest'][:5]
            summary[filename] = results
            speech_file = open(os.path.join('abbott', filename), 'w')
            speech_file.write(results['text'])
	    speech_file.write("\n")
            speech_file.close()
    return summary

def get_links(url):
    page = lxml.html.parse(url)
    return [e.get('href') for e in page.xpath('//h2/a')]

def get_speeches(urls):
    ''' Loop through list of speech urlsl, call get_speech()
    '''

    summary = {}
    for speech_url in urls:
        results = get_speech(speech_url)
        date_str = results['date'].strftime('%Y-%m-%d')
        print
        print 'TITLE: ' + results['title']
        print 'DATE: ' + results['posted']
        print 'DATE (conv): ' + date_str
        print 'TEXT: %d' % len(results['text'])
        filename = date_str + "-" + results['digest'][:5]
        summary[filename] = results
        speech_file = open(os.path.join('abbott', filename), 'w')
        speech_file.write(results['text'])
        speech_file.write("\n")
        speech_file.close()
    return summary
    

if __name__ == '__main__':
    summary = get_pages([0])
    with open('summary.csv', 'wb') as csvfile:
        cw = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
        cw.writerow(['filename', 'title', 'date', 'digest'])
        for key in summary:
            speech = summary[key]
            date_str = speech['date'].strftime('%Y-%m-%d')
            cw.writerow([key, speech['title'].encode('utf-8'), 
                date_str, speech['digest']])



