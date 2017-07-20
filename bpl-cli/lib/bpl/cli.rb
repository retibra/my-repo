require_relative "version"

class BPL::CLI

  def call
    puts "Welcome to the Library finder -- let's find some books!"
    list_libraries
  end

  def list_libraries
    puts "Please enter your Zip Code or type 'list' to see the full list of libraries"
  end
end
