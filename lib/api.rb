class API

    def self.get_animal_tsn_by_common_name(input)
        response = API.get_animal_tsn(input)
        array = response["searchByCommonNameResponse"]['return']["commonNames"]

        if array.class == Hash
            hash = {common_name: array["commonName"], tsn: array["tsn"]}
            Animal.new(hash)  
        elsif array == nil
            CLI.invalid_response_common_name
        else
            array.each do |animal|
                hash = {common_name: animal["commonName"], tsn: animal["tsn"]}
                Animal.new(hash)
            end
        end
        CLI.list_animal_selection
    end

    def self.get_animal_tsn(animal)
        url = "http://www.itis.gov/ITISWebService/services/ITISService/searchByCommonName?srchKey=#{animal}"
        response = HTTParty.get(url) 
    end

        def self.get_animal_details(detail_select, tsn_select)
        response = API.get_animal_details_by_tsn(detail_select.gsub(" ", ""), tsn_select)

        if detail_select == "Scientific Name"
            value = response["getScientificNameFromTSNResponse"]["return"]["combinedName"]            
            attributes = {sci_name: value}
                
        elsif detail_select == "Full Hierarchy"
            value = response["getFullHierarchyFromTSNResponse"]["return"]["hierarchyList"]
            attributes = {full_hier: value}

        else  detail_select == "Publications"
            value = response["getPublicationsFromTSNResponse"]["return"]["publications"]
            attributes = {publications: value}
        end

        animal = Animal.find_by_tsn(tsn_select)
        animal.assign_attributes(attributes)

        CLI.print_selected_details(detail_select, animal)
    end

    def self.get_animal_details_by_tsn(detail_type, tsn)
        url = "http://www.itis.gov/ITISWebService/services/ITISService/get#{detail_type}FromTSN?tsn=#{tsn}"
        response = HTTParty.get(url) 
    end
end