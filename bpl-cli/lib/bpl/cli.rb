require_relative 'version'
require_relative 'library'

require 'pry'

class BPL::CLI

  attr_accessor :libraries, :neighborhood

  def call
    puts "Welcome to the Boston Library finder -- let's find some books!"
    get_library_info
    list_libraries
    goodbye
  end

  def get_library_info
    BPL::Library.scrape
    @libraries = BPL::Library.all
  end

  def list_libraries
    puts "Would you like to look up your local Boston library by neighborhood or zip code?"

    input = gets.strip.downcase.to_s

    case input
    when "02129"
        puts "Charlestown Library"
    when "list"
      puts "all libraries"
    else
      list_libraries
    end

  end

  def goodbye
    puts "Get to that library and learn something!"
  end

end
