require 'tty-prompt'
require 'tty-table'
require 'tty-font'
require 'pastel'
require 'csv'

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

def display_guest_options_menu
    prompt = TTY::Prompt.new
    display_options_menu = prompt.select('Please select an option:') do |menu|   
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
    images_font = TTY::Font.new(:doom)
    images_title = Pastel.new
    puts images_title.cyan.bold(images_font.write("IMAGES", letter_spacing: 2))
    images = []
    CSV.foreach("image_manipulation.csv", headers: true).select { |row| 
        images << [row["title"], row["description"], row["code snippet"]]
    }
    image_table = TTY::Table.new(["Title","Description","Code Snippet"], images)
    puts image_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def display_text
    system("clear")
    text_font = TTY::Font.new(:doom)
    text_title = Pastel.new
    puts text_title.cyan.bold(text_font.write("TEXT", letter_spacing: 2))
    text = []
    CSV.foreach("text_manipulation.csv", headers: true).select { |row| 
    text << [row["title"], row["description"], row["code snippet"]]
    }
    text_table = TTY::Table.new(["Title","Description","Code Snippet"], text)
    puts text_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def display_flexbox
    system("clear")
    flexbox_font = TTY::Font.new(:doom)
    flexbox_title = Pastel.new
    puts flexbox_title.cyan.bold(flexbox_font.write("FLEXBOX", letter_spacing: 2))
    flexbox = []
    CSV.foreach("flexbox.csv", headers: true).select { |row| 
    flexbox << [row["title"], row["description"], row["code snippet"]]
    }
    flexbox_table = TTY::Table.new(["Title","Description","Code Snippet"], flexbox)
    puts flexbox_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def display_grid
    system("clear")
    grid_font = TTY::Font.new(:doom)
    grid_title = Pastel.new
    puts grid_title.cyan.bold(grid_font.write("GRID", letter_spacing: 2))
    grid = []
    CSV.foreach("grid.csv", headers: true).select { |row| 
        grid << [row["title"], row["description"], row["code snippet"]]
    }
    grid_table = TTY::Table.new(["Title","Description","Code Snippet"], grid)
    puts grid_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def display_favourites
    system("clear")
    favourites_font = TTY::Font.new(:doom)
    favourites_title = Pastel.new
    puts favourites_title.cyan.bold(favourites_font.write("FAVOURITES", letter_spacing: 2))
    favourites = []
    CSV.foreach("favourites.csv", headers: true).select { |row| 
    favourites << [row["title"], row["description"], row["code snippet"]]
    }
    favourites_table = TTY::Table.new(["Title","Description","Code Snippet"], favourites)
    puts favourites_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def add_code
    add_code_font = TTY::Font.new(:doom)
    add_code_title = Pastel.new
    puts add_code_title.cyan.bold(add_code_font.write("ADD CODE", letter_spacing: 2))
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
    remove_code_font = TTY::Font.new(:doom)
    remove_code_title = Pastel.new
    puts remove_code_title.cyan.bold(remove_code_font.write("REMOVE CODE", letter_spacing: 2))
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
    edit_code_font = TTY::Font.new(:doom)
    edit_code_title = Pastel.new
    puts edit_code_title.cyan.bold(edit_code_font.write("EDIT CODE", letter_spacing: 2))
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

def display_admin_search
    csv_option = 
    csv_options
    system("clear")
    display_code = []
    if csv_option == "image_manipulation.csv"
        images_font = TTY::Font.new(:doom)
        images_title = Pastel.new
        puts images_title.cyan.bold(images_font.write("IMAGES", letter_spacing: 2))
    elsif csv_option == "text_manipulation.csv"
        text_font = TTY::Font.new(:doom)
        text_title = Pastel.new
        puts text_title.cyan.bold(text_font.write("TEXT", letter_spacing: 2))
    elsif csv_option == "flexbox.csv"
        flexbox_font = TTY::Font.new(:doom)
        flexbox_title = Pastel.new
        puts flexbox_title.cyan.bold(flexbox_font.write("FLEXBOX", letter_spacing: 2))
    else csv_option == "grid.csv"
        grid_font = TTY::Font.new(:doom)
        grid_title = Pastel.new
        puts grid_title.cyan.bold(grid_font.write("GRID", letter_spacing: 2))
    end
    CSV.foreach(csv_option, headers: true).select { |row| 
        display_code << [row["title"], row["description"], row["code snippet"]]
    }
    display_code_table = TTY::Table.new(["Title","Description","Code Snippet"], display_code)
    puts display_code_table.render(:unicode, multiline: true, alignments: [:left, :left], padding:[1,1])
end

