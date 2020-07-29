

#get info from api / ask for data

class API

    def self.get_animal_tsn(animal)

        url = "http://www.itis.gov/ITISWebService/services/ITISService/searchByCommonName?srchKey=#{animal}"
        response = HTTParty.get(url)
        
        array = response["searchByCommonNameResponse"]['return']["commonNames"]
        array.each do |animal|    # area to discuss in the technical blog
            binding.pry
            hash = {common_name: animal["commonName"], tsn: animal["tsn"]}
            Animal.new(hash)
        end
    end
end