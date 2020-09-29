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

# This content is used to populate the Image manipulation table
image_height = [" Increase image height by a percentage or by pixel amount ", " height: %, height: px "]
image_width = [" Increase image width by a percentage or by pixel amount ", " width: %, width: px "]
responsive_image = [" Responsive Image ", " width: 100%, height: auto "]
image_border = [" Image border, defines the width of the border, what type of border, is this case it is solid, and the colour ", " border: 5px solid black "]
opacity = [" Opacity, in the example the opacity is set to 50% ", " opacity: 0.5 "]

# This content is used to populate the Font manipulation table
font_size = [" Font Size ", " font-size: 16px, font-size: 1rem "]
font_weight = [" Font Weight ", " font-weight: bold, font-weight: 800 "]
font_colour = [" Font Colour ", " color: white, colour: #fff "]
font_family = [" Font Family ", " font-family: Arial, Helvetica, sans-seriff "]
font_style = [" Font Style ", " font-style: normal, font-style: italic "]
responsive_font = [" Responsive Font Size ", " font-size: 10vw "]

# This content is used to populate the Flexbox table
flex_direction = [" Flex Direction ", " flex-direction: row | row-reverse | column | column-reverse "]
flex_wrap = [" Flex Wrap ", " flex-wrap: nowrap | wrap | wrap-reverse "]
flex_flow = [" Flex Flow is a shorthand for direction and wrap ", " flex-flow: column wrap "]
justify_content = [" Justify Content - main axis ", " jusitfy-content: flex-start | flex-end | center | space-between | space-around | space-evenly "]
align_items = [" Align Items - cross axis ", " align-items: flex-start | flex-end | center | stretch | baseline "]
order = [" Order - Is used to manipulate the order of objects ", " order: 0 | 1 | 2 | 3 "]

# This content is used to populate the Flexbox table
grid_template_columns = [" Grid Template Columns - Defines the columns of the grid with a space-seperated list of values ", " grid-template-columns: 40px 50px auto 50px 40px | 1fr 1fr 1fr | repeat(3, 1fr) "]
grid_template_rows = [" Grid Template Rows - Defines the rows of the grid with a space-seperated list of values ", " grid-template-rows: 25% 100px auto | 1fr 1fr | repeat(2, 1fr) "]
grid_column_grid_row = [" Grid Column/Grid Row - This is the shorthand for grid-column-start/end and grid-row-start/end ", " grid-column: 1/3 | grid-row: 2/4 "]
grid_template_areas = [" Defines a grid template by referencing the names of the grid areas which are specified with the grid-area property", " header header main main footer footer "]
column_row_gap = [" Column and Row Gap - Specifies the size of the grid lines. ", " column-gap: 15px | row-gap: 10px "]


prompt = TTY::Prompt.new
    display_options_menu = prompt.select('Please select an option:') do |menu|   
        menu.choice 'Add Code'
        menu.choice 'Edit Code'
        menu.choice 'Remove Code'
        menu.choice 'Search'
        menu.choice 'Help'
        menu.choice 'Exit'
    end

loop do
    case display_options_menu
    when "Search"
        prompt = TTY::Prompt.new
        search_options = prompt.select('Please select an option:') do |menu|
        
            menu.choice 'Image Manipulation'
            menu.choice 'Text Manipulation'
            menu.choice 'Flexbox'
            menu.choice 'Grid'
            menu.choice 'Exit'
        end
    end

    case search_options
    when "Image Manipulation"
        system("clear")
        image_table = TTY::Table.new(["Description","Code Snippet"], 
        [
            image_height,
            image_width,
            responsive_image,
            image_border,
            opacity
        ])
        puts image_table.render(:unicode, alignments: [:left, :left])

    when "Text Manipulation"
        system("clear")
        text_table = TTY::Table.new(["Description","Code Snippet"], 
        [
            font_size,
            font_weight,
            font_colour,
            font_family,
            font_style,
            responsive_font
        ])
        puts text_table.render(:unicode, alignments: [:left, :left])

    when "Flexbox"
        system("clear")
        flexbox_table = TTY::Table.new(["Description","Code Snippet"], 
        [
            flex_direction,
            flex_wrap,
            flex_flow,
            justify_content,
            align_items,
            order
            
        ])
        puts flexbox_table.render(:unicode, alignments: [:left, :left])

    when "Grid"
        system("clear")
        grid_table = TTY::Table.new(["Description","Code Snippet"], 
        [
            grid_template_columns,
            grid_template_rows,
            grid_column_grid_row,
            grid_template_areas
     
        ])
        puts grid_table.render(:unicode, alignments: [:left, :left])
    when "Exit"
        break
    end
end

puts "Goodbye"

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



