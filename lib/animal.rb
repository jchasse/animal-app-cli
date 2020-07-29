# create objects here

class Animal

    attr_accessor :common_name, :tsn

    @@all = []

    def initialize(hash)
        hash.each do |k,v|
            self.send("#{k}=", v)
        end
        @@all << self
        # binding.pry
    end
    
    def self.all
        @@all
    end


end