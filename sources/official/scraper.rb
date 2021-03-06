#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('th').text.gsub(/\(\w\)/, '').tidy
    end

    def position
      noko.xpath('.//td//text()').map(&:text).map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('table.cabinetListDl').first.css('tr')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
