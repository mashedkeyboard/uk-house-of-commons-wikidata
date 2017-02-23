#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

terms = {
  56 => '21084473',
  55 => '21084472',
  54 => '21084471',
  53 => '21084470',
  52 => '21084469',
}

# TODO: make this a single query that includes all the terms we care about
qual_sparq = <<EOQ
  SELECT ?item
  WHERE {
    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 wd:Q16707842 ;
                        pq:P2937 wd:Q%s .
  }
EOQ

# People with a position 'UK MP', with 'legislative period: @term' qualifier
qual_ids = terms.values.map { |t| EveryPolitician::Wikidata.sparql(qual_sparq % t) }.reduce(:|)

# People with a 'member of: @term'
term_sparq = 'SELECT ?item WHERE { ?item wdt:P463 wd:Q%s . }'
term_ids = terms.values.map { |t| EveryPolitician::Wikidata.sparql(term_sparq % t) }.reduce(:|)


ids = qual_ids | term_ids
warn "To fetch: #{ids.count}"

EveryPolitician::Wikidata.scrape_wikidata(ids: ids, batch_size: 50)
