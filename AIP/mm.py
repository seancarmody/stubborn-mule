#!/usr/bin/env python
# mm.py
#
# Scrape retail pump data from the MotorMouth website
# and write it to an sqlite3 database
#
# Author: Sean Carmody
# Created: 1 January 2012

import re
import BeautifulSoup
import logging
import sqlite3
import time
import urllib2

MM_BASE = 'http://motormouth.com.au/news/MediaData.aspx'

# Prepare log file
logfile = '/Users/sean/Dropbox/Mule/AIP Petrol/prices.log'
logfmt = '%(asctime)s|%(levelname)s|%(filename)s|%(message)s'
logdt = '%Y-%m-%d %I:%M %p'
logging.basicConfig(filename=logfile, level=logging.INFO, format=logfmt, datefmt=logdt)
logging.debug('Scrape process commenced')

fuels = ['ULP', 'DSL', 'LPG']

# Connect to the prices.db database
conn = sqlite3.connect('/Users/sean/Dropbox/Mule/AIP Petrol/prices.db')
cur = conn.cursor()
sql_t = 'select count(price) from mm where fuel=? and date=?'
sql = 'insert into mm values (?,?,?,?)'

fd = urllib2.urlopen(MM_BASE)
soup = BeautifulSoup.BeautifulSoup(fd.read())

for fuel in fuels:
	logging.info('Retrieving %s data' % fuel)
	t = soup.find(id='DataGrid' + fuel)
	if not t:
		t = soup.find(id='Datagrid' + fuel)	
	data =  [row.findAll("td") for row in t.findAll("tr")]
	cities = [x.text for x in data[0][1:]]
	dates = [x[0] for x in data[1:]]
	dates = [x.contents[3].text for x in dates if len(x.contents)>3]
	dates = [time.strftime("%Y-%m-%d", time.strptime(x, "(%d-%b-%y)")) for x in dates]

	for j in range(len(dates)):
		cur.execute(sql_t, [fuel.lower(), dates[j]])	
		if cur.fetchone()[0]>0:
			logging.info('%s data for %s already in database' % (fuel, dates[j]))
		else:
			for i in range(len(cities)): 
				cur.execute(sql, [dates[j], cities[i], fuel.lower(), data[j+1][i+1].text]) 

# Commit changes to database and close			
conn.commit()
conn.close()	
logging.debug('Scrape process completed')
	

