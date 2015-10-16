#!/bin/env ruby
# encoding: utf-8

require 'colorize'
require 'nokogiri'
require 'pry'
require 'scraperwiki'
require 'wikidata/fetcher'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def ids_from_claim(claim_str)
  url = 'https://wdq.wmflabs.org/api?q=claim[%s]' % claim_str
  json = JSON.parse(open(url).read, symbolize_names: true)
  json[:items].map { |id| "Q#{id}" }
end

claims = { 
  56 => '463:21084473',
  55 => '463:21084472',
}

wd_ids = claims.map { |term, claim| ids_from_claim(claim) }.reduce(&:+).uniq
warn "#{wd_ids.count} to fetch"

wd_ids.each_with_index do |id, i|
  warn i if (i % 20).zero?
  data = WikiData::Fetcher.new(id: id).data or next
  ScraperWiki.save_sqlite([:id], data)
end
