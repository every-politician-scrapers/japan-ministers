module.exports = function () {
  return `SELECT DISTINCT ?prefecture ?prefectureLabel ?position ?positionLabel ?person ?personLabel ?start 
         (STRAFTER(STR(?held), '/statement/') AS ?psid)
  WHERE {
    ?prefecture wdt:P31 wd:Q50337 ; wdt:P1313 ?position .
    MINUS { ?prefecture wdt:P576 [] }
    OPTIONAL {
      ?person wdt:P31 wd:Q5 ; p:P39 ?held .
      ?held ps:P39 ?position ; pq:P580 ?start .
      FILTER NOT EXISTS { ?held pq:P582 ?end }
    }
    SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
  }
  # ${new Date().toISOString()}
  ORDER BY ?prefectureLabel ?start`
}
