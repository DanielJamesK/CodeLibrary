require 'tty-prompt'
require 'tty-table'
require 'json'
require 'csv'


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


#     puts "Please create a username"
#     input_username = gets.chomp
#     puts "Please create a password"
#     input_password = gets.chomp
#     puts "Are you an admin? yes/no"
#     input_answer = gets.chomp
#     if input_answer == "yes"
#         AdminUser.new(input_username, input_password)
#     else
#         GeneralUser.new(input_username, input_password)
#     end
#     CSV.open("users.csv" , "a") do |user|
#         user << [input_username, input_password, input_answer]
#     end
#     puts "Account Created"
#     return



# def loginScreen
#     prompt = TTY::Prompt.new
#     login_menu = prompt.select('Please select an option:') do |menu|
        
#         menu.choice 'Create an Account'
#         menu.choice 'Sign-In'
#         menu.choice 'Exit'
#     end
    
#     case login_menu
#     when "Create an Account"
#         system ("clear")
#         puts "If you created an account, please Sign-In to continue"
#         loginScreen     
#     when "Sign-In"
#         puts "Please enter your username"
#         input_username = gets.chomp
#         puts "Please enter your password"
#         input_password = gets.chomp
#         authenticate_users = File.open("users.csv", "r")
#         if authenticate_users.read().include? "yes"
#             puts authenticate_users.read().include? input_username
#             puts "You are logged in as admin"
#         else 
#             puts authenticate_users.read().include? input_username
#             puts "You are logged in"
#         end
#     end
# end

prompt = TTY::Prompt.new
    display_options_menu = prompt.select('Please select an option:') do |menu|
        
        menu.choice 'Add Code'
        menu.choice 'Edit Code'
        menu.choice 'Remove Code'
        menu.choice 'Search'
        menu.choice 'Help'
        menu.choice 'Exit'
    end

    case display_options_menu
    when "Search"
        table = TTY::Table.new(["header1","header2"], [["a1", "a2"], ["b1", "b2"]])
        puts table.render(:ascii)
    end
    
    

# list_of_users = []

# CSV.foreach("users.csv") do |row|
#     #p row 
#     hash = {name: row[0], password: row[1]}
#     list_of_users << hash
# end

# p list_of_users

# user = list_of_users.find { |user| user.username == input_username  }
# if user.username == input.username && user.password == input_password
#     p "hello"
# end

#loginScreen
#signIn



