require 'tty-prompt'
require 'tty-table'
require 'pastel'
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

def display_favourites
    system("clear")
    favourites = []
    CSV.foreach("favourites.csv", headers: true).select { |row| 
    favourites << [row["title"], row["description"], row["code snippet"]]
    }
    favourites_table = TTY::Table.new(["Title","Description","Code Snippet"], favourites)
    puts favourites_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def add_code
    csv_option = 
    csv_options
    puts "Please enter a Title for the code"
    puts "Valid characters include a-z A-Z ':|-"
    add_title_input = gets.chomp
    if add_title_input.match? /\A[a-zA-Z':|-]{1,20}\z/
        warning_pastel = Pastel.new
        puts warning_pastel.yellow("Are you sure you want to add #{add_title_input.capitalize} to the code library?")
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
                        system("clear")
                        success_pastel = Pastel.new
                        puts success_pastel.green("#{add_title_input.capitalize} successfully added to the code library")
                        puts "Returning you to the Main Menu"
                    else
                        invalid_code_snippet
                    end
                else
                    invalid_description
                end
            else
                invalid_title_name
            end
        else add_code_warning_prompt.downcase == "no"
            system("clear")
            puts "Returning you to the Main Menu"
        end
    else
        invalid_title_name
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
        warning_pastel = Pastel.new
        puts warning_pastel.yellow("Are you sure you want to remove #{delete_input.capitalize} from the code library?")
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
                success_pastel = Pastel.new
                puts success_pastel.green("#{delete_input.capitalize} successfully Removed")
                puts "Returning you to the Main Menu"
            else
                code_title_not_found
            end
        else remove_code_warning_prompt.downcase == "no"
            system("clear")
            puts "Returning you to main menu"
        end
    else
        invalid_title_name
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
        warning_pastel = Pastel.new
        puts warning_pastel.yellow("Are you sure you want to edit #{edit_input.capitalize}?")
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
                            system("clear")
                            success_pastel = Pastel.new
                            puts success_pastel.green("#{edit_input.capitalize} successfully edited")
                            puts "Returning you to the Main Menu"
                        else
                            invalid_code_snippet
                        end
                    else
                        invalid_description
                    end
                else
                    invalid_title_name
                end
            else 
                code_title_not_found
            end
        else edit_code_warning_prompt.downcase == "no"
            system("clear")
            puts "Returning you to the Main Menu"
        end 
    else
        invalid_title_name
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
        puts "Valid characters include a-z A-Z ':|-"
        favourites_input = gets.chomp
        if favourites_input.match? /\A[a-zA-Z':|-]{1,20}\z/
            favourites_add = CSV.read(csv_option, headers:true)
            if favourites_add.find { |row| row["title"] == favourites_input.capitalize }
                favourites_add.delete_if{ |row| row["title"] != favourites_input.capitalize } 
                CSV.open("favourites.csv", "a", headers:true) { |row| 
                favourites_add.each { |favourite| row << favourite }
                }
                system("clear")
                success_pastel = Pastel.new
                puts success_pastel.green("#{favourites_input.capitalize} successfully added to favourites library")
            else
                code_title_not_found
            end
        else
            invalid_title_name
        end
    else add_code_prompt.downcase == "no"
        system("clear")
        puts "Returning you to the Main Menu"
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

def invalid_title_name
    invalid_title_pastel = Pastel.new
    puts invalid_title_pastel.red("Error - Invalid Title name")
    puts "Returning you to the Main Menu"
end

def invalid_description
    invalid_description_pastel = Pastel.new
    puts invalid_description_pastel.red("Error - Invalid Description")
    puts "Returning you to the Main Menu"
end

def invalid_code_snippet
    invalid_code_snippet_pastel = Pastel.new
    puts invalid_code_snippet_pastel.red("Error - Invalid Code Snippet")
    puts "Returning you to the Main Menu"
end

def code_title_not_found
    code_title_pastel = Pastel.new
    puts code_title_pastel.red("Error - Code title not found")
    puts "Returning you to the Main Menu"
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
        display_favourites
        prompt = TTY::Prompt.new
        favourites_prompt = prompt.select('What would you like to do?') do |menu|
            menu.choice 'Delete Code From Favourites'
            menu.choice 'Back to Main Menu'
            menu.choice 'Exit'
        end
        case favourites_prompt
        when "Delete Code From Favourites"
            puts "Please type the Title of the code you wish to delete"
            favourite_delete_input = gets.chomp
            if favourite_delete_input.match? /\A[a-zA-Z':|-]{1,20}\z/
                puts "Are you sure you want to remove #{favourite_delete_input.capitalize} from your favourites list?"
                prompt = TTY::Prompt.new
                favourite_remove_code_warning_prompt = prompt.select('Please select an answer:') do |menu|
                    menu.choice 'Yes'
                    menu.choice 'No'
                end
                if favourite_remove_code_warning_prompt.downcase == "yes"
                    removed_favourite = CSV.read("favourites.csv", headers:true)
                    if removed_favourite.find { |row| row["title"] == favourite_delete_input.capitalize }
                        removed_favourite.delete_if{ |row| row["title"] == favourite_delete_input.capitalize }
                        CSV.open("favourites.csv", "w", headers:true) { |row| 
                        row << ["title","description","code snippet"]
                        removed_favourite.each { |favourite| row << favourite }
                        }
                        system("clear")
                        puts "#{favourite_delete_input.capitalize} Successfully Removed"
                    else
                        puts "Error - Code title not found"
                        puts "Returning you to the Main Menu"
                    end
                else favourite_remove_code_warning_prompt.downcase == "no"
                    system("clear")
                    puts "Returning you to Main Menu"
                end 
            else
                puts "Error - Invalid Title name"
                puts "Returning you to the Main Menu"
            end
        when "Back To Main Menu"
            system("clear")
            next
        when "Exit"
            system("clear")
            exit
        end
    when "Exit"
        system("clear")
        exit
    end
end



