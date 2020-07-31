# create objects here

class Animal

    attr_accessor :common_name, :tsn, :sci_name, :full_hier, :comment, :publications

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

    def assign_attributes(attributes)
        attributes.each {|k, v| self.send(("#{k}="), v)}
    end

# iteration over the animal class to assign/set attributes in here

end