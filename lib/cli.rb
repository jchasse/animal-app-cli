# Don't overuse instance variables, only when an 'attribute of an instance' truly needs to be stored
# Interaction with user is in here
# puts and gets here

# git add .
# git commit -m "   "
# git push -u

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
        if input.to_i.between?(1,Animal.all.length)

            tsn_select = Animal.all[input.to_i-1].tsn
            cn_select = Animal.all[input.to_i-1].common_name
            
            puts "\nThank you, the Taxonomic Serial Number for the #{cn_select} is #{tsn_select}. \n\n"

            self.select_details(cn_select, tsn_select)
        else
            puts "Invalid entry."
            self.narrow_animal_selection
        end
    end

    def select_details(cn_select = "this species",tsn_select)

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

        self.print_selected_details(detail_select, animal)
    end

    def print_selected_details(detail_select, animal)
        if detail_select == "Scientific Name"
            puts "\nScientific Name: #{animal.sci_name}"
        elsif detail_select == "Full Hierarchy"
            puts "\n"
            animal.full_hier.each do |hier|
                puts "#{hier["rankName"]}: #{hier["taxonName"]}"
            end
        elsif detail_select == "Publications"
            if animal.publications.class == Hash
                puts "\nPublication: #{animal.publications["pubName"]}"
                puts "Author: #{animal.publications["referenceAuthor"]}"
                puts "Title: #{animal.publications["title"]}"
                puts "Date: #{animal.publications["actualPubDate"]}"                

            elsif animal.publications.class == Array
                animal.publications.each do |pub|
                    puts "\nPublication: #{pub["pubName"]}"
                    puts "Author: #{pub["referenceAuthor"]}"
                    puts "Title: #{pub["title"]}"
                    puts "Date: #{pub["actualPubDate"]}"
                end
            else
                puts "No publications recorded in our database yet"
            end
        else
            # invalid_response_common_name
        end
        what_next?(animal)
    end

    def what_next?(animal)
        puts "\nEnter 'more info', 'new search', 'show prior species searched' or 'exit'"
        input = gets.chomp

        if input = "more info"
            self.def select_details(animal.tsn)
        # if input = "new search"
        #     self.run
        # elsif input = 'show prior species searched'
        #     self.list_animal_selection
        elsif input = 'exit'
            abort("\nThank you for learning with us!\n\n")
        else
            self.invalid_input
            self.what_next?(animal)
        end
    end

    def invalid_input
        puts "Invalid response"
    end
end