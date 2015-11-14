#!/bin/env ruby
# encoding: utf-8

require 'colorize'
require 'nokogiri'
require 'pry'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'rest-client'

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
  54 => '463:21084471',
  53 => '463:21084470',
  52 => '463:21084469',
  51 => '463:21084468',
  50 => '463:21084467',
  49 => '463:21084466',
  48 => '463:21084465',
  47 => '463:21084464',
  46 => '463:21084463',
}

wd_ids = claims.map { |term, claim| ids_from_claim(claim) }.reduce(&:+).uniq
warn "#{wd_ids.count} to fetch"

wd_ids.each_with_index do |id, i|
  warn i if (i % 20).zero?
  data = WikiData::Fetcher.new(id: id).data or next
  ScraperWiki.save_sqlite([:id], data)
end

warn RestClient.post ENV['MORPH_REBUILDER_URL'], {} if ENV['MORPH_REBUILDER_URL']

