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
    @neighborhoods = []
    @zip_codes = []
    @libraries = BPL::Library.all
    @libraries.each do |element|
      @neighborhoods << element.neighborhood.downcase unless @neighborhoods.include?(element.neighborhood.downcase)
      @zip_codes << element.zip_code unless @zip_codes.include?(element.zip_code)
    end
  end

  def choose_query
    puts "Would you like to look up your local Boston library by neighborhood or zip code? If you would like to exit, type 'exit'."

    input = gets.strip.downcase.to_s

    case input
      when "neighborhood"
        by_neighborhood
      when "zip code"
        by_zipcode
      when "exit"
      else
        choose_query
    end
  end

  def by_neighborhood
    puts "Please enter your neighborhood or type 'list' to receive a list of neighborhoods."

    input = gets.strip.downcase.to_s

    if input == "list"
      @neighborhoods.each { |n| puts "#{n.split.map(&:capitalize).join(' ')}"}
      by_neighborhood
    elsif @neighborhoods.include?(input)
      puts "These are the libraries in your neighborhood:"
      local_libraries = []
      @libraries.each do |library|
        if library.neighborhood.downcase == input
          local_libraries << library
        end
      end
      library_print(local_libraries)
    else
      puts "Unfortunately, there are no libraries in your neighborhood."
      choose_query
    end
  end

  def by_zipcode
    puts "Please enter your zip code (e.g. 02129):"

    input = gets.strip.downcase.to_s

    if @zip_codes.include?(input)
      puts "These are the libraries in your zip code:"
      local_libraries = []
      @libraries.each do |library|
        if library.zip_code.downcase == input
          local_libraries << library
        end
      end
      library_print(local_libraries)
    else
      puts "Unfortunately, there are no libraries in your zip_code."
      choose_query
    end
  end

  def library_print(local_libraries)
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
    lookup_again?
  end

  def lookup_again?
    puts "Would you like to lookup another library (y/n)?"
    input = gets.strip.downcase.to_s

    if input == "y"
      choose_query
    elsif input == "n"
    else
      lookup_again?
    end
  end

  def goodbye
    puts "Get to that library and learn something!"
  end

end
