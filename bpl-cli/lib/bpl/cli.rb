require_relative 'version'
require_relative 'library'

require 'pry'

class BPL::CLI

  attr_accessor :libraries, :neighborhoods

  def call
    puts "Welcome to the Boston Library finder -- let's find some books!"
    get_library_info
    choose_query
    goodbye
  end

  def get_library_info
    BPL::Library.scrape
    @neighborhoods = ["boston", "dorchester", "brighton", "charlestown", "jamaica plain", "roxbury", "east boston", "allston", "hyde park", "mattapan", "roslindale", "south boston", "west roxbury"]
    @libraries = BPL::Library.all
  end

  def choose_query
    puts "Would you like to look up your local Boston library by neighborhood or zip code?"

    input = gets.strip.downcase.to_s

    case input
      when "neighborhood"
        by_neighborhood
      when "zip code"
        by_zipcode
      else
        choose_query
    end
  end

  def by_neighborhood
    puts "Please enter your neighborhood or type 'list' to receive a list of neighborhoods."

    input = gets.strip.downcase.to_s

    if input == "list"
      @neighborhoods.each { |n| puts "#{n.split.map(&:capitalize).join(' ')}"}
      binding.pry
      by_neighborhood
    elsif @neighborhoods.include?(input)
      puts "These are the libraries in your neighborhood:"
      local_libraries = []
      @libraries.each do |library|
        if library.neighborhood.downcase == input
          local_libraries << library
        end
      end
      local_libraries.each do |lib|
        puts "========================================="
        puts "Name: #{lib.name.gsub(" Library", "")} Library"
        puts "Address: #{lib.address}"
        puts "Neighborhood: #{lib.neighborhood}"
        puts "Zip Code: #{lib.zip_code}"
        puts "Contact Number: #{lib.contact_number}"
        puts "Library Hours:"
        lib.hours.each {|d| puts"#{d}"}
        puts "========================================="
      end
    else
      puts "There are no libraries in your neighborhood"
      choose_query
    end
  end

  def by_zipcode
    puts "Please enter your zip code (e.g. 02129):"

    input = gets.strip.downcase.to_s

    case input
      when "neighborhood"
        by_neighborhood
      when "zip code"
        by_zipcode
      else
        choose_query
    end

  end

  def goodbye
    puts "Get to that library and learn something!"
  end

end
