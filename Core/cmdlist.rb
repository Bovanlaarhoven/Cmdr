require './library/colors.rb'

def list_commands
    puts "#{COLOR_GREEN}Available commands:#{COLOR_END}"
    puts "#{COLOR_YELLOW}install <package_name> <method>#{COLOR_END}"
    puts "#{COLOR_YELLOW}uninstall <package_name>#{COLOR_END}"
end
