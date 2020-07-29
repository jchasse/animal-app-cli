# Don't overuse instance variables, only when an 'attribute of an instance' truly needs to be stored
# Interaction with user is in here
#puts and gets here

class CLI

    def welcome
        puts "Welcome!"
        puts "Please enter your favorite animal:"
        animal = gets.chomp
        self.get_animal_info(animal)
    end

  



end