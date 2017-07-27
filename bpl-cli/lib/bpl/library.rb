require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative 'version'

class BPL::Library

  attr_accessor :name, :address, :zip_code, :neighborhood, :contact_number, :hours

  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  def self.scrape
    index_scrape = Nokogiri::HTML(open("http://www.bpl.org/general/hours/"))
    days = ["Monday: ", "Tuesday: ", "Wednesday: ", "Thursday: ", "Friday: ", "Saturday: ", "Sunday: "]
    totalhours = []
    index_scrape.css("div#maincontent td").each_with_index do |element, i = 0|
      if i.odd?
         hours = []
         hours << element.text.gsub("\u2013","").split("m.").each_slice(2).map { |e| "#{e.first}m. - #{e.last}m."}
         totalhours << days.zip(hours.flatten).map(&:join)
      end

    end

    index_scrape.css("div#maincontent h2").each_with_index do |element, i = 0|
      if i != 0
        lib = self.new
        lib.name = element.text
        lib.address = element.next.text.gsub(/617.*/,"")
        lib.neighborhood = lib.address.split(", ")[1]
        lib.zip_code = lib.address[-5..-1]
        lib.contact_number = element.next.text.gsub(/.*617/,"617")[0..11]
        lib.hours = totalhours[i-1]
      end
    end

  end


end
