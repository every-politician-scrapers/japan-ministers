#!/bin/bash

bundle exec ruby bin/scraper/governors-wikipedia.rb > data/governors-wikipedia.csv
# wd list was fetched earlier
bundle exec ruby bin/diff-governors.rb > data/diff-governors.csv
