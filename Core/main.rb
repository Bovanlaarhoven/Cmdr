require './Core/cmdlist'
require './commands/install'
require './library/colors.rb'

def main
  args = ARGV
  if args.empty?
    puts "#{COLOR_RED}No arguments provided.#{COLOR_END}"
  elsif args.length >= 1 && args[0].downcase.start_with?('help')
    list_commands
  elsif args.length >= 1 && args[0].downcase.start_with?('install')
    package_name = args[1]
    method = args[2]
    install_package(package_name, method)
  elsif args.length >= 1 && args[0].downcase.start_with?('uninstall')
    package_name = args[1]
    uninstall_package(package_name)
  else
    puts "#{COLOR_RED}Invalid command: #{args[0]}#{COLOR_END}"
  end
end

if __FILE__ == $0
  main
end
