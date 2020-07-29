# create objects here

class Animal

    attr_accessor :common_name, :tsn

    def initialize(hash)
        hash.each do |k,v|
            self.send("#{k}=", v)
        end
    end
        


end