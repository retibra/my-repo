require_relative 'cli'

require 'nokogiri'
require 'open-uri'
require 'pry'

class BPL::Library

  attr_accessor :name, :address, :zip_code, :contact_number, :hours

  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    puts "all libraries"
    @@all
  end

  def self.scrape
    index_scrape = Nokogiri::HTML(open("http://www.bpl.org/general/hours/"))
    days = ["Monday: ", "Tuesday: ", "Wednesday: ", "Thursday: ", "Friday: ", "Saturday: ", "Sunday: "]
    totalhours = []
    index_scrape.css("div#maincontent td").each_with_index do |element, i = 0|
      if i.odd?
         quickscrape = element.text.gsub("\u2013","")
         hours = element.text.gsub("2013","").gsub("p.m.","p.m., ").gsub("a.m.","a.m. - ").split(',')
         totalhours << days.zip(hours).map(&:join)
         binding.pry
      end

    end

    index_scrape.css("div#maincontent h2").each_with_index do |element, i = 0|
      if i != 0
        lib = self.new
        lib.name = element.text
        lib.address = element.next.text.gsub(/617.*/,"")
        lib.zip_code = lib.address[-5..-1]
        lib.contact_number = element.next.text.gsub(/.*617/,"617")[0..11]
        lib.hours = index_scrape.css("div#maincontent td")
      end
    end
    binding.pry
  end
binding.pry

end
