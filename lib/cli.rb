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
        binding.pry

        #enter in 2nd level deep question
        tsn_selected = Animal.all[int.to_i].tsn

    end




end