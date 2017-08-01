

class BPL::Library

  attr_accessor :name, :address, :zip_code, :neighborhood, :contact_number, :hours

  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  def self.scrape
    index_scrape = Nokogiri::HTML(open("http://www.bpl.org/general/hours/"))
    days = ["Monday: ", "Tuesday: ", "Wednesday: ", "Thursday: ", "Friday: ", "Saturday: ", "Sunday: "]
    totalhours = []
    index_scrape.css("div#maincontent td").each_with_index do |element, i = 0|
      if i.odd?
         hours = []
         hours << element.text.gsub("\u2013","").gsub("Closed", "Closedm.").split("m.").each_slice(2).map {|e| "#{e.first}m. - #{e.last}m."}
         hours = hours.flatten
         hours << "Closed" while hours.length < 7
         hours.collect! do |element|
          if element.include?("Closed")
            element = "Closed"
          else
            element
          end
         end

         totalhours << days.zip(hours.flatten).map(&:join)
      end

    end

    index_scrape.css("div#maincontent h2").each_with_index do |element, i = 0|
      if i != 0
        lib = self.new
        lib.name = element.text
        lib.address = element.next.text.gsub(/617.*/,"")
        if lib.address.include?("Boston")
          lib.neighborhood = "Boston"
        else
          lib.neighborhood = lib.address.split(", ")[1]
        end
        lib.zip_code = lib.address[-5..-1]
        lib.contact_number = element.next.text.gsub(/.*617/,"617")[0..11]
        lib.hours = totalhours[i-1]
      end
    end

  end

  def self.find_by(attr, input)
    self.all.select{|l| l.send("#{attr}") == input.capitalize}
  end


end
