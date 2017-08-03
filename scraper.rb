#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

term_ids = {
  57 => 'Q29974940',
  56 => 'Q21084473',
  55 => 'Q21084472',
  54 => 'Q21084471',
  53 => 'Q21084470',
  52 => 'Q21084469'
}
terms = term_ids.values.map { |id| "wd:#{id}" }.join ' '

membership_ids = {
  57 => 'Q30524710',
  56 => 'Q30524718',
}
memberships = membership_ids.values.map { |id| "wd:#{id}" }.join ' '

# People with a position 'UK MP', with 'legislative period: @term' qualifier
qual_sparq = <<EOQ
  SELECT DISTINCT ?item WHERE {
    ?item p:P39 ?position_statement .
    VALUES ?term { %s }
    ?position_statement ps:P39 wd:Q16707842 ; pq:P2937 ?term
  }
EOQ
qual_ids = EveryPolitician::Wikidata.sparql(qual_sparq % terms)

# People with a 'member of: @term'
term_sparq = 'SELECT DISTINCT ?item WHERE { VALUES ?term { %s } ?item wdt:P463 ?term }'
term_ids = EveryPolitician::Wikidata.sparql(term_sparq % terms)

# People with a P39 of a Term-specific membership
term_mem_sparq = 'SELECT DISTINCT ?item WHERE { VALUES ?term { %s } ?item wdt:P39 ?term }'
term_mem_ids = EveryPolitician::Wikidata.sparql(term_mem_sparq % memberships)

ids = qual_ids | term_ids | term_mem_ids
warn "To fetch: #{ids.count}"

EveryPolitician::Wikidata.scrape_wikidata(ids: ids, batch_size: 50)
