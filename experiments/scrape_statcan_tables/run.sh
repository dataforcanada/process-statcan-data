# You'll need to stop the crawler after the last page, as it will just restart at page 1
scrapy crawl statcan_tables -o tables.json