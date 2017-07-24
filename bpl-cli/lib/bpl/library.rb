require 'nokogiri'
require 'openUri'

class BPL::Library

  attr_accessor :name, :address, :contact_number, :hours

  def self.all
    puts "all libraries"
    index_scrape = Nokogiri::HTML(open(http://www.bpl.org/general/hours/))


  end


end