def display_search
    csv_option = 
    csv_options
    system("clear")
    display_code = []
    if csv_option == "image_manipulation.csv"
        images_font = TTY::Font.new(:doom)
        images_title = Pastel.new
        puts images_title.cyan.bold(images_font.write("IMAGES", letter_spacing: 2))
    elsif csv_option == "text_manipulation.csv"
        text_font = TTY::Font.new(:doom)
        text_title = Pastel.new
        puts text_title.cyan.bold(text_font.write("TEXT", letter_spacing: 2))
    elsif csv_option == "flexbox.csv"
        flexbox_font = TTY::Font.new(:doom)
        flexbox_title = Pastel.new
        puts flexbox_title.cyan.bold(flexbox_font.write("FLEXBOX", letter_spacing: 2))
    else csv_option == "grid.csv"
        grid_font = TTY::Font.new(:doom)
        grid_title = Pastel.new
        puts grid_title.cyan.bold(grid_font.write("GRID", letter_spacing: 2))
    end
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
    system("clear")
    invalid_title_pastel = Pastel.new
    puts invalid_title_pastel.red("Error - Invalid Title name")
    puts "Returning you to the Main Menu"
end

def invalid_description
    system("clear")
    invalid_description_pastel = Pastel.new
    puts invalid_description_pastel.red("Error - Invalid Description")
    puts "Returning you to the Main Menu"
end

def invalid_code_snippet
    system("clear")
    invalid_code_snippet_pastel = Pastel.new
    puts invalid_code_snippet_pastel.red("Error - Invalid Code Snippet")
    puts "Returning you to the Main Menu"
end

def code_title_not_found
    system("clear")
    code_title_pastel = Pastel.new
    puts code_title_pastel.red("Error - Code title not found")
    puts "Returning you to the Main Menu"
end
require 'optparse'

@options = {}

op = OptionParser.new do |opts|
    opts.on("-a", "--adminuser", "If you would like to Add, Edit, or Remove and Code from the library, please continue as Admin.")
    opts.on("-g", "--guestuser", "If you would like to just Search and Add code to your favourites, please continue as Guest")
end

op.parse!
p @options
system("clear")
title_line_one_font = TTY::Font.new(:doom)
welcome_title = Pastel.new
puts welcome_title.cyan.bold(title_line_one_font.write("WELCOME", letter_spacing: 2))

title_line_two_font = TTY::Font.new(:doom)
welcome_title = Pastel.new
puts welcome_title.cyan.bold(title_line_two_font.write("TO THE", letter_spacing: 2))

title_line_three_font = TTY::Font.new(:doom)
welcome_title = Pastel.new
puts welcome_title.cyan.bold(title_line_three_font.write("CODE LIBRARY", letter_spacing: 2))
prompt = TTY::Prompt.new
login_options = prompt.select('Which user would you like to continue as?') do |menu|
    menu.choice 'Admin'
    menu.choice 'Guest'
    menu.choice 'Exit'
end
if login_options.downcase == "admin"
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
        when "Search"
            display_admin_search 
        when "Help"
            system("clear")
            help_font = TTY::Font.new(:doom)
            help_title = Pastel.new
            puts  help_title.cyan.bold( help_font.write("HELP", letter_spacing: 2))
            puts "\n\n"
            puts "Welcome to the Code Library. The Code Library is a resource that allows the user to search for and save helpful code snippets, to assist them on their coding journeys."
            puts "\n"
            help_admin_add_code_font = TTY::Font.new(:straight)
            help_admin_add_code = Pastel.new
            puts  help_admin_add_code.yellow.bold( help_admin_add_code_font.write("ADD CODE", letter_spacing: 2))
            puts "\n"
            puts "To Add Code to the library, select Add Code from the Main Menu. Next select the category you would like to add to, then input a valid Title, Description and Code Snippet for the code you are trying to add, if all the inputs are valid entries, you will be displayed a success message"
            success_pastel = Pastel.new
            puts success_pastel.green("Success! Code added to the Code Library")
            puts "\n"
            puts "If the entries are not valid, you will be displayed an error"
            error_pastel = Pastel.new
            puts error_pastel.red("Error - Invalid Input")
            puts "\n"
            help_admin_edit_code_font = TTY::Font.new(:straight)
            help_admin_edit_code = Pastel.new
            puts  help_admin_edit_code.yellow.bold( help_admin_edit_code_font.write("EDIT CODE", letter_spacing: 2))
            puts "\n"
            puts "To Edit Code in the code library, select Edit Code from the Main Menu. Next select the category the code is in that you would like to edit. Once you have selected the category, enter the Title of the code you want to edit, and the enter a new Title, Description and Code Snippet. If all the inputs are valid entries, you will be displayed a success message"
            puts success_pastel.green("Successfully edited code!")
            puts "\n"
            puts "If the entries are not valid, you will be displayed an error"
            error_pastel = Pastel.new
            puts error_pastel.red("Error - Invalid Input")
            puts "\n"
            help_admin_remove_code_font = TTY::Font.new(:straight)
            help_admin_remove_code = Pastel.new
            puts  help_admin_remove_code.yellow.bold( help_admin_remove_code_font.write("REMOVE CODE", letter_spacing: 2))
            puts "\n"
            puts "To Remove Code from the code library, select Remove Code from the Main Menu. Next select the category you would like to remove code  from, then input the Title of the code you are trying to remove. If the input is a valid entry, you will be displayed a success message"
            success_pastel = Pastel.new
            puts success_pastel.green("Success! Code removed from the code library")
            puts "\n"
            puts "If the entry is not valid, you will be displayed an error"
            error_pastel = Pastel.new
            puts error_pastel.red("Error - Invalid Input")
            puts "\n"
            help_admin_search_font = TTY::Font.new(:straight)
            help_admin_search = Pastel.new
            puts  help_admin_search.yellow.bold( help_admin_search_font.write("SEARCH", letter_spacing: 2))
            puts "\n"
            puts "To Search for Code, select the Search option from the Main Menu. Once selected, it will prompt you with categories of code you can search, simply select one to search its code."
        when "Exit"
            system("clear")
            puts "Goodbye!"
            exit
        end
    end
