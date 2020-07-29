

#get info from api / ask for data

class API

    def self.api_connect(animal)

        url = "http://www.itis.gov/ITISWebService/services/ITISService/searchByCommonName?srchKey=#{animal}"
        response = HTTParty.get(url)
        binding.pry

    end


end