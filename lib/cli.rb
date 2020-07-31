# Don't overuse instance variables, only when an 'attribute of an instance' truly needs to be stored
# Interaction with user is in here
# puts and gets here

class CLI

    def welcome
        puts "\nWelcome!\n\n"
        puts "Please enter the common name of any living thing:"
        animal = gets.chomp
        self.get_animal_tsn_by_common_name(animal)
    end

    def get_animal_tsn_by_common_name(animal)
        response = API.get_animal_tsn(animal)
        array = response["searchByCommonNameResponse"]['return']["commonNames"]

        # binding.pry

        array.each do |animal|    # area to discuss in the techical blog
            hash = {common_name: animal["commonName"], tsn: animal["tsn"]}
            Animal.new(hash)
        end
        self.list_animal_selection
    end

    def invalid_response

    end

    def list_animal_selection
        # insert if statement here to account for only 1 animal selection
        puts "\n"
        Animal.all.each_with_index do |animal, index|
            puts "#{index+1}. #{animal.common_name}"
        end
        # binding.pry
        self.narrow_animal_selection
    end

    def narrow_animal_selection
        puts "\nPlease narrow your animal selection by entering the corresponding number:"
        input = gets.chomp
        tsn_select = Animal.all[input.to_i-1].tsn
        cn_select = Animal.all[input.to_i-1].common_name
        
        puts "\nThank you, the Taxonomic Serial Number for the #{cn_select} is #{tsn_select}. \n\n"

        self.select_details(cn_select, tsn_select)
    end


    def select_details(cn_select,tsn_select)

        option_array = ["Scientific Name", "Full Hierarchy", "Comment Detail"]
        
        option_array.each_with_index do |option, index|
            puts "#{index+1}. #{option}"
        end

        puts "\nWhat would you like to learn about the #{cn_select}? (Enter corresponding number)"
        input = gets.chomp
        
        detail_select = option_array[input.to_i-1]

        self.detail_input_split(detail_select, tsn_select)

    end


    def detail_input_split(detail_select, tsn_select)

        #blog option to talk about route of nested if statements vs spliting off earlier

        if detail_select == "Scientific Name"
            self.get_animal_details_by_sci_name(detail_select, tsn_select)
        elsif detail_select == "Full Hierarchy"
            self.get_animal_details_by_full_hier(detail_select, tsn_select)
        elsif  detail_select == "Comment Detail"
            self.get_animal_details_by_comment(detail_select, tsn_select)
        end

    end

    def get_animal_details_by_sci_name(detail_select, tsn_select)
        response = API.get_animal_details_by_tsn(detail_select.gsub(" ", ""), tsn_select)
        sci_name = response["getScientificNameFromTSNResponse"]["return"]["combinedName"]

        Animal.all.each do |animal|
            if animal.tsn == tsn_select
                animal.sci_name = sci_name
            end
        end

        self.print_selected_string_details(sci_name)

    end

    def get_animal_details_by_full_hier(detail_select, tsn_select)
        response = API.get_animal_details_by_tsn(detail_select.gsub(" ", ""), tsn_select)
        full_hier = response["getFullHierarchyFromTSNResponse"]["return"]["hierarchyList"]

        Animal.all.each do |animal|
            if animal.tsn == tsn_select
                animal.full_hier = full_hier
            end
        end

        self.print_selected_array_details(full_hier)

    end


    def get_animal_details_by_comment(detail_select, tsn_select)
        response = API.get_animal_details_by_tsn(detail_select.gsub(" ", ""), tsn_select)
        comment = response["getCommentDetailFromTSNResponse"]["return"]["comments"]

        Animal.all.each do |animal|
            if animal.tsn == tsn_select
                animal.comment = comment
            end
        end

        self.print_selected_string_details(comment)

    end

    def print_selected_string_details(string)
        if string == nil 
            puts "\nNo comments logged yet on this species"
        else
            puts string
        end
        self.exit
    end

    def print_selected_array_details(array)
        puts "\n"
       array.each do |hier|
        # binding.pry
        puts "#{hier["rankName"]}: #{hier["taxonName"]} "
       end
       self.exit
    end

    def exit
        abort("\nThank you for learning with us!\n\n")
    end

end