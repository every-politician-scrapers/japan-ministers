#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath('//h2[contains(.,"議員一覧")]//preceding::*').remove
    noko.xpath('//h2[contains(.,"脚注")]//following::*').remove
    noko.css('table td a')
  end

  class Officeholder < OfficeholderBase
    def name_cell
      noko
    end

    def item
      name_cell.attr('wikidata')
    end

    def itemLabel
      name_cell.text
    end

    def startDate
      '2021-10-31'
    end

    def endDate
      nil
    end

    def empty?
      false
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
