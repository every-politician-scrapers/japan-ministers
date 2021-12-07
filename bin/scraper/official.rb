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
      [first_position] + other_positions
    end

    private

    def name_and_position
      lines.first.split(':').map(&:tidy)
    end

    def first_position
      name_and_position[1]
    end

    def other_positions
      lines.drop(1)
    end

    def lines
      noko.xpath('text()').map(&:text).map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('ul.enMinisterList').css('li')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
