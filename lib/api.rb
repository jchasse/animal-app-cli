class API

    def self.get_animal_tsn(animal)
        url = "http://www.itis.gov/ITISWebService/services/ITISService/searchByCommonName?srchKey=#{animal}"
        response = HTTParty.get(url) 
        # binding.pry
    end

    def self.get_animal_details_by_tsn(detail_type, tsn)
        url = "http://www.itis.gov/ITISWebService/services/ITISService/get#{detail_type}FromTSN?tsn=#{tsn}"
        response = HTTParty.get(url) 
    end
end