require 'tty-prompt'
require 'json'
require 'csv'

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
    input_username = gets.chomp
    puts "Please create a password"
    input_password = gets.chomp
    user_account = { input_username: input_password }
    CSV.open("users.csv" , "a") do |user|
        user << [input_username, input_password]
    end


    # CSV.open("cats.csv", "w") do |csv|
#    csv << ["color", "qty"]
#    cats.to_a.each { |cat| csv << cat }
# end
end



list_of_users = [
    GeneralUser.new("Steph", "pass"),
    GeneralUser.new("Ben", "password"),
    AdminUser.new("Daniel", "admin")
]


login_menu = prompt.select('Please select an option:') do |menu|
  
    menu.choice 'Create an Account'
    menu.choice 'Sign-In'
    menu.choice 'Exit'
end

case login_menu
when "Create an Account"
    createAccount
end
    

