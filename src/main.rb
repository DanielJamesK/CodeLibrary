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

def display_text
    system("clear")
    text = []
    CSV.foreach("text_manipulation.csv", headers: true).select { |row| 
    text << [row["title"], row["description"], row["code snippet"]]
    }
    text_table = TTY::Table.new(["Title","Description","Code Snippet"], text)
    puts text_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def display_flexbox
    system("clear")
    flexbox = []
    CSV.foreach("flexbox.csv", headers: true).select { |row| 
    flexbox << [row["title"], row["description"], row["code snippet"]]
    }
    flexbox_table = TTY::Table.new(["Title","Description","Code Snippet"], flexbox)
    puts flexbox_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def display_grid
    system("clear")
    grid = []
    CSV.foreach("grid.csv", headers: true).select { |row| 
        grid << [row["title"], row["description"], row["code snippet"]]
    }
    grid_table = TTY::Table.new(["Title","Description","Code Snippet"], grid)
    puts grid_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def add_code
    csv_option = 
    csv_options
    puts "Please enter a Title for the code"
    puts "Valid characters include a-z A-Z ':|-"
    add_title_input = gets.chomp
    if add_title_input.match? /\A[a-zA-Z':|-]{1,20}\z/
        puts "Are you sure you want to add #{add_title_input.capitalize} to the code library?"
        prompt = TTY::Prompt.new
        add_code_warning_prompt = prompt.select('Please select an answer:') do |menu|
            menu.choice 'Yes'
            menu.choice 'No'
        end
        if add_code_warning_prompt.downcase == "yes"
            if add_title_input.match? /\A[a-zA-Z':|-]{1,20}\z/
                puts "Please enter a description of the code - max 40 characters"
                puts "Valid characters include a-z A-Z ':|-"
                add_description_input = gets.chomp
                if add_description_input.match? /\A[a-zA-Z':|-]{1,40}\z/
                    puts "Please enter a code snippet - max 40 characters"
                    puts "Valid characters include a-z A-Z ':|-"
                    add_snippet_input = gets.chomp
                    if add_snippet_input.match? /\A[a-zA-Z':|-]{1,40}\z/
                        CSV.open(csv_option, "a") do |row|
                            row << [add_title_input.capitalize, add_description_input.capitalize, add_snippet_input]
                        end
                    else
                        puts "Invalid Code Snippet"
                        puts "Returning you to the Main Menu"
                    end
                else
                    puts "Invalid Description"
                    puts "Returning you to the Main Menu"
                end
            else
                puts "Invalid Title name"
                puts "Returning you to the Main Menu"
            end
        else add_code_warning_prompt.downcase == "no"
            puts "Returning you to the Main Menu"
        end
    else
        puts "Invalid Title name"
        puts "Returning you to the Main Menu"
    end
end

def remove_code
    csv_option = 
    csv_options
    if csv_option == "image_manipulation.csv"
        display_images
    elsif csv_option == "text_manipulation.csv"
        display_text
    elsif csv_option == "flexbox.csv"
        display_flexbox
    else csv_option == "grid.csv"
        display_grid
    end
    puts "Please type the Title of the code you wish to delete"
    delete_input = gets.chomp
    if delete_input.match? /\A[a-zA-Z':|-]{1,20}\z/
        puts "Are you sure you want to remove #{delete_input.capitalize} from the code library?"
        prompt = TTY::Prompt.new
        remove_code_warning_prompt = prompt.select('Please select an answer:') do |menu|
            menu.choice 'Yes'
            menu.choice 'No'
        end
        if remove_code_warning_prompt.downcase == "yes"
            removed_code = CSV.read(csv_option, headers:true)
            if removed_code.find { |row| row["title"] == delete_input.capitalize }
                removed_code.delete_if{ |row| row["title"] == delete_input.capitalize }

                CSV.open(csv_option, "w", headers:true) { |row| 
                row << ["title","description","code snippet"]
                removed_code.each { |code| row << code }
                }
                system("clear")
                puts "#{delete_input.capitalize} Successfully Removed"
            else
                puts "Code title not found"
                puts "Returning you to main menu"
            end
        else remove_code_warning_prompt.downcase == "no"
            puts "Returning you to main menu"
        end
    else
        puts "Invalid Title name"
        puts "Returning you to the Main Menu"
    end
end

def edit_code
    csv_option = 
    csv_options
    if csv_option == "image_manipulation.csv"
        display_images
    elsif csv_option == "text_manipulation.csv"
        display_text
    elsif csv_option == "flexbox.csv"
        display_flexbox
    else csv_option == "grid.csv"
        display_grid
    end
    puts "Please type the Title of the code you wish to edit"
    edit_input = gets.chomp
    if edit_input.match? /\A[a-zA-Z':|-]{1,20}\z/
        puts "Are you sure you want to edit #{edit_input}?"
        prompt = TTY::Prompt.new
        edit_code_warning_prompt = prompt.select('Please select an answer:') do |menu|
            menu.choice 'Yes'
            menu.choice 'No'
        end
        if edit_code_warning_prompt.downcase == "yes"
            edited_code = CSV.read(csv_option, headers:true)
            if edited_code.find { |row| row["title"] == edit_input.capitalize }
                edited_code.delete_if do |row| 
                row["title"] == edit_input.capitalize
                end
                puts "Please enter new Title for the code - max 20 characters"
                puts "Valid characters include a-z A-Z ':|-"
                edit_title_input = gets.chomp
                if edit_title_input.match? /\A[a-zA-Z':|-]{1,20}\z/
                    puts "Please enter a new Description for the code - max 40 characters"
                    puts "Valid characters include a-z A-Z ':|-"
                    edit_description_input = gets.chomp
                    if edit_description_input.match? /\A[a-zA-Z':|-]{1,40}\z/
                        puts "Please enter a new code snippet - max 40 characters"
                        puts "Valid characters include a-z A-Z ':|-"
                        edit_snippet_input = gets.chomp
                        if edit_snippet_input.match? /\A[a-zA-Z':|-]{1,40}\z/
                            edited_code << [edit_title_input.capitalize, edit_description_input.capitalize, edit_snippet_input]
                            CSV.open(csv_option, "w", headers:true) { |row| 
                            row << ["title","description","code snippet"]
                            edited_code.each { |code| row << code }
                            }
                        else
                            puts "Invalid Code Snippet"
                            puts "Returning you to the Main Menu"
                        end
                    else
                        puts "Invalid Description"
                        puts "Returning you to the Main Menu"
                    end
                else
                    puts "Invalid Title name"
                    puts "Returning you to the Main Menu"
                end
            else 
                puts "Code title not found"
                puts "Returning you to the Main Menu"
            end
        else edit_code_warning_prompt.downcase == "no"
            puts "Returning you to the Main Menu"
        end 
    else
        puts "Invalid Title name"
        puts "Returning you to the Main Menu"
    end
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
        system("clear")
        add_code   
    when "Remove Code"
        system("clear")
        remove_code
    when "Edit Code"
        system("clear")
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



