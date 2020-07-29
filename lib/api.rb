

#get info from api / ask for data

class API

    def self.get_animal_tsn(animal)

        url = "http://www.itis.gov/ITISWebService/services/ITISService/searchByCommonName?srchKey=#{animal}"
        HTTParty.get(url)
        
    end
    
end