class BPL::CLI

  def call
    puts "Welcome to the Library finder -- let's find some books!"
    list_libraries
    goodbye
  end

  def list_libraries
    puts "Please enter your Zip Code or type 'list' to see the full list of libraries in Boston"

    input = gets.strip.downcase.to_s

    case input
    when "02129"
        puts "Charlestown Library"
    when "list"
      puts "all libraries"
    else
      list_libraries
    end

    @libraries = BPL::Library.all
  end

  def goodbye
    puts "Get to that library and learn something!"
  end
end
