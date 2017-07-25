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
    dummy = index_scrape.css("div#maincontent td")
    index_scrape.css("div#maincontent td").each_with_index do |element, i = 0|
      if i.odd?
         # dummy << element.text.gsub("\u2013","") #how do i scrape? I thought about doing by p.m., but that doesn't work. neither does character length
         hours = element.text.gsub("\u2013","").gsub("p.m.","p.m., ").gsub("a.m.","a.m. - ").split(',')
         totalhours << days.zip(hours).map(&:join)
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
