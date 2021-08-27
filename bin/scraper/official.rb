#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    # everyone holds multiple positions, but we're only taking the first
    # one for now, unless they're also in this list
    # TODO: ensure Wikidata knows *all* of the positions
    OTHER_POSITIONS = [
      'Chairperson of the National Public Safety Commission',
      'Deputy Prime Minister',
      'Minister in charge of Information Technology Policy',
      'Minister of Economy,Trade and Industry',
      'Minister of the Environment',
      'Minister of Finance',
      'Minister of State for Regulatory Reform',
      'Minister of State for Science and Technology Policy'
    ].freeze

    def name
      name_and_position[0]
    end

    def position
      [first_position] + other_positions
    end

    def first_position
      name_and_position[1]
    end

    def other_positions
      lines.drop(1) & OTHER_POSITIONS
    end

    private

    def name_and_position
      lines.first.split(':').map(&:tidy)
    end

    def lines
      noko.xpath('text()').map(&:text).map(&:tidy)
    end
  end

  class Members
    def member_container
      # TODO: drop the first, to get State Ministers/Vice-Ministers
      noko.css('ul.enMinisterList').first.css('li')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
