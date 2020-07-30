# Don't overuse instance variables, only when an 'attribute of an instance' truly needs to be stored
# Interaction with user is in here
# puts and gets here

class CLI

    def welcome
        puts "Welcome!\n\n"
        puts "Please enter your favorite animal:"
        animal = gets.chomp
        self.get_animal_tsn_by_input(animal)
    end

    def get_animal_tsn_by_input(animal)
        response = API.get_animal_tsn(animal)

        array = response["searchByCommonNameResponse"]['return']["commonNames"]
        array.each do |animal|    # area to discuss in the technical blog
            hash = {common_name: animal["commonName"], tsn: animal["tsn"]}
            Animal.new(hash)
        end
        self.list_animal_selection
    end

    def list_animal_selection
        # insert if statement here to account for only 1 animal selection
        puts "\n"
        Animal.all.each_with_index do |animal, index|
            puts "#{index+1}. #{animal.common_name}"
        end
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
        
        detail_select = option_array[input.to_i-1].gsub(" ", "")

        self.get_animal_details_by_input(option_array, detail_select, tsn_select)

    end

    def get_animal_details_by_input(option_array, detail_select, tsn_select)

        response = API.get_animal_details_by_tsn(detail_select, tsn_select)

        binding.pry
        option_array.each do |option|
            detail_select == option


        sci_name = response["getScientificNameFromTSNResponse"]["return"]["combinedName"]

        # array = response["searchByCommonNameResponse"]['return']["commonNames"]
        # array.each do |animal|    # area to discuss in the technical blog
        #     hash = {common_name: animal["commonName"], tsn: animal["tsn"]}
        #     Animal.new(hash)
        # end
        # self.list_animal_selection

    end
end