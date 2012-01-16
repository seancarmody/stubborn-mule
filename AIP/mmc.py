#!/usr/bin/env python
# mm.py
#
# Scrape country town retail pump data from the MotorMouth website
# and write it to an sqlite3 database
#
# Author: Sean Carmody
# Created: 1 January 2012

#!/usr/bin/env python
# mm.py
#
# Scrape retail pump data from the MotorMouth website
# and write it to an sqlite3 database
#
# Author: Sean Carmody
# Created: 1 January 2012

import mechanize
import re
import BeautifulSoup
import logging
import sqlite3
import time

MM_BASE = 'http://motormouth.com.au/countryprices.aspx'

# Prepare log file
logfile = '/Users/sean/Dropbox/Mule/AIP Petrol/prices.log'
logfmt = '%(asctime)s|%(levelname)s|%(filename)s|%(message)s'
logdt = '%Y-%m-%d %I:%M %p'
logging.basicConfig(filename=logfile, level=logging.INFO, format=logfmt, datefmt=logdt)
logging.debug('Scrape process commenced')

b = mechanize.Browser()
b.open(MM_BASE)

states = ['QLD', 'NSW', 'VIC', 'SA', 'WA', 'ACT', 'TAS', 'NT']
fields = ['City', 'ULP', 'DSL', 'E10']

# Connect to the prices.db database
conn = sqlite3.connect('/Users/sean/Dropbox/Mule/AIP Petrol/prices.db')
cur = conn.cursor()

# Retrieve data for all states
for state in states:
	logging.debug('Retrieving data for ' + state)
	data = {}
	b.select_form(name='form1')
	b["DropDownListState"] = [state]
	res = b.submit()
	soup = BeautifulSoup.BeautifulSoup(res.get_data())
	
	mm_date = soup(id='LabelTimeStamp')[0].text	
	mm_date = time.strftime('%Y-%m-%d', time.strptime(mm_date, '%A %d %B %Y'))
	logging.debug('Retrieved data for %s' % (mm_date))
	
	cur.execute('select max(date) from mmc where state=?', [state])
	db_date = cur.fetchone()[0]
	logging.debug('Last DB data for %s: %s' % (state, db_date))
	
	if mm_date == db_date:
		logging.info('%s data for %s already in database' % (state, db_date))
	else:
		sql = 'insert into mmc values (?,?,?,?,?)'

		for f in fields:
			data[f.lower()] = [x.text for x in soup.findAll(id=re.compile(".*" + f + "$"))]
	
		n = len(data['city'])
		logging.info('Records read for %s: %d' % (state, n))
		for i in range(n):
			# Strip footnote label '3' from Capital Cities
			town = data['city'][i].rstrip('3')
			for f in [x.lower() for x in fields[1:]]:
				price =  data[f][i]
				if price != 'N/A':
					cur.execute(sql, [mm_date, state, town, f, price]) 

# Commit changes to database and close			
conn.commit()
conn.close()	
logging.debug('Scrape process completed')
	

