require './library/colors.rb'
require 'open3'
require 'json'
require 'nokogiri'
require 'net/http'

def install_package(package_name, method)
  case method
  when 'pip'
    success = try_pip(package_name)
    if success
      puts "#{COLOR_GREEN}Successfully installed #{package_name} using pip3#{COLOR_END}"
    else
      puts "#{COLOR_RED}Failed to install #{package_name} using pip3#{COLOR_END}"
    end
  when 'wget'
    success = try_wget(package_name)
    if success
      puts "#{COLOR_GREEN}Successfully downloaded #{package_name} using wget#{COLOR_END}"
    else
      puts "#{COLOR_RED}Failed to download #{package_name} using wget#{COLOR_END}"
    end
  when 'curl'
    success = try_curl(package_name)
    if success
      puts "#{COLOR_GREEN}Successfully downloaded #{package_name} using curl#{COLOR_END}"
    else
      puts "#{COLOR_RED}Failed to download #{package_name} using curl#{COLOR_END}"
    end
  when 'github'
    try_github(package_name)
  else
    puts "#{COLOR_RED}Invalid installation method: #{method}#{COLOR_END}"
  end
end


def try_pip(package_name)
  begin
    completed_process = Open3.capture2e("pip3 install #{package_name}")
    if completed_process[1].include?("Successfully installed")
      return true
    else
      return false
    end
  rescue
    return false
  end
end


def try_wget(package_name)
  begin
    Open3.capture2e("wget #{package_name}")
  end
end

def try_curl(package_name)
  begin
    Open3.capture2e("curl -O #{package_name}")
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