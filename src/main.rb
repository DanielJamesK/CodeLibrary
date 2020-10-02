require 'tty-prompt'
require 'tty-table'
require 'json'
require 'csv'
require 'pp'

# class User

#     attr_reader :username, :password
#     def initialize(username, password)
#         @username = username
#         @password = password
#     end
    
#     def display_options
#         puts "What would you like to do?"
#             puts "Options: "
#             puts @options
#     end
# end 

# class GeneralUser < User
#     def initialize(username, password)
#         super(username, password)
#         @options = ["Search For Code", "Favourites", "Help", "Exit"]
#         @favourites = {}
#     end
# end 

# class AdminUser < User
#     def initialize(username, password)
#         super(username, password)
#         @options = ["Add Code", "Edit Code", "Remove Code", "Search For Code", "Help", "Exit"]
#     end
# end

class CodeCatalogue
    attr_accessor :code
    def initialize
        @code = []
    end
end

class Images < CodeCatalogue
    @images_library = []
    def view_images_input(image_manipulation)
        @images_library=CSV.parse(FILE.read("#{image_manipulation}.csv"))
        image_table = TTY::Table.new(["Title","Description","Code Snippet"], @images_library.to_a)
        image_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
    end
end

def display_options_menu
    prompt = TTY::Prompt.new
    display_options_menu = prompt.select('Please select an option:') do |menu|   
        menu.choice 'Add Code'
        menu.choice 'Edit Code'
        menu.choice 'Remove Code'
        menu.choice 'Search'
        menu.choice 'Favourites'
        menu.choice 'Help'
        menu.choice 'Exit'
    end
end

def code_catelogue_menu
    prompt = TTY::Prompt.new
    search_options = prompt.select('Please select a category:') do |menu|
        menu.choice 'Image Manipulation'
        menu.choice 'Text Manipulation'
        menu.choice 'Flexbox'
        menu.choice 'Grid'
        #menu.choice 'Back To Main Menu'
        menu.choice 'Exit'
    end
end

def display_images
    system("clear")
    images = []
    CSV.foreach("image_manipulation.csv", headers: true).select { |row| 
        images << [row["title"], row["description"], row["code snippet"]]
    }
    image_table = TTY::Table.new(["Title","Description","Code Snippet"], images)
    puts image_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def add_code
    csv_option = 
    csv_options
    puts "Please enter a Title for the code"
    a_input = gets.chomp
    puts "Please enter a description of the code"
    b_input = gets.chomp
    puts "Please enter a code snippet"
    c_input = gets.chomp
    CSV.open(csv_option, "a") do |row|
        row << [a_input, b_input, c_input]
    end
end

def remove_code
    csv_option = 
    csv_options
    puts "Please type the Title of the code you wish to delete"
    delete_input = gets.chomp
    removed_code = CSV.read(csv_option, headers:true)
    removed_code.delete_if{ |row| row["title"] == delete_input }

    CSV.open(csv_option, "w", headers:true) { |row| 
    row << ["title","description","code snippet"]
    removed_code.each { |code| row << code }
    }
end

def edit_code
    csv_option = 
    csv_options
    puts "Please type the Title of the code you wish to edit"
    edit_input = gets.chomp
    edited_code = CSV.read(csv_option, headers:true)
    edited_code.delete_if do |row| 
    row["title"] == edit_input
    end
    puts "Please enter new Title for the code"
    edit_title_input = gets.chomp
    puts "Please enter a new Description for the code"
    edit_description_input = gets.chomp
    puts "Please enter a new code snippet"
    edit_snippet_input = gets.chomp
    edited_code << [edit_title_input, edit_description_input, edit_snippet_input]
    
    CSV.open(csv_option, "w", headers:true) { |row| 
    row << ["title","description","code snippet"]
    edited_code.each { |code| row << code }
    }
end

def display_search
    csv_option = 
    csv_options
    system("clear")
    display_code = []
    CSV.foreach(csv_option, headers: true).select { |row| 
        display_code << [row["title"], row["description"], row["code snippet"]]
    }
    display_code_table = TTY::Table.new(["Title","Description","Code Snippet"], display_code)
    puts display_code_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
    puts "Would you like to add any of these code snippets to your favourites?"
    prompt = TTY::Prompt.new
    add_code_prompt = prompt.select('Please select an answer:') do |menu|
        menu.choice 'Yes'
        menu.choice 'No'
    end
    if add_code_prompt.downcase == "yes"
        puts "Please enter the title of the code you would like to add"
        favourites_input = gets.chomp
        favourites_add = CSV.read(csv_option, headers:true)
        favourites_add.delete_if{ |row| row["title"] != favourites_input } 
        CSV.open("favourites.csv", "a", headers:true) { |row| 
        favourites_add.each { |favourite| row << favourite }
        }
    end
end

def csv_options
    csv_option = 
    case code_catelogue_menu
    when "Image Manipulation"
        csv_option = "image_manipulation.csv"
    when "Text Manipulation"
        csv_option = "text_manipulation.csv"
    when "Flexbox"
        csv_option = "flexbox.csv"
    when "Grid"
        csv_option = "grid.csv"
    when "Exit"
        system("clear")
        exit
    end
end

loop do
    case display_options_menu
    when "Add Code"
        add_code   
    when "Remove Code"
        remove_code
    when "Edit Code"
        edit_code
# General User Search Options
    when "Search"
        display_search 
    when "Favourites"
        system("clear")
        prompt = TTY::Prompt.new
        favourites_prompt = prompt.select('What would you like to do?') do |menu|
            menu.choice 'Display Favourite Code'
            menu.choice 'Delete Code From Favourites'
        end
        if favourites_prompt.downcase == "display favourite code"
            system("clear")
            favourites = []
            CSV.foreach("favourites.csv", headers: true).select { |row| 
                favourites << [row["title"], row["description"], row["code snippet"]]
            }
            favourites_table = TTY::Table.new(["Title","Description","Code Snippet"], favourites)
            puts favourites_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
        else favourites_prompt.downcase == "delete code from favourites"
            puts "Please type the Title of the code you wish to delete"
            favourite_delete_input = gets.chomp
            removed_favourite = CSV.read("favourites.csv", headers:true)
            removed_favourite.delete_if{ |row| row["title"] == favourite_delete_input }

            CSV.open("favourites.csv", "w", headers:true) { |row| 
            row << ["title","description","code snippet"]
            removed_favourite.each { |image| row << image }
            }
        end
    when "Exit"
        system("clear")
        exit
    end
end


puts "Goodbye"