elsif login_options.downcase == "guest"
# Guest Search Options
    loop do
        case display_guest_options_menu
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
                    warning_pastel = Pastel.new
                    puts warning_pastel.yellow("Are you sure you want to remove #{favourite_delete_input.capitalize} from your favourites list?")
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
                            success_pastel = Pastel.new
                            puts success_pastel.green("#{favourite_delete_input.capitalize} Successfully Removed")
                        else
                            code_title_not_found
                        end
                    else favourite_remove_code_warning_prompt.downcase == "no"
                        system("clear")
                        puts "Returning you to Main Menu"
                    end 
                else
                    invalid_title_name
                end
            when "Back To Main Menu"
                system("clear")
                next
            when "Exit"
                system("clear")
                puts "Goodbye!"
                exit
            end
        when "Help"
            system("clear")
            help_font = TTY::Font.new(:doom)
            help_title = Pastel.new
            puts  help_title.cyan.bold( help_font.write("HELP", letter_spacing: 2))
            puts "\n\n"
            puts "Welcome to the Code Library. The Code Library is a resource that allows the user to search for and save helpful code snippets, to assist them on their coding journeys."
            puts "\n"
            help_search_font = TTY::Font.new(:straight)
            help_search = Pastel.new
            puts  help_search.yellow.bold( help_search_font.write("SEARCH", letter_spacing: 2))
            puts "\n"
            puts "To Search for Code, select the Search option from the Main Menu. Once selected, it will prompt you with categories of code you can search, simply select one to search its code."
            puts "Once you have finished searching a category, you will be prompted whether or not you would like to add any of the code snippets to your favourites library."
            puts "\n"
            help_add_font = TTY::Font.new(:straight)
            help_add = Pastel.new
            puts  help_add.yellow.bold( help_add_font.write("ADD", letter_spacing: 2))
            puts "\n"
            puts "If you would like to add code to your favourites, select yes from the prompt menu, and then enter the Title of the code, for example - Opacity"
            success_pastel = Pastel.new
            puts success_pastel.green("Success! You have added code to your favourites!")
            puts "\n"
            puts "If the code title you add doesn't match one from the code library, you will get an error message and have to re-add your desired code."
            error_pastel = Pastel.new
            puts error_pastel.red("Error - Code Title not found")
            puts "\n"
            view_favourites_help_font = TTY::Font.new(:straight)
            view_favourites_help = Pastel.new
            puts  view_favourites_help.yellow.bold( view_favourites_help_font.write("VIEW FAVOURITES", letter_spacing: 2))
            puts "\n"
            puts "To view the code you have added to your favourites, simply select the Favourites menu option from the Main Menu"
            puts "\n"
            delete_help_font = TTY::Font.new(:straight)
            delete_help = Pastel.new
            puts  delete_help.yellow.bold( delete_help_font.write("DELETE", letter_spacing: 2))
            puts "\n"
            puts "If you would like to delete code that you have added to your favourites, firstly select Favourites from the Main Menu. After you have done that, select Delete Code From Favourites. Once you have done that, enter the Title of the code you wish to delete."
            puts "If the Title you entered matches a code title in your favourites, it will delete it."
            success_pastel = Pastel.new
            puts success_pastel.green("Code successfully removed!")
            puts "\n"
            puts "If it doesn't match, you will get an error"
            error_pastel = Pastel.new
            puts error_pastel.red("Error - Code Title not found")
            puts "\n"
            enjoy_help_font = TTY::Font.new(:straight)
            enjoy_help = Pastel.new
            puts  enjoy_help.yellow.bold( enjoy_help_font.write("ENJOY", letter_spacing: 2))
            puts "\n"
            puts "That's everything you should need to know to successfully navigate your way around the code library, ENJOY!"
            puts "\n"
        when "Exit"
            system("clear")
            puts "Goodbye!"
            exit
        end
    end
else login_options.downcase == "exit"
    system("clear")
    puts "Goodbye!"
    exit
end