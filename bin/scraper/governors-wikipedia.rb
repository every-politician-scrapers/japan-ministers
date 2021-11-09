#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

require 'open-uri/cached'

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class MinistersList < Scraped::HTML
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  field :ministers do
    member_entries.map { |ul| fragment(ul => Officeholder).to_h }
  end

  private

  def member_entries
    table.flat_map { |table| table.xpath('.//tr[td]') }
  end

  def table
    noko.xpath('//h2[contains(.,"覧")]/following::table[.//th[contains(.,"氏名")]]')
  end
end

class Officeholder < Scraped::HTML
  field :precture do
    prefecture_link.attr('wikidata')
  end

  field :prefectureLabel do
    prefecture_link.text.tidy
  end

  field :person do
    name_link.attr('wikidata')
  end

  field :personLabel do
    name_link.text.tidy
  end

  private

  def tds
    noko.css('td')
  end

  def prefecture_link
    noko.xpath('.//th[1]//a[@href]').first
  end

  def name_link
    tds[1].xpath('.//a[@href]').first
  end
end

url = 'https://ja.wikipedia.org/wiki/%E9%83%BD%E9%81%93%E5%BA%9C%E7%9C%8C%E7%9F%A5%E4%BA%8B%E3%81%AE%E4%B8%80%E8%A6%A7'
data = MinistersList.new(response: Scraped::Request.new(url: url).response).ministers

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
