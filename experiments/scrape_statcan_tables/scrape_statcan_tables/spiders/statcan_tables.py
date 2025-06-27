import scrapy
import re


class StatCanDataTablesSpider(scrapy.Spider):
    name = "statcan_tables"
    allowed_domains = ["www150.statcan.gc.ca"]
    start_urls = [
        "https://www150.statcan.gc.ca/n1/en/type/data?count=100#tables"
    ]

    def parse(self, response):
        # Use regex to match any content after "Table:", stopping at a tag or line break
        # This finds patterns like: "Table: 12-10-0134-01", "Table: 45-67-8910-02", etc.
        matches = re.findall(r'\<span\>Table:\<\/span\>\s*([^<\n\r]+)', response.text)

        for table_id in matches:
            # Clean up whitespace
            yield {
                'table_id': table_id.strip()
            }

        # Follow the "Next" pagination link
        next_page = response.css('a[rel=next]::attr(href)').get()
        if next_page:
            yield response.follow(next_page, callback=self.parse)
