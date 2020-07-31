# create objects here

class Animal

    attr_accessor :common_name, :tsn, :sci_name, :full_hier, :comment

    @@all = []

    def initialize(hash)
        hash.each do |k,v|
            self.send("#{k}=", v)
        end
        @@all << self
    end
    
    def self.all
        @@all
    end

    def self.find_by_tsn(tsn)
        self.all.find {|animal| animal.tsn == tsn }
    end

end