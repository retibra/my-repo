require_relative 'cli'

require 'nokogiri'
require 'open-uri'
require 'pry'

class BPL::Library

  attr_accessor :name, :address, :contact_number, :hours

  def self.all
    puts "all libraries"
    html = File.read("www.bpl.org/general/hours/")
    index_scrape = Nokogiri::HTML(html)

    index_scrape.css("div h2").each do |element|
      lib = self.new
      lib.name = element
    end

  end
  binding.pry

end
