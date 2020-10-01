list_of_users = [    
    GeneralUser.new("Guest", "password"),
    AdminUser.new("Admin", "password")
]


puts "Please enter your username"
input_username = gets.chomp
puts "Enter your password"
input_password = gets.chomp
user = list_of_users.find { |user| user.username == input_username }
if user.username == input_username && user.password == input_password