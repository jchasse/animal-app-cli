

#get info from api / ask for data

class API

    def self.get_animal_tsn(animal)

        url = "http://www.itis.gov/ITISWebService/services/ITISService/searchByCommonName?srchKey=#{animal}"
        response = HTTParty.get(url)
        binding.pry
        data = {common_name: response["commonName"], tsn: response["tsn"])

    end


end