require_relative 'cli'

require 'nokogiri'
require 'open-uri'
require 'pry'

class BPL::Library

  attr_accessor :name, :address, :contact_number, :hours

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

    index_scrape.css("div#maincontent h2").each_with_index do |element, i = 0|
      if i != 0
        lib = self.new
        lib.name = element.text
        lib.address = element.next.text.gsub("*.617\\","")
      end
    end
    binding.pry
  end
binding.pry

end
