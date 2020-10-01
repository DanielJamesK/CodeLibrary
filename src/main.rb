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
        menu.choice 'Back To Main Menu'
        menu.choice 'Exit'
    end
end


loop do
    case display_options_menu
    when "Add Code"
        case code_catelogue_menu
        when "Image Manipulation"
            puts "Please enter a Title for the code"
            image_title_input = gets.chomp
            puts "Please enter a description of the code"
            image_description_input = gets.chomp
            puts "Please enter a code snippet"
            image_snippet_input = gets.chomp
            CSV.open("image_manipulation.csv", "a") do |row|
                row << [image_title_input, image_description_input, image_snippet_input]
            end
        when "Text Manipulation"
            puts "Please enter a Title for the code"
            text_title_input = gets.chomp
            puts "Please enter a description of the code"
            text_description_input = gets.chomp
            puts "Please enter a code snippet"
            text_snippet_input = gets.chomp
            CSV.open("text_manipulation.csv", "a") do |row|
                row << [text_title_input, text_description_input, text_snippet_input]
            end
        end     
    when "Remove Code"
        case code_catelogue_menu
        when "Image Manipulation"
            puts "Please type the Title of the code you wish to delete"
            image_delete_input = gets.chomp
            removed_images = CSV.read("image_manipulation.csv", headers:true)
            removed_images.delete_if{ |row| row["title"] == image_delete_input }

            CSV.open("image_manipulation.csv", "w", headers:true) { |row| 
            row << ["title","description","code snippet"]
            removed_images.each { |image| row << image }
            }
        end
    when "Edit Code"
        case code_catelogue_menu
        when "Image Manipulation"
            puts "Please type the Title of the code you wish to edit"
            image_edit_input = gets.chomp
            edited_images = CSV.read("image_manipulation.csv", headers:true)
            edited_images.delete_if do |row| 
            row["title"] == image_edit_input
            end
            puts "Please enter new Title for the code"
            image_edit_title_input = gets.chomp
            puts "Please enter a new Description for the code"
            image_edit_description_input = gets.chomp
            puts "Please enter a new code snippet"
            image_edit_snippet_input = gets.chomp
            edited_images << [image_edit_title_input, image_edit_description_input, image_edit_snippet_input]
            
            CSV.open("image_manipulation.csv", "w", headers:true) { |row| 
            row << ["title","description","code snippet"]
            edited_images.each { |image| row << image }
            }
        end
    when "Search"
        case code_catelogue_menu
        when "Image Manipulation"
            system("clear")
            images = []
            CSV.foreach("image_manipulation.csv", headers: true).select { |row| 
                images << [row["title"], row["description"], row["code snippet"]]
        }
            image_table = TTY::Table.new(["Title","Description","Code Snippet"], images)
            puts image_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
        when "Text Manipulation"
            system("clear")
            text = []
            CSV.foreach("text_manipulation.csv", headers: true).select { |row| 
                text << [row["Title"], row["Description"], row["Code Snippet"]]
        }
            text_table = TTY::Table.new(["Title","Description","Code Snippet"], text)
            puts text_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
        when "Flexbox"
            system("clear")
        when "Grid"
            system("clear")     
        when "Back"
            system("clear")
            break
        when "Exit"
            system("clear")
            exitProgram
        end
    when "Exit"
        system("clear")
        exit
    end
end

#.delete_if

puts "Goodbye"


