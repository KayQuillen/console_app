class User
  def initialize(user_name, password)
    @user_name = user_name
    @password = password
  end

  attr_accessor :user_name
  attr_accessor :password
end

def input
  puts 'Please enter a username'
  un = gets.chomp
  puts 'Please enter a password'
  pw = gets.chomp
  { user: un, pass: pw }
end

def validate_input(input)
  un = input[:user]
  pw = input[:pass]
  un_validated = true unless un.length < 5
  pw_validated = true unless pw.length < 5
  return true if un_validated && pw_validated
end

def create_user
  data = input
  if validate_input(data)
    User.new(data[:user], data[:pass])
  else
    puts 'User information rejected, please try again.'
  end
end

def intro
  puts 'Authenticator App'
  75.times { print '-' }
  puts "\n" + 'This program takes username and password as input.'
  puts 'If the information is correct, the user object will be returned'
  puts 'If the information is incorrect, an error will be returned'
end

def try_auth(store)
  max_attempts = 3
  attempts = 0
  puts 'Enter your username: '
  username = gets.chomp
  validated = false
  if !store[username]
    puts 'User not found.'
  else
    while attempts <= max_attempts && !validated
      attempts += 1
      puts 'Enter your password: '
      pw = gets.chomp
      if store[username][:password] == pw
        puts "Validated! -> User: '#{username}'\
 Secret: '#{store[username][:password]}'"
        validated = true
      elsif (max_attempts - attempts) > -1
        puts "Invalid password! #{max_attempts - attempts} remaining"
      else
        puts 'Invalid password entered too many times. No more attempts remain.'
      end
    end
  end
end

intro
exit_loop = false
user_store = {}

loop do
  instructions = "\nPress 'n' for new user, 'l' to login, 'd' to display users,\
 or 'x' to exit: -> "
  75.times { print '-' }
  puts instructions
  75.times { print '-' }
  puts "\n"

  valid_input = %w[n l x d]
  user_input = gets.chomp
  if !valid_input.include? user_input
    puts 'Invalid input'
    puts "\n" + instructions
  elsif user_input == 'n'
    new_user = create_user
    user_store[new_user.user_name] = { password: new_user.password }\
      if new_user
  elsif user_input == 'l'
    try_auth(user_store)
  elsif user_input == 'd'
    user_store.keys.each { |k| puts k } unless user_store.empty?
  elsif user_input == 'x'
    exit_loop = true
  end
  break if exit_loop
end