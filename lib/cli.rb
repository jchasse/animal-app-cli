# Don't overuse instance variables, only when an 'attribute of an instance' truly needs to be stored
# Interaction with user is in here
# puts and gets here

class CLI

    def welcome
        puts "Welcome!"
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

        Animal.all.each_with_index do |animal, index|
            puts "#{index+1}. #{animal.common_name}"
        end
        self.narrow_animal_selection
    end

    def narrow_animal_selection
        puts "Please narrow your animal selection by entering the corresponding number:"
        int = gets.chomp
        tsn_select = Animal.all[int.to_i-1].tsn
        cn_select = Animal.all[int.to_i-1].common_name
        
        puts "The Taxonomic Serial Number for #{cn_select} is #{tsn_select}."
        puts "What would you like to learn about the #{cn_select}? (Enter corresponding number)"

        option_array = ["Scientific Name", "Full Hierarchy", "Comment Detail"]
        
        option_array.each_with_index do |option|
            puts "#{index+1}. #{option}"
        end
        int_d = gets.chomp
        detail_select = option_array[int_d.to_i-1]

        details = API.get_animal_details_by_tsn(detail_select, tsn_select)
        binding.pry
        
    end
end