# Don't overuse instance variables, only when an 'attribute of an instance' truly needs to be stored
# Interaction with user is in here
# puts and gets here

class CLI

    def welcome
        puts "\nWelcome!"
        self.run
    end

    def run 
        puts "\nPlease enter the common name of any living thing:"
        animal = gets.chomp
        self.get_animal_tsn_by_common_name(animal)
        self.list_animal_selection
        self.narrow_animal_selection
    end

    def get_animal_tsn_by_common_name(animal)
        response = API.get_animal_tsn(animal)
        array = response["searchByCommonNameResponse"]['return']["commonNames"]

        if array.class == Hash
            hash = {common_name: array["commonName"], tsn: array["tsn"]}
            Animal.new(hash)
        elsif array == nil
            invalid_response_common_name
        else
            array.each do |animal|    # area to discuss in the techical blog
                hash = {common_name: animal["commonName"], tsn: animal["tsn"]}
                Animal.new(hash)
            end
        end
        # self.list_animal_selection
    end

    def invalid_response_common_name
        puts "\nInvalid input."
        self.run
    end

    def list_animal_selection
        # insert if statement here to account for only 1 animal selection
        puts "\n"
        Animal.all.each_with_index do |animal, index|
            puts "#{index+1}. #{animal.common_name}"
        end
        # self.narrow_animal_selection
    end

    def narrow_animal_selection
        puts "\nPlease narrow your animal selection by entering the corresponding number:"
        input = gets.chomp

        if input.to_i.between?(1,)

        tsn_select = Animal.all[input.to_i-1].tsn
        cn_select = Animal.all[input.to_i-1].common_name
        
        puts "\nThank you, the Taxonomic Serial Number for the #{cn_select} is #{tsn_select}. \n\n"

        self.select_details(cn_select, tsn_select)
    end

    def review_prior_called_animals
        puts "\n"
        Animal.all.each_with_index do |animal, index|
            puts "#{index+1}. #{animal.common_name}"
        end
    end


    def select_details(cn_select,tsn_select)

        option_array = ["Scientific Name", "Full Hierarchy", "Publications"]
        
        option_array.each_with_index do |option, index|
            puts "#{index+1}. #{option}"
        end

        puts "\nWhat would you like to learn about the #{cn_select}? (Enter corresponding number)"
        input = gets.chomp
        
        detail_select = option_array[input.to_i-1]

        self.get_animal_details(detail_select, tsn_select)

    end

    def get_animal_details(detail_select, tsn_select)
        response = API.get_animal_details_by_tsn(detail_select.gsub(" ", ""), tsn_select)

        # binding.pry
        if detail_select == "Scientific Name"
            value = response["getScientificNameFromTSNResponse"]["return"]["combinedName"]            
            attributes = {sci_name: value}
            
        elsif detail_select == "Full Hierarchy"
            value = response["getFullHierarchyFromTSNResponse"]["return"]["hierarchyList"]
            attributes = {full_hier: value}

        else  detail_select == "Publications"
            value = response["getPublicationsFromTSNResponse"]["return"]["publications"]
            attributes = {comment: value}
        end

        animal = Animal.find_by_tsn(tsn_select)
        animal.assign_attributes(attributes)

        self.print_selected_details(detail_select, animal)
    end

    def print_selected_details(detail_select, animal)
        if detail_select == "Scientific Name"
            # binding.pry
            puts "\n#{animal.sci_name}"
        elsif detail_select == "Full Hierarchy"
            puts "\n"
            animal.full_hier.each do |hier|
                puts "#{hier["rankName"]}: #{hier["taxonName"]} "
            end
        elsif detail_select == "Publications"
            if value == nil
                puts "No publications recorded in our database yet"

            elsif animal.publications.class == Hash
                puts "\nPublication: #{value["pubName"]}"
                puts "Author: #{value["referenceAuthor"]}"
                puts "Title: #{value["title"]}"
                puts "Date: #{value["actualPubDate"]}"                

            else
                animal.publications.each do |pub|
                    puts "\nPublication: #{pub["pubName"]}"
                    puts "Author: #{pub["referenceAuthor"]}"
                    puts "Title: #{pub["title"]}"
                    puts "Date: #{pub["actualPubDate"]}"
                end
            end
        else
            # invalid_response_common_name
        end
        new_search
    end

    def new_search
        puts "Enter 'new search', 'show prior species searched' or 'exit'"
        input = gets.chomp

        # what_next = ["New search", "Show prior species searched", "exit"]
        # puts "\n"

        # what_next.each_with_index do |option, index|
        #     puts "#{index+1}. #{option}"
        # end

        # puts "\nWhat would you like to do next? (Enter corresponding number)"
        # input = gets.chomp
        
        # option_select = option_array[input.to_i-1]

        # binding.pry

        if input = "new search"
            self.run
        elsif input = 'show prior species searched'
            self.list_animal_selection
        elsif input = 'exit'
            abort("\nThank you for learning with us!\n\n")
        end
    end
end