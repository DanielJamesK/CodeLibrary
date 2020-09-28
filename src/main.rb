
class User

    attr_reader :username, :password
    def initialize(username, password)
        @username = username
        @password = password
    end

    def display_options
        puts "What would you like to do?"
        puts "Options: "
        puts @options
    end
end 

class GeneralUser < User
    def initialize(username, password)
        super(username, password)
        @options = ["Search", "Favourites", "Help", "Exit"]
        @favourites = {}
    end

end 

list_of_users = [
    GeneralUser.new("Daniel", "pass"),
    GeneralUser.new("Ben", "password")
]