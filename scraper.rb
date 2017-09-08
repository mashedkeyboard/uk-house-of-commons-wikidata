#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

# People with a position 'UK MP', of a suitable subclass
qual_sparq = <<EOQ
  SELECT DISTINCT ?item WHERE { ?item p:P39 [ ps:P39 [ wdt:P279 wd:Q16707842 ] ] }
EOQ
qual_ids = EveryPolitician::Wikidata.sparql(qual_sparq)

EveryPolitician::Wikidata.scrape_wikidata(ids: qual_ids, batch_size: 50)
