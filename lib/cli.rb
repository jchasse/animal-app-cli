class CLI

    def self.welcome
        puts "\nWelcome!"
        self.run
    end

    def self.run 
        puts "\nPlease enter the common name of any living thing:"
        input = gets.chomp
        API.get_animal_tsn_by_common_name(input)
    end

    def self.invalid_response_common_name
        puts "\nInvalid input. Please make sure to input the common name, not scientific name."
        self.run
    end

    def self.list_animal_selection
        puts "\n" 
        Animal.all.each_with_index do |animal, index|
            puts "#{index+1}. #{animal.common_name}"
        end
        self.narrow_animal_selection
    end

    def self.narrow_animal_selection
        
        puts "\nPlease narrow your animal selection by entering the corresponding number:"
        input = gets.chomp
        if input.to_i.between?(1,Animal.all.length)

            tsn_select = Animal.all[input.to_i-1].tsn
            cn_select = Animal.all[input.to_i-1].common_name
            
            puts "\nThank you, the Taxonomic Serial Number for the #{cn_select} is #{tsn_select}."

            self.select_details(cn_select, tsn_select)
        else
            self.invalid_input
            self.narrow_animal_selection
        end
    end

    def self.select_details(cn_select = "species",tsn_select)

        option_array = ["Scientific Name", "Full Hierarchy", "Publications"]
        
        puts "\n"
        option_array.each_with_index do |option, index|
            puts "#{index+1}. #{option}"
        end

        puts "\nWhat would you like to learn about the #{cn_select}? (Enter corresponding number)"
        input = gets.chomp
        if input.to_i.between?(1, option_array.length)
            detail_select = option_array[input.to_i-1]
        else
            self.invalid_input
            self.select_details(cn_select,tsn_select)
        end
        self.check_for_animal_data(detail_select, tsn_select)
    end

    def self.check_for_animal_data(detail_select, tsn_select)
        if detail_select == "Scientific Name" && Animal.find_by_tsn(tsn_select).sci_name != nil
            self.animal_to_print(detail_select,tsn_select)
        elsif detail_select == "Full Hierarchy" && Animal.find_by_tsn(tsn_select).full_hier != nil
            self.animal_to_print(detail_select,tsn_select)
        elsif detail_select == "Publications" && Animal.find_by_tsn(tsn_select).publications != nil
            self.animal_to_print(detail_select,tsn_select)
        else
            API.get_animal_details(detail_select, tsn_select)
        end
    end

    def self.animal_to_print(detail_select,tsn_select)
        animal = Animal.find_by_tsn(tsn_select)
        self.print_selected_details(detail_select, animal)
    end

    def self.print_selected_details(detail_select, animal)
        if detail_select == "Scientific Name"
            puts "\nScientific Name: #{animal.sci_name}"
        
        elsif detail_select == "Full Hierarchy"
            puts "\n"
            if animal.full_hier.class == Hash
                puts "#{animal.full_hier["rankName"]}: #{animal.full_hier["taxonName"]}"
            elsif animal.full_hier.class == Array
                animal.full_hier.each do |hier|
                    puts "#{hier["rankName"]}: #{hier["taxonName"]}"
                end
            else
                puts "\nThis input resulted in an error in pulling from our database."
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
                puts "\nNo publications recorded in our database yet"
            end
        else
            self.invalid_input
        end
        self.what_next?(animal)
    end

    def self.what_next?(animal)
        puts "\nEnter 'more info', 'new search', 'show prior search' or 'exit'"
        input = gets.chomp

        if input == "more info"
            self.def select_details(animal.tsn)
        elsif input == "new search"
            Animal.clear
            self.run
        elsif input == 'show prior search'
            self.list_animal_selection
        elsif input == 'exit'
            sleep 1
            abort("\nThank you for learning with us!\n\n")
        else
            self.invalid_input
            self.what_next?(animal)
        end
    end

    def self.invalid_input
        puts "\nInvalid input"
        sleep 1
    end
end