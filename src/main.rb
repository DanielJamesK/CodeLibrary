require 'tty-prompt'

prompt = TTY::Prompt.new

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
        @options = ["Search For Code", "Favourites", "Help", "Exit"]
        @favourites = {}
    end
end 

class AdminUser < User
    def initialize(username, password)
        super(username, password)
        @options = ["Add Code", "Edit Code", "Remove Code", "Search For Code", "Help", "Exit"]
    end
end

def createAccount
    puts "Please create a username"
end

list_of_users = [
    GeneralUser.new("Steph", "pass"),
    GeneralUser.new("Ben", "password"),
    AdminUser.new("Daniel", "admin")
]


prompt.select('Please select an option:') do |menu|
  
    menu.choice 'Create an Account'
    menu.choice 'Sign-In'
    menu.choice 'Exit'
  end

