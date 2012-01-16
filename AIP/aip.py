#!/usr/bin/env python
# aip.py
#
# Scrape retail pump data from the AIP website
# and write it to an sqlite3 database
#
# Author: Sean Carmody
# Created: 1 January 2012

import urllib2, BeautifulSoup, time, sqlite3, sys, logging

AIP_BASE = 'http://www.aip.com.au/pricing/retail/'

def scrape_prices(state, fuel):
	urlstr = AIP_BASE + fuel + '/' + state + '.htm'

	# Scraping function does all the heavy lifting to find the data
	fd = urllib2.urlopen(urlstr)
	soup = BeautifulSoup.BeautifulSoup(fd.read())

	# Get Week Ending date and convert to Y-m-d format
	dtstr = soup(attrs={"class": "h3 left"})[0].contents[2].strip().split(';')[1]
	dtstr = time.strftime('%Y-%m-%d', time.strptime(dtstr, '%d %B %Y'))

	# Get Prices
	prices = []
	# Note that the table for States is grouped into regions (data1) and towns (data)
	fields = soup('th', attrs={"class": "data1"}) + soup('th', attrs={"class": "data"})
	
	for i in range(len(fields)):
		row = dict(date=dtstr, state=state, fuel=fuel)
		row['region'] = fields[i].text
		row['wkav'] = soup(title='Weekly Average')[i].string
		row['wklow'] = soup(title='Weekly Low')[i].string
		row['wkhigh'] = soup(title='Weekly High')[i].string
		prices.append(row)
		
	return prices

# Prepare log file
logfile = '/Users/sean/Dropbox/Mule/AIP Petrol/prices.log'
logfmt = '%(asctime)s|%(levelname)s|%(message)s'
logdt = '%Y-%m-%d %I:%M %p'
logging.basicConfig(filename=logfile, level=logging.INFO, format=logfmt, datefmt=logdt)
logging.debug('Commenced process')

# Scrape all state pages

pages = ['national', 'nsw', 'vic', 'wa', 'qld', 'sa', 'nt', 'tas']
fields = ['date', 'state', 'region', 'fuel', 'wkav', 'wklow', 'wkhigh']

# Connect to the prices.db database
conn = sqlite3.connect('/Users/sean/Dropbox/Mule/AIP Petrol/prices.db')
cur = conn.cursor()

# Check we don't already have the latest data
cur.execute('select max(date) from prices')
db_date = cur.fetchone()[0]
aip_date = scrape_prices('national', 'ulp')[0]['date']
if db_date==aip_date:
	logging.info('No new data available')
	logging.debug('Completed process')
	sys.exit('No new data available.')

sql = 'insert into prices values (?,?,?,?,?,?,?)'
# Loop through States and fuel types, writing prices to the CSV file
for p in pages:
	logging.info('Retrieving data for ' + p)
	for fuel in ['ulp', 'diesel']:
		prices = scrape_prices(p, fuel)
		for row in prices:
			cur.execute(sql, [row[k] for k in fields])

# Commit changes to database and close			
conn.commit()
conn.close()
logging.debug('Completed process')
