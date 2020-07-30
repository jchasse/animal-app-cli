

#get info from api / ask for data

class API

    def self.get_animal_tsn(animal)
        url = "http://www.itis.gov/ITISWebService/services/ITISService/searchByCommonName?srchKey=#{animal}"
        HTTParty.get(url) 
    end

    def self.get_animal_hierarchy_by_tsn(tsn)
        url = "http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=#{tsn}"
        response = HTTParty.get(url) 
        # binding.pry
    end

    def self.get_animal_comments_by_tsn(tsn)

        
        # Geo Coverage
        url = "http://www.itis.gov/ITISWebService/services/ITISService/getCoverageFromTSN?tsn=#{tsn}"
        
        
        #Animal Comments
         url = "http://www.itis.gov/ITISWebService/services/ITISService/getCommentDetailFromTSN?tsn=#{tsn}"
        response = HTTParty.get(url)
        binding.pry
    end

end