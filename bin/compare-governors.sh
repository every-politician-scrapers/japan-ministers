#!/bin/bash

bundle exec ruby bin/scraper/governors-wikipedia.rb | ifne tee data/governors-wikipedia.csv
# wd list was fetched earlier
bundle exec ruby bin/diff-governors.rb | ifne tee data/diff-governors.csv
