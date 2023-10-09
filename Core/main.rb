require "./Core/cmdlist.rb"

def main
  args = ARGV
  if args.empty?
    list_commands
  elsif args.length >= 1
    package_name = args[0]
    print "Installing #{package_name}..."
  end
end

if __FILE__ == $0
  main
end

