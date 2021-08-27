#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      name_and_position[0]
    end

    def position
      name_and_position[1]
    end

    private

    def name_and_position
      lines.first.split(':').map(&:tidy)
    end

    def lines
      noko.xpath('text()').map(&:text)
    end
  end

  class Members
    def member_container
      noko.css('ul.enMinisterList li')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
