require './library/colors.rb'
require 'open3'
require 'json'
require 'nokogiri'
require 'net/http'

def install_package(package_name, method)
  case method
  when 'pip'
    try_pip(package_name)
  when 'wget'
    try_wget(package_name)
  when 'curl'
    try_curl(package_name)
  when 'github'
    try_github(package_name)
  else
    puts "#{COLOR_RED}Invalid installation method: #{method}#{COLOR_END}"
  end
end

def try_pip(package_name)
  begin
    Open3.capture2e("pip3 install #{package_name}")
    puts "#{COLOR_GREEN}Successfully installed #{package_name} using pip3#{COLOR_END}"
  rescue
    puts "#{COLOR_RED}pip3 installation of #{package_name} failed, attempting other methods...#{COLOR_END}"
  end
end

def try_wget(package_name)
  puts "Trying to download using wget: #{COLOR_YELLOW}#{package_name}#{COLOR_END}"
  begin
    Open3.capture2e("wget #{package_name}")
    puts "#{COLOR_GREEN}Successfully downloaded #{package_name} using wget#{COLOR_END}"
  rescue
    puts "#{COLOR_RED}wget download of #{package_name} failed#{COLOR_END}"
  end
end

def try_curl(package_name)
  puts "Trying to download using curl: #{COLOR_YELLOW}#{package_name}#{COLOR_END}"
  begin
    Open3.capture2e("curl -O #{package_name}")
    puts "#{COLOR_GREEN}Successfully downloaded #{package_name} using curl#{COLOR_END}"
  rescue
    puts "#{COLOR_RED}curl download of #{package_name} failed#{COLOR_END}"
  end
end

def try_github(package_name)
  github = Net::HTTP.get(URI("https://github.com/search?q=#{package_name}&type=repositories"))
  soup = Nokogiri::HTML(github)
  json_data = soup.text.match(/{.*}/).to_s
  data = JSON.parse(json_data)
  results = data.dig("payload", "results")

  if results && !results.empty?
    name = results[0]["hl_name"]
    repo_link = "https://github.com/#{name}.git"
    puts "Cloning #{COLOR_YELLOW}#{repo_link}#{COLOR_END}..."
    Open3.capture2e("git clone #{repo_link}")
    puts "#{COLOR_GREEN}Successfully cloned #{repo_link}#{COLOR_END}"
  else
    puts "#{COLOR_RED}No Git repository found for #{package_name}#{COLOR_END}"
  end
end

def main
  args = ARGV
  if args.length >= 2
    package_name = args[0]
    method = args[1]
    install_package(package_name, method)
  else
    puts "#{COLOR_RED}Usage: install <package_name> <method>#{COLOR_END}"
  end
end

if __FILE__ == $0
  main
end