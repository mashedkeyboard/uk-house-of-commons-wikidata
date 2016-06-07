#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

terms = { 
  56 => '21084473',
  55 => '21084472',
  54 => '21084471',
  53 => '21084470',
  52 => '21084469',
  # 51 => '21084468',
  # 50 => '21084467',
  # 49 => '21084466',
  # 48 => '21084465',
  # 47 => '21084464',
  # 46 => '21084463',
}

claim = terms.values.map { |t| "claim[463:%d]" % t.sub('Q','').to_i }.join(' OR ')
ids = EveryPolitician::Wikidata.wdq(claim)
warn "To fetch: #{ids.count}"
EveryPolitician::Wikidata.scrape_wikidata(ids: ids, batch_size: 100, output: false)
